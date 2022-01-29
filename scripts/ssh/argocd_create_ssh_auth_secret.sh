#!/bin/bash
URL_GIT_REPOSITORY="git@github.com:smsilva/argocd.git"
BASE64ENCODED_URL_GIT_REPOSITORY=$(echo ${URL_GIT_REPOSITORY} | base64)
BASE64ENCODED_ID_RSA=$(cat ${HOME}/.ssh/id_rsa | base64 | tr -d "\n")

kubectl apply -f - <<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: argocd
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
---
apiVersion: v1
kind: Secret
metadata:
  name: argocd-repo-github-smsilva-argocd-creds
  namespace: argocd
  annotations:
    managed-by: argocd.argoproj.io
  labels:
    argocd.argoproj.io/secret-type: repo-creds
type: Opaque
data:
  sshPrivateKey: ${BASE64ENCODED_ID_RSA}
  url: ${BASE64ENCODED_URL_GIT_REPOSITORY}
EOF
