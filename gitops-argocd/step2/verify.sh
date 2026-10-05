#!/bin/bash
set -e
kubectl get namespace argocd >/dev/null
kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=10s >/dev/null
