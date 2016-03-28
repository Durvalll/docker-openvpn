# Docker-OpenVPN
Dockerized OpenVPN *Server* using an Ubuntu base image.

# How to run
Assuming you have Docker installed already, you can get an openvpn server up and running in the following quick steps:

1. Build the container on the server instance:
  ```
  bash build.sh
  ```

2. Run the container on the server instance:
  ```
  bash run.sh
  ```

This step generates an ovpn file that you will then wish to copy to your
client.

That's it! 

# How to add other users

To add other users, you can simply run the following:

```
docker exec -i -t 4f7 /get_ovpn.sh client2 `curl ifconfig.io` > client2.ovpn
```

where 4f7 is something you need to replace with the first three digits of 
your corresponding container ID found by
running `docker ps`, e.g.:

```
$ docker ps

CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                    NAMES
4f7fd0a54c85        openvpn:latest      "/bin/sh -c './start   22 minutes ago      Up 22 minutes       0.0.0.0:1194->1194/udp   noname
```

You can do this all in one line, though this isn't guarunteed to always
work if you have other containers running with openvpn in their names:

```
docker exec -i -t `docker ps | grep openvpn:latest | awk '{print $1}'` /get_ovpn.sh client2 `curl ifconfig.io` > client2.ovpn
```

# Persisting?

Keys are stored on the server where you are running the docker container.
This is for persistance, e.g. if you have to restart the container the
old keys still work. On the other hand, if you would prefer a throw-away
server, you can remove the -v line in the run.sh script so that the key
folder is not mounted locally. With that said, there is one big problem:
if you need to rebuild, you should add a line in the Dockerfile that copies
from the pre-existing keys folder to /etc/openvpn/easy-rsa/keys.

# Security

Out of the box, this OpenVPN server uses tls on top of having a strong dh key.
A potential weakness is the local mounting of the keys folder. This can
be easily remedied by removing the -v call in the run.sh file. This folder
is converted to root ownership in the process of running the server.


