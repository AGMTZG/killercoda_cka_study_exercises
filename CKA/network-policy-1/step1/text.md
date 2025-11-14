### Allow Pod-to-Pod Communication in a Restricted Environment

You are working in the `mercury` namespace, where several NetworkPolicies have already been applied to restrict pod communication.

The system includes:

- **client pod** – periodically requests data from the backend (`server-service:5678`) and sends logs to the logger (`logger-service:9880`).

- **server pod** – exposes an HTTP server on `port 5678`.

- **logger pod** – runs Fluentd to collect logs via HTTP on `port 9880`.

Currently, the client pod cannot access the backend and logger services by their service names due to egress restrictions, even though it can reach the pods by IP.

Your task is to:

- Create a new NetworkPolicy that allows the client pod to reach the backend and logger services using their service names (ClusterIP).

## Do not modify or delete any existing NetworkPolicies

Ensure that only the required traffic is allowed while maintaining existing restrictions.

Once done, you can test connectivity by executing from the client pod:

```bash
kubectl exec -n mercury client-xxx-xxx -- curl -s http://server-service:5678
kubectl exec -n mercury client-xxx-xxx -- curl -s http://logger-service:9880
```

<details>
<summary>Show commands / answers</summary>
<p>

In the `mercury` namespace, the `client` pod was unable to communicate with the `backend` (**server-service:5678**) and `logger` (**logger-service:9880**) using their service names, even though it could reach the pods by IP.
The root cause was that an existing `egress-blocker` NetworkPolicy blocked all outgoing traffic from the `client` pod, including requests to the cluster DNS, preventing service name resolution.
The following NetworkPolicy fixes the issue:


```bash
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ingress-access-client-to-server
  namespace: mercury
spec:
  podSelector:
    matchLabels:
      app: client
  policyTypes:
  - Egress
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: server
    ports:
    - protocol: TCP
      port: 5678
  - to:
    - podSelector:
        matchLabels:
          app: logger
    ports:
    - protocol: TCP
      port: 9880
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: TCP
      port: 53
    - protocol: UDP
      port: 53
```

Now, we can test the connections:

```bash
kubectl exec -n mercury client-xxx-xxx -- curl -s http://server-service:5678
kubectl exec -n mercury client-xxx-xxx -- curl -s http://logger-service:9880
```

</p>
</details>
