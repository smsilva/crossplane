#!/bin/bash
STACK_IMAGE="silviosilva/azure-kubernetes-cluster:0.1.0"

stackrun ${STACK_IMAGE} apply -auto-approve

env DEBUG=0 stackrun ${STACK_IMAGE} output -raw kubeconfig > "${KUBECONFIG?}"

chmod 0600 "${KUBECONFIG?}"
