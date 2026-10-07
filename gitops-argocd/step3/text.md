# Step 3: Deploy the application the GitOps way

Normally you would deploy an app with a command like `kubectl apply -f deployment.yaml`. In this step we don't apply the app manifests ourselves. We only tell Argo CD *where* the desired state is, and Argo CD does the deployment for us.

For this we use an `Application` resource. Let's have a look at it:

```bash
cat /tmp/my-app-application.yaml
```{{exec}}

The `source` points to our Git repository, the branch (`HEAD`) and the folder `gitops-argocd/gitops/app`. The `destination` is the same cluster where Argo CD runs (`https://kubernetes.default.svc`), in the `default` namespace.

`syncPolicy.automated` means that Argo CD syncs by itself, nobody has to click a button. With `prune: true` it deletes objects that are removed from Git, and with `selfHeal: true` it reverts manual changes in the cluster. We will test this last one in the next step.

Now apply it:

```bash
kubectl apply -f /tmp/my-app-application.yaml
```{{exec}}

What happens now is that Argo CD clones the repo and compares the manifests with the cluster. Nothing exists yet, so it creates everything. In the UI you should see a `my-app` tile, and after some seconds it becomes `Synced` and `Healthy`. Click on it to see the Deployment, ReplicaSet, Pods and Service.

You can also check it from the terminal:

```bash
kubectl get application my-app -n argocd
```{{exec}}

There are two different statuses here. The sync status tells you if the cluster is the same as Git (`Synced` or `OutOfSync`). The health status tells you if the application actually works (`Healthy`, `Progressing`, `Degraded`, ...). An app can be `Synced` but not `Healthy`, for example if the image can't be pulled.

Let's check the resources that Argo CD created:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
kubectl get pods -l app=my-app
```{{exec}}

You should see the `my-app` Deployment with 2 replicas, the `my-app-service` Service and 2 running Pods.

Click **CHECK** when the application is `Synced` and `Healthy`.
