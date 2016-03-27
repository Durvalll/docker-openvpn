#!/bin/bash

# This script is inspired directly from https://gist.github.com/trovao/18e428b5a758df24455b

server=${1?"The server address is required"}
cacert="/etc/openvpn/easy-rsa/keys/ca.crt"
client_cert="/etc/openvpn/easy-rsa/keys/client1.crt"
client_key="/etc/openvpn/easy-rsa/keys/client1.key"

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
EOF
