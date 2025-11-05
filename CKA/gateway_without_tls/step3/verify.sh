#!/bin/bash
set -e

if kubectl get ns ingress-nginx &>/dev/null; then
  echo "[ERROR] Namespace 'ingress-nginx' still exists. Please delete it before verifying."
  exit 1
else
  echo "[OK] Ingress namespace not found. Proceeding..."
fi

declare -A EXPECTED_CONTENT=(
  ["http://app.company.local/"]="Web App Home"
  ["http://app.company.local/dashboard"]="Dashboard App"
  ["http://orders.company.local/"]="Orders App"
  ["http://orders.company.local/reports"]="Reports App"
)

for url in "${!EXPECTED_CONTENT[@]}"; do
  expected="${EXPECTED_CONTENT[$url]}"
  echo -n "[TEST] $url ... "
  if curl -s --max-time 5 "$url" | grep -q "$expected"; then
    echo "[OK] Found '$expected'"
  else
    echo "[FAIL] '$expected' not found in response"
  fi
done
