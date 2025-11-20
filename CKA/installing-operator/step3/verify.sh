#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

NAMESPACE_POD="default"
NAMESPACE_MON="monitoring"
POD_NAME="nginx"
PODMON_NAME="nginx-monitor"

# -----------------------------
# Check Pod exists
# -----------------------------
kubectl get pod "$POD_NAME" -n "$NAMESPACE_POD" >/dev/null 2>&1 || {
  echo "Pod '$POD_NAME' not found in namespace '$NAMESPACE_POD'."
  exit 1
}

PORT_NAME=$(kubectl get pod "$POD_NAME" -n "$NAMESPACE_POD" -o jsonpath='{.spec.containers[0].ports[0].name}')

# -----------------------------
# Check PodMonitor exists
# -----------------------------
kubectl get podmonitor "$PODMON_NAME" -n "$NAMESPACE_MON" >/dev/null 2>&1 || {
  echo "PodMonitor '$PODMON_NAME' not found in namespace '$NAMESPACE_MON'."
  exit 1
}

LABEL=$(kubectl get podmonitor "$PODMON_NAME" -n "$NAMESPACE_MON" -o jsonpath='{.metadata.labels.release}')
SELECTOR=$(kubectl get podmonitor "$PODMON_NAME" -n "$NAMESPACE_MON" -o jsonpath='{.spec.selector.matchLabels.run}')

# -----------------------------
# Check namespaceSelector robusto
# -----------------------------
NS=$(kubectl get podmonitor "$PODMON_NAME" -n "$NAMESPACE_MON" -o yaml \
  | awk '
      /namespaceSelector:/ {in_ns=1}
      in_ns && /matchNames:/ {in_match=1; next}
      in_match {
        if ($1 !~ /^-/) { in_match=0; next }
        line=$0
        sub(/^[[:space:]]*-[[:space:]]*/, "", line)
        print line
        exit
      }
    ' | tr -d '"')

# -----------------------------
# Check podMetricsEndpoints port
# -----------------------------
PM_PORT=$(
  kubectl get podmonitor "$PODMON_NAME" -n "$NAMESPACE_MON" -o yaml |
  awk '
    /podMetricsEndpoints:/ {in_block=1; next}
    in_block {
      if ($0 ~ /^[^[:space:]]/) exit
      line=$0
      sub(/^[[:space:]]*-?[[:space:]]*/, "", line)
      if (line ~ /^port:[[:space:]]*/) {
        sub(/^port:[[:space:]]*/, "", line)
        print line
        exit
      }
    }
  ' | tr -d '"'
)

# -----------------------------
# Print summary
# -----------------------------
echo "===== PodMonitor Validation Summary ====="
echo "Pod name: $POD_NAME"
echo "Pod container port: $PORT_NAME"
echo "PodMonitor name: $PODMON_NAME"
echo "Release label: $LABEL"
echo "Selector label: $SELECTOR"
echo "NamespaceSelector: $NS"
echo "podMetricsEndpoints port: $PM_PORT"
echo "========================================"

# -----------------------------
# Validation checks
# -----------------------------
[[ "$PORT_NAME" == "nginx" ]] || { echo "❌ Pod container port must be 'nginx'"; exit 1; }
[[ "$LABEL" == "prometheus" ]] || { echo "❌ PodMonitor release label must be 'prometheus'"; exit 1; }
[[ "$SELECTOR" == "$POD_NAME" ]] || { echo "❌ PodMonitor selector must be run=$POD_NAME"; exit 1; }
[[ "$NS" == "$NAMESPACE_POD" ]] || { echo "❌ PodMonitor must target namespace $NAMESPACE_POD"; exit 1; }
[[ "$PM_PORT" == "nginx" ]] || { echo "❌ podMetricsEndpoints port must be 'nginx'"; exit 1; }

echo "✅ All checks passed."
