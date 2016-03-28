#!/bin/bash

# no cache for additional security (keys refreshed each time building)
docker build --no-cache -t openvpn .
