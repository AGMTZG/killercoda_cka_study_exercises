#!/bin/bash
set -e

SECRET_NAME="my-secret"
NAMESPACE="default"

if kubectl get secret "$SECRET_NAME" -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "[OK] Secret '$SECRET_NAME' exists in namespace '$NAMESPACE'."
else
    echo "[ERROR] Secret '$SECRET_NAME' not found in namespace '$NAMESPACE'."
    exit 1
fi
