#!/bin/bash
set -e

# Verify ClusterRole
if ! kubectl get clusterrole prometheus &> /dev/null; then
  echo "ClusterRole 'prometheus' not found."
  exit 1
fi

# Verify ServiceAccount
if ! kubectl get sa prometheus -n monitoring &> /dev/null; then
  echo "ServiceAccount 'prometheus' not found in namespace 'monitoring'."
  exit 1
fi

# Verify ClusterRoleBinding
if ! kubectl get clusterrolebinding prometheus &> /dev/null; then
  echo "ClusterRoleBinding 'prometheus' not found."
  exit 1
fi
