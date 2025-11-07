#!/bin/bash

if ! kubectl get hpa web-app -n production &>/dev/null; then
  echo "HPA 'web-app' not found in namespace 'production'"
  exit 1
fi

min_replicas=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.minReplicas}')
max_replicas=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.maxReplicas}')

if [ "$min_replicas" != "2" ] || [ "$max_replicas" != "5" ]; then
  echo "Expected minReplicas=2 and maxReplicas=5, found min=$min_replicas, max=$max_replicas"
  exit 1
else
  echo "Replica range is correctly set (2–5)"
fi

cpu_target=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.metrics[0].resource.target.averageUtilization}')

if [ "$cpu_target" != "60" ]; then
  echo "Expected target average CPU utilization = 60%, found $cpu_target%"
  exit 1
else
  echo "Target CPU utilization is correctly set to 60%"
fi

scale_up_limit=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.behavior.scaleUp.policies[0].value}')
scale_up_period=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.behavior.scaleUp.policies[0].periodSeconds}')
scale_down_limit=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.behavior.scaleDown.policies[0].value}')
scale_down_period=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.behavior.scaleDown.policies[0].periodSeconds}')
scale_down_stabilization=$(kubectl get hpa web-app -n production -o jsonpath='{.spec.behavior.scaleDown.stabilizationWindowSeconds}')

if [ "$scale_up_limit" != "1" ] || [ "$scale_up_period" != "30" ]; then
  echo "Scale-up policy incorrect (expected +1 every 30s)"
  exit 1
elif [ "$scale_down_limit" != "1" ] || [ "$scale_down_period" != "60" ]; then
  echo "Scale-down policy incorrect (expected -1 every 60s)"
  exit 1
elif [ "$scale_down_stabilization" != "120" ]; then
  echo "Stabilization window incorrect (expected 120s)"
  exit 1
else
  echo "Scaling behavior correctly configured (up: +1/30s, down: -1/60s, stabilize: 120s)"
fi
