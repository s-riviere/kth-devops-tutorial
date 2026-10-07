# Conclusion

## Summary

In this tutorial, Argo CD was installed in the cluster and connected to a Git repository. You created an `Application` that points to `gitops-argocd/gitops/app/`, and Argo CD deployed the app. You never ran `kubectl apply` on the app manifests. After that you deleted the Service and scaled the Deployment to zero, and both times Argo CD put everything back like in Git, in a few seconds.

You never asked Argo CD to fix something. The fix comes from the reconciliation loop, which repeats the same steps: look at the live state, compare it with the desired state, and change what is different. Kubernetes also works like this, for example the ReplicaSet controller makes sure the right number of Pods is running. Argo CD does the same, but at a higher level and with Git as input.

## Connection to DevOps

GitOps is close to Infrastructure as Code. The configuration of the application has versions and is reviewed like normal code, and with `git log` you can see who changed what and when. It also changes continuous delivery: to deploy you merge a commit, and to roll back you can use `git revert`.

It is also good for security. The CI pipeline doesn't need credentials for the cluster, because Argo CD pulls the changes from inside the cluster. So the Kubernetes API doesn't need to be open to a CI runner.

## Why we chose Argo CD

The main alternative is Flux. Both follow the GitOps principles. Flux is lighter, but you use it only with the CLI and CRDs and it has no web UI. We chose Argo CD mainly because of the web UI, where you can see the drift and the healing, and this was the main goal of our tutorial. Also Argo CD is a graduated CNCF project and you can install it with one manifest, so the setup on Killercoda was easier.

We changed two settings for the demo. `timeout.reconciliation.jitter` is `0` and the self-heal backoff is maximum 5 seconds, so the healing is fast and you can see it. In production you would probably use a longer backoff, so Argo CD doesn't fight with other controllers that change the same resources.

## Limitations of the tutorial

In this tutorial the drift only comes from the cluster. We don't show the other way, where you commit a change in Git and the cluster follows it. For this you need to push to the GitHub repository, and that needs an account. With your own fork you could change `replicas: 2` to `3`, commit it, and Argo CD would deploy it the next time it checks the repo.

## When to use it (and when not)

GitOps is useful for teams with many clusters or environments that need to be the same, and for companies that need a history of all changes, for example in finance or healthcare. It is also good for platform teams who want developers to deploy with a pull request, without direct access to the cluster.

But there are some problems:

- You can't save secrets in Git as plain text, so you need extra tools like Sealed Secrets, SOPS or External Secrets Operator.
- Urgent fixes are harder. With self-healing on, a manual hotfix is reverted in a few seconds, so you have to use Git or stop self-healing first. It is safer, but slower when there is a big problem.
- Argo CD only manages Kubernetes resources. For databases, DNS or cloud networking you still need Terraform or Crossplane.
- For a small project with one cluster and one developer, the extra component and repo structure is probably too much work for the benefit.
- Changes in Git are not instant, because by default the repo is checked every few minutes. Webhooks can make it faster.

## Further reading

- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [OpenGitOps principles](https://opengitops.dev/)
- [Flux](https://fluxcd.io/)
