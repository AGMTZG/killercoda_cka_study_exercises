#!/bin/bash

if free | awk '/Swap/ {exit !$2}'; then
    echo "Swap still enabled"
    exit 1
else
    echo "Swap disabled"
fi
