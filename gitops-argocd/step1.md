# 1. Check the Kubernetes cluster

Killercoda provides a Kubernetes environment for this scenario.

Run:

```bash
kubectl get nodes
```

The node should be `Ready`.

Then check the cluster version:

```bash
kubectl version --short 2>/dev/null || kubectl version
```

Once the node is ready, click **CHECK**.
