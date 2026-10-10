#!/bin/bash
set -euo pipefail

# ==============================================================================
# CONFIGURATION & VARIABLES
# ==============================================================================

SETUP_MARKER="/tmp/argocd-setup-complete"
STATUS_FILE="/tmp/argocd-setup-status"

# Pin Argo CD to a known stable version for reproducible tutorial runs.
ARGOCD_VERSION="v3.5.3"
ARGOCD_MANIFEST_URL="https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

GIT_REPO="my-app-git"
SOURCE_URL="https://github.com/s-riviere/kth-devops-tutorial.git"
GIT_DAEMON_PID_FILE="/tmp/gitops-git-daemon.pid"
GIT_DAEMON_LOG="/tmp/gitops-git-daemon.log"

# Write the current setup status for the foreground terminal.
set_status() {
  printf '%s\n' "$1" > "$STATUS_FILE"
}


# ==============================================================================
# 1. KUBERNETES & ARGOCD INSTALLATION
# ==============================================================================

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


# ==============================================================================
# 2. ARGOCD CONFIGURATION & COMPONENTS RESTART
# ==============================================================================

set_status "Configuring Argo CD..."

# Configure the Argo CD HTTP endpoint and self-healing backoff.
kubectl patch configmap argocd-cmd-params-cm \
  -n argocd \
  --type merge \
  -p '{
    "data": {
      "server.insecure": "true",
      "controller.self.heal.backoff.cap.seconds": "5"
    }
  }'

# Configure a 5-second reconciliation interval without jitter.
kubectl patch configmap argocd-cm \
  -n argocd \
  --type merge \
  -p '{
    "data": {
      "timeout.reconciliation": "5s",
      "timeout.reconciliation.jitter": "0s"
    }
  }'

set_status "Restarting the Argo CD server..."

# Apply the HTTP server configuration.
kubectl rollout restart deployment/argocd-server -n argocd
kubectl rollout status deployment/argocd-server \
  -n argocd \
  --timeout=120s

set_status "Restarting the Argo CD application controller..."

# Apply the controller configuration.
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


# ==============================================================================
# 3. LOCAL GIT REPOSITORY PREPARATION
# ==============================================================================

set_status "Preparing the local Git repository..."

# Determine the Kubernetes node IP used by the local Git server.
NODE_IP="$(kubectl get nodes \
  -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')"

if [ -z "$NODE_IP" ]; then
  echo "ERROR: Unable to determine the Kubernetes node IP." >&2
  exit 1
fi

GIT_URL="git://${NODE_IP}:9418/${GIT_REPO}"

# Clone the source repository into a temporary directory.
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

git clone --depth 1 "$SOURCE_URL" "$TEMP_DIR/source"

# Create the local Git repository.
mkdir -p "$HOME/$GIT_REPO"
cd "$HOME/$GIT_REPO"

cp -a "$TEMP_DIR/source/gitops-argocd/gitops/." .

git init -b main

git config user.name "Killercoda GitOps"
git config user.email "gitops@localhost"

# Configure the application to use the local repository.
sed -i -E \
  -e "s|^([[:space:]]*repoURL:).*|\1 ${GIT_URL}|" \
  -e 's|^([[:space:]]*targetRevision:).*|\1 main|' \
  -e 's|^([[:space:]]*path:).*|\1 app|' \
  "application.yaml"

# Create the initial commit.
git add .
git commit -m "Initialize local Git repository"

# Remove the temporary clone.
rm -rf "$TEMP_DIR"
trap - EXIT


# ==============================================================================
# 4. LOCAL GIT SERVER STARTUP
# ==============================================================================

set_status "Starting the local Git server..."

# Start the Git daemon.
nohup git daemon \
  --reuseaddr \
  --base-path=/root \
  --export-all \
  --listen=0.0.0.0 \
  --port=9418 \
  /root \
  >"$GIT_DAEMON_LOG" 2>&1 </dev/null &

echo "$!" > "$GIT_DAEMON_PID_FILE"

# Wait for the Git server to serve the repository.
GIT_READY=0

for _ in $(seq 1 30); do
  if git ls-remote "$GIT_URL" >/dev/null 2>&1; then
    GIT_READY=1
    break
  fi
  sleep 1
done

if [ "$GIT_READY" -ne 1 ]; then
  echo "ERROR: The local Git server did not become available." >&2
  echo "Check $GIT_DAEMON_LOG for details." >&2
  exit 1
fi


# ==============================================================================
# 5. ARGOCD WEB ENDPOINT & FINALIZATION
# ==============================================================================

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
