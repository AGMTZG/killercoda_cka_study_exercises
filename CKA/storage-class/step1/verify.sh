#!/bin/bash

if ! kubectl get storageclass csi-retain-sc &>/dev/null; then
  echo "StorageClass 'csi-retain-sc' not found."
  exit 1
fi

if [ ! -f /opt/storage/default-sc.txt ]; then
  echo "File /opt/storage/default-sc.txt not found."
  exit 1
fi

default_count=$(kubectl get storageclass -o custom-columns=NAME:.metadata.name,DEFAULT:.metadata.annotations."storageclass\.kubernetes\.io/is-default-class" | grep -w "true" | wc -l)

if [ "$default_count" -eq 1 ]; then
  echo "Exactly one default StorageClass is configured correctly."
else
  echo "Expected exactly one default StorageClass, found $default_count."
  kubectl get storageclass
  exit 1
fi
