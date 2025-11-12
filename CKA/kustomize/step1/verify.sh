#!/bin/bash

BASE_DIR=~/app/overlays/dev

if [[ ! -f "$BASE_DIR/kustomization.yaml" ]]; then
    echo "kustomization.yaml not found in $BASE_DIR"
    exit 1
fi

if [[ ! -f "$BASE_DIR/patch.json" ]]; then
    echo "patch.json not found in $BASE_DIR"
    exit 1
fi

grep -q "mysql.*dev" "$BASE_DIR/kustomization.yaml" || {
    echo "MySQL image not set to 'dev' in kustomization.yaml"
    exit 1
}

grep -q "env: dev" "$BASE_DIR/kustomization.yaml" || {
    echo "Common label 'env: dev' not set"
    exit 1
}

grep -q "DB_HOST=localhost" "$BASE_DIR/kustomization.yaml" || {
    echo "ConfigMap DB_HOST not set correctly"
    exit 1
}

grep -q "USERNAME=admin" "$BASE_DIR/kustomization.yaml" || {
    echo "Secret USERNAME not set correctly"
    exit 1
}

grep -q "PASSWORD=asdfqwerty" "$BASE_DIR/kustomization.yaml" || {
    echo "Secret PASSWORD not set correctly"
    exit 1
}

grep -q "DEBUG" "$BASE_DIR/patch.json" || {
    echo "Environment variable DEBUG not set in patch.json"
    exit 1
}

grep -q "init-permissions" "$BASE_DIR/patch.json" || {
    echo "InitContainer to fix permissions missing in patch.json"
    exit 1
}

if ! kustomize build ~/app/overlays/dev >/dev/null 2>&1; then
  echo "Error: kustomize build failed."
  exit 1
fi
