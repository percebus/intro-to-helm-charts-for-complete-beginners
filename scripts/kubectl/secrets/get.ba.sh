#!/bin/bash

set -e
set -x

kubectl get secrets -n helm-experiments

set +x
set +e
