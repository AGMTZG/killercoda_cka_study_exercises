#!/bin/sh
CONFIG="$HOME/.kube/config"

if [ ! -f "$CONFIG" ]; then
  echo "kubeconfig file not found at $CONFIG."
  exit 1
fi

if grep -q "alice-context" "$CONFIG" && grep -q "alice" "$CONFIG"; then
  echo "kubeconfig for alice configured correctly in $CONFIG."
  exit 0
else
  echo "kubeconfig missing or incomplete configuration for alice."
  exit 1
fi
