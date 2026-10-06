#!/bin/bash
set -euo pipefail

SETUP_MARKER="/tmp/argocd-setup-complete"
STATUS_FILE="/tmp/argocd-setup-status"
APPLICATION_FILE="/tmp/my-app-application.yaml"

# Pin Argo CD to a known stable version for reproducible tutorial runs.
ARGOCD_VERSION="v3.5.3"
ARGOCD_MANIFEST_URL="https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

rm -f "$SETUP_MARKER"
rm -f "$APPLICATION_FILE"

# Write the current setup status for the foreground terminal.
set_status() {
  printf '%s\n' "$1" > "$STATUS_FILE"
}

set_status "Waiting for the Kubernetes cluster..."

# Wait until all Kubernetes nodes are Ready.
# kubectl wait is preferred over parsing the human-readable kubectl output.
until kubectl wait \
  --for=condition=Ready \
  nodes \
  --all \
  --timeout=10s \
  >/dev/null 2>&1
do
  sleep 2
done

set_status "Creating the Argo CD namespace..."

# Create the Argo CD namespace.
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -

set_status "Installing Argo CD ${ARGOCD_VERSION}..."

# Install a pinned Argo CD version.
kubectl apply --server-side --force-conflicts \
  -n argocd \
  -f "$ARGOCD_MANIFEST_URL"

set_status "Configuring Argo CD..."

# Configure Argo CD for the Killercoda HTTP endpoint
# and use a short self-healing backoff for the demo.
kubectl patch configmap argocd-cmd-params-cm \
  -n argocd \
  --type merge \
  -p '{
    "data": {
      "server.insecure": "true",
      "controller.self.heal.backoff.timeout.seconds": "20",
      "controller.self.heal.backoff.factor": "2",
      "controller.self.heal.backoff.cap.seconds": "30"
    }
  }'

set_status "Restarting the Argo CD server..."

# Restart the Argo CD server so the HTTP setting is applied.
kubectl rollout restart deployment/argocd-server -n argocd
kubectl rollout status deployment/argocd-server \
  -n argocd \
  --timeout=120s

set_status "Restarting the Argo CD application controller..."

# Restart the application controller so the self-healing settings are applied.
kubectl rollout restart statefulset/argocd-application-controller -n argocd
kubectl rollout status statefulset/argocd-application-controller \
  -n argocd \
  --timeout=120s

set_status "Waiting for the Argo CD admin credentials..."

# Wait for the initial admin password.
until kubectl get secret argocd-initial-admin-secret \
  -n argocd >/dev/null 2>&1
do
  sleep 2
done

set_status "Preparing the GitOps application manifest..."

# Download the Argo CD Application manifest directly from GitHub.
# This keeps the tutorial independent from Killercoda asset copying.
curl -fsSL \
  https://raw.githubusercontent.com/s-riviere/kth-devops-tutorial/main/gitops-argocd/gitops/application.yaml \
  -o "$APPLICATION_FILE"

test -s "$APPLICATION_FILE"

set_status "Starting the Argo CD web endpoint..."

# Start the Argo CD web endpoint.
nohup kubectl port-forward \
  --address 0.0.0.0 \
  svc/argocd-server \
  -n argocd \
  8080:80 \
  >/tmp/argocd-port-forward.log 2>&1 </dev/null &

set_status "Waiting for the Argo CD web endpoint..."

# Wait until the HTTP endpoint is responding.
until curl -fsS \
  http://127.0.0.1:8080/api/version >/dev/null 2>&1
do
  sleep 2
done

set_status "Argo CD is ready."

# Signal that the environment is completely ready.
touch "$SETUP_MARKER"
