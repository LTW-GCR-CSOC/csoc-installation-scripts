#!/bin/bash
#
# TODO: 
# - add pre-install checks for baseline versions required, e.g. Ubuntu version supported 
# - add in CLI options to specify "development" or "production" installations, with tools such as DionaeaFR, VNC being for development use only
# - add IPTABLES configuration for "development" and "production" installations
# - configure remote syslog software
# - add in OSSEC installation script
# - add post-install sanity check to ensure all core functions are operating
# - add in watchdog timer configuration for Raspberry Pi deployments
# - add in scheduled therapudic reset?
# - add in AWS IoT libraries and configuration
# - add in scripts to remove all files not required in production environment (e.g. source files)
# - add in checks to ensure all services start-up on reboot/restart as expected
#
SCRIPTSDIR=$HOME
echo "Started setup script on" `date`  >$SCRIPTSDIR/SETUP-RUN.TXT
chmod 0660 $SCRIPTSDIR/SETUP-RUN.TXT
# check Ubuntu version
if [[ `lsb_release -rs` != "16.04" ]] 
then
 echo "**** WARNING: this script has not been tested on this version of Ubuntu ****"
fi
echo "-----@ SET TIMEZONE -----"
sudo cp /usr/share/zoneinfo/Canada/Eastern /etc/localtime

# ---------------
#
# Update System
#
#---------------

sudo apt-get -y update
sudo apt-get -y dist-upgrade
sudo apt-get -y update --fix-missing 

# ---------------
#
# Install Cowrie
#
#----------------
echo "-----@ COWRIE CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# change default port to Port 8742 (to be tested with the pi)
#    sed -i '/^Port/c\Port 8742' /etc/ssh/sshd_config

# Dedicated user and group for Cowrie
sudo adduser --disabled-password cowrie
sudo groupadd cowrie
sudo usermod -a -G cowrie corwie

sudo $SCRIPTSDIR/cowrieinstall.sh - cowrie
echo "-----@ COWRIE CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install Cowrie Log Viewer (for development)
#
#----------------
echo "-----@ COWRIE LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo $SCRIPTSDIR/cowrielogviewerinstall.sh
echo "-----@ COWRIE LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT


# ---------------
#
# Install Dionaea 
#
#----------------
echo "-----@ DIONAEA INSTALL STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo $SCRIPTSDIR/dionaeainstall.sh
echo "-----@ DIONAEA INSTALL DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install Dionaea Log Viewer (for development)
#
#----------------
echo "-----@ DIONAEA LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo $SCRIPTSDIR/dionaealogviewer.sh
echo "-----@ DIONAEA LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install OSSEC (used
# https://ossec.github.io/index.html
#
#----------------
echo "-----@ OSSEC CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
#sudo $SCRIPTSDIR/ossecinstall.sh
echo "-----@ OSSEC CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
#  Configure Dionaea for desired services
#
#---------------
echo "-----@ DIONAEA CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
cd $SCRIPTSDIR
# TODO: need to add script to configure dionaea .cfg file for services to be active - https://dionaea.readthedocs.io/en/latest/configuration.html
echo "-----@ DIONAEA CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# Setup Raspberry Pi components
#
#---------------
echo "-----@ Raspberry Pi CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
cd $SCRIPTSDIR
# sudo rpinstall.sh
echo "-----@ Raspberry Pi DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# Setup AWS IoT components
#
#---------------
echo "-----@ AWS IoT CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
cd $SCRIPTSDIR
# sudo awsiotinstall.sh
echo "-----@ AWS IoT DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# CONFIGURE IPTABLES for all services and lockdown instance
#
#---------------
echo "-----@ IPTABLES CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# TODO - Ahmed
echo "-----@ IPTABLES DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT


#---------------
#
# Check that expected processes are active
#
#---------------
pgrep dionaea > /dev/null && echo "Dionaea tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT
pgrep ossec > /dev/null && echo "OSSEC tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT
pgrep cowrie > /dev/null && echo "Dionaea tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# TODO: clean-up remove all files (e.g. applications, source downloads) that not required for production operation
#
#---------------
sudo apt-get -y remove git 
sudo apt-get -y remove make
sudo apt -y autoremove

#---------------
#
# Check for pretend python packages
# http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/
#
#---------------
pip list –format=legacy | egrep '^(acqusition|apidev-coop|bzip|crypt|django-server|pwd|setup-tools|telnet|urlib3|urllib)'

#---------------
#
# Collect status data that may be used for other configuration activities
#
#---------------
echo "-----@ STATUS SNAPSHOT -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo ifconfig -a >>$SCRIPTSDIR/SETUP-RUN.TXT
