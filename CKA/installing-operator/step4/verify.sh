#!/bin/bash 
 
NAMESPACE="monitoring" 
 
# Get the Prometheus pod name 
PROM_POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].metadata.name}') 
 
if [ -z "$PROM_POD" ]; then 
    echo "No Prometheus pod found in namespace $NAMESPACE." 
    exit 1 
fi 
 
# Check that port 9090 is open 
PORT=$(kubectl exec -n $NAMESPACE $PROM_POD -- sh -c "echo | nc -zv localhost 9090 2>&1 || true") 
if [[ "$PORT" == *succeeded* ]] || [[ "$PORT" == *open* ]]; then 
    echo "Prometheus port 9090 is reachable inside the pod." 
else 
    echo "Prometheus port 9090 might not be reachable." 
fi 
 
# Query Prometheus API for active targets 
TARGETS=$(kubectl exec -n $NAMESPACE $PROM_POD -- wget -qO- http://localhost:9090/api/v1/targets) 
 
if echo "$TARGETS" | grep -q "nginx-monitor"; then 
    echo "PodMonitor nginx-monitor detected by Prometheus." 
else 
    echo "PodMonitor nginx-monitor NOT detected in Prometheus targets." 
    exit 1 
fi 
