# Tutorial complete

You have demonstrated the core GitOps reconciliation loop:

```text
Git desired state
       ↓
    Argo CD
       ↓
Kubernetes live state
       ↓
configuration drift
       ↓
automatic reconciliation
       ↓
restored state
```

You changed Kubernetes directly, but Git remained the source of truth.

Argo CD detected the drift and automatically restored the desired configuration.
