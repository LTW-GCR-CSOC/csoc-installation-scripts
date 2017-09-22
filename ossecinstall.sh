# ---------------
# install ossec
# https://ossec.github.io/index.html
#
SCRIPTSDIR=$HOME/csoc-installation-scripts-master/

echo "SCRIPTSDIR = " $HOME  >>$SCRIPTSDIR/SETUP-RUN.TXT

echo "-----@ INSTALL OSSEC -----" >>~/SETUP-RUN.TXT
cd ~
sudo apt-get -y install build-essential
sudo apt-get -y install mysql-server
wget -U ossec https://bintray.com/artifact/download/ossec/ossec-hids/ossec-hids-2.8.3.tar.gz
tar -zxf ossec-hids-2.8.3.tar.gz
cd ossec-hids-2.8.3
sudo ./install.sh
echo "-----@ OSSEC SETUP DONE -----" >>~/SETUP-RUN.TXT
#
# Configure OSSEC
#
# TODO: configure OSSEC
#
#--------
#
# start OSSEC
#
echo "-----@ START OSSEC -----" >>~/SETUP-RUN.TXT
sudo /var/ossec/bin/ossec-control start
#
# TODO: clean-up remove all files (e.g. source downloads) that not required for production operation
#
