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
# 
echo "Started setup script on" `date`  >~/SETUP-RUN.TXT
chmod 0660 SETUP-RUN.TXT
echo "-----@ SET TIMEZONE -----"
sudo cp /usr/share/zoneinfo/Canada/Eastern /etc/localtime
#
#update&upgrade
sudo apt-get update -y && apt-get upgrade
#install dependencies
sudo apt-get install -y git python-dev python-openssl openssh-server python-pyasn1 python-twisted authbind
#set cowrie to listen to port22
touch /etc/authbind/byport/22
chown cowrie /etc/authbind/byport/22
chmod 777 /etc/authbind/byport/22
#install cowrie
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
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
gunzip GeoLite2-Country.mmdb.gz
cd ..
cd ..
cd cowrie/log
touch cowrie.json
touch cowrie.log
cd ..
cd ..
cd cowrie-logviewer
python cowrie-logviewer.py
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
# remove old directory to do a clean install
if [ -d "/opt/dionaea" ]; then
  echo "Removing old /opt/dionaea directory" >>~/SETUP-RUN.TXT
  sudo rm -rf /opt/dionaea
fi
# setup user and group to run dionaea under
sudo useradd dionaea
sudo groupadd dionaea
sudo usermod dionaea -G dionaea
sudo chown -R dionaea:dionaea /opt/dionaea/var/dionaea
sudo chown -R dionaea:dionaea /opt/dionaea/var/log
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
echo "-----@ DIONAEA SETUP DONE -----" >>~/SETUP-RUN.TXT
#
# the following command should run and display dionaea help 
#
/opt/dionaea/bin/dionaea -H
# start service
sudo /opt/dionaea/bin/dionaea -u nobody -g nogroup -c /opt/dionaea/etc/dionaea/dionaea.conf -w /opt/dionaea -p /opt/dionaea/var/dionaea.pid -D
# check operation
echo "-----@ DIONAEA RUNNING CHECK -----" >>~/SETUP-RUN.TXT
sudo ps -ef | grep dionaea >>~/SETUP-RUN.TXT
ls -l /opt/dionaea/var/log/dionaea-errors.log >>~/SETUP-RUN.TXT
