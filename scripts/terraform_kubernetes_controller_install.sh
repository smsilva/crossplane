#!/bin/bash
helm repo add --force-update terraform-controller https://smsilva.github.io/helm

helm repo update

helm install terraform-controller \
  terraform-controller/terraform-controller && \

kubectl wait \
  deployment terraform-controller \
  --for condition=Available \
  --timeout=360s

echo "kubectl logs \\
  --follow \\
  --selector app=terraform-controller"
