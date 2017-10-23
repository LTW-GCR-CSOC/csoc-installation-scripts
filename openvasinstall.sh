#!/usr/bin/env bash
#
# OpenVAS install
# Reference: https://avleonov.com/2017/04/10/installing-openvas-9-from-the-sources/
# v0.3

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
  
# Install dependencies

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Starting the OpenVAS install. It will take between 1-3 hours to install"

echo "Installing curl and CMake..."
sudo apt-get -y install curl
sudo apt-get -y install cmake
echo "Finished installing curl and CMake"

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
# Add Creative Commons note here
# Install Redis from source
echo "Installing Redis..."
sudo apt-get -y update
sudo apt-get -y install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable

make
make test
sudo make install

sudo mkdir /etc/redis
cd /etc/redis
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/redis.conf
cd /etc/systemd/system/
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/redis.service

sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

sudo systemctl start redis

sudo systemctl enable redis

echo -n "Redis is currently: "
sudo systemctl is-active redis
echo "Finished installing Redis"


cd $DIR
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/openvas-commander/master/openvas_commander.sh
chmod +x openvas_commander.sh

# Install dependencies (the longest operation):
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

# ./openvas_commander.sh --install-component "openvas-smb"
#sudo ./openvas_commander.sh --install-component "openvas-libraries"
#sudo ./openvas_commander.sh --install-component "openvas-scanner"
#sudo ./openvas_commander.sh --install-component "openvas-manager"
#sudo ./openvas_commander.sh --install-component "openvas-cli"
#sudo ./openvas_commander.sh --install-component "greenbone-security-assistant"
echo "Finished installing the OpenVAS components"

echo "Cleaning up leftover files..."
sudo apt-get autoremove
sudo apt-get clean
echo "Finished cleaning up leftover files..."

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

# Check, that everything is started:

./openvas_commander.sh --check-proc

# Sleep for 3 min
echo "Sleeping for 3 minutes. Will check the status of the processes after that"
sleep 3m

./openvas_commander.sh --check-proc

# If something goes wrong, you can always find out what to do next with:
sudo ./openvas_commander.sh --check-status v9

# Install the autostart script
echo "Setting up OpenVAS for autostart on boot..."
cd /etc/init.d/
sudo wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/openvas_start
sudo chmod +x openvas_start 
sudo update-rc.d openvas_start defaults

cd $DIR
echo 'OpenVAS is now ready to use! Open a web browser and go to "localhost" to access the web interface.'
