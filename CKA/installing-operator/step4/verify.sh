#!/bin/bash

NAMESPACE="monitoring"

# Get Prometheus pod using YAML + awk (safe)
PROM_POD=$(kubectl get pods -n $NAMESPACE -l app.kubernetes.io/name=prometheus -o yaml \
  | awk '/metadata:/ {met=1} met && /name:/ {print $2; exit}')

if [ -z "$PROM_POD" ]; then
  echo "Prometheus pod not found."
  exit 1
fi

# Get first PodMonitor name safely
PODMON=$(kubectl get podmonitor -n $NAMESPACE -o yaml 2>/dev/null \
  | awk '/metadata:/ {met=1} met && /name:/ {print $2; exit}')

if [ -z "$PODMON" ]; then
  echo "No PodMonitor found in namespace '$NAMESPACE'."
  exit 1
fi

# Query Prometheus API for the target
TARGETS=$(kubectl exec -n $NAMESPACE $PROM_POD -- \
  wget -qO- http://localhost:9090/api/v1/targets 2>/dev/null \
  | grep -i "$PODMON")

if [ -z "$TARGETS" ]; then
  echo "Prometheus API does not show any target for PodMonitor '$PODMON'."
  exit 1
fi
