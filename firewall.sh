##setup firewall and data throttle
chkconfig iptables on
yum install -y iptables-services 

export NIC=<i.e. eth1>
export ALLOW_TCP_PORTS=2202,23,22,25,8080,80,443,5060,5061,1900,69,139,445
export ALLOW_UDP_PORTS=22,1434,443,5060,5061,1900,69,139,44
export NICTHROTTLE1=683bps
export NICTHROTTLE2=1000kbps
export NICTHROTTLE3=1000kbps
export MESSAGEPORT1=<port to sent to metron>
export MESSAGEPORT2=<port to sent to metron>


# setup iptables-persistent
sudo apt-get -y install iptables-persistent
sudo service netfilter-persistent start
sudo invoke-rc.d netfilter-persistent save

#First delete all existing rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo iptables -F
sudo iptables -X

#Set the INPUT policy to DROP All:
sudo iptables -P INPUT DROP

# Allow packets from connections related to established ones, packets
# from established ones, and packets from localhost:
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow new connections to TCP ports:
sudo iptables -A INPUT -p TCP -m multiport --dports $ALLOW_TCP_PORTS \
-m state --state NEW -j ACCEPT

# Allow new connections to UDP ports:
sudo iptables -A INPUT -p UDP -m multiport --dports $ALLOW_UDP_PORTS \
-m state --state NEW -j ACCEPT

# Allow ping
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
sudo iptables -A OUTPUT -p icmp --icmp-type echo-reply -j ACCEPT



##Throttle data
#clear settings
sudo tc qdisc del dev $NIC root
sudo tc qdisc add dev $NIC root handle 1:0 htb default 10
sudo tc class add dev $NIC parent 1:0 classid 1:10 htb rate $NICTHROTTLE1 ceil $NICTHROTTLE1

#clear settings
#sudo tc qdisc del dev $NIC root

#define throttling
#sudo tc qdisc add dev $NIC root handle 1: htb
#sudo tc class add dev $NIC parent 1: classid 1:1 htb rate $NICTHROTTLE1
#sudo tc class add dev $NIC parent 1:1 classid 1:5 htb rate $NICTHROTTLE2 ceil $NICTHROTTLE2 prio 1
#sudo tc class add dev $NIC parent 1:1 classid 1:6 htb rate $NICTHROTTLE3 ceil $NICTHROTTLE3 prio 0
#sudo tc filter add dev $NIC parent 1:0 prio 1 protocol ip handle 5 fw flowid 1:5
#sudo tc filter add dev $NIC parent 1:0 prio 0 protocol ip handle 6 fw flowid 1:6
#sudo iptables -A OUTPUT -t mangle -p tcp --sport $MESSAGEPORT1 -j MARK --set-mark 5
#sudo iptables -A OUTPUT -t mangle -p tcp --sport $MESSAGEPORT2  -j MARK --set-mark 6

#show results 
#sudo tc qdisc show

#Save rules and make them persistant
sudo netfilter-persistent save
service iptables save
/usr/libexec/iptables/iptables.init save
service iptables reload

# show iptables setup
sudo iptables -S
