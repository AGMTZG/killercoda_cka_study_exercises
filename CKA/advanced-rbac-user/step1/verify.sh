#!/bin/bash
if kubectl get csr alice-certificate &>/dev/null; then
  echo "CSR for alice created successfully."
  exit 0
else
  echo "CSR not found. Please apply certificate.yaml correctly."
  exit 1
fi
