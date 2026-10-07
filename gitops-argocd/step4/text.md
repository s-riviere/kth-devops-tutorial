# Step 4: Create drift and watch self-healing

Now you are the engineer from the story in the introduction, who changes production by hand. Both commands below make the cluster different from what is in Git.

Keep the Argo CD UI open when you run them. Argo CD watches the cluster through the Kubernetes API, so it sees the change very fast, and it should be fixed in around 5 seconds.

## Delete the Service

```bash
kubectl delete service my-app-service
```{{exec}}

In the UI the application becomes `OutOfSync` and the Service disappears for a moment. Then Argo CD creates it again. Let's check:

```bash
kubectl get service my-app-service
```{{exec}}

The Service is back. If you look at the `AGE` column you can see that it is a new object. Argo CD simply applied the manifest from Git again.

## Scale the Deployment to zero

```bash
kubectl scale deployment my-app --replicas=0
```{{exec}}

In Git our Deployment has `replicas: 2`, so Argo CD changes it back. You can watch it happen:

```bash
watch -n 1 'kubectl get deployment my-app'
```{{exec}}

You might see `0/2` or `1/2` for a short time while the Pods are starting again. Press `Ctrl+C` to stop `watch`.

## So what happened?

Both times the same loop fixed the problem. Argo CD looked at the live state, compared it with Git and applied the difference. For Argo CD your manual change is only drift that needs to be corrected. So if you want to change the application for real, you have to change it in Git.

Click **CHECK** when the application has 2 replicas again and the Service exists.
