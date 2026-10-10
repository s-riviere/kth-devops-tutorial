# Step 3: Deploy the application the GitOps way

Instead of running `kubectl apply` on the app ourselves, we tell Argo CD where the desired state is and let it deploy it. This is done with an `Application`:

```bash
cat ~/my-app-git/application.yaml
```{{exec}}

`source` is our local Git repo and the `app` folder inside it, `destination` is this cluster. Under `syncPolicy.automated`, `prune: true` deletes things removed from Git and `selfHeal: true` reverts manual changes, which we test in the next step.

Apply it:

```bash
kubectl apply -f ~/my-app-git/application.yaml
```{{exec}}

Argo CD sees that nothing from Git exists in the cluster yet and creates it. In the UI `my-app` should become `Synced` (cluster matches Git) and `Healthy` (the app actually works) after a few seconds. You can also check from the terminal:

```bash
kubectl get application my-app -n argocd
kubectl get deployment,service,pods
```{{exec}}

Click **CHECK** when the application is `Synced` and `Healthy`.
