#!/bin/bash
set -euo pipefail

SETUP_MARKER="/tmp/argocd-setup-complete"
APPLICATION_FILE="/tmp/my-app-application.yaml"

rm -f "$SETUP_MARKER"
rm -f "$APPLICATION_FILE"

# Wait until the Kubernetes cluster is ready.
until kubectl get nodes --no-headers 2>/dev/null \
  | awk '$2 == "Ready" {found=1} END {exit(found ? 0 : 1)}'
do
  sleep 2
done

# Create the Argo CD namespace.
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

# Install Argo CD.
kubectl apply --server-side --force-conflicts \
  -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for the Argo CD server.
kubectl wait --for=condition=Available \
  deployment/argocd-server \
  -n argocd \
  --timeout=180s

# Configure Argo CD for the Killercoda HTTP endpoint
# and use a short self-healing backoff for the demo.
kubectl patch configmap argocd-cmd-params-cm \
  -n argocd \
  --type merge \
  -p '{"data":{"server.insecure":"true","controller.self.heal.backoff.timeout.seconds":"2","controller.self.heal.backoff.factor":"2","controller.self.heal.backoff.cap.seconds":"15"}}'

# Restart the Argo CD server so the HTTP setting is applied.
kubectl rollout restart deployment/argocd-server -n argocd
kubectl rollout status deployment/argocd-server \
  -n argocd \
  --timeout=120s

# Restart the application controller so the self-healing settings are applied.
kubectl rollout restart statefulset/argocd-application-controller -n argocd
kubectl rollout status statefulset/argocd-application-controller \
  -n argocd \
  --timeout=120s

# Wait for the initial admin password.
until kubectl get secret argocd-initial-admin-secret \
  -n argocd >/dev/null 2>&1
do
  sleep 2
done

# Download the Argo CD Application manifest directly from GitHub.
# This keeps the tutorial independent from Killercoda asset copying.
curl -fsSL \
  https://raw.githubusercontent.com/s-riviere/kth-devops-tutorial/main/gitops-argocd/gitops/application.yaml \
  -o "$APPLICATION_FILE"

test -s "$APPLICATION_FILE"

# Start the Argo CD web endpoint.
nohup kubectl port-forward \
  --address 0.0.0.0 \
  svc/argocd-server \
  -n argocd \
  8080:80 \
  >/tmp/argocd-port-forward.log 2>&1 </dev/null &

# Wait until the HTTP endpoint is responding.
until curl -fsS \
  http://127.0.0.1:8080/api/version >/dev/null 2>&1
do
  sleep 2
done

# Signal that the environment is completely ready.
touch "$SETUP_MARKER"
