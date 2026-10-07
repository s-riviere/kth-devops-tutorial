# GitOps and continuous reconciliation with Argo CD

## What you will learn

- What configuration drift is and why it is a problem
- The main ideas of GitOps: declarative configuration, Git as the source of truth, pull-based deployment and continuous reconciliation
- How to deploy an application with an Argo CD `Application` and check if it is `Synced` and `Healthy`
- How Argo CD finds drift (`OutOfSync`) and fixes it by itself with self-healing
- When GitOps with Argo CD is a good idea, and when it is not

## The plan

1. Wait for the environment (Argo CD is installed for you)
2. Open the Argo CD dashboard
3. Deploy our application the GitOps way
4. Break things on purpose and watch Argo CD repair them
5. Conclusion and reflection

## Why do we need this?

Let's start with a small story. Someone from the team gets an alert in the middle of the night. To fix it fast they run `kubectl scale` or `kubectl edit` directly on the production cluster, and they forget to tell anyone. A few days later, what is running in the cluster is not the same as what the team thinks is deployed. The next release can remove the fix, or even fail because of it. This difference between the configuration we wrote and what is really running is called **configuration drift**.

With push-based Infrastructure as Code tools like Terraform, Ansible or a CI job running `kubectl apply`, the two states are only compared when someone runs the tool. If nobody runs it, nobody sees the drift.

GitOps tries to solve this problem. The desired state is saved in Git, and an agent inside the cluster compares it all the time with the live state. When there is a difference, the agent fixes it. In this tutorial the agent is Argo CD.

## How does it work?

![Architecture of the tutorial](./architecture.png)

Our setup has three parts:

- **The Git repository** ([s-riviere/kth-devops-tutorial](https://github.com/s-riviere/kth-devops-tutorial)). The folder `gitops-argocd/gitops/app/` has a `Deployment` with 2 nginx Pods and a `Service`. This is our desired state.
- **Argo CD**, in the `argocd` namespace. It has a few components: the repo-server gets the manifests from Git, the application-controller compares them with the cluster and applies the changes, and argocd-server is the web UI.
- **Our application**, in the `default` namespace. This is the live state.

Argo CD checks two things. It checks Git for new commits (every 3 minutes by default), and it also watches the cluster through the Kubernetes API. This is why a manual change is found in only a few seconds. If the two states are different and `selfHeal` is turned on, the controller simply applies the version from Git again.

## Before you begin

You don't need an account or to install anything, everything runs here in the browser on a one node Kubernetes cluster from Killercoda. A script in the background installs Argo CD for you, this can take up to two minutes.

The whole tutorial takes around 15-20 minutes. Have fun! 🚀
