#!/bin/bash

# Check if the deployment exists
DEPLOYMENT=$(kubectl get deployment webapp --no-headers 2>/dev/null)
if [[ -z "$DEPLOYMENT" ]]; then
  echo "Deployment 'webapp' not found."
  exit 1
fi

# Check if the service exists
SERVICE=$(kubectl get service webapp --no-headers 2>/dev/null)
if [[ -z "$SERVICE" ]]; then
  echo "Service 'webapp' not found."
  exit 1
fi
