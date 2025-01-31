#!/bin/bash

set -x
set -v

kubectl get service \
  --namespace helm-experiments

set +v
set +x
