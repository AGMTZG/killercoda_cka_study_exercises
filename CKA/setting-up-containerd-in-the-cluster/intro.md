# Containerd Cluster Setup

**Introduction**: </br> 
In this scenario, you will learn how to install and configure containerd manually to be used as the container runtime for Kubernetes.

**Scenario**: </br>
Your manager created an EC2 instance with an Ubuntu AMI in AWS. He tasked you, as the cluster manager, with installing kubeadm using containerd as the container runtime.

Your tasks:

- SSH into the EC2 instance.

- Install containerd.

- Configure containerd with systemd cgroup driver.

- Install kubeadm, kubelet, and kubectl.

- Initialize the Kubernetes cluster specifying containerd as the CRI and verify that the node appears as Ready

Note: Docker will be uninstalled from the environment. Please wait until the process completes.

References:
[Kubernetes kubeadm setup guide](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)
