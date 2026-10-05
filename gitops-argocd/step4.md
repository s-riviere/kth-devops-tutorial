# 4. Break it and watch self-healing

Now create configuration drift by changing the live cluster directly.

Delete the Service:

```bash
kubectl delete service my-app-service
```

Scale the Deployment to zero:

```bash
kubectl scale deployment my-app --replicas=0
```

Immediately inspect the live state:

```bash
kubectl get deployment,service
```

Then wait a little and run the same command again:

```bash
kubectl get deployment,service
```

Argo CD should restore the state declared in Git:

- the Service should exist again
- the Deployment should return to `2` replicas

Open the Argo CD UI:

[Open Argo CD]({{TRAFFIC_HOST1_8080}})

The Application should return to **Synced / Healthy** without you manually repairing the resources.

Click **CHECK** after the automatic recovery.
