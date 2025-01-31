#!/bin/bash

set -e
set -x

helmfile apply

set +x
set +e
