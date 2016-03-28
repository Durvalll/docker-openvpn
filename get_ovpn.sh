#!/bin/bash

# This script is inspired from https://gist.github.com/trovao/18e428b5a758df24455b

clientnum=${1?"The client num is required"}
server=${2?"The server address is required"}

cd /etc/openvpn/easy-rsa/
source /etc/openvpn/easy-rsa/vars > /dev/null 2>&1
./build-key --batch $clientnum > /dev/null 2>&1

cacert="/etc/openvpn/ca.crt"
client_cert="/etc/openvpn/easy-rsa/keys/${clientnum}.crt"
client_key="/etc/openvpn/easy-rsa/keys/${clientnum}.key"
ta_key="/etc/openvpn/ta.key"

cat << EOF
client
dev tun
remote ${server} 1194
resolv-retry infinite
nobind
user nobody
group nogroup
persist-key
persist-tun
ns-cert-type server
verb 3
proto udp
comp-lzo
remote-cert-tls server
key-direction 1

<ca>
EOF
cat ${cacert}
cat << EOF
</ca>
<cert>
EOF
cat ${client_cert}
cat << EOF
</cert>
<key>
EOF
cat ${client_key}
cat << EOF
</key>
<tls-auth>
EOF
cat ${ta_key}
cat << EOF
</tls-auth>
EOF
