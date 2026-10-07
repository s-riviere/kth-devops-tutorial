# 2. Open the Argo CD dashboard

Check that the Kubernetes node is `Ready`:

```bash
kubectl get nodes
```{{exec}}

Look at what the background script installed:

```bash
kubectl get pods -n argocd
```{{exec}}

You should see, among others, `argocd-server` (web UI and API), `argocd-repo-server` (clones Git and renders manifests) and `argocd-application-controller` (runs the reconciliation loop). The architecture diagram in the introduction shows how they work together.

Open the Argo CD web interface in a new tab and place it next to this one, so you can see the terminal and the UI at the same time:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

Argo CD creates a random admin password on first install and stores it in a Kubernetes Secret. Read it with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```{{exec}}

Log in with:

- **Username:** `admin`
- **Password:** the value printed by the command above

The dashboard is empty: Argo CD is running, but it does not manage any application yet.

Click **CHECK** when you are logged in.
