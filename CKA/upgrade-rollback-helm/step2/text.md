### Upgrade the chart configuration, then inspect the changes and troubleshoot any issues

After the initial deployment, your manager has requested that the Nginx release be upgraded to enable TLS using certificates stored in your home directory. This will modify the existing release configuration to include the TLS secrets and update the corresponding Kubernetes resources, such as deployments, services, and pods.

Once the upgrade is applied, you will inspect the release to ensure that the new TLS configuration is correctly applied, verify that all pods are running as expected, and troubleshoot any issues that may arise during the upgrade.

The updated manifests (**manifest-tls.yaml**), and release status (**status-tls.txt**) should be saved in `/opt/helm/nginx` as well.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Display the default configuration values of the Bitnami Nginx chart
# and review the TLS section to understand available parameters.
helm show values bitnami/nginx

# Upgrade the release
helm upgrade my-nginx-release bitnami/nginx --set tls.enabled=true --set-file tls.cert=./cert.pem --set-file tls.key=./certKeyA.pem

# Verify that the values were applied correctly
helm get values my-nginx-release

# Display detailed status of the Helm release
helm status my-nginx-release > /opt/helm/nginx/status-tls.txt

# Retrieve the complete manifest generated for the release
helm get manifest my-nginx-release > /opt/helm/nginx/manifest-tls.yaml
```

</p>
</details>
