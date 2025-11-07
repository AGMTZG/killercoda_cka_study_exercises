#!/bin/bash

CSR_NAME="alice-certificate"
STATUS=$(kubectl get csr $CSR_NAME -o jsonpath='{.status.conditions[?(@.type=="Approved")].status}')

if [[ "$STATUS" == "True" ]]; then
  echo "CSR $CSR_NAME has been approved."
else
  echo "CSR $CSR_NAME has not been approved yet."
  exit 1
fi


