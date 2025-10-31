#!/bin/bash
set -e

if ! command -v crio >/dev/null 2>&1; then
  echo "CRI-O is not installed"
  exit 1
fi

if systemctl is-active --quiet crio; then
  echo "CRI-O service is running"
else
  echo "CRI-O service is not running"
  exit 1
fi

if [ -f /etc/crio/crio.conf ]; then
  echo "CRI-O default configuration exists"
else
  echo "CRI-O default configuration is missing"
  exit 1
fi

if grep -q '^cgroup_manager = "systemd"' /etc/crio/crio.conf; then
  echo "Cgroup driver is correctly set to systemd"
else
  echo "Cgroup driver is not set to systemd"
  exit 1
fi
