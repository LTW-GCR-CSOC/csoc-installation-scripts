#!/usr/bin/env bash
#
# openvas install
# Reference: https://avleonov.com/2017/04/10/installing-openvas-9-from-the-sources/
# v0.1

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

# install dependencies

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

apt-get -y install curl
apt-get -y install cmake

# Reference: https://askubuntu.com/questions/689935/unable-to-locate-package-mingw32
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mingw32/mingw32_4.2.1.dfsg-2ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mingw32-binutils/mingw32-binutils_2.20-0.2ubuntu1_amd64.deb
wget http://archive.ubuntu.com/ubuntu/pool/universe/m/mingw32-runtime/mingw32-runtime_3.15.2-0ubuntu1_all.deb
dpkg -i *.deb
apt-get install -f
dpkg -i *.deb
rm *.deb

# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-redis-on-ubuntu-16-04
# Add Creative Commons note here
# Install Redis from source
apt-get -y update
apt-get -y install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable

make
make test
make install

mkdir /etc/redis
cd /etc/redis
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/redis.conf
chown root:root redis.conf
chmod 0755 redis.conf
cd /etc/systemd/system/
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/redis.service
chown root:root redis.service
chmod 0755 redis.service

adduser --system --group --no-create-home redis
mkdir /var/lib/redis
chown redis:redis /var/lib/redis
chmod 770 /var/lib/redis

systemctl start redis

systemctl enable redis

cd $DIR
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/openvas-commander/master/openvas_commander.sh
chmod +x openvas_commander.sh

# Install dependencies (the longest operation):

./openvas_commander.sh --install-dependencies

# Available versions of OpenVAS:

./openvas_commander.sh --show-releases

# Available source archives for OpenVAS 9:

./openvas_commander.sh --show-sources "OpenVAS-9"

# Download and unpack:

./openvas_commander.sh --download-sources "OpenVAS-9"
./openvas_commander.sh --create-folders

# Everything is in place and we are ready for actual installation:

ls openvas

# Install the components:

#./openvas_commander.sh --install-all

# NB: If you are afraid that something might go wrong, you can start separately:

# ./openvas_commander.sh --install-component "openvas-smb"
./openvas_commander.sh --install-component "openvas-libraries"
./openvas_commander.sh --install-component "openvas-scanner"
./openvas_commander.sh --install-component "openvas-manager"
./openvas_commander.sh --install-component "openvas-cli"
./openvas_commander.sh --install-component "greenbone-security-assistant"

#The rest of the install script goes here
# Create certificates and a user:

./openvas_commander.sh --configure-all

# Update and rebuild content:

./openvas_commander.sh --update-content

./openvas_commander.sh --kill-all
./openvas_commander.sh --start-all

#Wait 10 min to allow the NVTs to generate
echo "Waiting for 10 minutes to allow the NVTs to generate..."
./openvas_commander.sh --rebuild-content

#Launch the OpenVAS processes:

./openvas_commander.sh --kill-all
./openvas_commander.sh --start-all

# Check, that everything is started, wait for openvassd:

./openvas_commander.sh --check-proc

# Sleep for 3 min
echo "Sleeping for 3 minutes. Will check the status of the processes after that"
sleep 180

./openvas_commander.sh --check-proc

# If something goes wrong, you can always find out what to do next with:
./openvas_commander.sh --check-status v9
