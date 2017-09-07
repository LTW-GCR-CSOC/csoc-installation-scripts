#update&upgrade
sudo apt-get update -y && apt-get upgrade
#install dependencies
sudo apt-get install -y git python-dev python-openssl openssh-server python-pyasn1 python-twisted authbind
#set cowrie to listen to port22
touch /etc/authbind/byport/22
chown cowrie /etc/authbind/byport/22
chmod 777 /etc/authbind/byport/22
#install cowrie
git clone https://github.com/micheloosterhof/cowrie.git
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
cd ..
cd log
touch cowrie.json
touch cowrie.log
cd ..
cd cowrie-logviewer
python cowrie-logviewer.py
