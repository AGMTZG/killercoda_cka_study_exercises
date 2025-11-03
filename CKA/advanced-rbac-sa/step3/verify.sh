#!/bin/sh
CONFIG="$HOME/.kube/config"

if [ ! -f "$CONFIG" ]; then
  echo "kubeconfig file not found at $CONFIG."
  exit 1
fi

if grep -q "deploybot-context" "$CONFIG" && grep -q "deploybot" "$CONFIG"; then
  echo "kubeconfig for deploybot configured correctly in $CONFIG."
  exit 0
else
  echo "kubeconfig missing or incomplete configuration for deploybot."
  exit 1
fi
