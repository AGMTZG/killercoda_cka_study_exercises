#!/bin/bash

PODS=$(kubectl get pods -n kube-system --no-headers | grep -E "kube-apiserver-controlplane|kube-controller-manager-controlplane")

if [ -z "$PODS" ]; then
  echo "done"
else
  echo "Some control-plane pods are still running:"
  echo "$PODS"
  exit 1
fi
