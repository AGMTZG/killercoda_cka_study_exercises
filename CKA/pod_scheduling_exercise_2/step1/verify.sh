#!/bin/bash
# verify.sh - Verify pods, affinities, anti-affinities, and tolerations

set -e

echo "Verifying pods status..."
kubectl get pods -o wide

echo
echo "Checking if 'api' pod tolerates controlplane taint..."
kubectl describe pod api | grep -A5 Tolerations

echo
echo "Checking if 'api' pod has affinity and anti-affinity rules..."
kubectl get pod api -o json | jq '.spec.affinity'

echo
echo "Checking if 'auth' pod tolerates controlplane taint..."
kubectl describe pod auth | grep -A5 Tolerations

echo
echo "Checking 'logger' pod node affinity..."
kubectl get pod logger -o json | jq '.spec.affinity.nodeAffinity'

echo
echo "Checking 'db' pod node affinity..."
kubectl get pod db -o json | jq '.spec.affinity.nodeAffinity'

echo
echo "Checking if all pods are scheduled on nodes according to rules..."
kubectl get pods -o wide

echo
echo "Verify complete. Make sure 'api' and 'auth' can co-locate, 'logger' avoids tier=testing nodes, and 'db' prefers tier=testing node."
