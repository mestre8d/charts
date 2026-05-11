{{/*
Expand the name of the chart.
*/}}
{{- define "romm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "romm.fullname" -}}
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
{{- define "romm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "romm.labels" -}}
helm.sh/chart: {{ include "romm.chart" . }}
{{ include "romm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: server
app.kubernetes.io/part-of: {{ include "romm.name" . }}
{{- end }}

{{/*
Selector labels (immutable: only name + instance).
*/}}
{{- define "romm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "romm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "romm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "romm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the Secret holding RomM credentials. Honors existingSecret.
*/}}
{{- define "romm.secretName" -}}
{{- if .Values.existingSecret -}}
{{- .Values.existingSecret -}}
{{- else -}}
{{- printf "%s-secrets" (include "romm.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Initial password generation. Preserves the existing Secret value across upgrades
via lookup so that the auto-generated password is stable.
*/}}
{{- define "romm.initial_user.password" -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (printf "%s-secrets" (include "romm.fullname" .)) -}}
{{- if and $existing $existing.data.initial_password -}}
{{- $existing.data.initial_password | b64dec -}}
{{- else if .Values.server.configuration.initialPassword -}}
{{- .Values.server.configuration.initialPassword -}}
{{- else -}}
{{- randAlphaNum 24 -}}
{{- end -}}
{{- end -}}
