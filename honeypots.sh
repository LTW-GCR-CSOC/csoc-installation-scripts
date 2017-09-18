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
SCRIPTSDIR=echo `$HOME`
echo "Started setup script on" `date`  >$SCRIPTSDIR/SETUP-RUN.TXT
chmod 0660 $SCRIPTSDIR/SETUP-RUN.TXT
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
#
#----------------
echo "-----@ COWRIE CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# change default port to Port 8742 (to be tested with the pi)
#    sed -i '/^Port/c\Port 8742' /etc/ssh/sshd_config

# Dedicated user and group for Cowrie
sudo adduser --disabled-password cowrie
sudo groupadd cowrie
sudo usermod -a -G cowrie corwie

sudo $SCRIPTSDIR/cowrieinstall.sh - cowrie
echo "-----@ COWRIE CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install Cowrie Log Viewer (for development)
#
#----------------
echo "-----@ COWRIE LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo $SCRIPTSDIR/cowrielogviewerinstall.sh
echo "-----@ COWRIE LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT


# ---------------
#
# Install Dionaea 
#
#----------------

# remove old directories to do a clean install
if [ -d "/opt/dionaea" ]; then
  echo "Removing old /opt/dionaea directory" >>$SCRIPTSDIR/SETUP-RUN.TXT
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
echo "-----@ DIONAEA SETUP DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
#
# the following command should run and display dionaea help 
#
/opt/dionaea/bin/dionaea -H
# start service
sudo /opt/dionaea/bin/dionaea -u nobody -g nogroup -c /opt/dionaea/etc/dionaea/dionaea.cfg -w /opt/dionaea -p /opt/dionaea/var/dionaea.pid -D

# Dionaea log rotation configuration
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
               kill -HUP `cat /opt/dionaea/var/dionaea.pid`
       endscript
}
EOF
sudo chmod 0755 /etc/logrotate.d

# Check Dionaea processes 
echo "-----@ DIONAEA RUNNING CHECK -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo ps -ef | grep dionaea >>$SCRIPTSDIR/SETUP-RUN.TXT
# Check Dionaea logs exist
ls -l /opt/dionaea/var/dionaea/dionaea.log >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install Dionaea Log Viewer (for development)
#
#----------------
echo "-----@ DIONAEA LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo $SCRIPTSDIR/dionaealogviewer.sh
echo "-----@ DIONAEA LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install OSSEC (used
# https://ossec.github.io/index.html
#
#----------------
echo "-----@ OSSEC CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
#sudo $SCRIPTSDIR/ossecinstall.sh
echo "-----@ OSSEC CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
#  Configure Dionaea for desired services
#
#---------------
echo "-----@ DIONAEA CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
cd $SCRIPTSDIR
# TODO: need to add script to configure dionaea .cfg file for services to be active - https://dionaea.readthedocs.io/en/latest/configuration.html
echo "-----@ DIONAEA CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# Setup Raspberry Pi components
#
#---------------
echo "-----@ Raspberry Pi CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
cd $SCRIPTSDIR
# sudo rpinstall.sh
echo "-----@ Raspberry Pi DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# Setup AWS IoT components
#
#---------------
echo "-----@ AWS IoT CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
cd $SCRIPTSDIR
# sudo awsiotinstall.sh
echo "-----@ AWS IoT DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# CONFIGURE IPTABLES for all services and lockdown instance
#
#---------------
echo "-----@ IPTABLES CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# TODO - Ahmed
echo "-----@ IPTABLES DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT


#---------------
#
# Check that expected processes are active
#
#---------------
pgrep dionaea > /dev/null && echo "Dionaea tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT
pgrep ossec > /dev/null && echo "OSSEC tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT
pgrep cowrie > /dev/null && echo "Dionaea tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# TODO: clean-up remove all files (e.g. applications, source downloads) that not required for production operation
#
#---------------
sudo apt-get -y remove git 
sudo apt-get -y remove make
sudo apt -y autoremove

#---------------
#
# Check for pretend python packages
# http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/
#
#---------------
pip list –format=legacy | egrep '^(acqusition|apidev-coop|bzip|crypt|django-server|pwd|setup-tools|telnet|urlib3|urllib)'

#---------------
#
# Collect status data that may be used for other configuration activities
#
#---------------
echo "-----@ STATUS SNAPSHOT -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo ifconfig -a >>$SCRIPTSDIR/SETUP-RUN.TXT
