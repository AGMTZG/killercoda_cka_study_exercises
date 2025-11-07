### Advanced RBAC: Creating a ServiceAccount and Modifying Kubeconfig

**Introduction**:</br>
In this scenario, you’ll learn how to create a **ServiceAccount** in Kubernetes with limited access to deployments and replicasets in a specific namespace.

**Scenario**:</br>
A CI/CD automation bot called `deploybot` needs to manage **deployments** and **replicasets** in the `appenv` namespace, but it should not have full cluster privileges.

Your goal:
1. Create a **ServiceAccount** for `deploybot`.  
2. Grant it restricted permissions using **RBAC**.  
3. Generate a token for authentication.  
4. Build a **kubeconfig** to allow secure access.  
5. Validate that it has the correct permissions.

Press **Next** to begin.
