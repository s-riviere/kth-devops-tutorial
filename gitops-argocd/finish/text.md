# Great job! 🎉

You finished the tutorial! Let's go through what you did and think a bit about when this is useful.

## Summary

Here's what you did:

- Argo CD was installed in the cluster and connected to our Git repository
- You created an `Application` pointing to `gitops-argocd/gitops/app/`, and Argo CD deployed the app for you, without you running `kubectl apply` on the app manifests
- You deleted the Service and scaled the Deployment to zero, and both times Argo CD put everything back like in Git in a few seconds

Notice that you never asked Argo CD to fix anything. The fix comes from the reconciliation loop, which repeats the same steps again and again: look at the live state, compare it with the desired state, and change what is different. Kubernetes itself also works like this, for example the ReplicaSet controller makes sure the right number of Pods is running. Argo CD does the same thing, just at a higher level and with Git as the input.

## How is this connected to DevOps?

GitOps is very close to Infrastructure as Code. The configuration of the application is versioned and reviewed like normal code, and with `git log` you can see who changed what and when. It also changes how continuous delivery works: to deploy you merge a commit, and to roll back you can just use `git revert`.

It is also good for security. The CI pipeline doesn't need any credentials for the cluster, because Argo CD pulls the changes from inside the cluster. This means the Kubernetes API doesn't have to be open to a CI runner.

## Why did we choose Argo CD?

The main alternative is Flux. Both follow the GitOps principles and Flux is lighter, but you only use it through the CLI and CRDs and it has no web UI. We chose Argo CD mostly because of the web UI, where you can actually see the drift and the healing happen, and that was the main goal of our tutorial. Argo CD is also a graduated CNCF project and can be installed with one manifest, which made the setup on Killercoda easier.

We also changed two settings for the demo. `timeout.reconciliation.jitter` is set to `0` and the self-heal backoff is maximum 5 seconds, so the healing is fast enough to see. In production you would probably want a longer backoff, so that Argo CD doesn't end up fighting with other controllers that change the same resources.

## Limitations of our tutorial

In this tutorial the drift only came from the cluster side. We didn't show the other direction, where you commit a change to Git and the cluster follows it. For this you would need to push to the GitHub repository, and that needs an account. If you have your own fork you can try it: change `replicas: 2` to `3`, commit it, and Argo CD will deploy it the next time it checks the repo.

## When should you use it?

GitOps is useful for teams with many clusters or environments that need to stay the same, and for companies that need a history of all changes, for example in finance or healthcare. It is also nice for platform teams who want developers to deploy with a pull request, without giving them direct access to the cluster.

But it is not perfect, there are some problems:

- You can't put secrets in Git as plain text, so you need extra tools like Sealed Secrets, SOPS or External Secrets Operator.
- Urgent fixes are harder. With self-healing on, a manual hotfix is reverted in a few seconds (like you saw in step 4!), so you have to go through Git or turn off self-healing first. It is safer, but slower when there is a big problem.
- Argo CD only manages Kubernetes resources. For databases, DNS or cloud networking you still need something like Terraform or Crossplane.
- For a small project with one cluster and one developer, the extra component and repo structure is probably too much work for what you get.
- Changes in Git are not instant, since the repo is checked every few minutes by default. Webhooks can make this faster.

## Want to learn more?

- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [OpenGitOps principles](https://opengitops.dev/)
- [Flux](https://fluxcd.io/)

Thanks for following our tutorial! 👋
