# Reference: https://hackertarget.com/openvas-9-install-ubuntu-1604/
add-apt-repository ppa:mrazavi/openvas
apt update
apt install sqlite3
apt install openvas9
apt install texlive-latex-extra --no-install-recommends
apt-get install texlive-fonts-recommended
apt install libopenvas9-dev
greenbone-nvt-sync
greenbone-scapdata-sync
greenbone-certdata-sync
service openvas-scanner restart
ps -ef | grep openvas
# apt install smbclient
service openvas-manager restart
openvasmd --rebuild --progress
# admin / admin https://<local>:4000
