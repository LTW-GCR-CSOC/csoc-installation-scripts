#---------------
# This install script installs Raspberry Pi specific capabilities
#
# TODO: setup watchdog timer support for raspberry pi device
#
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
