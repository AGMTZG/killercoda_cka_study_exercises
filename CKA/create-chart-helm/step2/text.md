### Update Helm Helper Templates

The next step is to create Helm helper templates. These helpers will allow you to generate consistent resource names and labels across all your Kubernetes objects.

Tasks:

- Delete the `_helpers.tpl` file in the `templates/` directory and create a new one.
- Define a function `database-app.fullname` that generates a unique name for your resources by combining the **release name**, a **hyphen**, and the **chart name**.
- Define a function `database-app.labels` that generates a consistent set of labels for all resources, using the following keys: `app.kubernetes.io/name` for the application name and `app.kubernetes.io/instance` for the release name.
- Define a function `database-app.selectorLabels` that provides the minimal set of labels for resource selectors, using the key: `app.kubernetes.io/name` for the application name.

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Navigate to the templates directory
cd database-app/templates

# Remove the existing _helpers.tpl if it exists and create a new one
rm -f _helpers.tpl
touch _helpers.tpl

# _helpers.tpl

{{- define "fullstack-app.labels" -}}
app.kubernetes.io/name: {{ include "fullstack-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "fullstack-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fullstack-app.name" . }}
{{- end }}

{{- define "fullstack-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}
```

</p>
</details>


