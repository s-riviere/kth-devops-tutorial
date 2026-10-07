# 1. Wait for the environment

Right now a script is preparing the cluster in the background. First it waits until the Kubernetes node is ready, and then it installs Argo CD `v3.5.3` in the `argocd` namespace. We use a fixed version so the tutorial works the same every time.

The script also changes some settings:

- the Argo CD server uses HTTP, because Killercoda already adds HTTPS in front of it
- the self-heal backoff is only 5 seconds, so you don't have to wait long to see the healing
- it downloads the `Application` manifest for step 3
- it opens the web UI on port 8080

You can see the progress in the terminal. Normally it takes less than two minutes.

We made the installation automatic because it is not the main topic of the tutorial. But the application is not deployed yet, you will do this yourself in step 3.

Click **CHECK** when you see `Argo CD is ready` in the terminal.
