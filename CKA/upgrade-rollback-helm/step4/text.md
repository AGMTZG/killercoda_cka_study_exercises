### Remove the release and clean up all associated resources

After successfully rolling back to the previous stable version, you waited for further instructions from your manager. As no additional testing or configuration changes were requested, it was clear that the best course of action was to **delete the temporary Nginx release**, freeing cluster resources and preventing leftover configurations from causing confusion in future tests.

Tasks:

- Uninstall the Helm release `my-nginx-release`.

- Verify that the release is no longer listed by Helm.

- Ensure that no pods, services, or other Kubernetes resources remain related to the release.

- Delete the folder `/opt/helm/nginx` containing saved manifests and status files.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Uninstall the Helm release
helm uninstall my-nginx-release

# Verify that the release is no longer listed
helm list

# Ensure no related resources remain in the namespace
kubectl get all -l app.kubernetes.io/instance=my-nginx-release

# Remove saved manifests and status files
rm -rf /opt/helm/nginx
```

</p>
</details>
