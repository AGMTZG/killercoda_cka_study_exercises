### Initialize Kubernetes cluster with kubeadm using CRI-O

Finally, we need to initialize the Kubernetes cluster using kubeadm, specifying CRI-O as the container runtime.

Note:
Use the --ignore-preflight-errors=NumCPU flag because the instance does not have enough CPU resources to initialize the cluster.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We initialize the kubernetes cluster
sudo kubeadm init --cri-socket=unix:///var/run/crio/crio.sock --ignore-preflight-errors=NumCPU

# To start using kubectl as a regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# We check that crio runtime and the node are ready
kubectl get nodes -o wide
```

</p>
</details>
