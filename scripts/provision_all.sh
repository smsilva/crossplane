#!/bin/bash
clear

CURRENT_DIRECTORY=$(pwd)
THIS_SCRIPT="${0}"

SCRIPTS_DIRECTORY=$(dirname "${THIS_SCRIPT}")

export PATH="${SCRIPTS_DIRECTORY}:${PATH}"

UNDERCLOUD_TYPE=$(yq e .undercloud.type config.yaml)
UNDERCLOUD_NAME=$(yq e .undercloud.name config.yaml)

echo "CURRENT_DIRECTORY.: ${CURRENT_DIRECTORY}"
echo "THIS_SCRIPT.......: ${THIS_SCRIPT}"
echo "SCRIPTS_DIRECTORY.: ${SCRIPTS_DIRECTORY}"
echo "UNDERCLOUD_TYPE...: ${UNDERCLOUD_TYPE}"
echo "UNDERCLOUD_NAME...: ${UNDERCLOUD_NAME}"

"${SCRIPTS_DIRECTORY?}/${UNDERCLOUD_TYPE?}/undercloud_create.sh"
