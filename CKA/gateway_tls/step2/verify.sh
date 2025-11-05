#!/bin/bash

if kubectl get gatewayclass nginx -o jsonpath='{.status.conditions[?(@.type=="Accepted")].status}' 2>/dev/null | grep -q True; then
  echo "GatewayClass 'nginx' is accepted."
else
  echo "GatewayClass 'nginx' not found or not accepted."
  exit 1
fi

if kubectl get gateway my-tls-gateway >/dev/null 2>&1; then
  echo "Gateway 'my-tls-gateway' exists."
else
  echo "Gateway 'my-tls-gateway' not found."
  exit 1
fi
