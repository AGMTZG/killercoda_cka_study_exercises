#!/bin/sh

if ! kubectl get role deploybot-role -n appenv >/dev/null 2>&1; then
  echo "Role 'deploybot-role' not found in namespace appenv."
  exit 1
fi

if ! kubectl get role deploybot-role -n appenv -o yaml | grep -q "resources: \[deployments, replicasets\]"; then
  echo "Role 'deploybot-role' found but missing required resources (deployments, replicasets)."
  exit 1
fi

if ! kubectl get role deploybot-role -n appenv -o yaml | grep -q "verbs: \[get, list, create, update, delete\]"; then
  echo "Role 'deploybot-role' found but missing one or more required verbs."
  exit 1
fi

if ! kubectl get rolebinding deploybot-role-binding -n appenv >/dev/null 2>&1; then
  echo "RoleBinding 'deploybot-role-binding' not found in namespace appenv."
  exit 1
fi

if ! kubectl get rolebinding deploybot-role-binding -n appenv -o yaml | grep -q "name: deploybot-role"; then
  echo "RoleBinding does not reference the correct Role (deploybot-role)."
  exit 1
fi

if ! kubectl get rolebinding deploybot-role-binding -n appenv -o yaml | grep -q "name: deploybot"; then
  echo "RoleBinding does not reference the correct ServiceAccount (deploybot)."
  exit 1
fi
