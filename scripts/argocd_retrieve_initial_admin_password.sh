#!/bin/bash
ARGOCD_INITIAL_PASSWORD=$(kubectl \
  --namespace argocd \
  get secret argocd-initial-admin-secret \
  --output jsonpath="{.data.password}" | base64 -d)

LOCAL_ARGOCD_INITIAL_PASSWORD_FILE="${HOME}/.argocd-password.txt"

echo "${ARGOCD_INITIAL_PASSWORD}" > "${LOCAL_ARGOCD_INITIAL_PASSWORD_FILE}"

(
echo ""
echo "  1. Open a new Terminal and run a port-forward command:"
echo ""
echo "     env KUBECONFIG=~/.kube/undercloud kubectl --namespace argocd port-forward svc/argocd-server 8080:443"
echo ""
echo "  2. Copy the Password for admin user:"
echo ""
echo "     ${LOCAL_ARGOCD_INITIAL_PASSWORD_FILE}:"
echo ""
echo "     ${ARGOCD_INITIAL_PASSWORD}"
echo ""
echo "  3. Open the addres bellow in a browser:"
echo ""
echo "     https://localhost:8080"
echo ""
)
