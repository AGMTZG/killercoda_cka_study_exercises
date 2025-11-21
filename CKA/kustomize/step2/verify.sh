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

GENERATED_YAML=$(kubectl kustomize "$BASE_DIR")
if [[ $? -ne 0 ]]; then
    echo "Error: kustomize build failed."
    exit 1
fi

echo "$GENERATED_YAML" | grep -q "image: mysql:prod" || {
    echo "MySQL image not set to 'prod'"
    exit 1
}

echo "$GENERATED_YAML" | grep -q "env: prod" || {
    echo "Label 'env: prod' missing"
    exit 1
}

CONFIG_DB_HOST=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="ConfigMap" and .metadata.name|test("db_host")) | .data.DB_HOST' -)
CONFIG_DB_PORT=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="ConfigMap" and .metadata.name|test("db_host")) | .data.DB_PORT' -)

if [[ "$CONFIG_DB_HOST" != "mysql-prod.company.local" ]]; then
    echo "ConfigMap DB_HOST not correct"
    exit 1
fi

if [[ "$CONFIG_DB_PORT" != "3306" ]]; then
    echo "ConfigMap DB_PORT not correct"
    exit 1
fi

SECRET_USERNAME=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="Secret" and .metadata.name|test("db_secret")) | .data.USERNAME' -)
SECRET_PASSWORD=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="Secret" and .metadata.name|test("db_secret")) | .data.PASSWORD' -)

DECODED_USERNAME=$(echo "$SECRET_USERNAME" | base64 --decode)
DECODED_PASSWORD=$(echo "$SECRET_PASSWORD" | base64 --decode)

if [[ "$DECODED_USERNAME" != "prod_admin" ]]; then
    echo "Secret USERNAME not correct"
    exit 1
fi

if [[ "$DECODED_PASSWORD" != "G7hT9pX2!zQ4" ]]; then
    echo "Secret PASSWORD not correct"
    exit 1
fi

TOLERATIONS=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="StatefulSet") | .spec.template.spec.tolerations[]? | .key' -)
if [[ "$TOLERATIONS" != *"prod"* ]]; then
    echo "Toleration for prod nodes missing"
    exit 1
fi

CPU_REQUEST=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="StatefulSet") | .spec.template.spec.containers[0].resources.requests.cpu' -)
MEM_REQUEST=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="StatefulSet") | .spec.template.spec.containers[0].resources.requests.memory' -)
CPU_LIMIT=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="StatefulSet") | .spec.template.spec.containers[0].resources.limits.cpu' -)
MEM_LIMIT=$(echo "$GENERATED_YAML" | yq eval 'select(.kind=="StatefulSet") | .spec.template.spec.containers[0].resources.limits.memory' -)

if [[ "$CPU_REQUEST" != "500m" ]]; then
    echo "CPU request not correct"
    exit 1
fi

if [[ "$MEM_REQUEST" != "1Gi" ]]; then
    echo "Memory request not correct"
    exit 1
fi

if [[ "$CPU_LIMIT" != "1" ]]; then
    echo "CPU limit not correct"
    exit 1
fi

if [[ "$MEM_LIMIT" != "2Gi" ]]; then
    echo "Memory limit not correct"
    exit 1
fi

echo "All checks passed for prod overlay!"
