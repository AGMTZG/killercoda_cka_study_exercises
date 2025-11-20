### Set Up ClusterRole, ServiceAccount, and ClusterRoleBinding for Prometheus

**Introduction**  
To allow Prometheus to collect metrics from your cluster, we need to configure proper **RBAC (Role-Based Access Control)** permissions. This involves creating a **ClusterRole** that defines what resources Prometheus can access, a **ServiceAccount** for Prometheus to use, and a **ClusterRoleBinding** to link the two.

The ClusterRole specifies which Kubernetes resources Prometheus can monitor and which actions (verbs) it can perform. In this scenario, Prometheus will be able to **get, list, and watch** nodes, services, endpoints, pods, and ingresses.

Task:

- Define a **ClusterRole** that grants permissions to monitor core resources (`nodes`, `services`, `endpoints`, `pods`) under the **core API group**, and the `ingresses` resource under the **extensions API group**, all with the `get`, `list`, and `watch` verbs.

- Create a **ServiceAccount** in the `monitoring` namespace.

- Link both components with a ClusterRoleBinding, all three resources share the name `prometheus`.

- Verify that the resources are created correctly.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Create the Cluster role
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: prometheus
rules:
- apiGroups: [""]
  resources:
  - nodes
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]

# Next, Create the serviceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: prometheus
  namespace: monitoring

# Finally, Create the clusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: prometheus
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: prometheus
subjects:
- kind: ServiceAccount
  name: prometheus
  namespace: monitoring
```

</p>
</details>
