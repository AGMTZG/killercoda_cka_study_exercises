#!/bin/bash

PKI_DIR="/etc/kubernetes/pki"
ETCD_DIR="${PKI_DIR}/etcd"

CERTS=(
  "${PKI_DIR}/apiserver.crt"
  "${PKI_DIR}/scheduler.crt"
  "${PKI_DIR}/controller-manager.crt"
  "${ETCD_DIR}/server.crt"
)

for cert in "${CERTS[@]}"; do
  if [ ! -f "$cert" ]; then
    echo "Certificate not found: $cert"
    continue
  fi

  expire_ts=$(openssl x509 -in "$cert" -noout -enddate | cut -d= -f2 | xargs -I{} date -d "{}" +%s)
  now_ts=$(date +%s)
  days_left=$(( (expire_ts - now_ts) / 86400 ))

  if [ "$days_left" -ge 365 ]; then
    echo "Valid for at least 365 days"
  else
    echo "Less than 365 days remaining"
  fi
done
