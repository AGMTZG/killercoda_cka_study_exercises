#!/bin/bash

RELEASE="my-nginx-release"
OUTPUT_DIR="/opt/helm/nginx"
MANIFEST_FILE="${OUTPUT_DIR}/manifest-custom.yaml"
STATUS_FILE="${OUTPUT_DIR}/status-custom.txt"
CUSTOM_FILE="./custom-server-blocks.conf"

# Check that the manifest and status files exist
if [ ! -f "$MANIFEST_FILE" ]; then
  echo "Manifest file not found at ${MANIFEST_FILE}"
  exit 1
fi

if [ ! -f "$STATUS_FILE" ]; then
  echo "Status file not found at ${STATUS_FILE}"
  exit 1
fi

# Check that the Helm release exists
if ! helm list -q | grep -q "^${RELEASE}$"; then
  echo "Helm release '${RELEASE}' not found"
  exit 1
fi

# Check that the release has the serverBlock set
if ! helm get values "$RELEASE" | grep -q "serverBlock"; then
  echo "Custom server block not found in release values"
  exit 1
fi

# Check that the manifest contains the server block
if ! grep -q "server" "$MANIFEST_FILE"; then
  echo "No server block detected in manifest file"
  exit 1
fi

echo "Verification completed: custom server block applied. Check Helm status and pods for detailed info."
