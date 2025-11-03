#!/bin/bash
if kubectl get sa deploybot -n appenv &>/dev/null; then
  echo "ServiceAccount 'deploybot' successfully created in namespace appenv."
  exit 0
else
  echo "ServiceAccount not found. Please create it correctly."
  exit 1
fi
