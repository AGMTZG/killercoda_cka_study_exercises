### Remove the release and clean up all associated resources

After successfully rolling back to the previous stable version, your manager decided that the Nginx release should be completely removed from the cluster to prevent leftover configurations or confusion with future tests. You will now delete the release and ensure that all related Kubernetes resources are fully cleaned up.

Once the release is deleted, confirm that no pods, services, or Helm references remain in the cluster(also delete the folder `/opt/helm/nginx`).

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
