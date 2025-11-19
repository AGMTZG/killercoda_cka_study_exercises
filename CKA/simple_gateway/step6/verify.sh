#!/bin/bash

# Check if the HTTPRoute exists
kubectl get httproute webapp-route >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "HTTPRoute 'webapp-route' was not found."
  exit 1
fi

# Get the external IP of the Gateway
GATEWAY_IP=$(kubectl get gateway my-gateway -o jsonpath='{.status.addresses[0].value}')

# Check /etc/hosts entry
echo "Checking /etc/hosts entry for app.example.com..."
grep -q "$GATEWAY_IP app.example.com" /etc/hosts
if [ $? -ne 0 ]; then
  echo "/etc/hosts does not contain the gateway IP and app.example.com"
  exit 1
fi

# Test HTTP access
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://app.example.com/)

if [ "$HTTP_RESPONSE" -eq 200 ]; then
  echo "Connection successful! Gateway routed traffic correctly."
else
  echo "Unexpected HTTP status code: $HTTP_RESPONSE"
  exit 1
fi
