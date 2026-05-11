{{/*
Expand the name of the chart.
*/}}
{{- define "rathena.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rathena.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rathena.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rathena.labels" -}}
helm.sh/chart: {{ include "rathena.chart" . }}
{{ include "rathena.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rathena.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rathena.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component labels (combine common labels with app.kubernetes.io/component).
Usage: {{ include "rathena.componentLabels" (dict "context" . "component" "login-server") }}
*/}}
{{- define "rathena.componentLabels" -}}
{{ include "rathena.labels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Component selector labels.
Usage: {{ include "rathena.componentSelectorLabels" (dict "context" . "component" "login-server") }}
*/}}
{{- define "rathena.componentSelectorLabels" -}}
{{ include "rathena.selectorLabels" .context }}
app.kubernetes.io/component: {{ .component }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rathena.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rathena.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
