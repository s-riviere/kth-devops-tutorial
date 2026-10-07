# Conclusion

You deployed an app through Argo CD without applying its manifests yourself, then broke it twice and watched Argo CD fix it. You never told it to fix anything, it just keeps repeating the same loop: look at the cluster, compare with Git, fix the difference. Kubernetes controllers work the same way, Argo CD just does it with Git as the input.

## Connection to DevOps

GitOps is Infrastructure as Code with continuous reconciliation. Every change is a commit, so you get history and review for free, and a rollback is a `git revert`. It is also more secure, since the CI pipeline doesn't need access to the cluster, Argo CD pulls from inside.

## Why Argo CD

The main alternative is Flux, which follows the same principles but has no web UI. We chose Argo CD because the UI lets you actually see the drift and the healing, which was the point of this tutorial. We also lowered the self-heal backoff to 5 seconds for the demo, in production you would keep it longer.

## Limitations

We only showed drift from the cluster side. The other direction, pushing a change to Git and seeing the cluster follow, needs write access to the repo and so a GitHub account. With your own fork you could change `replicas: 2` to `3` and see it deployed on the next poll.

## When to use it

GitOps makes sense for teams with several clusters or environments that should stay the same, or that need a history of every change. It is less useful when:

- you have secrets, since they can't go in Git as plain text (you need something like Sealed Secrets or SOPS)
- you need an urgent manual fix, because self-healing will revert it
- you manage things outside Kubernetes, like databases or DNS, where you still need Terraform
- it's a small project, where the extra setup is not worth it

## Further reading

- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [OpenGitOps](https://opengitops.dev/)
