# 2. Kubernetes and ArgoCD setup

First, make sure the Kubernetes cluster is ready.

```bash
kubectl get nodes
```

Open the Argo CD web interface and put it side to side with the Killercoda window:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

Get the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Log in with:

- **Username:** `admin`
- **Password:** the value returned by the command above

At this point, Argo CD is running, but it is not managing our application yet.

Click **CHECK** when you can access the Argo CD dashboard.
