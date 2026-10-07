# 4. Create drift and watch self-healing

Now simulate a manual production change.

The self-healing process will take effect in the 5 seconds, make sure to have the Argo CD web interface opened to see the drift and the healing.

The two subsequent drift are presented here:

## Delete the Service:

Run the following command to delete my-app-service:

```bash
kubectl delete service my-app-service
```

You can check the drift with:

```bash
kubectl get service my-app-service
```

## Scale the Deployment to zero:

Run the following command to set the number of replicas of the my-app to 0:

```bash
kubectl scale deployment my-app --replicas=0
```

You can check the drift:

```bash
kubectl get deployment my-app
```

You can also run:

```bash
watch -n 1 'kubectl get deployment my-app'
```

Click **CHECK** after the application has recovered.
