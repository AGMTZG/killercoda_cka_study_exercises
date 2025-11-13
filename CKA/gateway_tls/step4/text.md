### Test the Gateway and Clean Up the Old Ingress

Since this exercise involves migrating from Ingress to Gateway, you should remove any existing Ingress resources.

Note: Deleting the entire ingress-nginx namespace will automatically clean up all related resources. This may take a few moments.

Because the cluster is running locally, you also need to update your `/etc/hosts` file so that the following hostnames resolve correctly ( you need to add the external ip from the gateway ):

|Host               | Path      | Backend Service |
|-------------------|-----------|-----------------|
|app.home.local     |  /	    | home-svc        |
|app.home.local	    |  /sales   | sales-svc       |
|app.contact.local  |  /contact | contact-svc     |
|app.contact.local  |  /about   | about-us-svc    |

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Delete the Ingress namespace (this will remove all Ingress-related resources)
kubectl delete ns ingress-nginx

# We check the external ip from the gateway
kubectl get gateway

# Update the /etc/hosts file to resolve the application domains locally
sudo vim /etc/hosts
<external ip from gateway>    app.home.local
<external ip from gateway>    app.contact.local

or

echo "<external ip from gateway>   app.home.local" | sudo tee -a /etc/hosts
echo "<external ip from gateway>   app.contact.local" | sudo tee -a /etc/hosts

# Test the Gateway endpoints, for http
curl http://app.home.local/
curl http://app.home.local/sales
curl http://app.contact.local/contact
curl http://app.contact.local/about

# For https
curl -k https://app.home.local/
curl -k https://app.home.local/sales
curl -k https://app.contact.local/contact
curl -k https://app.contact.local/about
```

</p>
</details>
