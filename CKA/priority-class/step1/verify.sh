#!/bin/bash

if ! kubectl get priorityclass signal-frame &>/dev/null; then
  echo "PriorityClass 'signal-frame' not found."
  exit 1
fi

VALUE=$(kubectl get priorityclass signal-frame -o jsonpath='{.value}')

if [ "$VALUE" -gt 500 ] && [ "$VALUE" -lt 1000 ]; then
  echo "PriorityClass 'signal-frame' exists with a valid value: $VALUE"
else
  echo "PriorityClass 'signal-frame' has an invalid value: $VALUE (expected between 501–999)"
  exit 1
fi
