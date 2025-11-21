### Modify the Helm Chart Templates

After generating the base chart, tailor it for a MongoDB database:

Inside the templates/ directory:

- Remove default templates: `deployment.yaml`, `service.yaml`, `hpa.yaml`, `httproute.yaml`, `ingress.yaml`, `serviceaccount.yaml`.

- Move all provided YAML files from the `~/` (home directory) into `templates/`.

**StatefulSet**:

- Use the values defined in `_helpers.tpl` for the resource name, `metadata.labels`, `spec.selector.matchLabels`, and `template.metadata.labels`.

- Configure **replicas** (`.Values.replicaCount`), **container image** (`.Values.image.repository`) and **tag** (`.Values.image.tag`), **port container** (use with + toYaml for the ports section, `.Values.statefulset.port`) via `values.yaml`.

- Add a toggle (`.Values.statefulset.enabled`) in `values.yaml` to enable or disable the creation of the statefulset at will.

**Headless Service**:
- Create a named for the headless service (.Values.service.headlessName) via `values.yaml`

- Make ports (use with + toYaml for the ports section, `.Values.service.port`) configurable via `values.yaml`.

- Only create the service if the StatefulSet is enabled.

<details>
<summary>Click here to see helpers.tpl</summary>
<p>

```bash
{{- define "database-app.labels" -}}
app.kubernetes.io/name: {{ include "database-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "database-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "database-app.name" . }}
{{- end }}

{{- define "database-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end }}

{{- define "database-app.name" -}}
{{ .Chart.Name }}
{{- end }}
```
</p>
</details>

<details>
<summary>Show commands / answers</summary>
<p>

```bash
# Navigate to the templates directory
cd database-app/templates

# Remove the default templates
rm deployment.yaml service.yaml hpa.yaml httproute.yaml ingress.yaml serviceaccount.yaml

# Return to the home directory
cd

# Move the provided templates to the templates/ directory
mv statefulset.yaml headless-service.yaml database-app/templates/

# templates/statefulset.yaml

{{- if .Values.statefulset.enabled }}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "database-app.fullname" . }}
  labels:
    {{- include "database-app.labels" . | nindent 4 }}
spec:
  serviceName: {{ .Values.service.headlessName }}
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "database-app.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "database-app.labels" . | nindent 8 }}
    spec:
      containers:
        - name: mongo
          image: "{{ .Values.statefulset.image.repository }}:{{ .Values.statefulset.image.tag }}"
          ports:
            {{- with .Values.statefulset.port }}
            {{- toYaml . | nindent 12 }}
            {{- end }}
          env:
          - name: MONGO_INITDB_ROOT_USERNAME
            value: mongoadmin
          - name: MONGO_INITDB_ROOT_PASSWORD
            value: 123456789
{{- end }}

# templates/headless-service.yaml

{{- if .Values.statefulset.enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.service.headlessName }}
  labels:
    {{- include "database-app.labels" . | nindent 4 }}
spec:
  clusterIP: None
  selector:
    {{- include "database-app.selectorLabels" . | nindent 4 }}
  ports:
    {{- with .Values.service.port }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
```

</p>
</details>
