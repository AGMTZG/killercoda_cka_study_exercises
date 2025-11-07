#!/bin/bash

if ! kubectl get secret my-secret -o jsonpath='{.type}' | grep -q "kubernetes.io/tls"; then
  echo "TLS secret 'my-secret' not found or not a TLS secret!"
  exit 1
fi

if ! kubectl get ingress connection-ingress >/dev/null 2>&1; then
  echo "Ingress 'connection-ingress' does not exist!"
  exit 1
fi

tls_host=$(kubectl get ingress connection-ingress -o jsonpath='{.spec.tls[0].hosts[0]}')
tls_secret=$(kubectl get ingress connection-ingress -o jsonpath='{.spec.tls[0].secretName}')

if [[ "$tls_host" != "example.local" ]] || [[ "$tls_secret" != "my-secret" ]]; then
  echo "❌ Ingress TLS is not configured correctly!"
  exit 1
fi

alpha_path=$(kubectl get ingress connection-ingress -o jsonpath='{.spec.rules[0].http.paths[0].path}')
beta_path=$(kubectl get ingress connection-ingress -o jsonpath='{.spec.rules[0].http.paths[1].path}')

if [[ "$alpha_path" != "/alpha" ]] || [[ "$beta_path" != "/beta" ]]; then
  echo "❌ Ingress paths are not configured correctly!"
  exit 1
fi
