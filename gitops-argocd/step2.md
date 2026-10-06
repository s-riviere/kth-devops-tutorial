# 2. Install Argo CD

Install Argo CD into the `argocd` namespace.

Run:

```bash
kubectl create namespace argocd

kubectl apply --server-side --force-conflicts \
  -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl wait --for=condition=Available \
  deployment/argocd-server \
  -n argocd \
  --timeout=180s
```

Configure Argo CD for the Killercoda environment and speed up self-healing:

```bash
kubectl patch configmap argocd-cmd-params-cm \
  -n argocd \
  --type merge \
  -p '{"data":{"server.insecure":"true","controller.self.heal.backoff.timeout.seconds":"2","controller.self.heal.backoff.factor":"2","controller.self.heal.backoff.cap.seconds":"15"}}'
```

Restart the Argo CD server and application controller:

```bash
kubectl rollout restart deployment/argocd-server -n argocd

kubectl rollout status deployment/argocd-server \
  -n argocd \
  --timeout=120s

kubectl rollout restart statefulset/argocd-application-controller -n argocd

kubectl rollout status statefulset/argocd-application-controller \
  -n argocd \
  --timeout=120s
```

Expose the Argo CD web interface on port `8080`:

```bash
kubectl port-forward \
  --address 0.0.0.0 \
  svc/argocd-server \
  -n argocd \
  8080:80 \
  >/tmp/argocd-port-forward.log 2>&1 &
```

Open the Argo CD UI:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

Get the initial admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d; echo
```

Login with:

- **Username:** `admin`
- **Password:** the value returned by the command above

Argo CD is now ready.

Click **CHECK**.
