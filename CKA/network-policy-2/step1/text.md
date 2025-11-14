### Resolving Backend-to-Redis Communication Issues

You are given a Kubernetes namespace called `webapp` that contains multiple workloads: `frontend`, `backend`, `Redis`, and a `MySQL` database. Each workload has different labels and is managed by **Deployments** or **StatefulSets**.

Several NetworkPolicies are applied in the namespace to control traffic between pods. Your manager has noticed that the `backend` pod cannot connect to `Redis`. 

Task:

Your task is to investigate the resources, labels, and NetworkPolicies to identify why the connection is failing and fix the issue by adjusting the NetworkPolicy configuration. (Don't modify the existing network policies nor add new ones)

- Inspect the **Deployments**, **StatefulSets**, and **Services** in the **webapp** namespace.

- Review the labels assigned to each pod and workload.

- Analyze the existing NetworkPolicies and understand what traffic is allowed or denied.

- Identify why the `backend` cannot connect to `Redis`.

- Verify that connectivity is restored.

## Important: Do not add more NetworkPolicies. You may only edit existing NetworkPolicies.

<details>
<summary>Show commands / answers</summary>
<p>

First, get an overview of all deployments in all namespaces:

```bash
kubectl get deploy -A

NAMESPACE     NAME                      READY   UP-TO-DATE   AVAILABLE   AGE
kube-system   calico-kube-controllers   1/1     1            1           35m
kube-system   coredns                   1/1     1            1           35m
webapp        backend                   3/3     3            3           8m40s
webapp        frontend                  3/3     3            3           8m40s
webapp        redis                     3/3     3            3           8m40s
```
Check the pods and deployments specifically in the 'webapp' namespace for the backend:

```bash
kubectl get po,deploy -n webapp | grep backend

pod/backend-59dc864466-ddd5b   1/1     Running   0          10m
pod/backend-59dc864466-tfxnd   1/1     Running   0          10m
pod/backend-59dc864466-wlr44   1/1     Running   0          11m
deployment.apps/backend    3/3     3            3           11m
```

Verify the image used by the `backend` deployment:

```bash
kubectl describe deploy backend -n webapp | grep -i Image

Image: busybox
```
Output shows **busybox**, so we can use **wget** or **nc** from the pod

Get IP addresses of redis pods in the `webapp` namespace:

```bash
kubectl get po,deploy -n webapp -o wide | grep -i redis

pod/redis-b5465c746-dvzpj      1/1     Running   0          19m   10.244.120.76   minikube   <none>           <none>
pod/redis-b5465c746-gs722      1/1     Running   0          19m   10.244.120.73   minikube   <none>           <none>
pod/redis-b5465c746-lc6x6      1/1     Running   0          19m   10.244.120.75   minikube   <none>           <none>
deployment.apps/redis      3/3     3            3           19m   redis        redis:alpine   service=redis
```

Confirm the port that the `redis` deployment is using:

```bash
kubectl describe deploy redis -n webapp | grep -i Port
Port:       6379/TCP
```

Attempt to connect from a `backend` pod to a `redis` pod

```bash
kubectl exec -it backend-59dc864466-ddd5b -n webapp -- nc -vz 10.244.120.79 6379

# We get:
nc: connect to 10.244.120.79 port 6379 (tcp) failed: Connection refused
command terminated with exit code 1
# Connection fails -> likely blocked by a NetworkPolicy
```

Check labels on `redis` pods

```bash
kubectl describe po redis-b5465c746-dvzpj -n webapp | grep -i labels -A10

Labels: pod-template-hash=b5465c746
        service=redis
```

# Same with backend
```bash
kubectl describe po backend-59dc864466-ddd5b -n webapp | grep -i labels -A10

Labels: component=alpha
        pod-template-hash=59dc864466
        role=internal
        service=backend
```


List all network policies in the `webapp` namespace

```bash
kubectl describe netpol -n webapp

Name:         http-access
Namespace:    webapp
Created on:   2025-10-10 12:24:50 -0600 CST
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     tier=presentation
  Allowing ingress traffic:
    To Port: 80/TCP
    From: <any> (traffic not restricted by source)
  Not affecting egress traffic
  Policy Types: Ingress


Name:         ingress-from-local-environment
Namespace:    webapp
Created on:   2025-10-10 12:24:50 -0600 CST
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     <none> (Allowing the specific traffic to all pods in this namespace)
  Allowing ingress traffic:
    To Port: <any> (traffic allowed to all ports)
    From:
      NamespaceSelector: kubernetes.io/metadata.name in (webapp)
  Not affecting egress traffic
  Policy Types: Ingress


Name:         internal-role-access
Namespace:    webapp
Created on:   2025-10-10 12:24:50 -0600 CST
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     component=alpha
  Allowing ingress traffic:
    To Port: <any> (traffic allowed to all ports)
    From:
      PodSelector: component=alpha,role=internal,service=backend
  Not affecting egress traffic
  Policy Types: Ingress
```

Observing `internal-role-access` network policy:
- spec.PodSelector: component=alpha
- ingress.from.podSelector: matches all labels of backend pods
- Redis pods need 'component: alpha' to allow access from backend pods

```bash
kubectl edit deploy redis -n webapp

  selector:
    matchLabels:
      service: redis # You cannot change this, because is immutable
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        service: redis
        component: alpha
```

After updating, try connecting again from the `backend` pod

```bash
kubectl exec -it backend-59dc864466-ddd5b -n webapp -- nc -vz 10.244.120.79 6379

# We get:
10.244.120.79 (10.244.120.79:6379) open

# Connection succeeds -> NetworkPolicy allows traffic now
```

</p>
</details>
