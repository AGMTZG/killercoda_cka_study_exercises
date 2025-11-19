#!/bin/bash

# List all Gateway API CRDs
CRDS=$(kubectl get crds | grep -E 'gatewayclasses\.gateway\.networking\.k8s\.io|gateways\.gateway\.networking\.k8s\.io|httproutes\.gateway\.networking\.k8s\.io')

if [[ -n "$CRDS" ]]; then
  echo "Gateway CRDs are installed correctly."
  echo "$CRDS"
  exit 0
else
  echo "Gateway CRDs not found. Make sure you applied the CRDs correctly."
  exit 1
fi
