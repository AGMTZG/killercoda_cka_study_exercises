#!/bin/bash

NAMESPACE="monitoring"

# Verificar que exista el pod de Prometheus
PROM_POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=prometheus -o jsonpath='{.items[0].metadata.name}')

if [ -z "$PROM_POD" ]; then
    echo "No Prometheus pod found in namespace $NAMESPACE."
    exit 1
fi

# Verificar que exista el PodMonitor nginx-monitor
if kubectl get podmonitor nginx-monitor -n $NAMESPACE &> /dev/null; then
    echo "PodMonitor nginx-monitor exists."
else
    echo "PodMonitor nginx-monitor NOT found."
    exit 1
fi
