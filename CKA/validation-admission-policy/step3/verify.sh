#!/bin/bash

# Checking if ValidatingAdmissionPolicyBinding exists...
if ! kubectl get validatingadmissionpolicybindings | grep -q require-basic-labels-binding; then
  echo "Error: ValidatingAdmissionPolicyBinding 'require-basic-labels-binding' not found!"
  exit 1
else
  echo "ValidatingAdmissionPolicyBinding 'require-basic-labels-binding' exists."
fi

# Testing valid Pod in 'dev' namespace...
if ! kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: valid-pod-dev
  namespace: dev
  labels:
    owner: mercury
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:1.26
EOF
then
  echo "Pod was accepted "
else
  echo "ERROR: Pod was rejected"
  exit 1
fi

# Invalid pod in 'dev', no 'owner'
if ! kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: invalid-pod-no-owner
  namespace: dev
  labels:
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:1.26
EOF
then
  echo "Invalid Pod rejected as expected"
else
  echo "ERROR: Pod was accepted but should have been rejected"
  exit 1
fi

# Testing invalid Pod with mismatched env label...
if ! kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: invalid-pod-env
  namespace: staging
  labels:
    owner: saturn
    env: dev
spec:
  containers:
  - name: nginx
    image: nginx:1.26
EOF
then
  echo "Invalid Pod rejected as expected"
else
  echo "ERROR: Pod was accepted but should have been rejected"
  exit 1
fi

echo "Verification complete. Check above outputs for validation messages."
