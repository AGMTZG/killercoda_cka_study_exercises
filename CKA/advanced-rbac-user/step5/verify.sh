#!/bin/sh

kubectl config use-context alice-context >/dev/null 2>&1 || { echo "Error: alice-context not found"; exit 1; }

if kubectl auth can-i create pods -n projectx --as alice >/dev/null 2>&1; then
    echo "Alice can create pods: OK"
else
    echo "Alice cannot create pods: FAILED"
    exit 1
fi

if kubectl auth can-i create deployments -n projectx --as alice >/dev/null 2>&1; then
    echo "Alice can create deployments: ERROR (she should NOT be able to)"
    exit 1
else
    echo "Alice cannot create deployments: OK"
fi

if kubectl auth can-i list pods -n projectx --as alice >/dev/null 2>&1; then
    echo "Alice can list pods: OK"
else
    echo "Alice cannot list pods: FAILED"
    exit 1
fi

if kubectl auth can-i get secrets -n projectx --as alice >/dev/null 2>&1; then
    echo "Alice can get secrets: ERROR (she should NOT be able to)"
    exit 1
else
    echo "Alice cannot get secrets: OK"
fi
