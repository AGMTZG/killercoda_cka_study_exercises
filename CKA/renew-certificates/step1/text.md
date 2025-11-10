### Inspect Certificate Expiration Dates

First, list all the certificates in `/etc/kubernetes/pki` and review their expiration dates.

<details>
<summary>Show commands / answers</summary>
<p>

```bash

# To verify individual certificates, use commands like the following:
sudo openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -enddate
sudo openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -noout -enddate
sudo openssl x509 -in /etc/kubernetes/pki/controller-manager.crt -noout -enddate
sudo openssl x509 -in /etc/kubernetes/pki/scheduler.crt -noout -enddate

# To check the expiration date of all certificates in the directory at once:
for cert in /etc/kubernetes/pki/*.crt; do
    echo "$cert expires on:"
    sudo openssl x509 -in $cert -noout -enddate
done
```

</p>
</details>
