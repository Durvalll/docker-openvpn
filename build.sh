#!/bin/bash
if (( $EUID != 0 )); then 
    echo "This must be run as root. Try 'sudo bash $0'." 
    exit 1 
fi
echo "$(tput setaf 2)                        ##         $(tput sgr0)"
echo "$(tput setaf 2)                  ## ## ##        ==$(tput sgr0)"
echo "$(tput setaf 2)               ## ## ## ## ##    ===$(tput sgr0)"
echo "$(tput setaf 6)           /''''''''''''''''''\___/ ===$(tput sgr0)"
echo "$(tput setaf 6)      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~$(tput sgr0)"
echo "$(tput setaf 6)           \______ o           __/$(tput sgr0)"
echo "$(tput setaf 6)             \    \         __/$(tput sgr0)"
echo "$(tput setaf 6)              \____\_______/$(tput sgr0)"

echo "$(tput setaf 6)This script will configure a OpenVPN Serve on your Raspberry Pi(2 or 3), this may take while.$(tput sgr0)"
read -p "$(tput bold ; tput setaf 2)Press [Enter] to begin, [Ctrl-C] to abort...$(tput sgr0)"

echo "$(tput bold 6)Check if Docker is installed$(tput sgr0)"
if ! docker_loc="$(type -p "docker")" || [ -z "docker" ]; then
  echo "$(tput bold 6)Installing Docker$(tput sgr0)"
  curl -sSL https://get.docker.com | sh
  sudo usermod -aG docker pi
fi
# no cache for additional security (keys refreshed each time building)
docker build --no-cache -t openvpn .
