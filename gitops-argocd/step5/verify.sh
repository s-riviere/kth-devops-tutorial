#!/bin/bash
set -e

for i in $(seq 1 60); do
  replicas="$(kubectl get deployment my-app -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"

  if [ "$replicas" = "3" ]; then
    break
  fi

  sleep 1
done

replicas="$(kubectl get deployment my-app -o jsonpath='{.status.readyReplicas}')"
test "$replicas" = "3"

kubectl wait \
  --for=jsonpath='{.status.sync.status}'=Synced \
  application/my-app \
  -n argocd \
  --timeout=30s >/dev/null
