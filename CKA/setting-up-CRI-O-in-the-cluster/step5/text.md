### Initialize Kubernetes cluster with kubeadm using CRI-O

Before initializing the cluster, Killercoda configures the kubelet service to source /etc/default/kubelet, which may force the kubelet to use containerd. Update the line to point to CRI-O:
KUBELET_EXTRA_ARGS="--container-runtime-endpoint=unix:///var/run/crio/crio.sock".

In a normal kubelet setup this isn’t needed, as kubeadm init --cri-socket sets the runtime. But since Killercoda uses /etc/default/kubelet, specifying --cri-socket is optional.

Then, initialize the Kubernetes cluster with kubeadm using CRI-O.

Note:
Use the --ignore-preflight-errors=NumCPU flag because the instance does not have enough CPU resources to initialize the cluster.
If you get errors like something is using port <number> when using kubeadm init, run:

```bash
sudo lsof -i :6443

# Terminate the processes listening on the port, not established connections.
sudo kill <PID>
```

Important: Since we haven’t specified a CNI plugin during kubeadm init, the node will appear as ‘NotReady’ when checked with kubectl get nodes -o wide. You can still verify that the node is using the correct container runtime.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# First, we modify /etc/default/kubelet
vim /etc/default/kubelet

# We search for
KUBELET_EXTRA_ARGS="--container-runtime-endpoint=unix:///run/containerd/containerd.sock"

# Change it
KUBELET_EXTRA_ARGS="--container-runtime-endpoint=unix:///var/run/crio/crio.sock"

# We restart kubelet
sudo systemctl daemon-reload
sudo systemctl restart kubelet

# We initialize the kubernetes cluster
sudo kubeadm init --ignore-preflight-errors=NumCPU

# To start using kubectl as a regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# We check that crio runtime and the node are ready
kubectl get nodes -o wide
```

</p>
</details>
