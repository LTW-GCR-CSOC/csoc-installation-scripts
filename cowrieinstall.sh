#!/bin/bash
# ---------------
#
# Install Cowrie
# https://github.com/micheloosterhof/cowrie/blob/master/INSTALL.md
#
#----------------

#install dependencies
sudo apt-get install -y git
sudo apt-get install -y python-dev
sudo apt-get install -y python-openssl
sudo apt-get install -y openssh-server
sudo apt-get install -y python-pyasn1
sudo apt-get install -y python-twisted
sudo apt-get install -y authbind

su - cowrie <<!
/usr/bin/easy_install virtualenv

#change default port to Port 8742(to be tested with the pi)
#sed -i '/^Port/c\Port 8742' /etc/ssh/sshd_config

cd /home/cowrie
rm -rf cowrie
git clone https://github.com/LTW-GCR-CSOC/cowrie.git
cd cowrie
virtualenv cowrie-env
source cowrie-env/bin/activate
export PYTHONPATH=/home/cowrie/cowrie
pip install -r requirements.txt
bin/cowrie start
#sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
touch /etc/authbind/byport/22
chown cowrie:cowrie /etc/authbind/byport/22
chmod 770 /etc/authbind/byport/22
!

# ---------------
#
# Configure DionaeaFR to restart on reboot
# https://blog.honeynet.org.my/2010/02/14/dionaea-auto-start-script-on-ubuntu/
#
#----------------
echo "-----@ COWRIE REBOOT CONFIGURATION -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo mv $SCRIPTSDIR/cowrie /etc/init.d/
sudo chmod 0755 /etc/init.d/cowrie
sudo update-rc.d cowrie defaults
sudo /etc/init.d/cowrie start
echo "-----@ COWRIE REBOOT CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

