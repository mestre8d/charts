{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "voting-app.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
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
Create the default labels for all components.
*/}}
{{- define "voting-app.labels" -}}
app.kubernetes.io/name: "voting-app"
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ include "voting-app.fullname" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
{{- end -}}


{{/*
Create a connection URI for the PostgreSQL dependant service.
*/}}
{{- define "postgres.host" -}}
  {{ template "voting-app.fullname" . }}-database-svc.{{ template "voting-app.namespace" . }}.svc.{{- .Values.clusterZone -}}
{{- end -}}

{{/*
Create a connection URI for the Redis dependant service.
*/}}
{{- define "redis.host" -}}
  {{ template "voting-app.fullname" . }}-redis-svc.{{ template "voting-app.namespace" . }}.svc.{{ .Values.clusterZone }}
{{- end -}}

{{/*
Create database password template
*/}}
{{- define "database.password" -}}
{{- if .Values.database.password }}
{{- .Values.database.password -}}
{{ else }}
{{- randAlphaNum 24 | nospace -}}
{{ end }}
{{- end -}}