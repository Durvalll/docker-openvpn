#!/bin/bash

if [ ! -d ${PWD}/keys ]; then
    mkdir ${PWD}/keys
fi

CID=$(docker run --privileged -d -v ${PWD}/keys:/etc/openvpn/easy-rsa/keys -p 1194:1194/udp openvpn)
docker exec -i -t $CID chown -R root.root /etc/openvpn/easy-rsa/keys
docker exec -i -t $CID cp /etc/openvpn/ca.key /etc/openvpn/ca.crt  /etc/openvpn/index.txt /etc/openvpn/serial /etc/openvpn/easy-rsa/keys
docker exec -i -t $CID /get_ovpn.sh client1 `curl ifconfig.io` > client1.ovpn
