#!/bin/bash
if sudo kubeadm config view >/dev/null 2>&1; then
  echo "Cluster initialized"
  exit 0
else
  echo "Cluster not initialized"
  exit 1
fi
