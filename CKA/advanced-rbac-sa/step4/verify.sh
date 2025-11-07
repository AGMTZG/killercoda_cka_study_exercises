#!/bin/bash

KUBECONFIG=~/.kube/config
NAMESPACE=appenv

if kubectl --kubeconfig="$KUBECONFIG" create deployment nginx --image=nginx -n "$NAMESPACE" --dry-run=client &>/dev/null; then
    echo "deploybot can create deployments"
else
    echo "deploybot cannot create deployments"
    exit 1
fi

if kubectl --kubeconfig="$KUBECONFIG" get replicasets -n "$NAMESPACE" &>/dev/null; then
    echo "deploybot can list replicasets"
else
    echo "deploybot cannot list replicasets"
    exit 1
fi

if ! kubectl --kubeconfig="$KUBECONFIG" run test-pod --image=nginx -n "$NAMESPACE" --dry-run=client &>/dev/null; then
    echo "deploybot is denied from creating pods"
else
    echo "deploybot should not be able to create pods"
    exit 1
fi

if kubectl --kubeconfig="$KUBECONFIG" auth can-i delete deployments -n "$NAMESPACE" &>/dev/null; then
    echo "deploybot can delete deployments"
else
    echo "deploybot cannot delete deployments"
    exit 1
fi

if ! kubectl --kubeconfig="$KUBECONFIG" auth can-i get secrets -n "$NAMESPACE" &>/dev/null; then
    echo "deploybot cannot get secrets"
else
    echo "deploybot should not be able to get secrets"
    exit 1
fi
