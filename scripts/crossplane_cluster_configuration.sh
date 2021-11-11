#!/bin/bash
kubectl apply -f  manifests/cluster/composite-resource-definition.yaml

sleep 2

kubectl apply -f  "manifests/cluster/composition-${OVERCLOUD_TYPE}.yaml"
