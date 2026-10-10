# Step 5: Change the app through Git

Now we do it the right way. The repo Argo CD reads from is in `~/my-app-git`, let's change the number of replicas from 2 to 3:

```bash
cd ~/my-app-git
sed -i 's/replicas: 2/replicas: 3/' app/deployment.yaml
git diff
```{{exec}}

You can also open `app/deployment.yaml` with an editor if you prefer. Then commit the change:

```bash
git commit -am "Scale my-app to 3 replicas"
```{{exec}}

There is no `git push` here because Argo CD reads this repo directly through the Git server. In a real project you would push to GitHub or GitLab, usually with a pull request first.

Argo CD sees the new commit within 5 seconds and creates a third Pod. Watch it (`Ctrl+C` to stop):

```bash
watch -n 1 kubectl get deployment my-app
```{{exec}}

In the UI you can also see the new commit in the app details. We never ran `kubectl` to change the app, we only made a commit.

Click **CHECK** when the app has 3 replicas.
