#!/bin/bash

if helm list --short | grep -q "my-nginx-release"; then
  echo "The Helm release 'my-nginx-release' still exists. Cleanup incomplete."
  exit 1
else
  echo "Helm release successfully removed."
fi

if kubectl get all -l app.kubernetes.io/instance=my-nginx-release --no-headers 2>/dev/null | grep -q .; then
  echo "Some Kubernetes resources associated with 'my-nginx-release' are still present."
  kubectl get all -l app.kubernetes.io/instance=my-nginx-release
  exit 1
else
  echo "All Kubernetes resources associated with 'my-nginx-release' have been removed."
fi

if [ -d "/opt/helm/nginx" ]; then
  echo "The directory /opt/helm/nginx still exists. Consider removing it manually."
else
  echo "The directory /opt/helm/nginx has been removed or is not present."
fi
