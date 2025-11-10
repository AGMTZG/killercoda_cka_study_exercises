**Congratulations!**

You have successfully renewed the Kubernetes control plane certificates manually.

Notes:

- Kubernetes certificates are stored under `/etc/kubernetes/pki/` and are critical for secure communication between control plane components.
- You can manually create, sign, and replace certificates using the internal CA when `kubeadm` is not available.
- Always verify certificate expiration dates and validity before replacing them.

Well done!
