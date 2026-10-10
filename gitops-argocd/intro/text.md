# GitOps and continuous reconciliation with Argo CD

## What you will learn

- What configuration drift is and how GitOps deals with it
- How to deploy an application with an Argo CD `Application`
- How Argo CD detects drift and fixes it with self-healing
- How to change the app by committing to Git
- When GitOps with Argo CD is a good idea and when it is not

## Why do we need this?

Imagine someone fixes a problem in production by running `kubectl scale` or `kubectl edit` by hand, and doesn't tell anyone. Now the cluster is different from what the team thinks is deployed. This is called configuration drift.

With push-based tools like Terraform, Ansible or a CI job running `kubectl apply`, drift is only noticed when someone runs the tool again. In GitOps the desired state is stored in Git, and an agent inside the cluster keeps comparing it with the live state and fixes any difference. Here the agent is Argo CD.

## How does it work?

![Architecture of the tutorial](./architecture.png)

- The Git repository `~/my-app-git` has a `Deployment` (2 nginx Pods) and a `Service` in `app/`. This is the desired state. It runs on a small Git server inside the environment, so you can commit to it without a GitHub account.
- Argo CD runs in the `argocd` namespace. The repo-server gets the manifests from Git, the application-controller compares them with the cluster and applies changes, and argocd-server is the web UI.
- Our application runs in the `default` namespace. This is the live state.

Argo CD checks Git for new commits every 3 minutes by default (we set it to 5 seconds for the demo), and it also watches the cluster through the Kubernetes API, so manual changes are noticed in a few seconds.

Everything runs in the browser, no account needed. The tutorial takes around 15 minutes.
