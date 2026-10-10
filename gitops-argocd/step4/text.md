# Step 4: Create drift and watch self-healing

Now let's change production by hand, like in the example from the introduction. Keep the Argo CD UI visible.

Delete the Service:

```bash
kubectl delete service my-app-service
```{{exec}}

The app goes `OutOfSync` for a moment and then the Service comes back. Check its `AGE`, it's a new object created from Git:

```bash
kubectl get service my-app-service
```{{exec}}

Now scale the Deployment to zero:

```bash
kubectl scale deployment my-app --replicas=0
```{{exec}}

Git says 2 replicas, so Argo CD scales it back up. Watch it (`Ctrl+C` to stop):

```bash
watch -n 1 kubectl get deployment my-app
```{{exec}}

In both cases Argo CD compared the live state with Git and applied the difference. So the only way to really change the app is to change Git, which is what we do next.

Click **CHECK** when the app is back to 2 replicas and the Service exists.
