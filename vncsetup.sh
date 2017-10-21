#!/bin/bash
# Ref: https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-16-04
# Install VNC server for use on Raspberry Pi for development testing
sudo apt install xfce4 xfce4-goodies tightvncserver -y
vncserver
vncserver -kill :1
mv ~/.vnc/xstartup ~/.vnc/xstartup.bak
cd ~/.vnc
wget https://raw.githubusercontent.com/LTW-GCR-CSOC/csoc-installation-scripts/master/InstallerFiles/xstartup
sudo chmod +x ~/.vnc/xstartup
vncserver
