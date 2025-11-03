#!/bin/bash
if kubectl get role alice-developer -n projectx &>/dev/null; then
  echo "Role 'alice-developer' successfully created in namespace projectx."
  exit 0
else
  echo "Role not found. Please create it with the correct verbs and namespace."
  exit 1
fi

if kubectl get rolebinding alice-developer-binding -n projectx &>/dev/null; then
  echo "RoleBinding 'alice-developer-binding' successfully created in namespace projectx."
  exit 0
else
  echo "RoleBinding not found. Please create it and bind it to the user 'alice' and the role 'alice-developer'."
  exit 1
fi
