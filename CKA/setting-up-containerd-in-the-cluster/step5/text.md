### Initialize the Kubernetes cluster with containerd

Finally, we need to initialize the Kubernetes cluster using kubeadm, specifying containerd as the container runtime.

Note:
Use the --ignore-preflight-errors=NumCPU flag because the instance does not have enough CPU resources to initialize the cluster.

Important: Since we haven’t specified a CNI plugin during kubeadm init, the node will appear as ‘NotReady’ when checked with kubectl get nodes -o wide. You can still verify that the node is using the correct container runtime.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# We initialize the kubernetes cluster
sudo kubeadm init --cri-socket=unix:///var/run/containerd/containerd.sock --ignore-preflight-errors=NumCPU

# To start using kubectl as a regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# We check that containerd runtime and the node are redy
kubectl get nodes -o wide
```

</p>
</details>
