# 2. Install Argo CD

Install Argo CD into the `argocd` namespace.

Run:

```bash
kubectl create namespace argocd
```

Then install the official Argo CD manifest:

```bash
kubectl apply --server-side --force-conflicts -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

Wait for the Argo CD server:

```bash
kubectl wait --for=condition=Available deployment/argocd-server -n argocd --timeout=180s
```

For the Killercoda HTTP endpoint, run Argo CD without TLS:

```bash
kubectl patch configmap argocd-cmd-params-cm -n argocd --type merge -p '{"data":{"server.insecure":"true"}}'
kubectl rollout restart deployment/argocd-server -n argocd
kubectl rollout status deployment/argocd-server -n argocd --timeout=120s
```

Expose the UI on port `8080`:

```bash
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8080:80 >/tmp/argocd-port-forward.log 2>&1 &
```

Open the UI:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

The initial admin password is available with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

Login with:

- **Username:** `admin`
- **Password:** the value printed above

Then click **CHECK**.
