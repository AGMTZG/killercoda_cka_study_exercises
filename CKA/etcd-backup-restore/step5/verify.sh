#!/bin/bash
if grep -q "/mnt/etcd-data" /etc/kubernetes/manifests/etcd.yaml; then
  echo "done"
else
  echo "etcd manifest not updated correctly"
  exit 1
fi
