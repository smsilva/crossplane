#!/bin/bash
THIS_SCRIPT="${0}"
SCRIPTS_DIRECTORY=$(dirname "${THIS_SCRIPT}")
PATH="${SCRIPTS_DIRECTORY}:${PATH}"

CONFIG_FILE="${SCRIPTS_DIRECTORY}/../config.yaml"
KUBECONFIG="${HOME}/.kube/undercloud"

# Export
export KUBECONFIG
export PATH

# Retrieve Undercloud Information
UNDERCLOUD_TYPE=$(yq e .undercloud.type "${CONFIG_FILE?}")
UNDERCLOUD_NAME=$(yq e .undercloud.name "${CONFIG_FILE?}")

# Stop on any error
set -e

# Undercloud Creation: Bootstrap Crossplane Cluster
env \
  KUBECONFIG="${KUBECONFIG}" \
  UNDERCLOUD_NAME="${UNDERCLOUD_NAME}" \
  "${SCRIPTS_DIRECTORY?}/${UNDERCLOUD_TYPE?}/undercloud_create.sh"

# Cloud Credentials Creation
cloud_secrets_create.sh

# Crossplane Installation
# - providers:
#   - azure
#   - google
#   - helm
#   - kubernetes
crossplane_install.sh

# ArgoCD Install using Crossplane Helm Provider
argocd_install.sh

# ArgoCD bootstrap Application Creation
kubectl apply -f https://raw.githubusercontent.com/smsilva/argocd/master/applications/bootstrap.yaml

# Retrieve ArgoCD Initial admin password
argocd_retrieve_initial_admin_password.sh
