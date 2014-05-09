#!/bin/bash
 
#
# Network configuration script for vm1
#
 
# bridge setup
brctl addbr br0
ifconfig br0 10.10.20.1/24 up
 
# enable ipv4 forwarding
echo "1" > /proc/sys/net/ipv4/ip_forward
 
# netfilter cleanup
iptables --flush
iptables -t nat -F
iptables -X
iptables -Z
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
 
# external interface - accept only packets going to 10.10.20.10:80
iptables -A FORWARD -i eth0 -d 10.10.20.10 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -i eth0 -j DROP
 
# internal interface - no new connections
iptables -A FORWARD -i br0 -m state --state NEW,INVALID -j DROP
 
# netfilter port forwarding
iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to 10.10.20.10:80
