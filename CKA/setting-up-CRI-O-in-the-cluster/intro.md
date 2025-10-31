# CRI-O Cluster Setup

**Introduction**: </br> 
In this scenario, you will learn how to set up an alternative container runtime, CRI-O, which can be useful when containerd is no longer suitable or stable for your node. Most of the setup is similar to the containerd scenario, with a few minor differences. In fact, it is simpler because CRI-O provides a .deb package, so there is no need to manually move binaries or create a systemd service.

**Scenario**: </br>
Your manager has assigned you to prepare a control plane node that previously hosted a Kubernetes cluster, as containerd is no longer functioning. You need to remove all existing configurations and set up a fresh, clean cluster using kubeadm with the CRI-O container runtime.

Tasks:

- Stop all Kubernetes-related services and the container runtime.

- Run kubeadm reset to clean up the existing cluster.

- Remove all residual Kubernetes and CNI directories.

- Clear iptables rules related to Kubernetes and CNI and delete virtual network interfaces created by CNI plugins (Flannel, Calico, etc.).

- Configure kubelet to explicitly use the appropriate CRI socket.

- Initialize a new cluster with kubeadm init, using a configuration file that specifies the CRI socket.

- Verify the cluster is operational and that nodes are ready (kubectl get nodes).

Note: Docker will be uninstalled from the environment. Please wait until the process completes.
