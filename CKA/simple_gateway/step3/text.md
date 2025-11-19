### Step 3: Install MetalLB and Configure LoadBalancer

In local Kubernetes clusters like Minikube or kubeadm, Services of type `LoadBalancer` cannot obtain an external IP by default because there is no cloud provider to provision it. MetalLB solves this limitation by providing a software-based LoadBalancer that can assign external IPs to Services within your cluster.

Using MetalLB allows you to simulate real cloud LoadBalancer behavior locally, making it possible to expose services such as Gateways externally and test routing and traffic management.

MetalLB assigns external IPs from a defined IP pool. Without this pool, it wouldn’t know which addresses are safe to use, and LoadBalancer Services would fail to receive an external IP.

**Note:** In Minikube, installing MetalLB is optional. You can simply use `minikube tunnel` to assign external IPs to LoadBalancer Services.

**Tasks:**

1. Apply the MetalLB manifests and wait for the pods to become ready. You can monitor their status in the `metallb-system namespace`. Use the following command to deploy MetalLB. Make sure all MetalLB pods are running before proceeding.

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.9/config/manifests/metallb-native.yaml
```

2. Find the network interface used by your kubeadm cluster.

```bash
# Run this command to check your network interfaces.
ip addr show

# Example output for the main network interface:
enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether ee:4f:d8:00:fe:29 brd ff:ff:ff:ff:ff:ff
    inet 172.30.1.2/24 brd 172.30.1.255 scope global dynamic noprefixroute enp1s0
    inet6 fe80::434:4cd3:e11f:8178/64 scope link

# The main network interface is: enp1s0 with IP: 172.30.1.2/24.
# This means your local network is in the 172.30.1.0/24 subnet.
# Choose a small block of free IP addresses within this range for MetalLB, for example:

172.30.1.240-172.30.1.250
```
3. Create an IP pool named `lb-pool` in the namespace `metallb-system` using the range you determined. Use the following manifest:

```bash
# ip.yaml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: lb-pool
  namespace: metallb-system
spec:
  addresses:
  - 172.30.1.240-172.30.1.250

kubectl create -f ip.yaml
```

