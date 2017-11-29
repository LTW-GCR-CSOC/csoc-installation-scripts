#setup firewall

sudo apt-get install iptables-persistent
sudo service netfilter-persistent start
sudo invoke-rc.d netfilter-persistent save

#First delete all existing rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

#Set the INPUT policy to DROP All:
sudo iptables -P INPUT DROP

# Allow packets from connections related to established ones, packets
# from established ones, and packets from localhost:
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow new connections to TCP ports:
sudo iptables -A INPUT -p TCP -m multiport --dports 2202,23,22,25,8080,80,443,5060,5061,1900,69,139,445 \
-m state --state NEW -j ACCEPT

# Allow new connections to TCP ports:
sudo iptables -A INPUT -p UDP -m multiport --dports 22,1434,443,5060,5061,1900,69,139,44 \
-m state --state NEW -j ACCEPT

sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT

#Save rules and make them persistant
sudo netfilter-persistent save

# show iptables setup
sudo iptables -S
