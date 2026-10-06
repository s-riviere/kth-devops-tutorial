#!/bin/bash
set -e

for i in $(seq 1 90); do
  replicas="$(kubectl get deployment my-app -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
  service_exists="$(kubectl get service my-app-service >/dev/null 2>&1 && echo yes || echo no)"

  if [ "$replicas" = "2" ] && [ "$service_exists" = "yes" ]; then
    break
  fi

  sleep 1
done

replicas="$(kubectl get deployment my-app -o jsonpath='{.spec.replicas}')"
test "$replicas" = "2"

kubectl get service my-app-service >/dev/null

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
