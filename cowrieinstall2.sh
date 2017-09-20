 echo "Installing Cowrie..."
  apt install libffi-dev libgmp-dev libmpc-dev libmpfr-dev libpython-dev python-virtualenv -y
  # Cowrie requires the latest version of Python OpenSSL.
  apt remove python-openssl -y
  pip install pyopenssl
  cd /opt
  git clone https://github.com/micheloosterhof/cowrie.git
  cd cowrie
  cp cowrie.cfg.dist cowrie.cfg
  mkdir tmp
  cd tmp
  # Cowrie requires the latest verison of Twisted.
  git clone -b trunk https://github.com/twisted/twisted.git
  cd twisted
  python setup.py install
  cd ../..
  rm -rf tmp
  pip install -U -r requirements.txt
  echo "Making underprivileged user..."
  useradd -r -s /bin/false cowrie
  mkdir -p /var/run/cowrie
  chown -R cowrie:cowrie /opt/cowrie/
  chown -R cowrie:cowrie /var/run/cowrie/
  mkdir /home/cowrie
  chown cowrie:cowrie /home/cowrie
  echo "Fixing up the Cowrie config file..."
  sed -i 's/^\(hostname\s*=\s*\).*/\1'"$SERVER"'/' cowrie.cfg
  echo "Making the Cowrie filesystem..."
  /opt/cowrie/bin/createfs
  echo "Making logrotate script..."
  wget https://raw.githubusercontent.com/phage-nz/malware-hunting/master/honeypot/cowrie.logrotate -O /etc/logrotate.d/cowrie
  echo "Setting service to autostart..."
  wget https://raw.githubusercontent.com/phage-nz/malware-hunting/master/honeypot/cowrie.service -O /etc/systemd/system/cowrie.service
  wget https://raw.githubusercontent.com/phage-nz/malware-hunting/master/honeypot/cowrie.socket -O /etc/systemd/system/cowrie.socket
  sed -i 's/tcp:2222:interface=0.0.0.0/systemd:domain=INET:index=0/g' /opt/cowrie/cowrie.cfg
  sed -i 's/tcp:2223:interface=0.0.0.0/systemd:domain=INET:index=1/g' /opt/cowrie/cowrie.cfg
  systemctl daemon-reload
  systemctl enable --now cowrie.socket
  systemctl enable cowrie.service
  echo "Redirecting port 22 and 23 to Cowrie. You will need to re-establish your SSH session on port 8925 after the service reloads."
  sed -i 's/Port 22/Port 8925/g' /etc/ssh/sshd_config
  service ssh reload
  iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port 2222
  iptables -t nat -A PREROUTING -p tcp --dport 23 -j REDIRECT --to-port 2223
  iptables-save > /etc/iptables.rules
  echo '#!/bin/sh' >> /etc/network/if-up.d/iptablesload 
  echo 'iptables-restore < /etc/iptables.rules' >> /etc/network/if-up.d/iptablesload 
  echo 'exit 0' >> /etc/network/if-up.d/iptablesload
  chmod +x /etc/network/if-up.d/iptablesload
  echo "Starting service..."
  service cowrie start
  echo "Cowrie install complete!"
