#!/bin/bash
if kubectl get pod -n kube-system | grep -q etcd; then
  echo "done"
else
  echo "etcd pod not found"
  exit 1
fi
