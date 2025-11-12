### Configure the Prod Environment with Kustomize

In this step, you will customize the production environment for the database using Kustomize.  

You will:

- Update the MySQL image to `mysql:prod`.
- Add the label `env: prod` to all resources.
- Create a ConfigMap named `db_host` with the host `mysql-prod.company.local` and port `3306`.
- Create a Secret named `db_secret` with the username `prod_admin` and password `G7hT9pX2!zQ4`.
- Use `patch-prod.json` to add tolerations for nodes with the taint `prod=true:NoSchedule`.
- In the same `patch-prod.json`, define resource requests and limits for CPU and memory:
  - Requests: cpu: `500m`, memory: `1Gi`
  - Limits: cpu: `1`, memory: `2Gi`

After completing these tasks, your **prod** overlay will be ready for deployment.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
~/app
└── overlays
    └── prod
        └── kustomization.yaml
        └── patch-prod.json

# kustomization.yaml
resources:
- ../../base

images:
  - name: mysql
    newName: mysql
    newTag: prod

commonLabels:
  env: prod

configMapGenerator:
- name: db-config
  literals:
    - DB_HOST=mysql-prod.company.local
    - DB_PORT=3306

secretGenerator:
- name: db-secret
  literals:
    - USERNAME=prod_admin
    - PASSWORD=G7hT9pX2!zQ4


patches:
- target:
    group: apps
    version: v1
    kind: StatefulSet
    name: mysql_app
  path: patch-prod.json
  type: json6902

# patch-prod
[
  {
    "op": "add",
    "path": "/spec/template/spec/tolerations",
    "value": [
      {
        "key": "prod",
        "operator": "Equal",
        "value": "true",
        "effect": "NoSchedule"
      }
    ]
  },
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/resources",
    "value": {
      "requests": {
        "cpu": "500m",
        "memory": "1Gi"
      },
      "limits": {
        "cpu": "1",
        "memory": "2Gi"
      }
    }
  }
]
```

</p>
</details>
