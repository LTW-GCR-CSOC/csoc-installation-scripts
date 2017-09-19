#!/bin/bash
# original source https://bruteforcelab.com/visualizing-dionaeas-results-with-dionaeafr.html
apt-get install python-pip python-netaddr
pip install Django==1.8.1
pip install pygeoip
pip install django-pagination
pip install django-tables2
pip install django-compressor
pip install django-htmlmin
pip install django-filter
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
#wget https://github.com/RootingPuntoEs/DionaeaFR/archive/master.zip -O DionaeaFR.zip
wget https://github.com/LTW-GCR-CSOC/DionaeaFR/archive/master.zip -O DionaeaFR.zip
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

# Dionaea log rotation configuration
sudo chmod 0777 /etc/logrotate.d
cd /etc/logrotate.d/
sudo cat > dionaeafr << EOF
/var/log/dionaeafr/dionaeafr.log {
        notifempty
        missingok
        rotate 7
        daily
        delaycompress
        compress
        create 660 root root
        dateext
}
EOF
sudo chmod 0755 /etc/logrotate.d

mkdir /var/run/dionaeafr #for DionaeaFR's pid file
# ---------------
#
# Configure DionaeaFR to restart on reboot
# https://blog.honeynet.org.my/2010/02/14/dionaea-auto-start-script-on-ubuntu/
#
#----------------
echo "-----@ DIONAEAFR REBOOT CONFIGURATION -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo mv $SCRIPTSDIR/dionaeafr /etc/init.d/
sudo chmod 0755 /etc/init.d/dionaeafr
sudo update-rc.d dionaeafr defaults
sudo /etc/init.d/dionaeafr start
echo "-----@ DIONAEAFR REBOOT CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Run dionaeaFR
# https://blog.honeynet.org.my/2010/02/14/dionaea-auto-start-script-on-ubuntu/
#
#----------------
#cd /opt/DionaeaFR/
#python manage.py collectstatic #type yes when asked
#nohup python manage.py runserver 0.0.0.0:8000 &
# TODO: remove files and apps no longer required 
