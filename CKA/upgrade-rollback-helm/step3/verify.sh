#!/bin/bash

OUTPUT_DIR="/opt/helm/nginx"
RELEASE_NAME="my-nginx-release"

mkdir -p "$OUTPUT_DIR"

if ! helm history "$RELEASE_NAME" | grep -q "rollback"; then
  echo "No rollback revision found in Helm history"
  exit 1
fi

if helm get values "$RELEASE_NAME" | grep -q "tls.enabled: true"; then
  echo "TLS is still enabled after rollback"
  exit 1
fi

if ! kubectl get pods -l app.kubernetes.io/instance="$RELEASE_NAME" | grep -q "Running"; then
  echo "Pods are not running after rollback"
  exit 1
fi
