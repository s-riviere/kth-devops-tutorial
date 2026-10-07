# 4. Create drift and watch self-healing

Now you are the on-call engineer who changes production by hand. Both commands below make the cluster different from what is in Git. Keep the Argo CD UI open while you run them. Since Argo CD watches the cluster through the Kubernetes API it sees the change almost right away, and it should be fixed in about 5 seconds.

## Delete the Service

```bash
kubectl delete service my-app-service
```{{exec}}

In the UI the application goes `OutOfSync` and the Service disappears from the tree for a moment, then Argo CD creates it again. Check it:

```bash
kubectl get service my-app-service
```{{exec}}

The Service is back. Look at the `AGE` column, it is a new object, Argo CD just applied the manifest from Git one more time.

## Scale the Deployment to zero

```bash
kubectl scale deployment my-app --replicas=0
```{{exec}}

In Git the Deployment has `replicas: 2`, so Argo CD changes it back. You can watch it (stop with `Ctrl+C`):

```bash
watch -n 1 'kubectl get deployment my-app'
```{{exec}}

For a short time you might see `0/2` or `1/2` while the Pods are starting again.

## What happened

In both cases the same loop did the work: Argo CD looked at the live state, compared it with Git and applied the difference. For Argo CD your manual change is just drift that has to be corrected. If you want to change the application permanently, the change has to go into Git.

Click **CHECK** when the application is back to 2 replicas and the Service exists.
