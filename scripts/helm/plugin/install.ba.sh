#!/bin/bash

set -e
set -x

helm plugin install https://github.com/databus23/helm-diff

set +x
set +e
