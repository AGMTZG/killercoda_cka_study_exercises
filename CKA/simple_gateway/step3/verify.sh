#!/bin/bash

# Check if the IPAddressPool lb-pool exists in metallb-system namespace
POOL=$(kubectl get ippools -n metallb-system lb-pool --no-headers 2>/dev/null)

if [[ -n "$POOL" ]]; then
  echo "IPAddressPool 'lb-pool' exists."
  exit 0
else
  echo "IPAddressPool 'lb-pool' not found. Please create it using the manifest."
  exit 1
fi
