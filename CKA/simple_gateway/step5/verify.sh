#!/bin/bash

# Check if the Gateway exists
if ! kubectl get gateway my-gateway >/dev/null 2>&1; then
    echo "Gateway 'my-gateway' not found."
    exit 1
fi

# Verify GatewayClass
GWC=$(kubectl get gateway my-gateway -o jsonpath='{.spec.gatewayClassName}')
if [ "$GWC" != "nginx" ]; then
    echo "GatewayClass is '$GWC' but should be 'nginx'."
    exit 1
fi

# Verify port 80 listener exists
PORT=$(kubectl get gateway my-gateway -o jsonpath='{.spec.listeners[0].port}')
if [ "$PORT" != "80" ]; then
    echo "Listener port is '$PORT' but should be '80'."
    exit 1
fi

# Verify hostname
HOST=$(kubectl get gateway my-gateway -o jsonpath='{.spec.listeners[0].hostname}')
if [ "$HOST" != "app.example.com" ]; then
    echo "Hostname is '$HOST' but should be 'app.example.com'."
    exit 1
fi
