#!/bin/bash

NAMESPACE="monitoring"
PROM_POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=prometheus -o jsonpath="{.items[0].metadata.name}")
PODMON=$(kubectl get podmonitor -n $NAMESPACE -o jsonpath="{.items[0].metadata.name}" 2>/dev/null)

# Exec into Prometheus pod and query targets
TARGETS=$(kubectl exec -n $NAMESPACE $PROM_POD -- wget -qO- http://localhost:9090/api/v1/targets | grep -i $PODMON)

if [ -z "$TARGETS" ]; then
  echo "Prometheus API does not show any target related to PodMonitor '$PODMON'."
  exit 1
fi
