# canary-installation-scripts
LTW Canary Installation Scripts

Tested on Ubuntu Mate LTS 16.04 with Raspberry Pi 3

This script will install Dionaea honeypot onto an Ubuntu Mate instance.

It is a work in progress.

# Procedure #

Run the following commands to install:
```
wget https://github.com/LTW-GCR-CSOC/canary-installation-scripts/archive/master.zip && unzip master.zip && cd canary-installation-scripts-master/ && chmod +x *.sh && ./honeypots.sh
```
      
Dionaea logs and database will be in this directory /opt/dionaea/var/dionaea
      
To view the Cowrie Log Viewer,visit port 5000 of your IP address

Note : You will be prompted to enter password to execute sudo commands

