#!/bin/bash
echo "Installing Helm Release using Crossplane Helm Provider"

kubectl apply -f manifests/examples/provider-helm/argocd.yaml

kubectl wait Release argocd \
  --for condition=Ready \
  --timeout 360s

for deploymentName in $(kubectl \
  --namespace argocd get deploy \
  --output name); do
  echo "Waiting for: ${deploymentName}"

  kubectl \
    --namespace argocd \
    wait \
    --for condition=Available \
    --timeout=360s \
    "${deploymentName}";
done
