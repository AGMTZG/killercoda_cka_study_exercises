#!/bin/bash

RELEASE_NAME="my-nginx-release"

# Check that there is at least one previous revision in Helm history
if ! helm history "$RELEASE_NAME" | grep -q "1"; then
  echo "No previous revision found in Helm history to roll back to"
  exit 1
fi

# Verify that the custom server block configuration has been removed/restored
if helm get values "$RELEASE_NAME" | grep -q "serverBlock"; then
  echo "Custom server block is still present after rollback"
  exit 1
fi

# Check that all pods are running after rollback
if ! kubectl get pods -l app.kubernetes.io/instance="$RELEASE_NAME" --no-headers | grep -q "Running"; then
  echo "One or more pods are not in Running state after rollback"
  exit 1
fi

echo "Rollback verification completed: release restored and pods running."
