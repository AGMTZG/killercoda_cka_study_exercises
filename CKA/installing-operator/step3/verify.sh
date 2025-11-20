#!/bin/bash

# Check if Nginx Pod exists in default namespace
if kubectl get pod nginx -n default &> /dev/null; then
    echo "Nginx Pod exists in default namespace."
else
    echo "Nginx Pod NOT found in default namespace."
    exit 1
fi

# Check if the container port is named nginx
PORT_NAME=$(kubectl get pod nginx -n default -o jsonpath='{.spec.containers[0].ports[0].name}')
if [ "$PORT_NAME" == "nginx" ]; then
    echo "Nginx container port is correctly named nginx"
else
    echo "Nginx container port is not named nginx. Found: $PORT_NAME"
    exit 1
fi

# Check if PodMonitor exists in monitoring namespace
if kubectl get podmonitor nginx-monitor -n monitoring &> /dev/null; then
    echo "PodMonitor nginx-monitor exists in monitoring namespace."
else
    echo "PodMonitor nginx-monitor NOT found in monitoring namespace."
    exit 1
fi

# Verify that PodMonitor targets the 'nginx' Pod
MATCH_LABEL=$(kubectl get podmonitor nginx-monitor -n monitoring -o jsonpath='{.spec.selector.matchLabels.run}')
if [ "$MATCH_LABEL" == "nginx" ]; then
    echo "PodMonitor selector correctly targets Pod nginx."
else
    echo "PodMonitor selector does not target Pod nginx. Found: $MATCH_LABEL"
    exit 1
fi
