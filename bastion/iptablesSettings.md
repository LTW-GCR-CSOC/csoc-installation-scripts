
The following are to configure a bastion for port forwarding.   

Flush/delete all existing rules. 
```
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
```

Create new rules for port forwarding.
```
sysctl -w net.ipv4.tcp_fwmark_accept=1
sysctl net.ipv4.ip_forward=1
sysctl -p /etc/sysctl.conf 
iptables -t nat -A PREROUTING -p tcp --dport <syslog port> -j DNAT --to-destination <central alert server private ip>:<syslog port>
iptables -t nat -A POSTROUTING -s <bastian server private ip> -j MASQUERADE
```

#another approach https://spin.atomicobject.com/2012/10/01/useful-iptables-port-forwarding-patterns/
