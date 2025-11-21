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

GENERATED_YAML=$(kubectl kustomize "$BASE_DIR")
if [[ $? -ne 0 ]]; then
    echo "Error: kustomize build failed."
    exit 1
fi

echo "$GENERATED_YAML" | grep -q "image: mysql:dev" || {
    echo "MySQL image not set to 'dev' in generated YAML"
    exit 1
}

echo "$GENERATED_YAML" | grep -q "env: dev" || {
    echo "Label 'env: dev' not set in generated YAML"
    exit 1
}

echo "$GENERATED_YAML" | grep -q "DB_HOST: localhost" || {
    echo "ConfigMap DB_HOST not set correctly"
    exit 1
}
echo "$GENERATED_YAML" | grep -q "DB_PORT: \"3306\"" || {
    echo "ConfigMap DB_PORT not set correctly"
    exit 1
}

echo "$GENERATED_YAML" | grep -q "USERNAME: YWRtaW4=" || {
    echo "Secret USERNAME not set correctly"
    exit 1
}
echo "$GENERATED_YAML" | grep -q "PASSWORD: YXNkZnF3ZXJ0eQ==" || {
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

echo "All checks passed!"
