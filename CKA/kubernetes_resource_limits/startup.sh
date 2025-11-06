#!/bin/bash
set -e

envsubst < ~/deploy.yaml | kubectl apply -f -
