#!/bin/bash
helm repo add \
  --force-update terraform-controller https://smsilva.github.io/helm

helm repo update

helm search repo terraform-controller

helm list

helm install terraform-controller \
  --set secrets.azurerm.namespace="default" \
  --set secrets.azurerm.data.clientId="${ARM_CLIENT_ID}" \
  --set secrets.azurerm.data.clientSecret="${ARM_CLIENT_SECRET}" \
  terraform-controller/terraform-controller

kubectl wait \
  deployment terraform-controller \
  --for condition=Available \
  --timeout=360s

echo "kubectl logs \\
  --follow \\
  --selector app=terraform-controller"
