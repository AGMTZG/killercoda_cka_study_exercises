### Test the Gateway and Clean Up the Old Ingress

Since we’re migrating from Ingress to Gateway, you need to remove the old Ingress resources.

Note: You can delete the entire Ingress-NGINX namespace to automatically remove all its resources. This process may take a few moments to complete.

Because this setup runs on localhost, you must also update your /etc/hosts file to properly resolve the endpoints.

|Host                  | Path        | Backend Service | Listeners name     | port | image |
|----------------------|-------------|-----------------|--------------------|------|-------|
|app.company.local     |  /	         | web-app         | http-app           | 80   | nginx |
|app.company.local	   |  /dashboard | dashboard-app   | http-app           | 80   | nginx |
|orders.company.local  |  /          | orders-app      | http-orders        | 80   | nginx |
|orders.company.local  |  /reports   | reports-app     | http-orders        | 80   | nginx |

You can test your Gateway configuration using curl commands against these endpoints.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Delete the Ingress namespace (this will remove all Ingress-related resources)
kubectl delete ns ingress-nginx

# Update the /etc/hosts file to resolve the application domains locally
echo "127.0.0.1   app.company.local" | sudo tee -a /etc/hosts
echo "127.0.0.1   orders.company.local" | sudo tee -a /etc/hosts

# Test the Gateway endpoints
curl http://app.company.local/
curl http://app.company.local/dashboard
curl http://orders.company.local/
curl http://orders.company.local/reports
```

</p>
</details>
