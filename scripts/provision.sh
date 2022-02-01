#!/bin/bash
THIS_SCRIPT="${0}"
SCRIPTS_DIRECTORY=$(dirname "${THIS_SCRIPT}")
PATH="${SCRIPTS_DIRECTORY}:${PATH}"

CONFIG_FILE="${SCRIPTS_DIRECTORY}/../config.yaml"
KUBECONFIG="${HOME}/.kube/config"

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
#   - helm
#   - kubernetes
crossplane_install.sh

# ArgoCD Install using Crossplane Helm Provider
argocd_install.sh

# ArgoCD Create SSH Secret
argocd_create_ssh_auth_secret.sh

# ARgoCD Update Config Maps
kubectl apply -f manifests/argocd-ssh-auth/argocd_config_maps.yaml

# Retrieve ArgoCD Initial admin password
argocd_retrieve_initial_admin_password.sh

# ArgoCD bootstrap Application Creation
kubectl apply -f https://raw.githubusercontent.com/smsilva/argocd/wasp/applications/undercloud.yaml

echo ""
echo "  4. The bootstrap ArgoCD Application was created using:"
echo ""
echo "    kubectl apply -f https://raw.githubusercontent.com/smsilva/argocd/wasp/applications/undercloud.yaml"
echo ""
