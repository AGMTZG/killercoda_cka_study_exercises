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

not_ready_pods=$(kubectl get pods -n production -l app=web-app --no-headers 2>/dev/null | grep -v "Running" | wc -l)

if [ "$not_ready_pods" -gt 0 ]; then
  echo "Some pods are not in Running state. Please check 'kubectl get pods -n production'"
  exit 1
else
  echo "All web-app pods are running"
fi

quota_name=$(kubectl get quota -n production -o jsonpath='{.items[0].metadata.name}')
if [ -z "$quota_name" ]; then
  echo "No ResourceQuota found in namespace 'production'"
else
  over_quota=$(kubectl describe quota "$quota_name" -n production | grep -E 'Used.*Hard' | awk '{if ($2>$3) print $0}' | wc -l)
  if [ "$over_quota" -gt 0 ]; then
    echo "ResourceQuota exceeded in namespace 'production'"
    kubectl describe quota "$quota_name" -n production
    exit 1
  else
    echo "ResourceQuota limits not surpassed"
  fi
fi
