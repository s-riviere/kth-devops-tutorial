# Step 1: Wait for the environment

A script is installing Argo CD (`v3.5.3`) in the background, you can see the progress in the terminal. We automated this because the installation is not what this tutorial is about.

It also creates the Git repository `~/my-app-git` with our manifests and starts a Git server so Argo CD can read it. For the demo it lowers the self-heal backoff and the Git polling to 5 seconds, so you don't have to wait long in steps 4 and 5.

Click **CHECK** when you see `Argo CD is ready`.
