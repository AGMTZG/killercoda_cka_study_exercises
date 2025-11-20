#!/bin/bash

# Check if pod exists
kubectl get pod nginx -n default >/dev/null 2>&1 || {
  echo "Nginx pod not found in default namespace"
  exit 1
}

# Check pod port name using awk
PORT_NAME=$(kubectl get pod nginx -n default -o yaml \
  | awk '/ports:/{flag=1} flag && /name:/ {print $2; exit}')

if [ "$PORT_NAME" != "nginx" ]; then
  echo "The container port name must be 'nginx' but found '$PORT_NAME'"
  exit 1
fi

# Check PodMonitor exists
kubectl get podmonitor nginx-monitor -n monitoring >/dev/null 2>&1 || {
  echo "PodMonitor 'nginx-monitor' not found in monitoring namespace"
  exit 1
}

# Extract metadata.labels.release
LABEL=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/labels:/ {found=1} found && /release:/ {print $2; exit}')

if [ "$LABEL" != "prometheus" ]; then
  echo "PodMonitor missing required label release=prometheus"
  exit 1
fi

# Extract selector.matchLabels.run
SELECTOR=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/matchLabels:/ {found=1} found && /run:/ {print $2; exit}')

if [ "$SELECTOR" != "nginx" ]; then
  echo "PodMonitor selector must match label run=nginx"
  exit 1
fi

# Extract namespaceSelector.matchNames[0]
NS=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/matchNames:/ {getline; print $2; exit}')

if [ "$NS" != "default" ]; then
  echo "PodMonitor must target namespace 'default'"
  exit 1
fi

# Extract podMetricsEndpoints[0].port
PM_PORT=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/podMetricsEndpoints:/ {found=1} found && /port:/ {print $2; exit}')

if [ "$PM_PORT" != "nginx" ]; then
  echo "podMetricsEndpoints.port must be 'nginx'"
  exit 1
fi
