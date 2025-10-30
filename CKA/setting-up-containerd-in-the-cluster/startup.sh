#!/bin/bash
set -e

# ------------------------------
# Stop any existing container runtimes
# ------------------------------
systemctl stop docker || true
systemctl stop docker.socket || true
systemctl stop containerd || true

# ------------------------------
# Remove Docker and containerd packages if they exist
# ------------------------------
apt-get purge -y docker docker-engine docker.io containerd runc docker-compose || true

# ------------------------------
# Remove persistent data
# ------------------------------
rm -rf /var/lib/docker
rm -rf /var/lib/containerd

# ------------------------------
# Remove Docker/Containerd repos
# ------------------------------
rm -f /etc/apt/sources.list.d/docker*.list
rm -f /etc/apt/sources.list.d/docker*.save

# ------------------------------
# Remove containerd configuration file if exists
# ------------------------------
rm -f /etc/containerd/config.toml

# ------------------------------
# Update system repositories
# ------------------------------
apt-get update
