#!/bin/bash

NS="webapp"

EXPECTED_POLICIES=("deny-all" "internal-role-access" "internal-ops-policy")

CURRENT_POLICIES=($(kubectl get networkpolicy -n $NS -o jsonpath='{.items[*].metadata.name}'))

for policy in "${EXPECTED_POLICIES[@]}"; do
    if [[ ! " ${CURRENT_POLICIES[@]} " =~ " ${policy} " ]]; then
        echo "[FAILURE] Missing NetworkPolicy: $policy"
        exit 1
    fi
done

for policy in "${CURRENT_POLICIES[@]}"; do
    if [[ ! " ${EXPECTED_POLICIES[@]} " =~ " ${policy} " ]]; then
        echo "[FAILURE] Unexpected NetworkPolicy found: $policy"
        exit 1
    fi
done

BACKEND_POD=$(kubectl get pod -n $NS -l service=backend -o jsonpath='{.items[0].metadata.name}')
REDIS_POD=$(kubectl get pod -n $NS -l service=redis -o jsonpath='{.items[0].metadata.name}')
REDIS_IP=$(kubectl get pod "$REDIS_POD" -n $NS -o jsonpath='{.status.podIP}')

kubectl exec -n $NS "$BACKEND_POD" -- sh -c "nc -vz -w 10 $REDIS_IP 6379" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "[SUCCESS] Backend can connect to Redis"
else
    echo "[FAILURE] Backend cannot connect to Redis (timeout 10s)"
fi
