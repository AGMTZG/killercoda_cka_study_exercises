#!/bin/bash

if ! kubectl get deployment signal-deploy &>/dev/null; then
  echo "Deployment 'signal-deploy' not found."
  exit 1
fi
echo "Deployment 'signal-deploy' exists."

PC_ASSIGNED=$(kubectl get deployment signal-deploy -o jsonpath='{.spec.template.spec.priorityClassName}')
if [[ "$PC_ASSIGNED" == "signal-frame" ]]; then
  echo "PriorityClass correctly set to 'signal-frame'."
else
  echo "Expected PriorityClass 'signal-frame', but found '$PC_ASSIGNED'."
  exit 1
fi

REPLICAS=$(kubectl get deployment signal-deploy -o jsonpath='{.spec.replicas}')
if [[ "$REPLICAS" -eq 3 ]]; then
  echo "Deployment has 3 replicas as expected."
else
  echo "Deployment has $REPLICAS replicas instead of 3."
  exit 1
fi

RUNNING=$(kubectl get pods -l app=signal-deploy --no-headers | grep -c "Running")
if [[ "$RUNNING" -eq 3 ]]; then
  echo "All 3 pods are running."
else
  echo "Pods are not running."
  exit 1
fi

PREEMPTED=$(kubectl get events --all-namespaces --no-headers 2>/dev/null | grep -c "Preempted")
if [[ "$PREEMPTED" -gt 0 ]]; then
  echo "Detected $PREEMPTED preemption event(s). Lower-priority pods were removed to make room for higher-priority workloads."
else
  echo "No preemption events detected."
  exit 1
fi
