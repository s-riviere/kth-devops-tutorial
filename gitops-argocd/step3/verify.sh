#!/bin/bash
set -e

kubectl get application my-app -n argocd >/dev/null
kubectl wait --for=jsonpath='{.status.sync.status}'=Synced application/my-app -n argocd --timeout=120s >/dev/null
kubectl get deployment my-app >/dev/null
kubectl get service my-app-service >/dev/null

replicas="$(kubectl get deployment my-app -o jsonpath='{.spec.replicas}')"
test "$replicas" = "2"
