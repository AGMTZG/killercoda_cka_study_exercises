### Resolving Backend-to-Redis Communication Issues

You are given a Kubernetes namespace called webapp that contains multiple workloads: `frontend`, `backend`, `Redis`, and a `MySQL` database. Each workload has different labels and is managed by **Deployments** or **StatefulSets**.

Several NetworkPolicies are applied in the namespace to control traffic between pods. Your manager has noticed that the `backend` pod cannot connect to `Redis`. 

Task:

Your task is to investigate the resources, labels, and NetworkPolicies to identify why the connection is failing and fix the issue by adjusting the NetworkPolicy configuration. (Don't modify the existing network policies nor add new ones)

- Inspect the **Deployments**, **StatefulSets**, and **Services** in the **webapp** namespace.

- Review the labels assigned to each pod and workload.

- Analyze the existing NetworkPolicies and understand what traffic is allowed or denied.

- Identify why the backend cannot connect to Redis.

- Verify that connectivity is restored.

## Important: Do not add more NetworkPolicies. You may only edit existing NetworkPolicies.
