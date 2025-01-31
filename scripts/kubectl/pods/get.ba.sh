#!/bin/bash

set -x
set -v

kubectl get pods \
  --namespace helm-experiments

set +v
set +x
