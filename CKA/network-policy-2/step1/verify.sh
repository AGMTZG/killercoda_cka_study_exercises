#!/bin/bash

NS="webapp"
BACKEND_POD=$(kubectl get pod -n $NS -l service=backend -o jsonpath='{.items[0].metadata.name}')
REDIS_POD=$(kubectl get pod -n $NS -l service=redis -o jsonpath='{.items[0].metadata.name}')
REDIS_IP=$(kubectl get pod "$REDIS_POD" -n $NS -o jsonpath='{.status.podIP}')

kubectl exec -n $NS "$BACKEND_POD" -- nc -vz "$REDIS_IP" 6379 >/dev/null 2>&1

if [ $? -eq 0 ]; then
    echo "[SUCCESS] Backend can connect to Redis"
else
    echo "[FAILURE] Backend cannot connect to Redis"
fi
