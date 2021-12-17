#!/bin/bash

kubectl delete -f /home/silvios/git/argocd/charts/common/wasp-base/values.yaml
kubectl delete -f /home/silvios/git/argocd/charts/common/wasp-base/templates/composition-stack-config.yaml
kubectl delete -f /home/silvios/git/argocd/charts/common/wasp-base/crds/stack-config.yaml

sleep 3

kubectl apply -f /home/silvios/git/argocd/charts/common/wasp-base/crds/stack-config.yaml

sleep 2

kubectl apply -f /home/silvios/git/argocd/charts/common/wasp-base/templates/composition-stack-config.yaml
kubectl apply -f /home/silvios/git/argocd/charts/common/wasp-base/values.yaml
