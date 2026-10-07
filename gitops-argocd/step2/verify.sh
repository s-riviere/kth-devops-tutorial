#!/bin/bash
set -e

# Verify that at least one Kubernetes node is in the "Ready" state
kubectl get nodes --no-headers | awk '$2 == "Ready" {found=1} END {exit(found ? 0 : 1)}'
