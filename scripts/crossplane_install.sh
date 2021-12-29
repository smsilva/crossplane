#!/bin/bash
helm repo add \
  --force-update crossplane-stable https://charts.crossplane.io/stable

helm repo update

helm install crossplane \
  --create-namespace \
  --namespace crossplane-system \
  --wait \
  crossplane-stable/crossplane

kubectl apply -f install/service-accounts.yaml
kubectl apply -f install/cluster-role-binding-admin.yaml
kubectl apply -f install/controller-config.yaml
kubectl apply -f install/providers.yaml && sleep 15
kubectl apply -f install/provider-config.yaml

kubectl \
  --namespace crossplane-system \
  get pod -o jsonpath="{range .items[*]}{.metadata.name}{'\n'}{end}" | xargs -n 1 -I {} kubectl \
    --namespace crossplane-system \
    wait pod {} \
    --for condition=Ready \
    --timeout=360s
