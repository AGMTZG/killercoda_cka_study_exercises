#!/bin/bash
set -e

if kubectl get ns ingress-nginx &>/dev/null; then
  echo "[ERROR] Namespace 'ingress-nginx' still exists. Please delete it before verifying."
  exit 1
else
  echo "[OK] Ingress namespace not found. Proceeding..."
fi

declare -A EXPECTED_CONTENT=(
  ["http://app.home.local/"]="Welcome to home page"
  ["https://app.home.local/"]="Welcome to home page"
  ["http://app.home.local/sales"]="Welcome to sales page"
  ["https://app.home.local/sales"]="Welcome to sales page"
  ["http://app.contact.local/contact"]="Welcome to contact page"
  ["https://app.contact.local/contact"]="Welcome to contact page"
  ["http://app.contact.local/about"]="Welcome to about us page"
  ["https://app.contact.local/about"]="Welcome to about us page"
)

for url in "${!EXPECTED_CONTENT[@]}"; do
  expected="${EXPECTED_CONTENT[$url]}"
  echo -n "[TEST] $url ... "
  
  if curl -k -s --max-time 5 "$url" | grep -q "$expected"; then
    echo -e "\033[95m[OK] Encontrado '$expected'\033[0m"
  else
    echo -e "\033[91m[FAIL] '$expected' no encontrado en la respuesta\033[0m"
  fi
done
