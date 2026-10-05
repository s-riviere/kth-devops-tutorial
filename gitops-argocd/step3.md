# 3. Deploy the GitOps application

The Kubernetes manifests are stored in this repository under:

```text
gitops/app/
```

Before using the Application manifest, set `repoURL` in:

```text
gitops/application.yaml
```

It must point to **this GitHub repository**.

Example:

```yaml
repoURL: https://github.com/YOUR-USER/YOUR-REPO.git
```

Commit and push that change before starting the scenario.

Then apply the Argo CD Application:

```bash
kubectl apply -f gitops/application.yaml
```

Check the result:

```bash
kubectl get applications -n argocd
kubectl get deployment,service
```

You should see:

- Application: `my-app`
- Sync status: `Synced`
- Health: `Healthy`
- Deployment: `my-app`
- Service: `my-app-service`

Open the Argo CD UI again:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

Click **CHECK** when the application is synced and healthy.
