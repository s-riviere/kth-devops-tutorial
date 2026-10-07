# 1. Wait for the environment

A background script is preparing the cluster. It:

- waits for the Kubernetes node to be ready;
- installs Argo CD `v3.5.3` in the `argocd` namespace (pinned so the tutorial behaves the same on every run);
- enables plain HTTP on the Argo CD server, since Killercoda already terminates HTTPS in front of it;
- shortens the self-heal backoff to 5 seconds so you can watch healing happen live;
- downloads the `Application` manifest you will use in step 3;
- exposes the Argo CD web UI on port 8080.

The terminal shows the progress. It usually takes less than two minutes.

Installing Argo CD is not the interesting part of this tutorial, which is why it is automated. The Argo CD *application* is deliberately **not** deployed yet: you will do that yourself.

Click **CHECK** when `Argo CD is ready` appears in the terminal.
