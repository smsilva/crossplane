#!/bin/bash
clear

THIS_SCRIPT="${0}"
SCRIPTS_DIRECTORY=$(dirname "${THIS_SCRIPT}")
CONFIG_FILE="${SCRIPTS_DIRECTORY}/../config.yaml"

export PATH="${SCRIPTS_DIRECTORY}:${PATH}"

UNDERCLOUD_TYPE=$(yq e .undercloud.type "${CONFIG_FILE?}")
UNDERCLOUD_NAME=$(yq e .undercloud.name "${CONFIG_FILE?}")

env \
  UNDERCLOUD_NAME="${UNDERCLOUD_NAME}" \
  "${SCRIPTS_DIRECTORY?}/${UNDERCLOUD_TYPE?}/undercloud_create.sh"

cloud_secrets_create.sh

crossplane_install.sh

OVERCLOUD_TYPE=$(yq e .overcloud.type "${CONFIG_FILE?}")
OVERCLOUD_NAME=$(yq e .overcloud.name "${CONFIG_FILE?}")

env \
  OVERCLOUD_TYPE="${OVERCLOUD_TYPE}" \
  OVERCLOUD_NAME="${OVERCLOUD_NAME}" \
  crossplane_cluster_configuration.sh

kubectl apply -f  manifests/cluster/instance.yaml
