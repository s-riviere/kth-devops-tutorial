# Conclusion

## Summary

In this tutorial Argo CD was installed in the cluster and connected to a Git repository. You created an `Application` pointing to `gitops-argocd/gitops/app/`, and Argo CD deployed the app without you running `kubectl apply` on any of the app manifests. Then you deleted the Service and scaled the Deployment to zero, and both times Argo CD put things back the way Git describes them within a few seconds.

You never told Argo CD to fix anything. The repair comes from the reconciliation loop, which keeps repeating three things: look at the live state, compare it with the desired state, and act on the difference. Kubernetes itself already works like this, for example a ReplicaSet controller keeps the right number of Pods running. Argo CD does the same thing but one level higher, with Git as the input.

## Connection to DevOps

GitOps is basically Infrastructure as Code taken one step further. The configuration of the application is versioned and reviewed like normal code, and `git log` shows who changed what and when. It also changes how continuous delivery works, since deploying means merging a commit and a rollback can be done with `git revert`.

There is also a security benefit. The CI pipeline does not need credentials for the cluster, because Argo CD pulls the changes from inside the cluster. So the Kubernetes API doesn't have to be reachable from a CI runner.

## Why we chose Argo CD

The main alternative is Flux. Both follow the GitOps principles, and Flux is lighter, but it is used through the CLI and CRDs only and has no built-in UI. We chose Argo CD mostly because of its web UI, which lets you actually see the drift and the healing happen, and that was the whole point of this tutorial. Argo CD is also a graduated CNCF project and can be installed with one manifest, which made the Killercoda setup easier.

We changed two settings for the demo: `timeout.reconciliation.jitter` is set to `0` and the self-heal backoff is capped at 5 seconds, so the healing happens fast enough to watch. In a real production setup you would probably keep a longer backoff, so Argo CD doesn't end up fighting with other controllers that modify the same resources.

## Limitations of the tutorial

The drift in this tutorial only comes from the cluster side. We don't show the other direction, where you commit a change to Git and the cluster follows it. That would need you to push to the GitHub repository, which needs an account. With your own fork you could change `replicas: 2` to `3`, commit it, and Argo CD would roll it out the next time it polls the repo.

## When to use it (and when not)

GitOps makes the most sense for teams that run several clusters or environments that need to stay the same, and for companies that need an audit trail of every change, for example in finance or healthcare. It also works well for platform teams that want developers to deploy by opening a pull request instead of having direct access to the cluster.

There are some problems though:

- Secrets can't be stored in Git in plain text, so you need extra tools like Sealed Secrets, SOPS or the External Secrets Operator.
- Emergency fixes become harder. With self-healing on, a manual hotfix gets reverted in a few seconds, so you either go through Git or pause self-healing first. It is safer, but slower when something is on fire.
- Argo CD only manages Kubernetes resources. For things like databases, DNS or cloud networking you still need Terraform or Crossplane.
- For a small project with one cluster and one developer, the extra component and repo structure is probably more overhead than it is worth.
- Changes in Git are not instant, since the repo is polled every few minutes by default. Webhooks can make it faster.

## Further reading

- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [OpenGitOps principles](https://opengitops.dev/)
- [Flux](https://fluxcd.io/)
