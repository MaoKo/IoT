#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi
apt install -y vim curl git coreutils
curl -fsSL https://get.docker.com | sh
RELEASE=$(curl -sL https://dl.k8s.io/release/stable.txt)
curl -LO "https://dl.k8s.io/release/${RELEASE}/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/${RELEASE}/bin/linux/amd64/kubectl.sha256"
echo "$(<kubectl.sha256) kubectl" | sha256sum --check
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
