# 1. Wait for the environment

While you read this, a background script is setting up the cluster. It waits for the Kubernetes node to be ready and then installs Argo CD `v3.5.3` in the `argocd` namespace. We pinned the version so the tutorial works the same way every time it is run.

It also changes a few settings:

- the Argo CD server runs on plain HTTP, because Killercoda already puts HTTPS in front of it
- the self-heal backoff is reduced to 5 seconds, otherwise you would have to wait a while to see the healing
- the `Application` manifest for step 3 is downloaded
- the web UI is exposed on port 8080

You can follow the progress in the terminal. Usually it is done in less than two minutes.

We automated the installation because it is not really what this tutorial is about. The application however is not deployed yet, you will do that yourself in step 3.

Click **CHECK** once you see `Argo CD is ready` in the terminal.
