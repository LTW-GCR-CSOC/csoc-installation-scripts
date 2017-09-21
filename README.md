# canary-installation-scripts
LTW Canary Installation Scripts

Tested on Ubuntu Mate LTS 16.04 with Raspberry Pi 3

This script will install Dionaea honeypot onto an Ubuntu Mate instance.

It is a work in progress.

# Procedure #
[Download](https://github.com/LTW-GCR-CSOC/canary-installation-scripts/archive/master.zip) the code and unzip it 
```
sudo wget https://github.com/LTW-GCR-CSOC/canary-installation-scripts/archive/master.zip   
sudo unzip master.zip -d gcrinstall   
cd gcrinstall/canary-installation-scripts-master/
```

Once you download the shell script,run the script using following command,
      bash ./honeypots.sh
      
Dionaea logs and database will be in this directory /opt/dionaea/var/dionaea
      
To view the Cowrie Log Viewer,visit port 5000 of your IP address

Note : You will be prompted to enter password to execute sudo commands

