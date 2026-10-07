#!/bin/bash
set -e

# Verify that the Argo CD application "my-app" exists and is synced and healthy
kubectl get application my-app -n argocd >/dev/null

kubectl wait \
  --for=jsonpath='{.status.sync.status}'=Synced \
  application/my-app \
  -n argocd \
  --timeout=30s >/dev/null

kubectl wait \
  --for=jsonpath='{.status.health.status}'=Healthy \
  application/my-app \
  -n argocd \
  --timeout=30s >/dev/null

# Verify that the deployment and service for "my-app" exist and have the expected number of replicas
kubectl get deployment my-app >/dev/null
kubectl get service my-app-service >/dev/null

replicas="$(kubectl get deployment my-app -o jsonpath='{.spec.replicas}')"
test "$replicas" = "2"
