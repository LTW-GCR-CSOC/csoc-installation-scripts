#!/usr/bin/env bash
#
# openvas install
# Reference: https://avleonov.com/2017/04/10/installing-openvas-9-from-the-sources/
# v0.1

# install dependencies

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sudo apt-get -y install curl
sudo apt-get -y install cmake

# Reference: https://askubuntu.com/questions/689935/unable-to-locate-package-mingw32
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mingw32/mingw32_4.2.1.dfsg-2ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mingw32-binutils/mingw32-binutils_2.20-0.2ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mingw32-runtime/mingw32-runtime_3.15.2-0ubuntu1_all.deb
sudo dpkg -i *.deb
sudo apt-get install -f
sudo dpkg -i *.deb
rm *.deb

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
# Add Creative Commons note here
# Install Redis from source
sudo apt-get -y update
sudo apt-get -y install build-essential tcl
sudo cd /tmp
sudo curl -O http://download.redis.io/redis-stable.tar.gz
sudo tar xzvf redis-stable.tar.gz
sudo cd redis-stable

sudo make
sudo make test
sudo make install

sudo mkdir /etc/redis
cd /etc/redis
sudo wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/redis.conf
sudo chown root:root redis.conf
sudo chmod 0755 redis.conf
sudo cd /etc/systemd/system/
sudo wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/redis.service
sudo chown root:root redis.service
sudo chmod 0755 redis.service

sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

sudo systemctl start redis

sudo systemctl enable redis

cd $DIR
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/openvas-commander/master/openvas_commander.sh
chmod +x openvas_commander.sh

# Install dependencies (the longest operation):

sudo ./openvas_commander.sh --install-dependencies

# Available versions of OpenVAS:

./openvas_commander.sh --show-releases

# Available source archives for OpenVAS 9:

./openvas_commander.sh --show-sources "OpenVAS-9"

# Download and unpack:

sudo ./openvas_commander.sh --download-sources "OpenVAS-9"
sudo ./openvas_commander.sh --create-folders

# Everything is in place and we are ready for actual installation:

ls openvas

# Install the components:

#./openvas_commander.sh --install-all

# NB: If you are afraid that something might go wrong, you can start separately:

# ./openvas_commander.sh --install-component "openvas-smb"
sudo ./openvas_commander.sh --install-component "openvas-libraries"
sudo ./openvas_commander.sh --install-component "openvas-scanner"
sudo ./openvas_commander.sh --install-component "openvas-manager"
sudo ./openvas_commander.sh --install-component "openvas-cli"
sudo ./openvas_commander.sh --install-component "greenbone-security-assistant"

#The rest of the install script goes here
# Create certificates and a user:

sudo ./openvas_commander.sh --configure-all

# Update and rebuild content:

sudo ./openvas_commander.sh --update-content

sudo ./openvas_commander.sh --kill-all
sudo ./openvas_commander.sh --start-all

#Wait 10 min to allow the NVTs to generate
echo "Waiting for 10 minutes to allow the NVTs to generate..."
sleep 10m
sudo ./openvas_commander.sh --rebuild-content

#Launch the OpenVAS processes:

sudo ./openvas_commander.sh --kill-all
sudo ./openvas_commander.sh --start-all

# Check, that everything is started, wait for openvassd:

./openvas_commander.sh --check-proc

# Sleep for 3 min
echo "Sleeping for 3 minutes. Will check the status of the processes after that"
sleep 180

./openvas_commander.sh --check-proc

# If something goes wrong, you can always find out what to do next with:
sudo ./openvas_commander.sh --check-status v9
