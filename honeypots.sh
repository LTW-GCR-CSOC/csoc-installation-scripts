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
echo "-----@ SET TIMEZONE -----"
sudo cp /usr/share/zoneinfo/Canada/Eastern /etc/localtime
#
#update&upgrade
sudo apt-get update -y && apt-get upgrade
# remove old directories to do a clean install
if [ -d "cowrie" ]; then
  echo "Removing old cowrie directory" >>~/SETUP-RUN.TXT
  sudo rm -rf cowrie
fi
if [ -d "/opt/dionaea" ]; then
  echo "Removing old /opt/dionaea directory" >>~/SETUP-RUN.TXT
  sudo rm -rf /opt/dionaea
fi
#install dependencies
sudo apt-get install -y git python-dev python-openssl openssh-server python-pyasn1 python-twisted authbind
#set cowrie to listen to port22
sudo touch /etc/authbind/byport/22
sudo chown cowrie /etc/authbind/byport/22
sudo chmod 777 /etc/authbind/byport/22
#install cowrie
# TODO - should change install to be /opt/cowrie
sudo adduser --disabled-password cowrie
sudo su - cowrie
git clone https://github.com/cowrie/cowrie.git
cd cowrie
#script to create script
touch start.sh
{ printf %s authbind --deep; cat <./start.sh; } >/tmp/output_file
mv -- /tmp/output_file ./start.sh
rm -rf /tmp/output_file
#restart ssh
service ssh restart
#install Cowrie-log-viewer
cd ..
git clone https://github.com/mindphluxnet/cowrie-logviewer
cd cowrie-logviewer
pip install -r requirements.txt
#install IPGeolocator
mkdir maxmind
cd maxmind
wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
unzip -o GeoLite2-Country.mmdb.gz
cd ..
cd ..
cd cowrie/log
touch cowrie.json
touch cowrie.log
cd ..
cd ..
cd cowrie-logviewer
python cowrie-logviewer.py 
sudo su - root
cd ..
echo "-----@ LATEST SOFTWARE UPDATES -----"
sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y update --fix-missing 
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
sudo git clone git://github.com/DinoTools/dionaea.git /opt/dionaea
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
cd /etc/logrotate.d/
cat > dionaea << EOF
/opt/dionaea/var/log/dionaea*.log {
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

# check operation
echo "-----@ DIONAEA RUNNING CHECK -----" >>~/SETUP-RUN.TXT
sudo ps -ef | grep dionaea >>~/SETUP-RUN.TXT
# ensure seeing dionaea logs
ls -l /opt/dionaea/var/dionaea.log >>~/SETUP-RUN.TXT

# ---------------
# install ossec
# https://ossec.github.io/index.html
#
echo "-----@ INSTALL OSSEC -----" >>~/SETUP-RUN.TXT
cd ~
sudo apt-get -y install build-essential
sudo apt-get -y install mysql-server
wget -U ossec https://bintray.com/artifact/download/ossec/ossec-hids/ossec-hids-2.8.3.tar.gz
tar -zxf ossec-hids-2.8.3.tar.gz
cd ossec-hids-2.8.3
./install.sh

echo "-----@ OSSEC SETUP DONE -----" >>~/SETUP-RUN.TXT
#
#  need to add script to configure dionaea .cfg file for services to be active - https://dionaea.readthedocs.io/en/latest/configuration.html
#
#---------------
#
# TODO: setup watchdog timer support for raspberry pi device
#
#echo "-----@ INSTALL WATCHDOG FOR CANARY -----" >>~/SETUP-RUN.TXT
#sudo modprobe bcm2708_wdog
#echo "bcm2708_wdog" | sudo tee -a /etc/modules
#sudo apt-get install watchdog
#
# - need to add configuration for watchdog sudo nano /etc/watchdog.conf
#
# Uncomment the line that starts with #watchdog-device by removing the hash (#) to enable the  watchdog daemon to use the watchdog device.
# Uncomment the line that says #max-load-1 = 24 by removing the hash symbol to reboot the device if the load goes over 24 over 1 minute. A load of 25 of one minute means that you would have needed 25 Raspberry Pis to complete that task in 1 minute. You may tweak this value to your liking.
#
#------
#
# install AWS IoT SW
# 
# TODO: install AWS IoT SW 
# TODO: configure AWS IoT SW 
#
#------
#
# CONFIGURE IPTABLES  
#
#------
echo "-----@ IPTABLES CONFIGURATION STARTS -----"  >>~/SETUP-RUN.TXT
# TODO - Ahmed
echo "-----@ IPTABLES DONE -----" >>~/SETUP-RUN.TXT
#--------
#
# Configure OSSEC
#
# TODO: configure OSSEC
#
#--------
#
# start OSSEC
#
echo "-----@ START OSSEC -----" >>~/SETUP-RUN.TXT
/var/ossec/bin/ossec-control start
#
# TODO: clean-up remove all files (e.g. source downloads) that not required for production operation
#
