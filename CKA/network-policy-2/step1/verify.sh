#!/bin/bash

NAMESPACE="webapp"
BACKEND_POD=$(kubectl get pods -n $NAMESPACE -l service=backend -o jsonpath='{.items[0].metadata.name}')
REDIS_SERVICE="redis"
REDIS_PORT=6379

if kubectl exec -n "$NAMESPACE" "$BACKEND_POD" -- nc -zv "${REDIS_SERVICE}" "${REDIS_PORT}" >/dev/null 2>&1; then
  echo "Backend pod can connect to Redis service (${REDIS_SERVICE}:${REDIS_PORT})."
  echo "NetworkPolicy has been correctly configured."
else
  echo "Backend pod cannot connect to Redis service. NetworkPolicy still blocking traffic."
  exit 1
fi
