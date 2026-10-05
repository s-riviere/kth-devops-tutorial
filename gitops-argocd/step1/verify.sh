#!/bin/bash
set -e
kubectl get nodes --no-headers | awk '$2 == "Ready" {found=1} END {exit(found ? 0 : 1)}'
