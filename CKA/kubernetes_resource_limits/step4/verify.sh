#!/bin/bash

DEPLOY_STATUS=$(kubectl get deployment heavy-deployment -o jsonpath='{.status.readyReplicas}')

if [ "$DEPLOY_STATUS" == "3" ]; then
  echo "All 3 Pods of 'heavy-deployment' are running."
  exit 0
else
  echo "Not all Pods are running yet. Current ready replicas: $DEPLOY_STATUS"
  echo "Check pod status with: kubectl get pods -l app=heavy-deployment"
  exit 1
fi
