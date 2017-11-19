#---------------
# This install script installs Raspberry Pi specific capabilities
#
# TODO: setup watchdog timer support for raspberry pi device
#
SCRIPTSDIR="$HOME/csoc-installation-scripts-master/"
echo "SCRIPTSDIR = " $SCRIPTSDIR  >>$SCRIPTSDIR/SETUP-RUN.TXT

# TODO: need to remove watchdog from here and use naveens script in honeypot.sh instead

echo "-----@ INSTALL WATCHDOG FOR CANARY -----" >>~/SETUP-RUN.TXT
sudo modprobe bcm2708_wdog
echo "bcm2708_wdog" | sudo tee -a /etc/modules
sudo apt-get install watchdog
#
# - need to add configuration for watchdog sudo nano /etc/watchdog.conf
#
# Uncomment the line that starts with #watchdog-device by removing the hash (#) to enable the  watchdog daemon to use the watchdog device.
# Uncomment the line that says #max-load-1 = 24 by removing the hash symbol to reboot the device if the load goes over 24 over 1 minute. A load of 25 of one minute means that you would have needed 25 Raspberry Pis to complete that task in 1 minute. You may tweak this value to your liking.
#
echo "-----@ INSTALL WATCHDOG FOR CANARY -----" >>~/SETUP-RUN.TXT


#Application to enable changing of mac address
sudo apt-get install -y macchanger

#Change MAC address - this is for rpi
#ifconfig enxb827eb9e5b73 down
#sudo macchanger -m 94:2e:17:9E:5B:73 enxb827eb9e5b73
#ifconfig enxb827eb9e5b73 up

#Disable bluetooth and wifi
echo '#GCR Disable bluetooth and wifi' | sudo tee --append /boot/config.txt
echo 'dtoverlay=pi3-disable-bt' | sudo tee --append /boot/config.txt
echo 'dtoverlay=pi3-disable-wifi' | sudo tee --append /boot/config.txt
sudo systemctl disable hciuart
echo '#GCR Disable bluetooth and wifi' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf
echo '#disable wifi' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf
echo 'blacklist brcmfmac' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf
echo 'blacklist brcmutil' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf
echo '#disable bluetooth' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf
echo 'blacklist btbcm' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf
echo 'blacklist hci_uart' | sudo tee --append /etc/modprobe.d/raspi-blacklist.conf

#enable ssh
sudo systemctl enable ssh
sudo service ssh restart

#device should be rebooted for changes to take effect



