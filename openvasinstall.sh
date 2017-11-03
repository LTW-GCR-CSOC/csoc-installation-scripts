#!/usr/bin/env bash
#
# OpenVAS install
# Reference: https://avleonov.com/2017/04/10/installing-openvas-9-from-the-sources/
# v0.4

# Variables
# https://misc.flogisoft.com/bash/tip_colors_and_formatting
BOG='\e[30;48;5;82m'
RED='\e[41m'
GRN='\e[42m'
NC='\033[0m' # e.g. printf "\033[1;31mThis is red text\033[0m\n" or printf "$(RED}This is red text${NC}\n"
 
if [[ "$EUID" -ne 0 ]]; then
  printf "**** ${RED}Sorry, you need to run this as root${NC} ****\n"
  exit 2
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  
# Install dependencies
echo "Starting the OpenVAS install. It will take between 1-3 hours to install"

echo "Installing curl and CMake..."
sudo apt-get -y install curl
sudo apt-get -y install cmake
echo "Finished installing curl and CMake"

cd $DIR
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/openvas-commander/master/openvas_commander.sh
chmod +x openvas_commander.sh

# Install dependencies (the longest operation):
echo "Installing Redis..."
sudo ./openvas_commander.sh --install-redis-source
echo "Finished installing Redis"

echo "Installing dependencies..."
sudo ./openvas_commander.sh --install-dependencies
echo "Finished installing dependencies"

# Available versions of OpenVAS:

sudo ./openvas_commander.sh --show-releases

# Available source archives for OpenVAS 9:

sudo ./openvas_commander.sh --show-sources "OpenVAS-9"

# Download and unpack:

echo "Downloading and unpacking the source files..."
sudo ./openvas_commander.sh --download-sources "OpenVAS-9"
sudo ./openvas_commander.sh --create-folders
echo "Finished downloading and unpacking the source files"

# Everything is in place and we are ready for actual installation:

ls openvas

# Install the components:
echo "Installing the OpenVAS components..."
sudo ./openvas_commander.sh --install-all

# NB: If you are afraid that something might go wrong, you can start separately:

#sudo ./openvas_commander.sh --install-component "openvas-smb"
#sudo ./openvas_commander.sh --install-component "openvas-libraries"
#sudo ./openvas_commander.sh --install-component "openvas-scanner"
#sudo ./openvas_commander.sh --install-component "openvas-manager"
#sudo ./openvas_commander.sh --install-component "openvas-cli"
#sudo ./openvas_commander.sh --install-component "greenbone-security-assistant"
echo "Finished installing the OpenVAS components"

# Cleanup needs further testing
#echo "Cleaning up leftover files..."
#sudo apt-get autoremove
#sudo apt-get clean
#echo "Finished cleaning up leftover files..."

# Create certificates and a user:

echo "Configuring the OpenVAS components..."
sudo ./openvas_commander.sh --configure-all
echo "Finished configuring the OpenVAS components"

# Update and rebuild content:
echo "Updating content..."
sudo ./openvas_commander.sh --update-content
echo "Done updating content"
sudo ./openvas_commander.sh --start-all

echo "Rebuilding content..."
sudo ./openvas_commander.sh --rebuild-content
echo "Finished rebuilding content"

# Check that everything is started:

./openvas_commander.sh --check-proc

# Sleep for 3 min
echo "Sleeping for 3 minutes. Will check the status of the processes after that"
sleep 3m

./openvas_commander.sh --check-proc

# If something goes wrong, you can always find out what to do next with:
sudo ./openvas_commander.sh --check-status v9

# Install the service
echo "Setting up OpenVAS for autostart on boot..."
sudo ./openvas_commander.sh --install-service

cd $DIR
echo 'OpenVAS is now ready to use! Open a web browser and go to "localhost" to access the web interface.'
