#!/bin/bash
BASE64ENCODED_ID_RSA=$(cat ${HOME}/.ssh/id_rsa | base64 | tr -d "\n") && \
kubectl apply -f - <<EOF
---
apiVersion: v1
kind: Secret
metadata:
  name: argocd-ssh-auth
  namespace: argocd
type: kubernetes.io/ssh-auth
data:
  ssh-privatekey: |
    ${BASE64ENCODED_ID_RSA}
EOF
