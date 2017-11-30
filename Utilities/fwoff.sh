#!/bin/bash
#---------------
# Turn off iptables rules inbound and outbound
#---------------
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -F
