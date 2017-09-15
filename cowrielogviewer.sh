#!/bin/bash
# ---------------
#
# Install Cowrie Log Viewer
#
#----------------
cd /opt/
mkdir cowrie
cd cowrie
git clone https://github.com/LTW-GCR-CSOC/cowrie-logviewer.git
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
