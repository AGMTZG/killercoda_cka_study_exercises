#!/bin/bash

kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-
kubectl create -f deploy.yaml
