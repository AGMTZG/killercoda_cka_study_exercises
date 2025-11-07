#!/bin/bash

if ! kubectl get storageclass csi-retain-sc &>/dev/null; then
  echo "StorageClass 'csi-retain-sc' not found."
  exit 1
fi

if [ ! -f /opt/storage/default-sc.txt ]; then
  echo "File /opt/storage/default-sc.txt not found."
  exit 1
fi

count=$(grep -c "true" /opt/storage/default-sc.txt || true)

if [ "$count" -ne 1 ]; then
  echo "Expected exactly one default StorageClass, found $count."
  exit 1
fi
