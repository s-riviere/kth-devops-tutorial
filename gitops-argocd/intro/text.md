# GitOps and continuous reconciliation with Argo CD

## The problem

Someone gets paged at night, runs `kubectl scale` or `kubectl edit` to fix production, and goes back to sleep. Nobody writes it down. A week later the cluster no longer matches what the team thinks is deployed, and the next release either undoes the fix or breaks on top of it. This gap between the declared configuration and what is actually running is called **configuration drift**.

Push-based Infrastructure as Code tools (Terraform, Ansible, a CI job running `kubectl apply`) only compare the two states when someone runs them. Between runs, drift goes unnoticed.

GitOps takes a different approach: Git holds the desired state, and an agent running inside the cluster keeps comparing that state with the live cluster and corrects any difference. In this tutorial that agent is **Argo CD**.

## Learning outcomes

By the end of this tutorial you will be able to:

1. Explain the GitOps principles: declarative configuration, Git as the single source of truth, pull-based deployment and continuous reconciliation.
2. Deploy an application through an Argo CD `Application` resource and read its `Synced` and `Healthy` status in the CLI and the web UI.
3. Cause configuration drift with imperative `kubectl` commands and observe Argo CD detect it (`OutOfSync`) and repair it with self-healing.
4. Discuss when GitOps with Argo CD is a good fit and where it falls short (secrets, emergency fixes, polling delay).

## Architecture

![Architecture of the tutorial](./architecture.png)

- **Git repository**: [s-riviere/kth-devops-tutorial](https://github.com/s-riviere/kth-devops-tutorial). The folder `gitops-argocd/gitops/app/` contains a `Deployment` (2 nginx Pods) and a `Service`. This is the desired state.
- **Argo CD** runs in the `argocd` namespace. The *repo-server* fetches the manifests from Git, the *application-controller* compares them with the live objects and applies changes, and the *argocd-server* serves the web UI.
- **The application** runs in the `default` namespace. This is the live state.

Argo CD has two triggers. It polls Git (about every 3 minutes by default) to catch new commits, and it watches the cluster through the Kubernetes API, so a manual change is detected within seconds. When the two states differ and `selfHeal` is on, the controller applies the Git version again.

## Environment

Everything runs in this browser tab: a single node Kubernetes cluster provided by Killercoda. No account or local installation is needed. A background script installs Argo CD (pinned to `v3.5.3`) and opens its web UI on port 8080. This takes up to two minutes; the first step waits for it.

The whole scenario takes about 15 to 20 minutes.
