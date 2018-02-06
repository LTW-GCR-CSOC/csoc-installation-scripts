
The following commands will allow you to configure a bastion server on a AWS Centos7 t2.micro machine. 
In this configuration the Canary will send messages to the basion IP to the PORT_FROM. 
The bastion will then redirect the messages to the DEST IP address on PORT_TO. The DEST IP contains the SIEM. 

1) Allow saving/persistance of iptable settings
```
chkconfig iptables on
yum install -y iptables-services 

```
```
in /etc/sysconfig/iptables-config
IPTABLES_SAVE_ON_RESTART="yes"
IPTABLES_SAVE_ON_STOP="yes"

```
2) Flush/delete all existing rules. 
```
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X
```

3) Create new rules for port forwarding
```
sysctl net.ipv4.ip_forward=1
sysctl -p

export NIC=<i.e. eth1>
export PORT_FROM=<input port into bastion>
export PORT_TO=<output port to forward to>
export DEST=<destination ip>


iptables -t nat -A PREROUTING  -p tcp --dport $PORT_FROM -j DNAT --to-destination $DEST:$PORT_TO
iptables -t nat -A POSTROUTING -o $NIC -j MASQUERADE

```

4) Block all unwanted input traffic except PORT_FROM, PORT_TO, and OTHERPORTS
```
export OTHERPORTS=<other ports to allow>
# Allow packets from connections related to established ones, packets
# from established ones, and packets from localhost:
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow new connections to TCP ports:
sudo iptables -A INPUT -p TCP -m multiport --dports $PORT_FROM,$PORT_TO,$OTHERPORTS \
-m state --state NEW -j ACCEPT
```

5) Persist Saving of new rules
```
service iptables save
/usr/libexec/iptables/iptables.init save
service iptables reload
```

6) Validate if rules were accepted
```
iptables -S
```
