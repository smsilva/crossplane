#!/bin/bash
THIS_SCRIPT="${0}"
SCRIPTS_DIRECTORY=$(dirname "${THIS_SCRIPT}")
CONFIG_FILE="${SCRIPTS_DIRECTORY}/../config.yaml"

export KUBECONFIG="${HOME}/.kube/undercloud"
export PATH="${SCRIPTS_DIRECTORY}:${PATH}"

UNDERCLOUD_TYPE=$(yq e .undercloud.type "${CONFIG_FILE?}")
UNDERCLOUD_NAME=$(yq e .undercloud.name "${CONFIG_FILE?}")

env \
  KUBECONFIG="${KUBECONFIG}" \
  UNDERCLOUD_NAME="${UNDERCLOUD_NAME}" \
  "${SCRIPTS_DIRECTORY?}/${UNDERCLOUD_TYPE?}/undercloud_create.sh"

cloud_secrets_create.sh

crossplane_install.sh

argocd_install.sh
