# 3. Deploy the application the GitOps way

Usually you deploy an app with a command like `kubectl apply -f deployment.yaml`. In this step you don't apply the app manifests. You only tell Argo CD where the desired state is, and Argo CD deploys it.

For this we use an `Application` resource. Let's look at it:

```bash
cat /tmp/my-app-application.yaml
```{{exec}}

The `source` part points to our Git repository, the branch (`HEAD`) and the folder `gitops-argocd/gitops/app`. The `destination` is the same cluster where Argo CD runs (`https://kubernetes.default.svc`), in the `default` namespace.

`syncPolicy.automated` means that Argo CD syncs by itself, nobody has to click a button. With `prune: true` it deletes objects that are removed from Git, and with `selfHeal: true` it reverts manual changes in the cluster. We test this last one in step 4.

Apply it:

```bash
kubectl apply -f /tmp/my-app-application.yaml
```{{exec}}

Now Argo CD clones the repo and compares the manifests with the cluster. Nothing exists yet, so it creates everything. In the UI you should see a `my-app` tile, and after some seconds it becomes `Synced` and `Healthy`. If you click on it you can see the Deployment, ReplicaSet, Pods and Service.

You can also check it in the terminal:

```bash
kubectl get application my-app -n argocd
```{{exec}}

There are two statuses. The sync status says if the cluster is the same as Git (`Synced` or `OutOfSync`). The health status says if the application really works (`Healthy`, `Progressing`, `Degraded`, ...).

Now check the resources that Argo CD created:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
kubectl get pods -l app=my-app
```{{exec}}

You should see the `my-app` Deployment with 2 replicas, the `my-app-service` Service and 2 running Pods.

Click **CHECK** when the application is `Synced` and `Healthy`.
