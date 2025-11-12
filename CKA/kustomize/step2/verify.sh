#!/bin/bash

BASE_DIR=~/app/overlays/prod

if [[ ! -f "$BASE_DIR/kustomization.yaml" ]]; then
    echo "kustomization.yaml not found in $BASE_DIR"
    exit 1
fi

if [[ ! -f "$BASE_DIR/patch-prod.json" ]]; then
    echo "patch-prod.json not found in $BASE_DIR"
    exit 1
fi

grep -q "mysql.*prod" "$BASE_DIR/kustomization.yaml" || {
    echo "MySQL image not set to 'prod' in kustomization.yaml"
    exit 1
}

grep -q "env: prod" "$BASE_DIR/kustomization.yaml" || {
    echo "Common label 'env: prod' not set"
    exit 1
}

grep -q "DB_HOST=mysql-prod.company.local" "$BASE_DIR/kustomization.yaml" || {
    echo "ConfigMap DB_HOST not set correctly"
    exit 1
}

grep -q "USERNAME=prod_admin" "$BASE_DIR/kustomization.yaml" || {
    echo "Secret USERNAME not set correctly"
    exit 1
}

grep -q "PASSWORD=G7hT9pX2!zQ4" "$BASE_DIR/kustomization.yaml" || {
    echo "Secret PASSWORD not set correctly"
    exit 1
}

grep -q "prod" "$BASE_DIR/patch-prod.json" || {
    echo "Toleration for prod nodes missing in patch-prod.json"
    exit 1
}

grep -q "500m" "$BASE_DIR/patch-prod.json" || {
    echo "CPU requests missing or incorrect in patch-prod.json"
    exit 1
}

grep -q "1Gi" "$BASE_DIR/patch-prod.json" || {
    echo "Memory requests missing or incorrect in patch-prod.json"
    exit 1
}

grep -q "\"cpu\": \"1\"" "$BASE_DIR/patch-prod.json" || {
    echo "CPU limits missing or incorrect in patch-prod.json"
    exit 1
}

grep -q "\"memory\": \"2Gi\"" "$BASE_DIR/patch-prod.json" || {
    echo "Memory limits missing or incorrect in patch-prod.json"
    exit 1
}

if ! kustomize build ~/app/overlays/prod >/dev/null 2>&1; then
  echo "Error: kustomize build failed."
  exit 1
fi
