#!/bin/bash

FILE="/opt/storage/default-sc.txt"

if ! kubectl get storageclass csi-retain-sc &>/dev/null; then
  echo "StorageClass 'csi-retain-sc' not found."
  exit 1
fi

if [ ! -f "$FILE" ]; then
  echo "File $FILE does not exist."
  exit 1
fi

# Extract non-empty lines and skip headers if present
lines=$(grep -v '^\s*$' "$FILE" | grep -v -i '^NAME')

# Count the remaining lines
line_count=$(echo "$lines" | wc -l)

if [ "$line_count" -eq 1 ]; then
  # Check the second column of the remaining line
  default_value=$(echo "$lines" | awk '{print $2}')
  if [ "$default_value" = "true" ] || [ "$default_value" = "default" ]; then
    echo "Default StorageClass is correctly configured."
  else
    echo "The StorageClass in the file is not marked as default."
    cat "$FILE"
    exit 1
  fi
else
  echo "Expected only one StorageClass in the file, found $line_count."
  cat "$FILE"
  exit 1
fi
