### Simulate a disaster recovery

Now, simulate a disaster recovery scenario by deleting the pods kube-apiserver-controlplane and kube-controller-manager-controlplane in the kube-system namespace.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
kubectl delete pod/kube-apiserver-controlplane pod/kube-controller-manager-controlplane -n kube-system --grace-period=0 --force
```

</p>
</details>
