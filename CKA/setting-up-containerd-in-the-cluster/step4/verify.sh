#!/bin/bash
if command -v kubeadm >/dev/null && command -v kubelet >/dev/null && command -v kubectl >/dev/null; then
  echo "Kubernetes tools installed"
  exit 0
else
  echo "Kubernetes tools not installed"
  exit 1
fi
