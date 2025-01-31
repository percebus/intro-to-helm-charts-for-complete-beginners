#!/bin/bash

set +e
set -x

bash scripts/helm/repo/add.ba.sh
bash scripts/helm/plugin/install.ba.sh

set +x
set +e
