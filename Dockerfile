From ubuntu:14.04
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    easy-rsa \
    iptables \
    openvpn \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/openvpn/easy-rsa/ \
 && cp -r /usr/share/easy-rsa/* /etc/openvpn/easy-rsa/ \
 && sed -i 's/export KEY_PROVINCE="CA"/export KEY_PROVINCE="VA"/g' /etc/openvpn/easy-rsa/vars \
 && sed -i 's/export KEY_CITY="SanFrancisco"/export KEY_CITY="Richmond"/g' /etc/openvpn/easy-rsa/vars \
 && sed -i 's/export KEY_ORG="Fort-Funston"/export KEY_ORG="Self"/g' /etc/openvpn/easy-rsa/vars \
 && sed -i 's/export KEY_EMAIL="me@myhost.mydomain"/export KEY_EMAIL="youremail@myhost.mydomain"/g' /etc/openvpn/easy-rsa/vars \
 && sed -i 's/export KEY_OU="MyOrganizationalUnit"/export KEY_OU="YourOrganizationalUnit"/g' /etc/openvpn/easy-rsa/vars \
 && echo "export KEY_NAME=MyVPN" >> /etc/openvpn/easy-rsa/vars \
 && echo "export KEY_OU=MyVPN" >> /etc/openvpn/easy-rsa/vars 

RUN cd /etc/openvpn/easy-rsa/ \
 && source /etc/openvpn/easy-rsa/vars \
 && ./clean-all \
 && /usr/sbin/openvpn --genkey --secret keys/ta.key \
 && ./build-ca --batch \
 && ./build-key-server --batch server \
 && ./build-dh --batch \
 #&& ./build-key --batch client1 \
 && cd keys/ \
 && cp index.txt serial ca.key ta.key server.crt server.key ca.crt dh2048.pem /etc/openvpn/

RUN sudo cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/ \
 && sudo gzip -d /etc/openvpn/server.conf.gz \
 && sudo sed -i 's/;local a.b.c.d/mode server/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/;push "redirect-gateway def1 bypass-dhcp"/push "redirect-gateway def1 bypass-dhcp"/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/;push "dhcp-option DNS 208.67.222.222"/push "dhcp-option DNS 8.8.8.8"/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/;push "dhcp-option DNS 208.67.220.220"/push "dhcp-option DNS 8.8.4.4"/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/dh dh1024.pem/dh dh2048.pem/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/;user nobody/user nobody/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/;tls-auth ta.key 0 # This file is secret/tls-auth ta.key 0/g' /etc/openvpn/server.conf \
 && sudo sed -i 's/;group nogroup/group nogroup/g' /etc/openvpn/server.conf \
 && sudo echo "tls-server" >> /etc/openvpn/server.conf 


RUN sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

ADD start.sh /start.sh
ADD get_ovpn.sh /get_ovpn.sh

EXPOSE 1194/udp
CMD './start.sh'
 


