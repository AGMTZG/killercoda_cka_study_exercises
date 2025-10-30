#!/bin/bash
set -e

sudo systemctl stop docker || true
sudo systemctl stop docker.socket || true
sudo systemctl stop containerd || true
sudo apt purge -y docker.io docker-compose containerd
sudo apt autoremove -y
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
sudo rm -f /etc/containerd/config.toml
sudo apt update
