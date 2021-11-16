#!/bin/bash
show_line() {
  MESSAGE=${1}
  OUTPUT=${2}

  echo "${MESSAGE}:"
  echo ""
  (bash -c "${OUTPUT}" 2>&1) | awk '{ print "  " $0 }'
  echo ""
}

show_line "Clusters (XRD)"                "kubectl get Cluster --show-labels"
show_line "Cluster Events"                "kubectl describe Cluster | grep 'Events:' -A 20"
show_line "Crossplane Kubernetes Objects" "kubectl get Objects"
#show_line "Object Events"                 "kubectl describe Objects | grep 'Events:' -A 20"
show_line "Secrets"                       "kubectl get Secrets -A | grep -vE '^kube|^local|^default.*-credentials|default-token|provider-|rbac|helm|crossplane-token'"
show_line "Configmaps"                    "kubectl get Configmaps --show-labels | grep -vE '^kube'"
