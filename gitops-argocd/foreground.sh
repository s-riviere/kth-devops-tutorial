#!/bin/bash
set -euo pipefail

printf 'Preparing the Argo CD environment'

for _ in $(seq 1 300); do
  if [ -f /tmp/argocd-setup-complete ]; then
    printf '\nArgo CD is ready.\n'
    exit 0
  fi
  printf '.'
  sleep 2
done

printf '\nArgo CD setup did not finish in time.\n' >&2
printf 'Check the Creator Debug Section for background script errors.\n' >&2
exit 1
