### Install kubeadm, kubelet and kubectl

Next, we need to install kubeadm, kubelet and kubectl 

You can follow the official documentation for reference:

[Kubernetes kubeadm setup guide](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)

Note: The environment is already prepared for the installation of these tools. You do not need to perform any additional node setup, simply proceed to install them.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Kubernetes installation version 1.34
sudo apt-get update

sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update

sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet
```

</p>
</details>
