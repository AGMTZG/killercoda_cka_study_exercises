### Generate a new private key, CSR, and sign it using the internal Kubernetes CA

The certificates identified in the previous step as nearing expiration are: apiserver, scheduler, controller-manager, and etcd-server. In this step, you will:

- Generate a new 2048-bit private key.

- Create a certificate signing request (CSR) using the key, specifying the Common Name (CN) that corresponds to the component or service the certificate will secure.

- Sign the CSR with the cluster’s internal Kubernetes Certificate Authority (CA) to issue a valid certificate with a 365-day validity.

- Restart the kubelet to apply the updated certificates.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Step 1: Generate the private key (replace *** with the certificate name)
sudo openssl genrsa -out /etc/kubernetes/pki/***.key 2048
sudo openssl genrsa -out /etc/kubernetes/pki/etcd/***.key 2048

# Step 2: Check the Common Name (CN) of a certificate (replace *** with the certificate name)
openssl x509 -in /etc/kubernetes/pki/***.crt -noout -subject
openssl x509 -in /etc/kubernetes/pki/etcd/***.crt -noout -subject

# Step 3: Create a Certificate Signing Request (CSR)
sudo openssl req -new -key /etc/kubernetes/pki/***.key \
  -out /etc/kubernetes/pki/***.csr \
  -subj "/CN=<common name>"

sudo openssl req -new -key /etc/kubernetes/pki/etcd/***.key \
  -out /etc/kubernetes/pki/etcd/***.csr \
  -subj "/CN=<common name>"

# Step 4: Sign the certificate using the internal Kubernetes CA
sudo openssl x509 -req -in /etc/kubernetes/pki/***.csr \
  -CA /etc/kubernetes/pki/ca.crt \
  -CAkey /etc/kubernetes/pki/ca.key \
  -CAcreateserial \
  -out /etc/kubernetes/pki/***.crt \
  -days 365

sudo openssl x509 -req -in /etc/kubernetes/pki/etcd/***.csr \
  -CA /etc/kubernetes/pki/ca.crt \
  -CAkey /etc/kubernetes/pki/ca.key \
  -CAcreateserial \
  -out /etc/kubernetes/pki/etcd/***.crt \
  -days 365

# Restart kubelet
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart kubelet
```

</p>
</details>
