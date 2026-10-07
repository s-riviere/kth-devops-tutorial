# GitOps and continuous reconciliation with Argo CD

## Why this matters

Imagine someone on call gets an alert at night, runs `kubectl scale` or `kubectl edit` directly on the production cluster to fix it, and goes back to bed without telling anyone. A week later what is running in the cluster is not what the team thinks is deployed anymore. The next release might undo the fix, or break because of it. This difference between the configuration you declared and what actually runs is called configuration drift.

With push-based Infrastructure as Code tools like Terraform, Ansible or a CI job that runs `kubectl apply`, the two states are only compared when somebody runs the tool. If nobody runs it, nobody notices the drift.

GitOps tries to solve this. The desired state is kept in Git, and an agent that runs inside the cluster keeps comparing it to the live state and fixes any difference it finds. In this tutorial we use Argo CD as that agent.

## Learning outcomes

After this tutorial you should be able to:

1. Explain the main GitOps principles (declarative config, Git as the source of truth, pull-based deployment, continuous reconciliation).
2. Deploy an application with an Argo CD `Application` resource and check its `Synced` and `Healthy` status, both in the terminal and in the web UI.
3. Create configuration drift with `kubectl` and see how Argo CD detects it (`OutOfSync`) and repairs it with self-healing.
4. Discuss in which cases GitOps with Argo CD is a good idea and where it has problems, for example secrets or emergency fixes.

## Architecture

![Architecture of the tutorial](./architecture.png)

There are three parts in the setup:

- The Git repository [s-riviere/kth-devops-tutorial](https://github.com/s-riviere/kth-devops-tutorial). The folder `gitops-argocd/gitops/app/` has a `Deployment` with 2 nginx Pods and a `Service`. This is our desired state.
- Argo CD, installed in the `argocd` namespace. It is made of several components. The repo-server fetches the manifests from Git, the application-controller compares them with what is in the cluster and applies changes, and argocd-server is the web UI.
- The application itself, which runs in the `default` namespace. This is the live state.

Argo CD reacts to two things. It polls Git for new commits (every 3 minutes by default), and it also watches the cluster through the Kubernetes API, which is why a manual change gets noticed in a few seconds. If the two states are different and `selfHeal` is enabled, the controller applies the version from Git again.

## Environment

Everything runs in the browser on a single node Kubernetes cluster from Killercoda, so you don't need an account or to install anything. A background script installs Argo CD (version `v3.5.3`) and opens the web UI on port 8080, this takes up to two minutes and the first step waits for it to finish.

The tutorial takes around 15-20 minutes.
