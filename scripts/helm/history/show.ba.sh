#!/bin/bash

set -e

release_name=${1}

errors=0
if [ -z "${release_name}" ]; then
  echo "ERROR: Missing release name"
  errors=1
fi

if [ ${errors} -eq 1 ]; then
  echo "Found ${errors} errors, exiting..."
  exit 1
fi

set -x

helm history ${release_name} \
  --namespace helm-experiments

set +x
set +e
