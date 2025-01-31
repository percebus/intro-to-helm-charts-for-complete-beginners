#!/bin/bash

set -e
set -x

rm -f helm-experiments-*.tgz

# TODO output to dist/
helm package ./helm

set +x
set +e
