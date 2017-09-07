
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
cd ..
cd log
touch cowrie.json
touch cowrie.log
cd ..
cd cowrie-logviewer
python cowrie-logviewer.py
