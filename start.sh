#!/bin/bash

echo 1 > /proc/sys/net/ipv4/ip_forward
/sbin/iptables -t nat -A POSTROUTING -s 10.8.0.0/8  -o eth0 -j MASQUERADE
cd /etc/openvpn && /usr/sbin/openvpn --config server.conf

# If the above command fails, keep running so can diagnose
while true
do 
 sleep 10
done

