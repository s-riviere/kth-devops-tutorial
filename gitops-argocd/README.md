# Killercoda — Argo CD GitOps V1

## Repository layout

Put this scenario directory in the GitHub repository connected to Killercoda.

The important files are:

- `index.json` — Killercoda scenario metadata
- `intro.md` — introduction
- `step1.md` ... `step4.md` — tutorial steps
- `step*/verify.sh` — optional step checks
- `gitops/application.yaml` — Argo CD Application
- `gitops/app/deployment.yaml` — desired Deployment
- `gitops/app/service.yaml` — desired Service

## One required edit

Open `gitops/application.yaml` and replace:

```yaml
repoURL: https://github.com/REPLACE-ME/YOUR-REPO.git
```

with the public URL of the GitHub repository that contains this file.

Example:

```yaml
repoURL: https://github.com/example/my-killercoda-tutorial.git
```

The `path: gitops/app` value must stay correct relative to the repository root.

## Expected demo

Initial state:

- Deployment `my-app` has 2 replicas
- Service `my-app-service` exists
- Argo CD is `Synced` / `Healthy`

Drift:

```bash
kubectl delete service my-app-service -n gitops-demo
kubectl scale deployment my-app -n gitops-demo --replicas=0
```

Recovery:

Argo CD detects the live-state difference and automatically restores the Git-defined state because automated sync with `selfHeal: true` is enabled.

## Notes

This V1 deliberately uses the current Killercoda Kubernetes kubeadm image rather than assuming a K3s image. The Killercoda creator documentation currently lists `kubernetes-kubeadm-1node` and `kubernetes-kubeadm-1node-4GB`.

The Argo CD server is switched to HTTP for the Killercoda browser endpoint. This is suitable only for the ephemeral lab environment; it is not a production security recommendation.
