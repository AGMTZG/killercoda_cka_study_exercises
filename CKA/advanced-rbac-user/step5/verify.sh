#!/bin/sh

# Validate that alice-context exists (but do NOT switch to it)
kubectl config get-contexts alice-context >/dev/null 2>&1 || {
    echo "Error: alice-context not found"
    exit 1
}

# Ensure we run as admin so --as alice works
kubectl config use-context kubernetes-admin@kubernetes >/dev/null 2>&1 || {
    echo "Error: admin context not found"
    exit 1
}

NAMESPACE="projectx"
USER="alice"

# Test: create pods
if kubectl auth can-i create pods -n "$NAMESPACE" --as "$USER" >/dev/null 2>&1; then
    echo "Alice can create pods: OK"
else
    echo "Alice cannot create pods: FAILED"
    exit 1
fi

# Test: create deployments (should NOT be allowed)
if kubectl auth can-i create deployments -n "$NAMESPACE" --as "$USER" >/dev/null 2>&1; then
    echo "Alice can create deployments: ERROR (should NOT be allowed)"
    exit 1
else
    echo "Alice cannot create deployments: OK"
fi

# Test: list pods
if kubectl auth can-i list pods -n "$NAMESPACE" --as "$USER" >/dev/null 2>&1; then
    echo "Alice can list pods: OK"
else
    echo "Alice cannot list pods: FAILED"
    exit 1
fi

# Test: get secrets (should NOT be allowed)
if kubectl auth can-i get secrets -n "$NAMESPACE" --as "$USER" >/dev/null 2>&1; then
    echo "Alice can get secrets: ERROR (should NOT be allowed)"
    exit 1
else
    echo "Alice cannot get secrets: OK"
fi
