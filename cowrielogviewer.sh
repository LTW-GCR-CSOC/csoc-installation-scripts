#!/bin/bash
# ---------------
#
# Install Cowrie Log Viewer
#
#----------------
# TODO remove old directories to do a clean install
# run as cowrie user su cowrie
su - cowrie <<!
cowrie
cd /home/cowrie
git clone https://github.com/LTW-GCR-CSOC/cowrie-logviewer.git
cd cowrie-logviewer
chmod +x cowrie-logviewer.py
pip install -r requirements.txt
mkdir -p maxmind
cd maxmind
wget http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz
gunzip GeoLite2-Country.mmdb.gz
rm GeoLite2-Country.mmdb.gz

cd /home/cowrie/cowrie-logviewer
nohup python cowrie-logviewer.py & 
!
