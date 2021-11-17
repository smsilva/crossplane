#!/bin/bash
kubectl apply -f manifests/examples/provider-helm/argocd.yaml

for deploymentName in $(kubectl -n argocd get deploy -o name); do
   echo "Waiting for: ${deploymentName}"

   kubectl \
     --namespace argocd \
     wait \
     --for condition=Available \
     --timeout=360s \
     "${deploymentName}";
done
