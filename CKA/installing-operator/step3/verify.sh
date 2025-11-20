#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

DEBUG=${DEBUG:-0}

info() { [ "$DEBUG" -eq 1 ] && echo "[DEBUG] $*"; }

# Check Pod exists
kubectl get pod nginx -n default >/dev/null 2>&1 || {
  echo "Nginx pod not found in default namespace"
  exit 1
}

# Check pod port name using YAML + awk (handles "- name: ..." and "name: ...")
PORT_NAME=$(kubectl get pod nginx -n default -o yaml \
  | awk '
    /ports:/ {in_ports=1; next}
    in_ports {
      # stop if new top-level section starts (same or less indent than "ports")
      if ($0 ~ /^[^[:space:]]/) exit
      # strip leading "- " or spaces
      line = $0
      sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (line ~ /^name:[[:space:]]*/) {
        sub(/^name:[[:space:]]*/, "", line)
        print line
        exit
      }
    }
  ' | tr -d '"' )

info "Port name read: '$PORT_NAME'"

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
  | awk '
    /labels:/ {f=1; next}
    f {
      if ($0 ~ /^[^[:space:]]/) exit
      line=$0; sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (line ~ /^release:[[:space:]]*/) {
        sub(/^release:[[:space:]]*/, "", line)
        print line; exit
      }
    }
  ' | tr -d '"' )

info "Label read: '$LABEL'"

if [ "$LABEL" != "prometheus" ]; then
  echo "PodMonitor missing required release=prometheus label"
  exit 1
fi

# Check selector label
SELECTOR=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '
    /matchLabels:/ {f=1; next}
    f {
      if ($0 ~ /^[^[:space:]]/) exit
      line=$0; sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (line ~ /^run:[[:space:]]*/) {
        sub(/^run:[[:space:]]*/, "", line)
        print line; exit
      }
    }
  ' | tr -d '"' )

info "Selector read: '$SELECTOR'"

if [ "$SELECTOR" != "nginx" ]; then
  echo "PodMonitor selector must be run=nginx"
  exit 1
fi

# Check namespaceSelector
NS=$(kubectl get podmonitor nginx-monitor -n monitoring -o yaml \
  | awk '
    /matchNames:/ {f=1; next}
    f {
      if ($0 ~ /^[^[:space:]]/) exit
      # handle "- default" or " - default"
      line=$0; sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (length(line)>0) { print line; exit }
    }
  ' | tr -d '"' )

info "Namespace read: '$NS'"

if [ "$NS" != "default" ]; then
  echo "PodMonitor must target namespace default"
  exit 1
fi

# Check podMetricsEndpoints port (handles "- port: nginx" and "port: nginx")
PM_PORT=$(
  kubectl get podmonitor nginx-monitor -n monitoring -o yaml |
  awk '
    /podMetricsEndpoints:/ {in_block=1; next}
    in_block {
      # if indentation stops (new top-level or sibling), exit
      if ($0 ~ /^[^[:space:]]/) exit
      # strip leading "- " and spaces
      line=$0; sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (line ~ /^port:[[:space:]]*/) {
        sub(/^port:[[:space:]]*/, "", line)
        print line
        exit
      }
    }
  ' | tr -d '"' 
)

info "PodMetricsEndpoints port read: '$PM_PORT'"

if [ "$PM_PORT" != "nginx" ]; then
  echo "podMetricsEndpoints.port must be 'nginx' but found '$PM_PORT'"
  exit 1
fi

echo "All checks passed."
