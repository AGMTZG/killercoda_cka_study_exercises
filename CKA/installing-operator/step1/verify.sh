#!/bin/bash

# Check namespace
if ! kubectl get namespace monitoring &> /dev/null; then
  echo "Namespace 'monitoring' does not exist."
  exit 1
fi

# Check Helm release
if ! helm list -n monitoring | grep -q "^prometheus"; then
  echo "Helm release 'prometheus' not found in namespace 'monitoring'."
  exit 1
fi

# Check pods by status safely
PODS_READY=$(kubectl get pods -n monitoring --no-headers 2>/dev/null | awk '$3 == "Running" {count++} END {print count+0}')

if [ "$PODS_READY" -eq 0 ]; then
  echo "No Prometheus pods are running in the 'monitoring' namespace."
  exit 1
fi
