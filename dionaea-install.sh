# ---------------
#
# Install Dionaea 
#
#----------------

# remove old directories to do a clean install
if [ -d "/opt/dionaea" ]; then
  echo "Removing old /opt/dionaea directory" >>$SCRIPTSDIR/SETUP-RUN.TXT
  sudo rm -rf /opt/dionaea
fi
echo "-----@ LATEST SOFTWARE UPDATES -----"
sudo apt-get install -y git
sudo apt-get install -y autogen autoconf libtool
sudo apt-get install -y make
sudo apt-get install -y pkg-config
sudo apt-get install -y libglib2.0-dev
sudo apt-get install -y curl
sudo apt-get install -y python3-pip
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt install -y python-pip
sudo -H pip install Cython
sudo apt-get install -y udns-utils
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y aptitude
sudo apt-get install -y libemu-dev
sudo apt-get install -y libudns-dev
sudo apt-get install -y libev-dev
sudo apt-get install -y \
    autoconf \
    automake \
    build-essential \
    check \
    cython3 \
    libcurl4-openssl-dev \
    libemu-dev \
    libev-dev \
    libglib2.0-dev \
    libloudmouth1-dev \
    libnetfilter-queue-dev \
    libnl-3-dev \
    libpcap-dev \
    libssl-dev \
    libtool \
    libudns-dev \
    python3 \
    python3-dev \
    python3-yaml 
sudo git clone https://github.com/LTW-GCR-CSOC/dionaea.git /opt/dionaea
cd /opt/dionaea
sudo autoreconf -vi
sudo ./configure \
 --disable-werror \
 --prefix=/opt/dionaea \
 --with-python=/usr/bin/python3 \
 --with-cython-dir=/usr/bin \
 --with-ev-include=/usr/include \
 --with-ev-lib=/usr/lib \
 --with-emu-lib=/usr/lib/libemu \
 --with-emu-include=/usr/include \
 --with-nl-include=/usr/include \
 --with-nl-lib=/usr/lib \
 --with-curl-dir=/usr/bin/curl 
sudo make
sudo make install
sudo ldconfig
sudo chown -R nobody:nogroup /opt/dionaea/var/dionaea
sudo chown -R nobody:nogroup /opt/dionaea/var/log
echo "-----@ DIONAEA SETUP DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
#
# the following command should run and display dionaea help 
#
/opt/dionaea/bin/dionaea -H
# start service
sudo /opt/dionaea/bin/dionaea -u nobody -g nogroup -c /opt/dionaea/etc/dionaea/dionaea.cfg -w /opt/dionaea -p /opt/dionaea/var/dionaea.pid -D

# Dionaea log rotation configuration
sudo chmod 0777 /etc/logrotate.d
cd /etc/logrotate.d/
sudo cat > dionaea << EOF
/opt/dionaea/var/dionaea/dionaea.log {
       notifempty
       missingok
       rotate 28
       daily
       delaycompress
       compress
       create 660 root root
       dateext
       postrotate
               kill -HUP `cat /opt/dionaea/var/dionaea.pid`
       endscript
}
EOF
sudo chmod 0755 /etc/logrotate.d

# Check Dionaea processes 
echo "-----@ DIONAEA RUNNING CHECK -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo ps -ef | grep dionaea >>$SCRIPTSDIR/SETUP-RUN.TXT
# Check Dionaea logs exist
ls -l /opt/dionaea/var/dionaea/dionaea.log >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Configure Dionaea to restart on reboot
# https://blog.honeynet.org.my/2010/02/14/dionaea-auto-start-script-on-ubuntu/
#
#----------------
echo "-----@ DIONAEA REBOOT CONFIGURATION -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo mv $SCRIPTSDIR/dionaea /etc/init.d/
sudo update-rc.d dionaea defaults
sudo /etc/init.d/dionaea start
echo "-----@ DIONAEA REBOOT CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT

# ---------------
#
# Install Dionaea Log Viewer (for development)
#
#----------------
echo "-----@ DIONAEA LOG VIEWER CONFIGURATION STARTS -----"  >>$SCRIPTSDIR/SETUP-RUN.TXT
sudo $SCRIPTSDIR/dionaealogviewer.sh
echo "-----@ DIONAEA LOG VIEWER CONFIGURATION DONE -----" >>$SCRIPTSDIR/SETUP-RUN.TXT
