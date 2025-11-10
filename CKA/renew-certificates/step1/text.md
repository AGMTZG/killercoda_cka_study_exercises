### Inspect Certificate Expiration Dates

First, list all the certificates in `/etc/kubernetes/pki` and `etc/kubernetes/pki/etcd` and review their expiration dates.

<details>
<summary>Show commands / answers</summary>
<p>

```bash

# To verify an individual certificate, use a command like the following (replace *** with the certificate file name):
sudo openssl x509 -in /etc/kubernetes/pki/***.crt -noout -enddate
sudo openssl x509 -in /etc/kubernetes/pki/etcd/***.crt -noout -enddate

# To check the expiration date of all certificates at once:
for cert in $(find /etc/kubernetes/pki -name "*.crt"); do
    echo "$cert expires on:"
    sudo openssl x509 -in "$cert" -noout -enddate
done
```

</p>
</details>
