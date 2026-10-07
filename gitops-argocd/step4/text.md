# 4. Create drift and watch self-healing

Now play the on-call engineer who changes production by hand. Each command below makes the live state differ from Git. Keep the Argo CD UI visible: Argo CD watches the cluster through the Kubernetes API, so it notices the change almost immediately and repairs it within about 5 seconds.

## Delete the Service

```bash
kubectl delete service my-app-service
```{{exec}}

In the UI, the application turns `OutOfSync` and the Service briefly disappears from the tree. Then Argo CD recreates it. Check:

```bash
kubectl get service my-app-service
```{{exec}}

The Service is back, with a new creation timestamp (`AGE`). Argo CD did not restore a backup; it applied the manifest from Git again.

## Scale the Deployment to zero

```bash
kubectl scale deployment my-app --replicas=0
```{{exec}}

Git says `replicas: 2`, so Argo CD sets it back. Watch it happen (press `Ctrl+C` to stop):

```bash
watch -n 1 'kubectl get deployment my-app'
```{{exec}}

You may see `0/2` or `1/2` for a moment while the Pods start again.

## What happened

Both times, the same loop ran: observe the live state, compare it with Git, apply the difference. Your manual change was treated as an error, not as a new version of the application. To change the application for good, you have to change Git.

Click **CHECK** once the application is back to 2 replicas with its Service.
