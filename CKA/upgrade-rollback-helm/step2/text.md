### Upgrade the chart configuration, then inspect the changes and troubleshoot any issues

In this step, the Nginx release will be upgraded to apply a pre-prepared custom server configuration, and you will verify that the changes are correctly applied to the deployment and that the server continues to operate as expected.

Tasks:

- Review the installed **bitnami/nginx** Helm chart values and locate the `serverBlock` section to understand how to provide a custom configuration through chart parameters.

- Use the pre-prepared file `custom-server-blocks.conf` located in your **home directory** to upgrade the **Nginx** release `my-nginx-release` by setting the `serverBlock` parameter.

- Inspect the release and pods to verify that the configuration is applied correctly and working as expected.

- Save the updated manifests `manifest-custom.yaml` in `/opt/helm/nginx`.

- Save the release status `status-custom.txt` in `/opt/helm/nginx`.


<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Display the default configuration values of the Bitnami Nginx chart
helm show values bitnami/nginx

# Upgrade the release using the pre-prepared custom server block file
helm upgrade my-nginx-release bitnami/nginx --set-file serverBlock=./custom-server-blocks.conf

# Verify the applied values
helm get values my-nginx-release

# Inspect release status to check for pod failures due to the intentional error
helm status my-nginx-release > /opt/helm/nginx/status-custom.txt

# Retrieve the complete manifest for reference
helm get manifest my-nginx-release > /opt/helm/nginx/manifest-custom.yaml
```

</p>
</details>
