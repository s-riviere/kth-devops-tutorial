#!/bin/bash
set -e

kubectl get service my-app-service >/dev/null

replicas="$(kubectl get deployment my-app -o jsonpath='{.spec.replicas}')"
test "$replicas" = "2"

kubectl wait --for=jsonpath='{.status.sync.status}'=Synced application/my-app -n argocd --timeout=30s >/dev/null
kubectl wait --for=jsonpath='{.status.health.status}'=Healthy application/my-app -n argocd --timeout=30s >/dev/null
