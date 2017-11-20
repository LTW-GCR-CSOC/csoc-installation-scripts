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
#  the OpenVAS install scripts are nicely done, need to look at how they have done their install scripts and learn ways to do this script better - particularly like their post-install checks

# Variables
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
BOG='\e[30;48;5;82m'
RED='\e[41m'
GRN='\e[42m'
NC='\033[0m' # e.g. printf "\033[1;31mThis is red text\033[0m\n" or printf "$(RED}This is red text${NC}\n"

SCRIPTSDIR=$HOME/csoc-installation-scripts-master
HOSTNAME="GCRCanaryTEST" #also see hosts file in Installfiles on github

#Unused Ubuntu Mate programs will be uninstalled before core applications are installed
PREINSTALL_CLEANUP="yes"

#Configure and install device
INSTALL_RP="yes"

#Update existing applications
INSTALL_REFRESH="yes"

#Post install cleanup (remove not nessiary applications after core applications are installed)
INSTALL_CLEANUP="no"

#install Syslog configuration files
SETUP_SYSLOG="yes"

#Install Dionaea
INSTALL_DIONAEA="yes" # yes or no.
INSTALL_DIONAEALOGVIEWER="no"  



INSTALL_COWRIE="no"  
INSTALL_COWRIELOGVIEWER="no"  

INSTALL_OSSEC="no"  
INSTALL_OPENVAS="no" 
INSTALL_AWSIOT="no" 
INSTALL_MENDER="no" 


INSTALL_VNCSERVER="no"

SETUP_HOSTNAME="no"

if [[ "$INSTALL_DIONAEA" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: Dionaea will not be installed ****\n"
else
  printf "**** ${GRN}INSTALLING${NC}: Dionaea  ****\n"
fi

if [[ "$INSTALL_COWRIE" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: Cowrie will not be installed ****\n"
else
  printf "**** ${GRN}INSTALLING${NC}: Cowrie  ****\n"
fi

if [[ "$INSTALL_OSSEC" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: OSSEC will not be installed ****\n"
else
  printf "**** ${GRN}INSTALLING${NC}: OSSEC  ****\n"
fi

if [[ "$INSTALL_OPENVAS" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: OpenVAS will not be installed ****\n"
else
  printf "**** ${GRN}INSTALLING${NC}: OpenVAS  ****\n"
fi

if [[ "$INSTALL_AWSIOT" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: AWS IoT will not be installed ****\n"
else
  printf "**** ${GRN}INSTALLING${NC}: AWS IoT  ****\n"
fi

if [[ "$PREINSTALL_CLEANUP" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: Unused Ubuntu Mate programs will not be uninstalled  ****\n"
else
  printf "**** ${GRN}CLEANUP${NC}: Unused Ubuntu Mate programs will be uninstalled  ****\n"
fi

if [[ "$INSTALL_REFRESH" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: No system refresh will not be done ****\n"
else
  printf "**** ${GRN}REFRESH${NC}: System refresh will be done  ****\n"
fi

if [[ "$SETUP_SYSLOG" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: Syslog won't be setup ****\n"
else
 printf "**** ${GRN}INSTALLING${NC}: Syslog will be setup  ****\n"
fi

if [[ "$INSTALL_VNCSERVER" == "no" ]] 
then
 printf "**** ${RED}WARNING${NC}: VNC server will not be installed ****\n"
else
  printf "**** ${GRN}INSTALLING${NC}: VNC server  ****\n"
fi

# ---------------
#
# Install Pre-Check and System Settings
#
#---------------
echo "SCRIPTSDIR = " $HOME  >$SCRIPTSDIR/SETUP-RUN.TXT
echo "Started setup script on" `date`  >>$SCRIPTSDIR/SETUP-RUN.TXT
chmod 0666 $SCRIPTSDIR/SETUP-RUN.TXT
# check Ubuntu version
if [[ `lsb_release -rs` != "16.04" ]]
then
 printf "**** ${RED}WARNING${NC}: this script has not been tested on this version of Ubuntu ****\n"
fi

echo "-----@ SET TIMEZONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
# Option to set it to local timezone
# sudo cp /usr/share/zoneinfo/Canada/Eastern /etc/localtime
# Change device time to UTC time as default for all Canary devices
sudo timedatectl set-timezone UTC

if [[ "$SETUP_HOSTNAME" == "yes" ]] 
then
 echo "-----@ SET HOSTNAME -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
 # set hostname for testing
 sudo hostname ${HOSTNAME}
 cd /etc
 sudo mv hostname hostname.bak
 sudo cat $HOSTNAME >/etc/hostname
 sudo mv hosts hosts.bak
 sudo wget -q https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/hosts
 sudo service hostname start
 printf "${BOG}HOSTNAME=`hostname`${NC}\n"
fi

#---------------
#
# Clean-up files pre-install (e.g. default Ubunut Mate applications) that not required for production operation
#
#---------------
if [[ "$PREINSTALL_CLEANUP" == "yes" ]]
then
printf "${BOG}---------------------------------- PRE INSTALL CLEANUP -----${NC}\n"
sudo apt-get -qq remove --purge -y youtube-dl* \
firefox \
rhythmbox \
brasero \
cheese \
transmission-gtk \
pidgin \
hexchat \
thunderbird \
scratch \
minecraft-pi \
libreoffice*
#sudo apt-get clean
#sudo apt -y autoremove
#atril* \
#qjackctl \
#libmateweather* \
fi

# ---------------
#
# Install Tools 
#
#----------------
sudo apt-get -qq install -y git
sudo apt-get -qq install -y autogen autoconf libtool
sudo apt-get -qq install -y make
sudo apt-get -qq install -y curl
sudo apt-get -qq install python3-pip
# sudo apt-get -qq install -y ntop

# ---------------
#
# Update System
#
#---------------
if [[  "$INSTALL_REFRESH" == "yes" ]]
then
 export DEBIAN_FRONTEND=noninteractive
 sudo apt-get -qq -y update
 sudo ucf --purge /boot/grub/menu.lst
 sudo UCF_FORCE_CONFFNEW=YES apt-get upgrade -yq
 sudo apt-get -qq -y update --fix-missing 
 pip -q install --upgrade pip
 pip3 -q install --upgrade pip setuptools
fi



# ---------------
#
# Install VNC server
#
#---------------
if [[  "$INSTALL_VNCSERVER" == "yes" ]]
then
 ./vncsetup.sh
fi

# ---------------
#
# Install Dionaea 
#
#----------------
if [[ "$INSTALL_DIONAEA" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING DIONAEA -----${NC}\n"
  echo "-----@ DIONAEA INSTALL STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  # don't delete the spaces between "<<!" and "!" below
  sudo adduser --disabled-password dionaea <<!
dionaea





!
sudo $SCRIPTSDIR/dionaeainstall.sh
# sudo $SCRIPTSDIR/dionaeainstall2.sh

#populate Dionaea with content
printf "${BOG}---------------------------------- INSTALLING DIONAEA DUMMY CONTENT -----${NC}\n"
# TODO - need to dynamically create realistic randomized set of files and directories
# TODO - files should have a call-home URL ping to identify where it was viewed
sudo bash -c 'echo "" >  /opt/dionaea/var/dionaea/roots/www/A.pdf'
sudo bash -c 'echo "" >  /opt/dionaea/var/dionaea/roots/www/B.pdf'
sudo bash -c 'echo "" >  /opt/dionaea/var/dionaea/roots/www/C.xls'
sudo bash -c 'echo "" >  /opt/dionaea/var/dionaea/roots/ftp/D.xls'
sudo bash -c 'echo "" >  /opt/dionaea/var/dionaea/roots/tftp/E.xls'

echo "[A.pdf]" | sudo tee --append  /opt/dionaea/var/dionaea/roots/www/A.pdf
echo "[B.pdf]" | sudo tee --append  /opt/dionaea/var/dionaea/roots/www/B.pdf
echo "[C.xls]" | sudo tee --append  /opt/dionaea/var/dionaea/roots/www/C.xls
echo "[D.xls]" | sudo tee --append  /opt/dionaea/var/dionaea/roots/ftp/D.xls
echo "[E.xls]" | sudo tee --append /opt/dionaea/var/dionaea/roots/tftp/E.xls


  echo "-----@ DIONAEA INSTALL DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

# ---------------
#
# Install Dionaea GCR enhanced dionaea log utility
#
#----------------
if [[ "$INSTALL_DIONAEA" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING DIONAEA ENHANCED LOG UTILITY -----${NC}\n"
  echo "-----@ DIONAEA GCR ENHANCED LOG INSTALL STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  cd $SCRIPTSDIR
  printf "${BOG}---------------------------------- INSTALLING DIONAEA ENHANCED LOG UTILITY - 2 minute delay -----${NC}\n"
  # delay for a few minutes to let dionaea and system get ready... prob should add a check here rather than a timer
  sleep 2m # 2 minutes for now
  sudo pip3 -q install schedule
  sudo pip3 -q install psutil
  sudo wget -q https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/SampleLogFiles/GCRdionaeaAlerts.py
  sudo mv $SCRIPTSDIR/GCRdionaeaAlerts.py /opt/dionaea/bin
  sudo chmod 0755 /opt/dionaea/bin/GCRdionaeaAlerts.py
  sudo chown nobody:nogroup /opt/dionaea/bin/GCRdionaeaAlerts.py
  sudo mv $SCRIPTSDIR/GCRdionaeaAlerts /etc/init.d
  sudo chmod 0755 /etc/init.d/GCRdionaeaAlerts
  sudo chown root:root /etc/init.d/GCRdionaeaAlerts
  sudo systemctl daemon-reload
  sudo update-rc.d GCRdionaeaAlerts defaults
  sudo update-rc.d GCRdionaeaAlerts enable
  sudo /etc/init.d/GCRdionaeaAlerts start
  sudo systemctl GCRdionaeaAlerts status >>$SCRIPTSDIR/SETUP-RUN.TXT
  echo "-----@ DIONAEA GCR ENHANCED LOG UTILITY INSTALL DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

# ---------------
#
# Install Dionaea Log Viewer (for development)
#
#----------------
if [[ "$INSTALL_DIONAEALOGVIEWER" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING DIONAEA LOG VIEWER -----${NC}\n"
  echo "-----@ DIONAEA LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  # Dedicated user and group for dionaeafr
  sudo adduser --disabled-password dionaeafr <<!
dionaeafr





!
  sudo groupadd dionaeafr
  sudo usermod -a -G dionaeafr dionaeafr
  sudo usermod -a -G dionaeafr dionaea
    
  sudo $SCRIPTSDIR/dionaealogviewer2.sh
  echo "-----@ DIONAEA LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

# ---------------
#
# Install Cowrie
#
#----------------
if [[ "$INSTALL_COWRIE" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING COWRIE -----${NC}\n"
  echo "-----@ COWRIE CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# change default port to Port 8742 (to be tested with the pi)
#    sed -i '/^Port/c\Port 8742' /etc/ssh/sshd_config
  sudo $SCRIPTSDIR/cowrieinstall.sh
  echo "-----@ COWRIE CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

# ---------------
#
# Install Cowrie Log Viewer (for development)
#
#----------------
if [[ "$INSTALL_COWRIELOGVIEWER" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING COWRIE LOG VIEWER -----${NC}\n"
  echo "-----@ COWRIE LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  sudo $SCRIPTSDIR/cowrielogviewer.sh
  echo "-----@ COWRIE LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi


# ---------------
#
# Install OSSEC  
# https://ossec.github.io/index.html
#
#----------------
if [[ "$INSTALL_OSSEC" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING OSSEC -----${NC}\n"
  echo "-----@ OSSEC CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  #sudo $SCRIPTSDIR/ossecinstall.sh
  echo "-----@ OSSEC CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

if [[ "$INSTALL_RP" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING and Configuring RP -----${NC}\n"
  sudo $SCRIPTSDIR/rpinstall.sh
fi

# ---------------
#
# Install OPENVAS  
# http://www.openvas.org/
#
#----------------
if [[ "$INSTALL_OPENVAS" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING OPENVAS -----${NC}\n"
  echo "-----@ OPENVAS CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  sudo $SCRIPTSDIR/openvas/openvasinstall.sh
  echo "-----@ OPENVAS CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

#---------------
#
# Setup Raspberry Pi components
#
#---------------
if [[ "$INSTALL_RP" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING RP -----${NC}\n"
  echo "-----@ Raspberry Pi CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  #cd $SCRIPTSDIR
  sudo $SCRIPTSDIR/rpinstall.sh
  echo "-----@ Raspberry Pi DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

#---------------
#
# Setup AWS IoT components
#
#---------------
if [[ "$INSTALL_AWSIOT" == "yes" ]]
then
  printf "${BOG}---------------------------------- INSTALLING AWS IOT -----${NC}\n"
  echo "-----@ AWS IoT CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
  cd $SCRIPTSDIR
  # sudo awsiotinstall.sh
  echo "-----@ AWS IoT DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
fi

#---------------
#
# CONFIGURE IPTABLES for all services and lockdown instance
#
#---------------
printf "${BOG}---------------------------------- CONFIGURING IPTABLES -----${NC}\n"
echo "-----@ IPTABLES CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# TODO - Ahmed
echo "-----@ IPTABLES DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install and configure syslog-ng
#
#----------------
printf "${BOG}---------------------------------- CONFIGURING SYSLOG-NG -----${NC}\n"
echo "-----@ SYSLOG-NG CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
# TODO 
echo "-----@ SYSLOG-NG DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# Check that expected processes are active
#
#---------------
printf "${BOG}---------------------------------- POST INSTALL CHECKING -----${NC}\n"
pgrep dionaea > /dev/null && echo "Dionaea tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT
pgrep ossec > /dev/null && echo "OSSEC tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT
pgrep cowrie > /dev/null && echo "Dionaea tasks are running" >>$SCRIPTSDIR/SETUP-RUN.TXT




#---------------
#
# TODO: clean-up remove all files (e.g. applications, source downloads) that not required for production operation
#
#---------------
if [[ "$INSTALL_CLEANUP" == "yes" ]]
then
 printf "${BOG}---------------------------------- POST INSTALL CLEANUP -----${NC}\n"
 sudo apt-get -y remove git 
 sudo apt-get -y remove make
 sudo apt-get -y remove ntop
 sudo apt -y autoremove
 # force removal of all compilers and dev tools that are no longer required for production deployment
fi


# ---------------
#
# Setup Syslog Configuration for honeypot
#
#----------------
if [[ "$SETUP_SYSLOG" == "yes" ]]
then
  printf "${BOG}---------------------------------- INITIAL CONFIGURATION OF SYSLOG -----${NC}\n"

  cd $SCRIPTSDIR
  #00-GCRdionaeaHP.conf
  sudo wget -q https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/SampleLogFiles/configForHP-notEnc/00-GCRdionaeaHP.conf
  sudo mv $SCRIPTSDIR/00-GCRdionaeaHP.conf /etc/rsyslog.d
  sudo chmod 0755 /etc/rsyslog.d/00-GCRdionaeaHP.conf
  sudo chown root:root /etc/rsyslog.d/00-GCRdionaeaHP.conf
  
  #50-default.conf
  sudo mv /etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.backup
  sudo wget -q https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/SampleLogFiles/configForHP-notEnc/50-default.conf
  sudo mv $SCRIPTSDIR/50-default.conf /etc/rsyslog.d
  sudo chmod 0755 /etc/rsyslog.d/50-default.conf
  sudo chown root:root /etc/rsyslog.d/50-default.conf
  
  #rsyslog.conf
  sudo mv /etc/rsyslog.conf /etc/rsyslog.backup
  cd $SCRIPTSDIR
  sudo wget -q https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/SampleLogFiles/configForHP-notEnc/rsyslog.conf
  sudo mv $SCRIPTSDIR/rsyslog.conf /etc/rsyslog.conf
  sudo chmod 0755 /etc/rsyslog.conf
  sudo chown root:root /etc/rsyslog.conf
  
  printf "${BOG}---------------------------------- INITIAL CONFIGURATION OF SYSLOG COMPLETE-----${NC}\n"
  printf "${BOG}REMINDER: update <dest_ip_address>:<port> in /etc/rsyslog.d/00-GCRdionaeaHP.conf ${NC}\n"
fi


#---------------
#
# Do post-install security checks: known exposures, ports, userids, etc
#
#---------------
printf "${BOG}---------------------------------- POST INSTALL SECURITY CHECKS -----${NC}\n"
# Check for pretend python packages
# http://www.nbu.gov.sk/skcsirt-sa-20170909-pypi/
# TODO : need to ensure pip is installed first
pip list –format=legacy | egrep '^(acqusition|apidev-coop|bzip|crypt|django-server|pwd|setup-tools|telnet|urlib3|urllib)'

#---------------
#
# Collect status data that may be used for other configuration activities
#
#---------------
printf "${BOG}---------------------------------- WRAPPING UP -----${NC}\n"
echo "-----@ STATUS SNAPSHOT -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo ifconfig -a >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo service --status-all >>$SCRIPTSDIR/SETUP-RUN.TXT

#---------------
#
# END - Prompt user to restart the device
#
#---------------
printf "${BOG}---------------------------- END -----------------------------------${NC}\n"
printf "DEVICE NEEDS TO BE REBOOTED. EXECUTE THE FOLLOWING COMMAND: shutdown -r now \n"
