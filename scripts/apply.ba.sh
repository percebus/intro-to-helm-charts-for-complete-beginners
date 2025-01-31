
set -e

release_name=${1}

set -x

bash scripts/helm/install.ba.sh ${release_name}
bash scripts/helm/status/show.ba.sh ${release_name}
bash scripts/helm/history/list.ba.sh ${release_name}

bash scripts/kubectl/get.ba.sh

set +x
set +v
