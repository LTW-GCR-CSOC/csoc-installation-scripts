#!/bin/bash
#
# remove old directories to do a clean install
if [ -d "cowrie" ]; then
  echo "Removing old cowrie directory" >>~/SETUP-RUN.TXT
  sudo rm -rf cowrie
fi
#install dependencies
sudo apt-get install -y git python-dev python-openssl openssh-server python-pyasn1 python-twisted authbind
#set cowrie to listen to port22
sudo touch /etc/authbind/byport/22
sudo chown cowrie /etc/authbind/byport/22
sudo chmod 777 /etc/authbind/byport/22
#install cowrie
# TODO - should change install to be /opt/cowrie
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
