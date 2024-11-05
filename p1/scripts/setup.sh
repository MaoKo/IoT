#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get install -y policycoreutils iptables net-tools
swapoff -a
sed -i '/swap/d' /etc/fstab
