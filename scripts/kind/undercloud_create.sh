#!/bin/bash
THIS_SCRIPT="${0}"
THIS_SCRIPT_DIRECTORY=$(dirname "${THIS_SCRIPT}")

CLUSTER_NAME="${UNDERCLOUD_NAME?}"
CLUSTER_CONFIG_FILE="${THIS_SCRIPT_DIRECTORY}/cluster-config.yaml"

if [ ! -e "${CLUSTER_CONFIG_FILE}" ]; then
  echo "${CLUSTER_CONFIG_FILE} doesn't exists"
  exit 1
fi

if ! which kind > /dev/null; then
  echo "Please install Kind first."
  exit 1
fi

if kind get clusters | grep "${UNDERCLOUD_NAME?}" > /dev/null; then
  printf "Kind Cluster '%s' already exists.\n" "${UNDERCLOUD_NAME?}"
  kubectl config use-context "kind-${UNDERCLOUD_NAME?}"
  exit 1
else
  echo "Creating Kind Cluster [${UNDERCLOUD_NAME?}]"

  kind create cluster \
    --config "${CLUSTER_CONFIG_FILE?}" \
    --name "${CLUSTER_NAME?}"

  for NODE in $(kubectl get nodes --output name); do
    kubectl wait "${NODE}" \
      --for condition=Ready \
      --timeout=360s
  done
fi
