apt-get install python-pip python-netaddr
pip install Django
pip install pygeoip
pip install django-pagination
pip install django-tables2
pip install django-compressor
pip install django-htmlmin
cd /opt/
wget https://github.com/benjiec/django-tables2-simplefilter/archive/master.zip -O django-tables2-simplefilter.zip
unzip django-tables2-simplefilter.zip
mv django-tables2-simplefilter-master/ django-tables2-simplefilter/
cd django-tables2-simplefilter/
python setup.py install
cd /opt/
git clone https://github.com/bro/pysubnettree.git
cd pysubnettree/
python setup.py install
cd /opt/
wget http://nodejs.org/dist/v0.8.16/node-v0.8.16.tar.gz
tar xzvf node-v0.8.16.tar.gz
cd node-v0.8.16
./configure
make
make install
npm install -g less
npm install -g promise

cd /opt/
wget https://github.com/RootingPuntoEs/DionaeaFR/archive/master.zip -O DionaeaFR.zip
unzip DionaeaFR.zip
mv DionaeaFR-master/ DionaeaFR

cd /opt/
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
gunzip GeoLiteCity.dat.gz
gunzip GeoIP.dat.gz
mv GeoIP.dat DionaeaFR/DionaeaFR/static
mv GeoLiteCity.dat DionaeaFR/DionaeaFR/static

cp /opt/DionaeaFR/DionaeaFR/settings.py.dist /opt/DionaeaFR/DionaeaFR/settings.py
#nano /opt/DionaeaFR/DionaeaFR/settings.py

mkdir /var/run/dionaeafr #for DionaeaFR's pid file
cd /opt/DionaeaFR/
python manage.py collectstatic #type yes when asked
python manage.py runserver 0.0.0.0:8000

