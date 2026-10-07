# Step 2: Open the Argo CD dashboard

First let's make sure the Kubernetes node is `Ready`:

```bash
kubectl get nodes
```{{exec}}

Now let's look at what was installed in the background:

```bash
kubectl get pods -n argocd
```{{exec}}

You will see quite a lot of pods, but the important ones for us are `argocd-server` (the web UI and the API), `argocd-repo-server` (it clones the Git repository and prepares the manifests) and `argocd-application-controller`. The last one runs the reconciliation loop, so it is the one doing the actual work. Do you remember where they are in the diagram from the introduction?

Go ahead and open the Argo CD web interface in a new tab:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

It helps to put the Argo CD tab next to this window, so you can see the terminal and the UI at the same time in step 4.

When Argo CD is installed, it creates a random password for the admin user and saves it in a Kubernetes Secret. We can get it with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```{{exec}}

Log in with the username `admin` and the password from the command.

The dashboard is empty for now. Argo CD is running, but it is not managing any application yet. Let's change that in the next step.

Click **CHECK** when you are logged in.
