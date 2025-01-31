#!/bin/bash

set -e
set -x

kubectl get service \
  --namespace helm-experiments

set +x
set +e
