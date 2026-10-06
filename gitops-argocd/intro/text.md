# GitOps and Continuous Reconciliation with Argo CD

In this hands-on tutorial, you will use Argo CD to keep a Kubernetes cluster aligned with configuration stored in Git.

You will:

1. connect an Argo CD Application to a Git repository;
2. deploy a small application;
3. create configuration drift by changing Kubernetes directly;
4. watch Argo CD automatically restore the desired state.

The Argo CD environment is prepared automatically in the background.

Let's start by checking the Kubernetes cluster.
