### Roll back the release to the previous stable version

During the upgrade to apply the **custom server configuration**, a minor intentional misconfiguration in the `custom-server-blocks.conf` file caused the Nginx pods to fail, preventing the deployment from running correctly. To quickly restore a stable environment, you will roll back the Nginx release to the previous version that worked before applying the custom server block.

After performing the rollback, confirm that all pods are running properly and that the configuration has returned to its original state.

Tasks:

- List the available revisions of the `my-nginx-release` Helm release.

- Roll back the release to the previous stable revision.

- Verify that the release values and manifests have been restored to the original configuration.

- Confirm that all pods are running as expected.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# List all available revisions of the release
helm history my-nginx-release

# Roll back to the previous stable revision (before the custom server block upgrade)
helm rollback my-nginx-release 1

# Verify that the release values were restored
helm get values my-nginx-release

# Verify that all pods are running
kubectl get pods
```

</p>
</details>
