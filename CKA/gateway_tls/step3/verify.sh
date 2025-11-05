#!/bin/bash

if kubectl get httproute http-home >/dev/null 2>&1; then
  echo "HTTPRoute 'http-home' exists."
else
  echo "HTTPRoute 'http-home' not found."
  exit 1
fi

if kubectl get httproute http-contact >/dev/null 2>&1; then
  echo "HTTPRoute 'http-contact' exists."
else
  echo "HTTPRoute 'http-contact' not found."
  exit 1
fi

if kubectl get httproute http-home -o jsonpath='{.spec.parentRefs[0].name}' 2>/dev/null | grep -q "my-tls-gateway"; then
  echo "'http-home' correctly references Gateway 'my-tls-gateway'."
else
  echo "'http-home' does not reference 'my-tls-gateway'."
  exit 1
fi

if kubectl get httproute http-contact -o jsonpath='{.spec.parentRefs[0].name}' 2>/dev/null | grep -q "my-tls-gateway"; then
  echo "'http-contact' correctly references Gateway 'my-tls-gateway'."
else
  echo "'http-contact' does not reference 'my-tls-gateway'."
  exit 1
fi
