# 4. Create drift and watch self-healing

Now you are the engineer who changes production by hand. The two commands below make the cluster different from Git. Keep the Argo CD UI open when you run them. Argo CD watches the cluster with the Kubernetes API, so it sees the change very fast, and it should be fixed in around 5 seconds.

## Delete the Service

```bash
kubectl delete service my-app-service
```{{exec}}

In the UI the application becomes `OutOfSync` and the Service disappears for a moment. Then Argo CD creates it again. Check it:

```bash
kubectl get service my-app-service
```{{exec}}

The Service is back. If you look at the `AGE` column you can see it is a new object, Argo CD applied the manifest from Git again.

## Scale the Deployment to zero

```bash
kubectl scale deployment my-app --replicas=0
```{{exec}}

In Git the Deployment has `replicas: 2`, so Argo CD changes it back. You can watch it (stop with `Ctrl+C`):

```bash
watch -n 1 'kubectl get deployment my-app'
```{{exec}}

Maybe you see `0/2` or `1/2` for a short time, while the Pods are starting again.

## What happened

Both times the same loop fixed the problem: Argo CD looked at the live state, compared it with Git and applied the difference. For Argo CD your manual change is only drift that needs to be corrected. If you want to change the application for real, you have to change Git.

Click **CHECK** when the application has 2 replicas again and the Service exists.
