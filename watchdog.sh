#Check WDT module status
lsmod | grep wd
ls -la /dev/watchdog*
#install @ configure watchdog
sudo apt-get -y install aptitude
sudo aptitude install watchdog
ln /lib/systemd/system/watchdog.service /etc/systemd/system/multi-user.target.wants/watchdog.service
echo 'watchdog-device = /dev/watchdog' >> /etc/watchdog.conf
echo 'watchdog-timeout = 10' >> /etc/watchdog.conf 
echo 'interval = 2' >> /etc/watchdog.conf
#restart watchdog
service watchdog restart
#forkbomb - device will restart
sudo su -
swapoff -a
:(){ :|:& };:

