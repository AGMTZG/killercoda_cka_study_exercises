#!/bin/bash

RELEASE_NAME="my-nginx-release"
HELM_DIR="/opt/helm/nginx"

if helm status "$RELEASE_NAME" &> /dev/null; then
    echo "Helm release '$RELEASE_NAME' is installed."
else
    echo "ERROR: Helm release '$RELEASE_NAME' is not installed."
    exit 1
fi

if [ ! -d "$HELM_DIR" ]; then
    echo "ERROR: Directory $HELM_DIR does not exist."
    exit 1
fi

FILES=("status.txt" "manifest.yaml" "notes.txt")
MISSING=0

for FILE in "${FILES[@]}"; do
    if [ -f "$HELM_DIR/$FILE" ]; then
        echo "Found $FILE"
    else
        echo "ERROR: $FILE not found in $HELM_DIR"
        MISSING=1
    fi
done

if [ $MISSING -eq 1 ]; then
    echo "Some required files are missing."
    exit 1
else
    echo "All required Helm files are present."
fi
