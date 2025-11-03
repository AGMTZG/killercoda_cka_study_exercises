#!/bin/sh
if ! kubectl config get-contexts deploybot-context >/dev/null 2>&1; then
  echo "Context 'deploybot-context' not found in kubeconfig."
  exit 1
fi
