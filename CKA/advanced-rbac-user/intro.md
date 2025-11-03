### Advanced RBAC: Creating a Role, RoleBinding, and Modifying Kubeconfig

**Introduction**:</br>
In this scenario, you’ll learn how to create a new Kubernetes user (`alice`) with restricted access to a single namespace (`projectx`) using Role-Based Access Control (RBAC).

**Scenario**:</br>
You are the Kubernetes administrator. A new developer named **alice** needs limited permissions in the **projectx** namespace. She should be able to:
- list
- get
- update
- delete
- create pods

Your goal is to:
1. Generate and sign a client certificate for alice.  
2. Create a **Role** and **RoleBinding** that define and grant access.  
3. Configure a **kubeconfig** file so alice can connect securely.  
4. Test her permissions using `kubectl auth can-i`.


Press **Next** to begin.
