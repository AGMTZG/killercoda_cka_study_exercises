#!/bin/bash
set -e
systemctl stop docker || true
systemctl stop docker.socket || true
systemctl stop containerd || true
apt-get purge -y docker.io docker-compose containerd || true
apt-get autoremove -y || true
rm -rf /var/lib/docker
rm -rf /var/lib/containerd
rm -f /etc/containerd/config.toml
apt-get update
