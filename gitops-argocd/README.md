# GitOps and Continuous Reconciliation with Argo CD — V4

Functional Killercoda scenario for demonstrating configuration drift and Argo CD self-healing.

## Scenario structure

```text
gitops-argocd/
├── index.json
├── background.sh
├── foreground.sh
├── intro/
│   └── text.md
├── step1/
│   ├── text.md
│   └── verify.sh
├── step2/
│   ├── text.md
│   └── verify.sh
├── step3/
│   ├── text.md
│   └── verify.sh
├── step4/
│   ├── text.md
│   └── verify.sh
├── finish/
│   └── text.md
├── assets/
│   └── application.yaml
└── gitops/
    ├── application.yaml
    └── app/
        ├── deployment.yaml
        └── service.yaml
```

## Startup

`background.sh` installs/configures Argo CD and starts the port-forward. `foreground.sh` waits for a completion marker before the learner can continue.

## Asset

Killercoda copies `assets/application.yaml` to `/tmp/my-app-application.yaml`.

## GitOps source

Argo CD watches:

`https://github.com/s-riviere/kth-devops-tutorial.git`

Path:

`gitops-argocd/gitops/app`

The repository is public for this first functional version.

## Drift demonstration

```bash
kubectl delete service my-app-service
kubectl scale deployment my-app --replicas=0
```

Argo CD has `selfHeal: true` enabled and restores the Git-defined state.
