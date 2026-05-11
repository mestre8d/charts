{{/*
Expand the name of the chart.
*/}}
{{- define "voting-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "voting-app.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "voting-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.

NOTE: these intentionally do NOT include `app.kubernetes.io/component`;
callers add the per-resource component label themselves (or use
`voting-app.componentLabels`) so the same helper can be reused across
roles (vote / result / worker / redis / database).
*/}}
{{- define "voting-app.labels" -}}
helm.sh/chart: {{ include "voting-app.chart" . }}
{{ include "voting-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.

These are emitted into BOTH `spec.selector.matchLabels` (immutable on
Deployments) AND `spec.template.metadata.labels`, so they MUST be a
stable, minimal set. Only `app.kubernetes.io/name` and
`app.kubernetes.io/instance` are included; chart version, helm release
service, and the per-component label are deliberately omitted to keep
upgrades safe.
*/}}
{{- define "voting-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "voting-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Component-aware labels. Pass a dict with `context` (the root context)
and `component` (e.g. "vote", "result", "worker", "redis", "database").

Usage:
  {{- include "voting-app.componentLabels" (dict "context" . "component" "vote") | nindent 4 }}
*/}}
{{- define "voting-app.componentLabels" -}}
{{ include "voting-app.labels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
Component-aware selector labels. Same shape as `componentLabels` but
only emits the stable selector subset plus the component label.
*/}}
{{- define "voting-app.componentSelectorLabels" -}}
{{ include "voting-app.selectorLabels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end -}}

{{/*
Create the name of the service account to use.
*/}}
{{- define "voting-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "voting-app.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Create a connection URI for the PostgreSQL dependant service.
*/}}
{{- define "postgres.host" -}}
{{ include "voting-app.fullname" . }}-database-svc.{{ .Release.Namespace }}.svc.{{ .Values.clusterZone }}
{{- end -}}

{{/*
Create a connection URI for the Redis dependant service.
*/}}
{{- define "redis.host" -}}
{{ include "voting-app.fullname" . }}-redis-svc.{{ .Release.Namespace }}.svc.{{ .Values.clusterZone }}
{{- end -}}

{{/*
Resolve the database password.

Order of precedence:
  1. The existing in-cluster Secret (preserves the value across upgrades
     so we don't churn on `helm upgrade`).
  2. An explicit `.Values.database.password`.
  3. A freshly-generated random alphanumeric (24 chars). Only stable for
     the duration of one render — callers MUST persist it via the Secret.

`lookup` returns nil during `helm template` / `--dry-run`, so the chart
still renders cleanly offline; in that mode we fall back to (2) or (3).
*/}}
{{- define "database.password" -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (printf "%s-database-secret" (include "voting-app.fullname" .)) -}}
{{- if and $existing $existing.data (index $existing.data "POSTGRES_PASSWORD") -}}
{{- index $existing.data "POSTGRES_PASSWORD" | b64dec -}}
{{- else if .Values.database.password -}}
{{- .Values.database.password -}}
{{- else -}}
{{- randAlphaNum 24 -}}
{{- end -}}
{{- end -}}
