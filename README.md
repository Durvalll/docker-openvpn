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

