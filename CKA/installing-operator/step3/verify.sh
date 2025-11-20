#!/bin/bash

# Check Pod exists
kubectl get pod nginx -n default >/dev/null 2>&1 || {
  echo "Nginx pod not found in default namespace"
  exit 1
}

# Check port name of Pod
PORT_NAME=$(kubectl get pod nginx -n default -o yaml \
  | awk '/ports:/{in_ports=1; next} in_ports && /^[[:space:]]*name:/ {print $2; exit}')

if [ "$PORT_NAME" != "nginx" ]; then
  echo "The container port name must be 'nginx' but found '$PORT_NAME'"
  exit 1
fi

# Check PodMonitor exists
kubectl get podmonitor nginx-monitor -n monitoring >/dev/null 2>&1 || {
  echo "PodMonitor 'nginx-monitor' not found."
  exit 1
}

# Check release label
LABEL=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/labels:/ {f=1; next} f && /release:/ {print $2; exit}')

if [ "$LABEL" != "prometheus" ]; then
  echo "PodMonitor missing required release=prometheus label"
  exit 1
fi

# Check selector label
SELECTOR=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/matchLabels:/ {f=1; next} f && /run:/ {print $2; exit}')

if [ "$SELECTOR" != "nginx" ]; then
  echo "PodMonitor selector must be run=nginx"
  exit 1
fi

# Check namespaceSelector
NS=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '/matchNames:/ {getline; print $2; exit}')

if [ "$NS" != "default" ]; then
  echo "PodMonitor must target namespace default"
  exit 1
fi

# Check podMetricsEndpoints port
PM_PORT=$(
  kubectl get podmonitor nginx-monitor -n monitoring -o yaml |
  awk '
    /podMetricsEndpoints:/ {in_block=1; next}
    in_block && /^[[:space:]]*port:/ {print $2; exit}
    in_block && !/^[[:space:]]/ {in_block=0}
  '
)

if [ "$PM_PORT" != "nginx" ]; then
  echo "podMetricsEndpoints.port must be 'nginx' but found '$PM_PORT'"
  exit 1
fi
