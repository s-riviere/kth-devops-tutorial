# 4. Create drift and watch self-healing

Now simulate a manual production change.

The self-healing process will take effect after 20 seconds so you have time to check the drift in command line or in the ArgoCD web UI.

The two subsequent drift are presented here:

1. Delete the Service:

```bash
kubectl delete service my-app-service
```

2. Then scale the Deployment to zero:

```bash
kubectl scale deployment my-app --replicas=0
```

Check the drift:

```bash
kubectl get deployment my-app
kubectl get service my-app-service
```

The Deployment should have `0` replicas and the Service should be absent.

Now stop changing the cluster.

Argo CD has `selfHeal: true` enabled. It should detect the difference between Git and the live cluster and restore the desired state.

Watch the Deployment:

```bash
watch -n 1 'kubectl get deployment my-app'
```

You should see the replica count return to:

```text
2
```

Then verify that the Service has been recreated:

```bash
kubectl get service my-app-service
```

Open the Argo CD UI:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

The application should return to:

**Synced / Healthy**

No manual repair command was required.

Click **CHECK** after the application has recovered.
