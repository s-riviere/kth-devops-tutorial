# 2. Open the Argo CD dashboard

First, check that the Kubernetes node is `Ready`:

```bash
kubectl get nodes
```{{exec}}

Then look at what was installed in the background:

```bash
kubectl get pods -n argocd
```{{exec}}

The important pods are `argocd-server` (web UI and API), `argocd-repo-server` (it clones the Git repo and prepares the manifests) and `argocd-application-controller`, which runs the reconciliation loop. The diagram in the introduction shows how they are connected.

Open the Argo CD web interface in a new tab. It is better to put it next to this window, so you can see the terminal and the UI together.

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

When Argo CD is installed, it creates a random admin password and saves it in a Kubernetes Secret. You can get it with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```{{exec}}

Log in with the username `admin` and the password from the command.

The dashboard is empty for now. Argo CD is running, but it doesn't manage any application yet.

Click **CHECK** when you are logged in.
