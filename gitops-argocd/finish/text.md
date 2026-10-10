# Conclusion

You deployed an app through Argo CD without applying its manifests yourself, broke it twice and watched Argo CD fix it, and in the end changed it with a simple Git commit. You never told it to fix anything, it just keeps repeating the same loop: look at the cluster, compare with Git, fix the difference. Kubernetes controllers work the same way, Argo CD just does it with Git as the input.

## Connection to DevOps

GitOps is Infrastructure as Code with continuous reconciliation. Every change is a commit, so you get history and review for free, and a rollback is a `git revert`. It is also more secure, since the CI pipeline doesn't need access to the cluster, Argo CD pulls from inside.

## Why Argo CD

The main alternative is Flux, which follows the same principles but has no web UI. We chose Argo CD because the UI lets you actually see the drift and the healing, which was the point of this tutorial. We also lowered the self-heal backoff and the Git polling to 5 seconds for the demo, in production you would keep them longer.

## Limitations

To keep it simple the Git repo is local and you commit directly to `main`. In a real setup the repo would be on GitHub or GitLab, changes would go through pull requests, and Argo CD would usually get a webhook on every push instead of polling every 5 seconds.

## When to use it

GitOps makes sense for teams with several clusters or environments that should stay the same, or that need a history of every change. It is less useful when:

- you have secrets, since they can't go in Git as plain text (you need something like Sealed Secrets or SOPS)
- you need an urgent manual fix, because self-healing will revert it
- you manage things outside Kubernetes, like databases or DNS, where you still need Terraform
- it's a small project, where the extra setup is not worth it

## Further reading

- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [OpenGitOps](https://opengitops.dev/)
