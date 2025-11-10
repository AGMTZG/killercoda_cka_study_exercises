#!/bin/bash

PKI_DIR="/etc/kubernetes/pki"
ETCD_DIR="${PKI_DIR}/etcd"

rm -rf "${PKI_DIR:?}"/*
mkdir -p "${ETCD_DIR}"

openssl genrsa -out ${PKI_DIR}/ca.key 2048
openssl req -x509 -new -nodes -key ${PKI_DIR}/ca.key -subj "/CN=kubernetes-ca" -days 1095 -out ${PKI_DIR}/ca.crt

for cert in front-proxy-client apiserver-kubelet-client apiserver-etcd-client etcd/healthcheck-client etcd/peer; do
  dir=$(dirname "$cert")
  [ "$dir" != "." ] && mkdir -p "$PKI_DIR/$dir"
  openssl genrsa -out ${PKI_DIR}/${cert}.key 2048
  openssl req -new -key ${PKI_DIR}/${cert}.key -subj "/CN=${cert}" -out ${PKI_DIR}/${cert}.csr
  openssl x509 -req -in ${PKI_DIR}/${cert}.csr \
    -CA ${PKI_DIR}/ca.crt -CAkey ${PKI_DIR}/ca.key -CAcreateserial \
    -out ${PKI_DIR}/${cert}.crt -days 365 -sha256
  rm -f ${PKI_DIR}/${cert}.csr
done

CRITICAL_CERTS=(
  "apiserver"
  "controller-manager"
  "scheduler"
  "etcd/server"
)

for cert in "${CRITICAL_CERTS[@]}"; do
  dir=$(dirname "$cert")
  [ "$dir" != "." ] && mkdir -p "$PKI_DIR/$dir"
  openssl genrsa -out ${PKI_DIR}/${cert}.key 2048
  openssl req -new -key ${PKI_DIR}/${cert}.key -subj "/CN=${cert}" -out ${PKI_DIR}/${cert}.csr
  openssl x509 -req -in ${PKI_DIR}/${cert}.csr \
    -CA ${PKI_DIR}/ca.crt -CAkey ${PKI_DIR}/ca.key -CAcreateserial \
    -out ${PKI_DIR}/${cert}.crt -days 1 -sha256
  rm -f ${PKI_DIR}/${cert}.csr
done

chown -R root:root ${PKI_DIR}
chmod -R 600 ${PKI_DIR}/*.key ${ETCD_DIR}/*.key 2>/dev/null || true

for c in $(find ${PKI_DIR} -name "*.crt"); do
  printf " - %-40s %s\n" "$(basename $c)" "$(openssl x509 -in $c -noout -enddate)"
done
