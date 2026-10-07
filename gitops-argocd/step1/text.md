# Step 1: Wait for the environment

Right now a script is preparing the cluster in the background. You can follow what it is doing in the terminal.

First it waits until the Kubernetes node is ready, and then it installs Argo CD `v3.5.3` in the `argocd` namespace. We use a fixed version so that the tutorial works the same every time you run it.

The script also changes some settings for us:

- the Argo CD server uses HTTP, because Killercoda already puts HTTPS in front of it
- the self-heal backoff is only 5 seconds, so you don't have to wait long to see the healing in step 4
- it downloads the `Application` manifest that we will use in step 3
- it opens the web UI on port 8080

We made the installation automatic because installing Argo CD is not really what this tutorial is about. The application however is **not** deployed yet, you will do that yourself in step 3.

> Note: This usually takes less than two minutes, so you can read the introduction again while you wait if you want 😉

Click **CHECK** when you see `Argo CD is ready` in the terminal.
