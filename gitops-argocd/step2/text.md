# Step 2: Open the Argo CD dashboard

Let's see what was installed:

```bash
kubectl get pods -n argocd
```{{exec}}

The ones we care about are `argocd-server`, `argocd-repo-server` and `argocd-application-controller`, the same as in the diagram.

Open the web UI in a new tab, preferably next to this window so you can see both in step 4:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

Argo CD creates a random admin password when it is installed. Get it with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```{{exec}}

Log in as `admin`. The dashboard is still empty because Argo CD isn't managing any application yet.

Click **CHECK** when you are logged in.
