#!/bin/bash
#
# TODO: 
# - add pre-install checks for baseline versions required, e.g. Ubuntu version supported 
# - add in CLI options to specify "development" or "production" installations, with tools such as DionaeaFR, VNC being for development use only
# - add IPTABLES configuration for "development" and "production" installations
# - configure remote syslog software
# - add in OSSEC installation script
# - add post-install sanity check to ensure all core functions are operating
# - add in watchdog timer configuration for Raspberry Pi deployments
# - add in scheduled therapudic reset?
# - add in AWS IoT libraries and configuration
# - add in scripts to remove all files not required in production environment (e.g. source files)
# - add in checks to ensure all services start-up on reboot/restart as expected
#
echo "Started setup script on" `date`  >~/SETUP-RUN.TXT
chmod 0660 SETUP-RUN.TXT
# check Ubuntu version
if [[ `lsb_release -rs` != "16.04" ]] 
then
 echo "**** WARNING: this script has not been tested on this version of Ubuntu ****"
fi
echo "-----@ SET TIMEZONE -----"
sudo cp /usr/share/zoneinfo/Canada/Eastern /etc/localtime

# ---------------
#
# Update System
#
#---------------

sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y update --fix-missing 

# ---------------
#
# Install Cowrie
# https://github.com/micheloosterhof/cowrie/blob/master/INSTALL.md
#
#----------------

sudo apt-get install -y git 
sudo apt-get install -y python-dev 
sudo apt-get install -y python-openssl
sudo apt-get install -y openssh-server
sudo apt-get install -y python-pyasn1 
sudo apt-get install -y python-twisted 
sudo apt-get install -y authbind
#set cowrie to listen to port22
sudo touch /etc/authbind/byport/22
sudo chown:cowrie /etc/authbind/byport/22
sudo chmod 777 /etc/authbind/byport/22
#change default port to Port 8742(to be tested with the pi)
#sed -i '/^Port/c\Port 8742' /etc/ssh/sshd_config

# Dedicated user and group for Cowrie
sudo adduser --disabled-password cowrie
sudo groupadd cowrie
sudo usermod -a -G cowrie corwie

sudo -u cowrie cowrieinstall.sh

# ---------------
#
# Install Dionaea 
#
#----------------

# remove old directories to do a clean install
if [ -d "/opt/dionaea" ]; then
  echo "Removing old /opt/dionaea directory" >>~/SETUP-RUN.TXT
  sudo rm -rf /opt/dionaea
fi
echo "-----@ LATEST SOFTWARE UPDATES -----"
sudo apt-get install -y git
sudo apt-get install -y autogen autoconf libtool
sudo apt-get install -y make
sudo apt-get install -y pkg-config
sudo apt-get install -y libglib2.0-dev
sudo apt-get install -y curl
sudo apt-get install -y python3-pip
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt install -y python-pip
sudo -H pip install Cython
sudo apt-get install -y udns-utils
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y aptitude
sudo apt-get install -y libemu-dev
sudo apt-get install -y libudns-dev
sudo apt-get install -y libev-dev
sudo apt-get install -y \
    autoconf \
    automake \
    build-essential \
    check \
    cython3 \
    libcurl4-openssl-dev \
    libemu-dev \
    libev-dev \
    libglib2.0-dev \
    libloudmouth1-dev \
    libnetfilter-queue-dev \
    libnl-3-dev \
    libpcap-dev \
    libssl-dev \
    libtool \
    libudns-dev \
    python3 \
    python3-dev \
    python3-yaml 
sudo git clone https://github.com/LTW-GCR-CSOC/dionaea.git /opt/dionaea
cd /opt/dionaea
sudo autoreconf -vi
sudo ./configure \
 --disable-werror \
 --prefix=/opt/dionaea \
 --with-python=/usr/bin/python3 \
 --with-cython-dir=/usr/bin \
 --with-ev-include=/usr/include \
 --with-ev-lib=/usr/lib \
 --with-emu-lib=/usr/lib/libemu \
 --with-emu-include=/usr/include \
 --with-nl-include=/usr/include \
 --with-nl-lib=/usr/lib \
 --with-curl-dir=/usr/bin/curl 
sudo make
sudo make install
sudo ldconfig
sudo chown -R nobody:nogroup /opt/dionaea/var/dionaea
sudo chown -R nobody:nogroup /opt/dionaea/var/log
echo "-----@ DIONAEA SETUP DONE -----" >>~/SETUP-RUN.TXT
#
# the following command should run and display dionaea help 
#
/opt/dionaea/bin/dionaea -H
# start service
sudo /opt/dionaea/bin/dionaea -u nobody -g nogroup -c /opt/dionaea/etc/dionaea/dionaea.cfg -w /opt/dionaea -p /opt/dionaea/var/dionaea.pid -D

# dionaea log rotation configuration
sudo chmod 0777 /etc/logrotate.d
cd /etc/logrotate.d/
sudo cat > dionaea << EOF
/opt/dionaea/var/dionaea/dionaea.log {
       notifempty
       missingok
       rotate 28
       daily
       delaycompress
       compress
       create 660 root root
       dateext
       postrotate
               kill -HUP `cat /opt/dionaea/var/run/dionaea.pid`
       endscript
}
EOF
sudo chmod 0755 /etc/logrotate.d

# check operation
echo "-----@ DIONAEA RUNNING CHECK -----" >>~/SETUP-RUN.TXT
sudo ps -ef | grep dionaea >>~/SETUP-RUN.TXT
# ensure seeing dionaea logs
ls -l /opt/dionaea/var/dionaea/dionaea.log >>~/SETUP-RUN.TXT

# ---------------
#
# Install OSSEC (used
# https://ossec.github.io/index.html
#
#----------------
#sudo ossecinstall.sh

#---------------
#
#  TODO: need to add script to configure dionaea .cfg file for services to be active - https://dionaea.readthedocs.io/en/latest/configuration.html
#
#---------------

#---------------
#
# Setup Raspberry Pi components, uncomment following line
# sudo rpinstall.sh
#
#---------------

#---------------
#
# Setup AWS IoT components, uncomment following line
# sudo awsiotinstall.sh
#
#---------------

#---------------
#
# CONFIGURE IPTABLES for all services and lockdown instance
#
#---------------
echo "-----@ IPTABLES CONFIGURATION STARTS -----"  >>~/SETUP-RUN.TXT
# TODO - Ahmed
echo "-----@ IPTABLES DONE -----" >>~/SETUP-RUN.TXT

#---------------
#
# TODO: clean-up remove all files (e.g. applications, source downloads) that not required for production operation
#
#---------------
sudo apt-get remove git 
sudo apt-get remove make
