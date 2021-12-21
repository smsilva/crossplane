#!/bin/bash

if kubectl get namespace crossplane-system &> /dev/null; then
  echo "Crossplane is already installed. I'll try to Apply the Configuration again."
fi

CROSSPLANE_VERSION="1.5.1"

if ! grep --quiet crossplane-stable <<< "$(helm repo list)"; then
  echo "Adding Crosplane Stable Helm Chart"
  helm repo add crossplane-stable https://charts.crossplane.io/stable
  helm repo update
else
  helm repo list | grep -E "NAME|crossplane-stable"
fi

helm install crossplane \
  --create-namespace \
  --namespace crossplane-system \
  --version "${CROSSPLANE_VERSION?}" \
  crossplane-stable/crossplane && \
kubectl \
  wait deployment \
  --namespace crossplane-system \
  --selector release=crossplane \
  --for condition=Available \
  --timeout=360s

if ! which kubectl-crossplane &> /dev/null; then
  curl -sL https://raw.githubusercontent.com/crossplane/crossplane/master/install.sh | sh
fi

kubectl apply -f install/service-accounts.yaml
kubectl apply -f install/cluster-role-binding-admin.yaml
kubectl apply -f install/controller-config.yaml
kubectl apply -f install/providers.yaml && sleep 5
kubectl apply -f install/provider-config.yaml

kubectl \
  --namespace crossplane-system \
  get pod -o name | xargs -n 1 -I {} kubectl \
    --namespace crossplane-system \
    wait pod {} \
    --for condition=Ready \
    --timeout=360s

kubectl get namespaces
echo ""

kubectl --namespace crossplane-system get pods
echo ""

kubectl api-resources | grep crossplane
echo ""
