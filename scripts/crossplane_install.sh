#!/bin/bash

configure() {
  kubectl apply -f provider/controller-config-debug.yaml

  kubectl apply -f provider/provider.yaml && \
  kubectl wait Provider provider-kubernetes \
    --for=condition=Healthy \
    --timeout=120s && \
  kubectl wait Provider provider-gcp \
    --for=condition=Healthy \
    --timeout=120s

CROSSPLANE_KUBERNETES_PROVIDER_SERVICE_ACCOUNT=$(kubectl \
  --namespace crossplane-system \
  get serviceaccount \
  --output name | grep provider-kubernetes | sed -e 's|serviceaccount\/||g') && \
echo "${CROSSPLANE_KUBERNETES_PROVIDER_SERVICE_ACCOUNT?}" && \
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: provider-kubernetes-admin-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: ${CROSSPLANE_KUBERNETES_PROVIDER_SERVICE_ACCOUNT?}
  namespace: crossplane-system
EOF

kubectl apply -f provider/config/provider-config.yaml

kubectl get pods --namespace crossplane-system
}

if kubectl get pods --namespace crossplane-system > /dev/null; then
  echo "Crossplane is already installed"
  configure
  exit 0
fi

CROSSPLANE_VERSION="1.4.1"

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

kubectl crossplane --version                   && echo ""
kubectl get namespaces                         && echo ""
kubectl get pods --namespace crossplane-system && echo ""
kubectl api-resources | grep crossplane

configure
