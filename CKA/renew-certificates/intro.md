# Renew the certificates

**Introduction**
In this exercise, you will work with TLS certificates used by Kubernetes components.  
You’ll inspect existing certificates, generate new ones, and ensure secure communication between services remains intact.

**Scenario**

You are the administrator of a Kubernetes cluster. The control plane certificates are about to expire, and kubeadm is unavailable. You need to regenerate the certificates manually using the cluster’s internal CA to ensure all components continue to communicate securely.

Tasks:

- Inspect the current certificate expiration dates

- List all **.crt** files in `/etc/kubernetes/pki` and check their expiration dates using openssl.

- Generate a new private 2048-bit RSA key for the expired certificates.

- Use the CA certificate and key from `/etc/kubernetes/pki` to sign the CSRs, set a 1-year (365-day) validity period, and replace the existing certificates and keys.

Note:

- Back up the expired certificate files.

- Replace them with the newly generated certificates.

- Restart the kubelet service to apply the changes.

Press **Next** to begin.
