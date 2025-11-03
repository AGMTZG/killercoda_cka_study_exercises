#!/bin/bash

set -e

FRONTEND_NODE=$(kubectl get pod frontend -o jsonpath='{.spec.nodeName}')
BACKEND_NODE=$(kubectl get pod backend -o jsonpath='{.spec.nodeName}')
CACHE_NODE=$(kubectl get pod cache -o jsonpath='{.spec.nodeName}')
DB_NODE=$(kubectl get pod mysql -o jsonpath='{.spec.nodeName}')

if [[ "$BACKEND_NODE" != "controlplane" ]]; then
    echo "Backend is not on controlplane, it is on $BACKEND_NODE"
    exit 1
fi
echo "Backend is on controlplane"

if [[ "$FRONTEND_NODE" != "$BACKEND_NODE" ]]; then
    echo "Frontend is not on the same node as backend. It's on $FRONTEND_NODE, backend on $BACKEND_NODE"
else
    echo "Frontend is colocated with backend on $FRONTEND_NODE"
fi

if [[ "$CACHE_NODE" == "node01" ]]; then
    echo "Cache is on node01, which is not allowed"
    exit 1
fi
echo "Cache is scheduled correctly on $CACHE_NODE"

if [[ "$DB_NODE" != "node01" ]]; then
    echo "DB is not on node01, it is on $DB_NODE"
    exit 1
fi
echo "DB is on node01"

echo "All pod scheduling checks passed!"
