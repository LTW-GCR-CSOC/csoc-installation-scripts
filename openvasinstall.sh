#
# openvas install
# https://avleonov.com/2017/04/10/installing-openvas-9-from-the-sources/
#

apt-get install curl
wget https://raw.githubusercontent.com/leonov-av/openvas-commander/master/openvas_commander.sh
chmod +x openvas_commander.sh

# Install dependencies (the longest operation):

./openvas_commander.sh --install-dependencies

# Available versions of OpenVAS:

./openvas_commander.sh --show-releases

# Available source archives for OpenVAS 9:

./openvas_commander.sh --show-sources "OpenVAS-9"
# http://wald.intevation.org/frs/download.php/2420/openvas-libraries-9.0.1.tar.gz
# http://wald.intevation.org/frs/download.php/2423/openvas-scanner-5.1.1.tar.gz
# http://wald.intevation.org/frs/download.php/2426/openvas-manager-7.0.1.tar.gz
# http://wald.intevation.org/frs/download.php/2429/greenbone-security-assistant-7.0.2.tar.gz
# http://wald.intevation.org/frs/download.php/2397/openvas-cli-1.4.5.tar.gz
# http://wald.intevation.org/frs/download.php/2377/openvas-smb-1.0.2.tar.gz
# http://wald.intevation.org/frs/download.php/2401/ospd-1.2.0.tar.gz
# http://wald.intevation.org/frs/download.php/2405/ospd-debsecan-1.2b1.tar.gz

# Download and unpack:

./openvas_commander.sh --download-sources "OpenVAS-9"
./openvas_commander.sh --create-folders

# Everything is in place and we are ready for actual installation:

ls openvas
greenbone-security-assistant-7.0.2 openvas-scanner-5.1.1
greenbone-security-assistant-7.0.2.tar.gz openvas-scanner-5.1.1.tar.gz
openvas-cli-1.4.5 openvas-smb-1.0.2
openvas-cli-1.4.5.tar.gz openvas-smb-1.0.2.tar.gz
openvas-libraries-9.0.1 ospd-1.2.0
openvas-libraries-9.0.1.tar.gz ospd-1.2.0.tar.gz
openvas-manager-7.0.1 ospd-debsecan-1.2b1
openvas-manager-7.0.1.tar.gz ospd-debsecan-1.2b1.tar.gz

# Install the components:

./openvas_commander.sh --install-all

# NB: If you are afraid that something might go wrong, you can start separately:

# ./openvas_commander.sh --install-component "openvas-smb"
# ./openvas_commander.sh --install-component "openvas-libraries"
# ./openvas_commander.sh --install-component "openvas-scanner"
# ./openvas_commander.sh --install-component "openvas-manager"
# ./openvas_commander.sh --install-component "openvas-cli"
# ./openvas_commander.sh --install-component "greenbone-security-assistant"

# Create certificates and a user:

./openvas_commander.sh --configure-all

# Update and rebuild content:

./openvas_commander.sh --update-content
./openvas_commander.sh --rebuild-content

#Launch the OpenVAS processes:

./openvas_commander.sh --kill-all
./openvas_commander.sh --start-all


# Check, that everything is started, wait for openvassd:

./openvas_commander.sh --check-proc
# root 10404 15.5 7.2 142980 74724 pts/0 SL 18:17 0:00 openvasmd
# root 10422 59.0 1.0 35424 11004 ? Rs 18:17 0:01 openvassd: Reloaded 14250 of 52652 NVTs (27% / ETA: 00:08)
# root 10424 0.0 0.2 31536 2732 ? S 18:17 0:00 openvassd (Loading Handler)
# root 10425 0.6 0.5 28452 6056 pts/0 Sl 18:17 0:00 /usr/local/sbin/gsad
# root 10426 0.0 0.3 28452 3424 pts/0 Sl 18:17 0:00 /usr/local/sbin/gsad
# root 10439 0.0 0.2 4556 2184 pts/0 S+ 18:17 0:00 grep -E (openvas.d|gsad)

# in a few minutes all NVTs are reloaded:

./openvas_commander.sh --check-proc
# root 10404 0.8 7.2 142980 74724 pts/0 SL 18:17 0:00 openvasmd
# root 10422 8.2 1.0 35556 11132 ? Ss 18:17 0:05 openvassd: Waiting for incoming connections
# root 10425 0.0 0.5 28452 6056 pts/0 Sl 18:17 0:00 /usr/local/sbin/gsad
# root 10426 0.0 0.3 28452 3424 pts/0 Sl 18:17 0:00 /usr/local/sbin/gsad
# root 10463 0.0 0.2 4556 2204 pts/0 S+ 18:19 0:00 grep -E (openvas.d|gsad)

# If something goes wrong, you can always find out what to do next with:
./openvas_commander.sh --check-status v9
