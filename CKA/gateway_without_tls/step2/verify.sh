#!/bin/bash

if kubectl get httproute http-app >/dev/null 2>&1; then
  echo "HTTPRoute 'http-app' exists."
else
  echo "HTTPRoute 'http-app' not found."
  exit 1
fi

if kubectl get httproute http-orders >/dev/null 2>&1; then
  echo "HTTPRoute 'http-orders' exists."
else
  echo "HTTPRoute 'http-orders' not found."
  exit 1
fi

if kubectl get httproute http-app -o jsonpath='{.spec.parentRefs[0].name}' 2>/dev/null | grep -q "my-gateway"; then
  echo "'http-app' correctly references Gateway 'my-gateway'."
else
  echo "'http-app' does not reference 'my-gateway'."
  exit 1
fi

if kubectl get httproute http-orders -o jsonpath='{.spec.parentRefs[0].name}' 2>/dev/null | grep -q "my-gateway"; then
  echo "'http-orders' correctly references Gateway 'my-gateway'."
else
  echo "'http-orders' does not reference 'my-gateway'."
  exit 1
fi
