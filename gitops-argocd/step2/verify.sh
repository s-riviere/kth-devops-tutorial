#!/bin/bash
set -e

kubectl get namespace argocd >/dev/null
kubectl get secret argocd-initial-admin-secret -n argocd >/dev/null
kubectl rollout status deployment/argocd-server -n argocd --timeout=10s >/dev/null
kubectl rollout status statefulset/argocd-application-controller -n argocd --timeout=10s >/dev/null
