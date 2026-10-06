# 3. Deploy the GitOps application

The Argo CD Application manifest is already configured to use the GitHub repository for this tutorial.

Apply the Application manifest directly from GitHub:

```bash
curl -fsSL   https://raw.githubusercontent.com/s-riviere/kth-devops-tutorial/main/gitops-argocd/gitops/application.yaml   | kubectl apply -f -
```

Check that the Application has been created:

```bash
kubectl get application my-app -n argocd
```

Wait for Argo CD to synchronize the application:

```bash
kubectl wait   --for=jsonpath='{.status.sync.status}'=Synced   application/my-app   -n argocd   --timeout=120s
```

Wait for the application to become healthy:

```bash
kubectl wait   --for=jsonpath='{.status.health.status}'=Healthy   application/my-app   -n argocd   --timeout=120s
```

Check the deployed Kubernetes resources:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
kubectl get pods -l app=my-app
```

You should see:

- `my-app` with **2 replicas**
- `my-app-service`
- two running application pods

Check the final Argo CD status:

```bash
kubectl get application my-app -n argocd   -o jsonpath='Sync: {.status.sync.status}{"\n"}Health: {.status.health.status}{"\n"}'
```

The expected result is:

```text
Sync: Synced
Health: Healthy
```

Open the Argo CD UI:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

You should see the `my-app` application in the Argo CD interface with a healthy resource tree.

Click **CHECK** when the application is **Synced** and **Healthy**.
