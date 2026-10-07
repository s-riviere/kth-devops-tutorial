#!/bin/bash
set -e

# Verify that the Argo CD background setup has been completed
test -f /tmp/argocd-setup-complete
