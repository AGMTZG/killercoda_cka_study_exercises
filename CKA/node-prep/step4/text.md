### Verify hostname and network connectivity

Kubernetes requires each node to have a unique and valid hostname so it can be identified in the cluster.
You also need to make sure the node has a reachable IP address and can communicate with other nodes (if any).

<details>
<summary>Show commands / answers</summary>
<p>

```bash

Verify hostname and network connectivity

hostnamectl
ip addr show
ping <other-node-ip>  # check connectivity with other nodes if any

```

</p>
</details>
