#!/bin/bash
#!/bin/bash

CID=$(docker run --privileged -d -p 1194:1194/udp openvpn)
docker exec -i -t $CID /get_ovpn.sh `curl ifconfig.io` > client1.ovpn
