#!/bin/bash

PKI_DIR="/etc/kubernetes/pki"
ETCD_DIR="${PKI_DIR}/etcd"

rm -rf "${PKI_DIR:?}"/*
mkdir -p "${ETCD_DIR}"

openssl genrsa -out ${PKI_DIR}/ca.key 2048
openssl req -x509 -new -nodes -key ${PKI_DIR}/ca.key -subj "/CN=kubernetes-ca" -days 1095 -out ${PKI_DIR}/ca.crt

openssl genrsa -out ${PKI_DIR}/front-proxy-ca.key 2048
openssl req -x509 -new -nodes -key ${PKI_DIR}/front-proxy-ca.key -subj "/CN=front-proxy-ca" -days 1095 -out ${PKI_DIR}/front-proxy-ca.crt

openssl genrsa -out ${ETCD_DIR}/ca.key 2048
openssl req -x509 -new -nodes -key ${ETCD_DIR}/ca.key -subj "/CN=etcd-ca" -days 1095 -out ${ETCD_DIR}/ca.crt

openssl genrsa -out ${PKI_DIR}/sa.key 2048
openssl rsa -in ${PKI_DIR}/sa.key -pubout -out ${PKI_DIR}/sa.pub

NORMAL_CERTS=(
  "apiserver-etcd-client"
  "apiserver-kubelet-client"
  "front-proxy-client"
)

for cert in "${NORMAL_CERTS[@]}"; do
  dir=$(dirname "$cert")
  [ "$dir" != "." ] && mkdir -p "$PKI_DIR/$dir"
  openssl genrsa -out ${PKI_DIR}/${cert}.key 2048
  openssl req -new -key ${PKI_DIR}/${cert}.key -subj "/CN=${cert}" -out ${PKI_DIR}/${cert}.csr
  openssl x509 -req -in ${PKI_DIR}/${cert}.csr \
    -CA ${PKI_DIR}/ca.crt -CAkey ${PKI_DIR}/ca.key -CAcreateserial \
    -out ${PKI_DIR}/${cert}.crt -days 365 -sha256
  rm -f ${PKI_DIR}/${cert}.csr
done

openssl genrsa -out ${PKI_DIR}/front-proxy-client.key 2048
openssl req -new -key ${PKI_DIR}/front-proxy-client.key -subj "/CN=front-proxy-client" -out ${PKI_DIR}/front-proxy-client.csr
openssl x509 -req -in ${PKI_DIR}/front-proxy-client.csr \
  -CA ${PKI_DIR}/front-proxy-ca.crt -CAkey ${PKI_DIR}/front-proxy-ca.key -CAcreateserial \
  -out ${PKI_DIR}/front-proxy-client.crt -days 365 -sha256
rm -f ${PKI_DIR}/front-proxy-client.csr

ETCD_CERTS=(peer healthcheck-client)
for cert in "${ETCD_CERTS[@]}"; do
  openssl genrsa -out ${ETCD_DIR}/${cert}.key 2048
  openssl req -new -key ${ETCD_DIR}/${cert}.key -subj "/CN=${cert}" -out ${ETCD_DIR}/${cert}.csr
  openssl x509 -req -in ${ETCD_DIR}/${cert}.csr \
    -CA ${ETCD_DIR}/ca.crt -CAkey ${ETCD_DIR}/ca.key -CAcreateserial \
    -out ${ETCD_DIR}/${cert}.crt -days 365 -sha256
  rm -f ${ETCD_DIR}/${cert}.csr
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
  if [[ "$cert" == etcd/* ]]; then
    openssl x509 -req -in ${PKI_DIR}/${cert}.csr \
      -CA ${ETCD_DIR}/ca.crt -CAkey ${ETCD_DIR}/ca.key -CAcreateserial \
      -out ${PKI_DIR}/${cert}.crt -days 1 -sha256
  else
    openssl x509 -req -in ${PKI_DIR}/${cert}.csr \
      -CA ${PKI_DIR}/ca.crt -CAkey ${PKI_DIR}/ca.key -CAcreateserial \
      -out ${PKI_DIR}/${cert}.crt -days 1 -sha256
  fi
  rm -f ${PKI_DIR}/${cert}.csr
done

chown -R root:root ${PKI_DIR}
chmod 600 $(find ${PKI_DIR} -type f -name "*.key") || true
