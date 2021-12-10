#!/bin/bash
STACK_IMAGE="silviosilva/azure-undercloud:latest"

stackrun ${STACK_IMAGE} apply -auto-approve

env DEBUG=0 stackrun ${STACK_IMAGE} output -raw kubeconfig > "${KUBECONFIG?}"

chmod 0600 "${KUBECONFIG?}"

if ! kubectl get namespaces &> /dev/null; then
  echo "It wasn't possible to access undercloud cluster."
  exit 1
fi
