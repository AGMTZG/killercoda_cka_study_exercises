#!/bin/bash
set -e

# ------------------------------
# Stop any existing container runtimes
# ------------------------------
sudo systemctl stop docker || true
sudo systemctl stop docker.socket || true
sudo systemctl stop containerd || true

# ------------------------------
# Remove Docker and containerd packages if they exist
# ------------------------------
sudo apt purge -y docker.io docker-compose containerd
sudo apt autoremove -y

# ------------------------------
# Remove persistent data
# ------------------------------
rm -rf /var/lib/docker
rm -rf /var/lib/containerd

# ------------------------------
# Remove containerd configuration file if exists
# ------------------------------
rm -f /etc/containerd/config.toml

# ------------------------------
# Update system repositories
# ------------------------------
sudo apt update
