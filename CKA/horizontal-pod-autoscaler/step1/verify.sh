#!/bin/bash

# Verify script for HPA exercise
# This script checks that the HPA "web-app" exists, is correctly configured, and targets the right Deployment

# Check if HPA exists
if ! kubectl get hpa web-app -n production &>/dev/null; then
  echo "❌ HPA 'web-app' not found in namespace 'production'"
  exit 1
fi

# Check target reference
TARGET=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.scaleTargetRef.name}')
if [ "$TARGET" != "web-app" ]; then
  echo "❌ HPA is not targeting the correct Deployment ('web-app')"
  exit 1
fi

# Check min and max replicas
MIN=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.minReplicas}')
MAX=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.maxReplicas}')
if [ "$MIN" != "2" ] || [ "$MAX" != "5" ]; then
  echo "❌ minReplicas or maxReplicas are not correctly configured (expected 2 and 5)"
  exit 1
fi

# Check CPU utilization target
UTIL=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')
if [ "$UTIL" != "60" ]; then
  echo "❌ Target CPU utilization should be 60%"
  exit 1
fi

# Check current replicas within allowed range
CURR=$(kubectl get hpa web-app -n production -o jsonpath='{.status.currentReplicas}')
if [ "$CURR" -lt "$MIN" ] || [ "$CURR" -gt "$MAX" ]; then
  echo "❌ Current replica count ($CURR) is outside the allowed range ($MIN–$MAX)"
  exit 1
fi
