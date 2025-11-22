#!/bin/bash

# Checking if the ValidatingAdmissionPolicy exists...
if ! kubectl get validatingadmissionpolicies | grep -q require-basic-labels; then
  echo "Error: ValidatingAdmissionPolicy 'require-basic-labels' not found!"
  exit 1
else
  echo "ValidatingAdmissionPolicy 'require-basic-labels' exists."
fi

# Checking syntax of the ValidatingAdmissionPolicy
if ! kubectl explain ValidatingAdmissionPolicy --recursive | grep -A 5 validations >/dev/null; then
  echo "Error: Could not retrieve validations syntax for 'require-basic-labels'."
  exit 1
else
  echo "Validations syntax appears correct."
fi
