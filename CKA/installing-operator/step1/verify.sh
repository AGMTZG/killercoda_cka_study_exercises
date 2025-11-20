#!/bin/bash
set -e

# Check if namespace exists
if ! kubectl get namespace monitoring &> /dev/null; then
  echo "Namespace 'monitoring' does not exist."
  exit 1
fi

# Check if the prometheus helm release exists
if ! helm list -n monitoring | grep -q "prometheus"; then
  echo "Helm release 'prometheus' not found in namespace 'monitoring'."
  exit 1
fi

# Check if at least one pod is running
PODS_READY=$(kubectl get pods -n monitoring -o jsonpath='{.items[*].status.phase}' | grep -c "Running")
if [ "$PODS_READY" -eq 0 ]; then
  echo "No Prometheus pods are running in the 'monitoring' namespace."
  exit 1
fi

