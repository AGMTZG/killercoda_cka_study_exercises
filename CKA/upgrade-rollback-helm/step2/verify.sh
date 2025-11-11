#!/bin/bash

RELEASE="my-nginx-release"
OUTPUT_DIR="/opt/helm/nginx"
MANIFEST_FILE="${OUTPUT_DIR}/manifest-tls.yaml"
STATUS_FILE="${OUTPUT_DIR}/status-tls.txt"

if [ ! -f "$MANIFEST_FILE" ]; then
  echo "Manifest file not found at ${MANIFEST_FILE}"
  exit 1
fi

if [ ! -f "$STATUS_FILE" ]; then
  echo "Status file not found at ${STATUS_FILE}"
  exit 1
fi

if ! helm list -q | grep -q "^${RELEASE}$"; then
  echo "Helm release '${RELEASE}' not found"
  exit 1
fi

if ! helm get values "$RELEASE" | grep -q "enabled: true"; then
  echo "TLS configuration not found or not enabled in release values"
  exit 1
fi

if ! grep -q "tls" "$MANIFEST_FILE"; then
  echo "No TLS configuration detected in manifest file"
  exit 1
fi

if ! kubectl get pods --no-headers | grep -q "Running"; then
  echo "One or more pods are not in Running state"
  exit 1
fi
