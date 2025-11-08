#!/bin/sh

NAMESPACE="appenv"
ROLE="deploybot-role"
ROLEBINDING="deploybot-role-binding"
SERVICEACCOUNT="deploybot"

if ! kubectl get role "$ROLE" -n "$NAMESPACE" >/dev/null 2>&1; then
  echo "Role '$ROLE' not found in namespace $NAMESPACE."
  exit 1
fi

for res in deployments replicasets; do
  if ! kubectl get role "$ROLE" -n "$NAMESPACE" -o yaml | grep -q "^\s*-\s*$res"; then
    echo "Role '$ROLE' missing resource '$res'."
    exit 1
  fi
done

for verb in get list create update delete; do
  if ! kubectl get role "$ROLE" -n "$NAMESPACE" -o yaml | grep -q "^\s*-\s*$verb"; then
    echo "Role '$ROLE' missing verb '$verb'."
    exit 1
  fi
done

if ! kubectl get rolebinding "$ROLEBINDING" -n "$NAMESPACE" >/dev/null 2>&1; then
  echo "RoleBinding '$ROLEBINDING' not found in namespace $NAMESPACE."
  exit 1
fi

if ! kubectl get rolebinding "$ROLEBINDING" -n "$NAMESPACE" -o yaml | grep -q "name: $ROLE"; then
  echo "RoleBinding does not reference the correct Role ($ROLE)."
  exit 1
fi

if ! kubectl get rolebinding "$ROLEBINDING" -n "$NAMESPACE" -o yaml | grep -q "name: $SERVICEACCOUNT"; then
  echo "RoleBinding does not reference the correct ServiceAccount ($SERVICEACCOUNT)."
  exit 1
fi
