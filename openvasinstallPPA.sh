# Reference: https://hackertarget.com/openvas-9-install-ubuntu-1604/
add-apt-repository ppa:mrazavi/openvas
apt -y update
apt -y install sqlite3
apt -y install openvas9
apt -y install texlive-latex-extra --no-install-recommends
apt-get -y install texlive-fonts-recommended
apt -y install libopenvas9-dev
greenbone-nvt-sync
greenbone-scapdata-sync
greenbone-certdata-sync
service openvas-scanner restart
ps -ef | grep openvas
# apt install smbclient
service openvas-manager restart
openvasmd --rebuild --progress
# admin / admin https://<local>:4000
