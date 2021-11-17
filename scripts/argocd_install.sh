#!/bin/bash
kubectl apply -f manifests/examples/provider-helm/argocd.yaml

kubectl wait Release argocd \
  --for condition=Ready \
  --timeout 360s

for deploymentName in $(kubectl -n argocd get deploy -o name); do
   echo "Waiting for: ${deploymentName}"

   kubectl \
     --namespace argocd \
     wait \
     --for condition=Available \
     --timeout=360s \
     "${deploymentName}";
done

ARGOCD_INITIAL_PASSWORD=$(kubectl \
  --namespace argocd \
  get secret argocd-initial-admin-secret \
  --output jsonpath="{.data.password}" | base64 -d)

echo ""
echo "  1. Open a new Terminal and run a port-forward command:"
echo ""
echo "    kubectl --namespace argocd port-forward svc/argocd-server 8080:443"
echo ""
echo "  2. Copy the Password for admin user:"
echo ""
echo "    ${ARGOCD_INITIAL_PASSWORD}"
echo ""
echo "  3. Open the addres bellow in a browser:"
echo ""
echo "    https://localhost:8080"
echo ""

kubectl apply -f https://raw.githubusercontent.com/smsilva/argocd/master/applications/bootstrap.yaml
