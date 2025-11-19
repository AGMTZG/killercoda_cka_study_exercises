#!/bin/bash

# Check if the namespace exists
NAMESPACE=$(kubectl get ns | grep nginx-gateway-fabric)

if [[ -z "$NAMESPACE" ]]; then
  echo "Namespace 'nginx-gateway-fabric' not found. Installation might have failed."
  exit 1
fi

# Check if the controller pod is running
POD=$(kubectl get pods -n nginx-gateway-fabric -l app=nginx-gateway-fabric-manager -o jsonpath='{.items[0].status.phase}')

if [[ "$POD" == "Running" ]]; then
  echo "NGINX Gateway Fabric controller is running successfully."
  exit 0
else
  echo "NGINX Gateway Fabric controller is not running. Current status: $POD"
  exit 1
fi
