#!/bin/bash

set -x
set -v

kubectl get secrets -n helm-experiments

set +v
set +x
