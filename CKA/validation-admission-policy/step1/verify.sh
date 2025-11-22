#!/bin/bash

# Verify that kube-apiserver pods are running
APISERVER_PODS=$(kubectl get pods -n kube-system -l component=kube-apiserver -o jsonpath='{.items[*].metadata.name}')

if [ -z "$APISERVER_PODS" ]; then
  echo "No kube-apiserver pods found in kube-system namespace."
  exit 1
else
  echo "kube-apiserver pods found: $APISERVER_PODS"
fi

# Check if the feature gate is enabled (optional, mostly for older versions)
FEATURE_GATE=$(ps -ef | grep kube-apiserver | grep -o "ValidatingAdmissionPolicy=true" || true)

if [ -n "$FEATURE_GATE" ]; then
  echo "ValidatingAdmissionPolicy feature gate is enabled."
else
  echo "Feature gate not explicitly set. In recent Kubernetes versions, it is enabled by default."
fi

echo "Step 1 verification complete."
