# 3. Deploy the GitOps application

Apply the Argo CD Application manifest which tells Argo CD what to do:

```bash
kubectl apply -f /tmp/my-app-application.yaml
```

Argo CD has `selfHeal: true` enabled. It should detect the difference between Git and the live cluster and restore the desired state.

Check the Argo CD Application on the web interface or with the following command:

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

Click **CHECK** when the application is ready.
