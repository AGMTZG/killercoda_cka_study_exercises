#!/bin/bash

KUBECONFIG=~/.kube/config
NAMESPACE=appenv

if kubectl --kubeconfig="$KUBECONFIG" auth can-i create deployments -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "deploybot can create deployments"
else
    echo "deploybot cannot create deployments"
    exit 1
fi

if kubectl --kubeconfig="$KUBECONFIG" auth can-i list replicasets -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "deploybot can list replicasets"
else
    echo "deploybot cannot list replicasets"
    exit 1
fi

if kubectl --kubeconfig="$KUBECONFIG" auth can-i create pods -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "deploybot can create pods (should NOT be able to)"
    exit 1
else
    echo "deploybot cannot create pods"
fi

if kubectl --kubeconfig="$KUBECONFIG" auth can-i delete deployments -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "deploybot can delete deployments"
else
    echo "deploybot cannot delete deployments"
    exit 1
fi

if kubectl --kubeconfig="$KUBECONFIG" auth can-i get secrets -n "$NAMESPACE" >/dev/null 2>&1; then
    echo "deploybot can get secrets (should NOT be able to)"
    exit 1
else
    echo "deploybot cannot get secrets"
fi
