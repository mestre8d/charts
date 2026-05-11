{{/*
Expand the name of the chart.
*/}}
{{- define "palworld.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "palworld.fullname" -}}
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
{{- define "palworld.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "palworld.labels" -}}
helm.sh/chart: {{ include "palworld.chart" . }}
{{ include "palworld.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "palworld.selectorLabels" -}}
app.kubernetes.io/name: {{ include "palworld.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "palworld.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "palworld.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Component-scoped name for the game server
*/}}
{{- define "palworld.serverFullname" -}}
{{- printf "%s-server" (include "palworld.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Component-scoped name for the api
*/}}
{{- define "palworld.apiFullname" -}}
{{- printf "%s-api" (include "palworld.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Server component labels
*/}}
{{- define "palworld.serverLabels" -}}
{{ include "palworld.labels" . }}
app.kubernetes.io/component: server
{{- end -}}

{{/*
Server selector labels
*/}}
{{- define "palworld.serverSelectorLabels" -}}
{{ include "palworld.selectorLabels" . }}
app.kubernetes.io/component: server
{{- end -}}

{{/*
API component labels
*/}}
{{- define "palworld.apiLabels" -}}
{{ include "palworld.labels" . }}
app.kubernetes.io/component: api
{{- end -}}

{{/*
API selector labels
*/}}
{{- define "palworld.apiSelectorLabels" -}}
{{ include "palworld.selectorLabels" . }}
app.kubernetes.io/component: api
{{- end -}}

{{/*
Guard: api.attach_to_game_server and api.enabled together produce two API containers.
*/}}
{{- define "palworld.validateApi" -}}
{{- if and .Values.api.enabled .Values.api.attach_to_game_server -}}
{{- fail "ERROR: api.enabled=true and api.attach_to_game_server=true cannot both be set. When attaching the API sidecar to the game server pod, set api.enabled=false to avoid running a duplicate API Deployment." -}}
{{- end -}}
{{- end -}}

{{/*
Resolve the RCON password.
Order of precedence:
  1. Existing Secret in the cluster (so it survives upgrades).
  2. .Values.server.config.rcon.password (user-provided).
  3. Newly generated random value (only on first install).
*/}}
{{- define "palworld.rconPassword" -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "palworld.serverFullname" .) -}}
{{- if and $existing (index $existing.data "rconPassword") -}}
{{- index $existing.data "rconPassword" | b64dec -}}
{{- else if .Values.server.config.rcon.password -}}
{{- .Values.server.config.rcon.password -}}
{{- else -}}
{{- randAlphaNum 24 -}}
{{- end -}}
{{- end -}}

{{/*
Resolve the bearer token for the API.
*/}}
{{- define "palworld.bearerToken" -}}
{{- $existing := lookup "v1" "Secret" .Release.Namespace (include "palworld.serverFullname" .) -}}
{{- if and $existing (index $existing.data "bearerToken") -}}
{{- index $existing.data "bearerToken" | b64dec -}}
{{- else if .Values.api.config.bearer_token -}}
{{- .Values.api.config.bearer_token -}}
{{- else -}}
{{- randAlphaNum 32 -}}
{{- end -}}
{{- end -}}
