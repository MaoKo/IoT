#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi
echo "Deleting cluster"
k3d cluster delete --all
