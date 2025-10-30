#!/bin/bash
set -e

sudo systemctl stop docker
sudo systemctl stop docker.socket
sudo systemctl stop containerd
sudo apt purge -y docker.io docker-compose containerd
sudo apt autoremove -y
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -f /etc/containerd/config.toml
sudo apt update
