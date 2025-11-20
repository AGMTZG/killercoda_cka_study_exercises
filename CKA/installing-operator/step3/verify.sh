#!/bin/bash

# Check if pod exist
kubectl get pod nginx -n default >/dev/null 2>&1 || {
  echo "Nginx pod not found in default namespace"
  exit 1
}

# Check port name
PORT_NAME=$(kubectl get pod nginx -n default -o jsonpath='{.spec.containers[0].ports[0].name}')
if [ "$PORT_NAME" != "nginx" ]; then
  echo "The container port name must be 'nginx' but found '$PORT_NAME'"
  exit 1
fi

# Check Pod Monitor
kubectl get podmonitor nginx-monitor -n monitoring >/dev/null 2>&1 || {
  echo "PodMonitor 'nginx-monitor' not found in monitoring namespace"
  exit 1
}

# Check the label
LABEL=$(kubectl get podmonitor nginx-monitor -n monitoring -o jsonpath='{.metadata.labels.release}')
if [ "$LABEL" != "prometheus" ]; then
  echo "PodMonitor missing required label release=prometheus"
  exit 1
fi

# Check selector
SELECTOR=$(kubectl get podmonitor nginx-monitor -n monitoring -o jsonpath='{.spec.selector.matchLabels.run}')
if [ "$SELECTOR" != "nginx" ]; then
  echo "PodMonitor selector must match label run=nginx"
  exit 1
fi

# Check namespaceSelector
NS=$(kubectl get podmonitor nginx-monitor -n monitoring -o jsonpath='{.spec.namespaceSelector.matchNames[0]}')
if [ "$NS" != "default" ]; then
  echo "PodMonitor must target namespace 'default'"
  exit 1
fi

# Check port name in podMetricsEndpoints
PM_PORT=$(kubectl get podmonitor nginx-monitor -n monitoring -o jsonpath='{.spec.podMetricsEndpoints[0].port}')
if [ "$PM_PORT" != "nginx" ]; then
  echo "podMetricsEndpoints.port must be 'nginx'"
  exit 1
fi
