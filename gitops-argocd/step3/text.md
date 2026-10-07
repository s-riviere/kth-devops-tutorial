# 3. Deploy the application the GitOps way

In a push-based workflow you would run `kubectl apply -f deployment.yaml`. Here you never apply the app manifests yourself. Instead, you tell Argo CD *where* the desired state lives and let it do the deployment.

That is the job of an `Application` resource. Look at it:

```bash
cat /tmp/my-app-application.yaml
```{{exec}}

- `source` points to the Git repository, the branch (`HEAD`) and the folder `gitops-argocd/gitops/app`.
- `destination` is the cluster Argo CD runs in (`https://kubernetes.default.svc`) and the `default` namespace.
- `syncPolicy.automated` makes Argo CD sync without anyone clicking a button. `prune: true` deletes objects that are removed from Git. `selfHeal: true` reverts manual changes to the cluster, which is what you will test in step 4.

Apply it:

```bash
kubectl apply -f /tmp/my-app-application.yaml
```{{exec}}

Argo CD now clones the repository, compares the manifests with the cluster (where nothing exists yet), sees that everything is missing, and creates it. In the UI, the `my-app` tile appears and turns `Synced` and `Healthy` after a few seconds. Click on it to see the tree: Deployment, ReplicaSet, Pods and Service.

From the CLI:

```bash
kubectl get application my-app -n argocd
```{{exec}}

- **Sync status** answers "does the cluster match Git?" (`Synced` / `OutOfSync`).
- **Health status** answers "is the application working?" (`Healthy`, `Progressing`, `Degraded`...).

Check the resources Argo CD created:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
kubectl get pods -l app=my-app
```{{exec}}

You should have:

- the `my-app` Deployment with 2 replicas;
- the `my-app-service` Service;
- 2 running Pods.

Click **CHECK** when the application is `Synced` and `Healthy`.
