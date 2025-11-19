#!/bin/bash

CLASS="nginx"

STATUS=$(kubectl get gatewayclass $CLASS -o jsonpath='{.status.conditions[?(@.type=="Accepted")].status}')

if [[ "$STATUS" == "True" ]]; then
  echo "GatewayClass '$CLASS' is accepted."
  exit 0
else
  echo "GatewayClass '$CLASS' is NOT accepted. Current status: $STATUS"
  exit 1
fi
