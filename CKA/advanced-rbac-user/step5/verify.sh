#!/bin/sh
if ! kubectl config get-contexts alice-context >/dev/null 2>&1; then
  echo "Context 'alice-context' not found in kubeconfig."
  exit 1
fi
