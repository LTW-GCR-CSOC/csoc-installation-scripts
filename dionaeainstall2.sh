#!/bin/bash
# Written by Mohd Khairulazam
# Honeypot Auto-Install Script
# Bug reports welcome
# email = m.khairulazam@gmail.com

echo "Type your network interface e.g. eth0, followed by [ENTER]:"
read ifconfig

echo "Type your IP address e.g. 10.10.10.10, followed by [ENTER]:"
read ipaddress

{
	
	# Update repo
	apt-get update --fix-missing

	# Install required packages from repo
	apt-get install libudns-dev libglib2.0-dev libssl-dev libcurl4-openssl-dev libreadline-dev libsqlite3-dev python-dev libtool automake autoconf build-essential subversion git-core flex bison pkg-config libgc-dev libgc1c2 sqlite3 python-geoip sqlite python-pip -y

	# Create /opt/dionaea/ directory
	mkdir /opt/dionaea/

	# Create temp folder for installation
	mkdir ~/src

	# Liblcfg
	cd ~/src
	git clone git://git.carnivore.it/liblcfg.git liblcfg
	cd liblcfg/code
	autoreconf -vi
	./configure --prefix=/opt/dionaea
	make install
	ldconfig

	# Libemu
	cd ~/src
	git clone git://git.carnivore.it/libemu.git libemu
	cd libemu
	autoreconf -vi
	./configure --prefix=/opt/dionaea
	make install
	ldconfig

	# Libnl
	apt-get install libnl-3-dev libnl-genl-3-dev libnl-nf-3-dev libnl-route-3-dev -y

	# Libev
	cd ~/src
	wget http://dist.schmorp.de/libev/libev-4.19.tar.gz
	tar xfz libev-4.19.tar.gz
	cd libev-4.19
	./configure --prefix=/opt/dionaea
	make install
	ldconfig

	# Python 
	cd ~/src
	wget http://www.python.org/ftp/python/3.2.2/Python-3.2.2.tgz
	tar xfz Python-3.2.2.tgz
	cd Python-3.2.2
	./configure --enable-shared --prefix=/opt/dionaea --with-computed-gotos --enable-ipv6 LDFLAGS="-Wl,-rpath=/opt/dionaea/lib/ -L/usr/lib/x86_64-linux-gnu/"
	make
	make install
	ldconfig

	# Cython
	cd ~/src
	wget http://cython.org/release/Cython-0.21rc1.tar.gz
	tar xfz Cython-0.21rc1.tar.gz
	cd Cython-0.21rc1
	/opt/dionaea/bin/python3 setup.py install
	ldconfig

	# Libpcap
	cd ~/src
	wget http://www.tcpdump.org/release/libpcap-1.6.2.tar.gz
	tar xfz libpcap-1.6.2.tar.gz
	cd libpcap-1.6.2
	./configure --prefix=/opt/dionaea
	make
	make install
	ldconfig

	# p0f
	apt-get install p0f -y
	cd /
	mkdir nonexistent
	chown -R nobody:nogroup nonexistent
	mkdir /var/p0f

	# Dionaea
	cd ~/src
	git clone git://git.carnivore.it/dionaea.git dionaea
	cd dionaea
	autoreconf -vi
	./configure --with-lcfg-include=/opt/dionaea/include/ --with-lcfg-lib=/opt/dionaea/lib/ --with-python=/opt/dionaea/bin/python3.2 --with-cython-dir=/opt/dionaea/bin --with-udns-include=/opt/dionaea/include/ --with-udns-lib=/opt/dionaea/lib/ --with-emu-include=/opt/dionaea/include/ --with-emu-lib=/opt/dionaea/lib/ --with-gc-include=/usr/include/gc --with-ev-include=/opt/dionaea/include --with-ev-lib=/opt/dionaea/lib --with-nl-include=/opt/dionaea/include --with-nl-lib=/opt/dionaea/lib/ --with-curl-config=/usr/bin/ --with-pcap-include=/opt/dionaea/include --with-pcap-lib=/opt/dionaea/lib/
	make
	make install
	ldconfig

	# Setting up dionaea config file
	wget https://github.com/zam89/maduu/raw/master/conf/dionaea.conf -O /opt/dionaea/etc/dionaea/dionaea.conf
	wget https://github.com/zam89/maduu/raw/master/hpfeeds/dionaea/hpfeeds.py -O /opt/dionaea/lib/dionaea/python/dionaea/hpfeeds.py
	wget https://github.com/zam89/maduu/raw/master/hpfeeds/dionaea/ihandlers.py -O /opt/dionaea/lib/dionaea/python/dionaea/ihandlers.py

	chown -R nobody:nogroup /opt/dionaea/var/dionaea
	chown -R nobody:nogroup /opt/dionaea/var/log

	# Setting up init.d file
	cd /etc/init.d
	wget https://github.com/zam89/maduu/raw/master/init/p0f -O /etc/init.d/p0f
	wget https://github.com/zam89/maduu/raw/master/init/dionaea -O /etc/init.d/dionaea

	chmod 755 p0f
	chmod +x p0f
	chmod 755 dionaea
	chmod +x dionaea

	sed -i 's/-i venet0:0/-i '$ifconfig'/' /etc/init.d/p0f
	sed -i 's/eth0 = \[""\]/'$ifconfig' = \["'$ipaddress'"\]/' /opt/dionaea/etc/dionaea/dionaea.conf

	# Start p0f & dionaea
	/etc/init.d/p0f start
	chown nobody:nogroup /tmp/p0f.sock
	/etc/init.d/dionaea start

} 2>&1 | tee hornet.log
