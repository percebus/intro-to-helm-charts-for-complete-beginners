#!/bin/bash

set -e
set -x

kubectl get secrets --all-namespaces

set +x
set +e
