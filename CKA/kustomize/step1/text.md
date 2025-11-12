### Configure the Dev Environment with Kustomize

In this step, you will customize the development environment for the database using Kustomize.  

You will:

- In your home directory, inside the `app` folder, create an `overlays` folder with a `subfolder dev`. Place the `kustomization.yaml` file inside `overlays/dev`.
- Update the MySQL image to `mysql:dev`.
- Add the label `env: dev` to all resources.
- Create a `patch.json` file to set the environment variable `DEBUG=true`.
- In the same `patch.json`, define an initContainer using the BusyBox image to adjust permissions on `/var/lib/mysql`.
- Create a ConfigMap named `db_host` with database host and password.
- Create a Secret named `db_secret` with username and password.

After completing these tasks, your **dev** overlay will be ready for deployment.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
~/app
└── overlays
    └── dev
        └── kustomization.yaml
        └── patch.json

# kustomization.yaml
resources:
- ../../base

images:
  - name: mysql
    newName: mysql
    newTag: dev

commonLabels:
  env: dev

configMapGenerator:
- name: db-config
  literals:
    - DB_HOST=localhost
    - DB_PORT=3306

secretGenerator:
- name: db-secret
  literals:
    - USERNAME=admin
    - PASSWORD=asdfqwerty

patches:
- target:
    group: apps
    version: v1
    kind: StatefulSet
    name: mysql
  path: patch.json
  type: json6902

# patch.json
[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/env/-",
    "value": {
      "name": "DEBUG",
      "value": "true"
    }
  },
  {
    "op": "add",
    "path": "/spec/template/spec/initContainers",
    "value": [
      {
        "name": "init-permissions",
        "image": "busybox",
        "command": ["sh", "-c", "chown -R mysql:mysql /var/lib/mysql"],
        "volumeMounts": [
          {
            "name": "mysql_volume",
            "mountPath": "/var/lib/mysql"
          }
        ]
      }
    ]
  }
]
```

</p>
</details>
