#!/bin/bash
# ---------------
#
# Install Cowrie Log Viewer
#
#----------------
# TODO remove old directories to do a clean install
sudo mkdir /opt/cowrie
cd /opt/cowrie
sudo git clone https://github.com/LTW-GCR-CSOC/cowrie-logviewer.git
cd cowrie-logviewer
pip install -r requirements.txt
#install IPGeolocator
sudo mkdir maxmind
cd maxmind
sudo wget -N http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
sudo unzip -o GeoLite2-Country.mmdb.gz
cd ..
cd ..
cd cowrie/log
sudo touch cowrie.json
sudo touch cowrie.log
cd ..
cd ..
cd cowrie-logviewer
python cowrie-logviewer.py 
