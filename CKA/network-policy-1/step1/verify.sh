#!/bin/bash

NAMESPACE="mercury"
CLIENT_POD=$(kubectl get pods -n $NAMESPACE -l app=client -o jsonpath='{.items[0].metadata.name}')

if kubectl exec -n $NAMESPACE $CLIENT_POD -- curl -s --connect-timeout 5 http://server-service:5678 > /dev/null; then
  echo "Client can reach server-service on port 5678"
else
  echo "Client cannot reach server-service on port 5678"
  exit 1
fi

if kubectl exec -n $NAMESPACE $CLIENT_POD -- curl -s --connect-timeout 5 http://logger-service:9880 > /dev/null; then
  echo "Client can reach logger-service on port 9880"
else
  echo "Client cannot reach logger-service on port 9880"
  exit 1
fi
