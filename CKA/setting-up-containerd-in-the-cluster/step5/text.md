### Initialize the Kubernetes cluster with containerd

Finally, we need to initialize the Kubernetes cluster using kubeadm, specifying containerd as the container runtime.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We initialize the kubernetes cluster
sudo kubeadm init --cri-socket=unix:///var/run/containerd/containerd.sock

# To start using kubectl as a regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# We check that containerd runtime and the node are redy
kubectl get nodes -o wide
```

</p>
</details>
