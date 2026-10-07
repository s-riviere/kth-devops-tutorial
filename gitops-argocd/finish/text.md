# Conclusion

## What you did

1. Argo CD was installed in the cluster and connected to a Git repository.
2. You created an `Application` that points Argo CD to `gitops-argocd/gitops/app/`, and Argo CD deployed it without you running `kubectl apply` on the app manifests.
3. You deleted the Service and scaled the Deployment to zero. Argo CD saw the live state diverge from Git and restored it in a few seconds.

At no point did you tell Argo CD to "fix" anything. The repair came from the reconciliation loop: observe the live state, compare it with the desired state, act on the difference, repeat. Kubernetes controllers already work this way for Pods and ReplicaSets; Argo CD applies the same loop one level higher, with Git as the input.

## How this relates to DevOps

- **Infrastructure as Code**: the application's configuration is versioned, reviewed and auditable like any other code. `git log` tells you who changed what and when.
- **Continuous delivery**: deploying becomes merging a commit. Rolling back becomes `git revert`.
- **Security**: CI never needs credentials to the cluster. Argo CD pulls from inside, so the cluster API does not have to be exposed to a CI runner.

## Why Argo CD

We picked Argo CD because it is a CNCF graduated project, it ships a web UI that makes drift visible (useful for learning), and it can be installed with a single manifest. **Flux** is the main alternative. It follows the same GitOps principles, is lighter, and is driven entirely by CLI and CRDs, but has no built-in UI. For a tutorial whose goal is to *see* reconciliation, the UI made Argo CD the better fit.

Two settings were changed for the demo: `timeout.reconciliation.jitter` set to `0` and a self-heal backoff capped at 5 seconds, so that healing is fast enough to watch. Production setups usually keep longer backoffs to avoid fighting with other controllers.

## Limitations of this tutorial

You only created drift from the cluster side. The other half of GitOps, changing the desired state by committing to Git and watching the cluster follow, is not shown here because the repository is on GitHub and you cannot push to it without an account. With a fork, you would change `replicas: 2` to `3`, commit, and Argo CD would roll it out on its next poll.

## When GitOps fits, and when it does not

**Good fit:**
- Teams running several Kubernetes clusters or environments that must stay identical.
- Organisations that need an audit trail of every change (finance, healthcare, regulated industries).
- Platform teams who want developers to deploy by opening a pull request, without cluster access.

**Poor fit or extra work needed:**
- **Secrets** cannot be stored in Git as plain text. You need extra tooling such as Sealed Secrets, SOPS or the External Secrets Operator.
- **Emergency fixes**: with self-healing on, a manual hotfix is reverted within seconds. The fix has to go through Git, or self-healing has to be paused first. This is safer but slower under pressure.
- **Non-Kubernetes infrastructure** (databases, DNS, cloud networking) is outside Argo CD's reach. Terraform or Crossplane is still needed there.
- **Small projects** with one cluster and one developer may find the extra component and repository structure more overhead than benefit.
- **Delay**: Git is polled every few minutes by default. Webhooks reduce it, but a change is never instant.

## Further reading

- [Argo CD documentation](https://argo-cd.readthedocs.io/)
- [OpenGitOps principles](https://opengitops.dev/)
- [Flux](https://fluxcd.io/)
