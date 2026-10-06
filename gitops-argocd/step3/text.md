# 3. Deploy the GitOps application

The Argo CD Application manifest has been prepared for you.

Apply it:

```bash
kubectl apply -f /tmp/my-app-application.yaml
```

Argo CD will now use the Git repository as the source of truth for the application.

Check the Argo CD Application:

```bash
kubectl get application my-app -n argocd
```

It should eventually be Synced and Healthy after a while.

Check the resources created by Argo CD:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
kubectl get pods -l app=my-app
```

You should have:

- `my-app` with 2 replicas;
- `my-app-service`;
- 2 running Pods.

Open the Argo CD UI again:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

You should see `my-app` as:

**Synced / Healthy**

Click **CHECK** when the application is ready.
