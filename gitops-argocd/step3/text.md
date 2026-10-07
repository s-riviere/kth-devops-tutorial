# 3. Deploy the application the GitOps way

Normally you would deploy the app with something like `kubectl apply -f deployment.yaml`. In this step you don't apply the app manifests at all. You only tell Argo CD where the desired state is stored, and Argo CD does the deployment.

This is done with an `Application` resource. Let's look at it:

```bash
cat /tmp/my-app-application.yaml
```{{exec}}

The `source` part points to our Git repository, the branch (`HEAD`) and the folder `gitops-argocd/gitops/app`. The `destination` is the same cluster Argo CD runs in (`https://kubernetes.default.svc`), in the `default` namespace.

The `syncPolicy.automated` part means Argo CD syncs on its own without someone clicking a button. `prune: true` deletes objects that get removed from Git, and `selfHeal: true` reverts manual changes made in the cluster. We will test the last one in step 4.

Apply it:

```bash
kubectl apply -f /tmp/my-app-application.yaml
```{{exec}}

Argo CD now clones the repo and compares the manifests with the cluster. Since nothing exists yet, everything is missing, so it creates all of it. In the UI you should see a `my-app` tile that becomes `Synced` and `Healthy` after some seconds. If you click on it you get the tree with the Deployment, ReplicaSet, Pods and Service.

You can check the same thing from the terminal:

```bash
kubectl get application my-app -n argocd
```{{exec}}

There are two different statuses here. The sync status tells you if the cluster matches Git (`Synced` or `OutOfSync`). The health status tells you if the application is actually working (`Healthy`, `Progressing`, `Degraded`, ...).

Now check the resources that Argo CD created:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
kubectl get pods -l app=my-app
```{{exec}}

You should see the `my-app` Deployment with 2 replicas, the `my-app-service` Service and 2 running Pods.

Click **CHECK** when the application is `Synced` and `Healthy`.
