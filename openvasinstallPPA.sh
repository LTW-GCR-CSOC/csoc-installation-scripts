# Reference: https://hackertarget.com/openvas-9-install-ubuntu-1604/
sudo add-apt-repository ppa:mrazavi/openvas
sudo apt -y update
sudo apt -y install sqlite3
sudo apt -y install openvas9
sudo apt -y install texlive-latex-extra --no-install-recommends
sudo apt-get -y install texlive-fonts-recommended
sudo apt -y install libopenvas9-dev
sudo greenbone-nvt-sync
sudo greenbone-scapdata-sync
sudo greenbone-certdata-sync
sudo service openvas-scanner restart
sudo ps -ef | grep openvas
# apt install smbclient
sudo service openvas-manager restart
sudo openvasmd --rebuild --progress
# admin / admin https://<local>:4000
