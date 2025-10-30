#!/bin/bash
if grep -q "SystemdCgroup = true" /etc/containerd/config.toml; then
  echo "cgroup driver configured correctly"
  exit 0
else
  echo "cgroup driver not configured"
  exit 1
fi
