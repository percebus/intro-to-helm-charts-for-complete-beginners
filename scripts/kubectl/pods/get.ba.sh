#!/bin/bash

set -e
set -x

kubectl get pods \
  --namespace helm-experiments

set +x
set +e
