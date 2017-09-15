#!/bin/bash
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
