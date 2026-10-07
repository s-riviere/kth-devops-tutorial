# 2. Open the Argo CD dashboard

First check that the Kubernetes node is `Ready`:

```bash
kubectl get nodes
```{{exec}}

Then have a look at what was installed in the background:

```bash
kubectl get pods -n argocd
```{{exec}}

The interesting pods are `argocd-server` (web UI and API), `argocd-repo-server` (clones the Git repo and renders the manifests) and `argocd-application-controller`, which is the one running the reconciliation loop. You can go back to the diagram in the introduction to see how they are connected.

Open the Argo CD web interface in a new tab. It helps to put it next to this window so you can see the terminal and the UI at the same time.

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

When Argo CD is installed it generates a random admin password and saves it in a Kubernetes Secret. You can read it with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```{{exec}}

Log in with the username `admin` and the password printed by the command.

For now the dashboard is empty. Argo CD is running but it is not managing any application yet.

Click **CHECK** when you are logged in.
