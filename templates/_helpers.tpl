{{/* Expand the name of the chart. */}}
{{- define "jitsi-scaler.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this.
If the release name contains chart name it will be used as a full name.
*/}}
{{- define "jitsi-scaler.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{-   .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{-   $name := default .Chart.Name .Values.nameOverride -}}
{{-   if contains $name .Release.Name -}}
{{-     .Release.Name | trunc 63 | trimSuffix "-" -}}
{{-   else -}}
{{-     printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{-   end -}}
{{- end -}}
{{- end -}}

{{/* Create chart name and version as used by the chart label. */}}
{{- define "jitsi-scaler.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Common labels */}}
{{- define "jitsi-scaler.labels" -}}
helm.sh/chart: {{ include "jitsi-scaler.chart" . | quote }}
{{ include "jitsi-scaler.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end -}}

{{/* Selector labels */}}
{{- define "jitsi-scaler.selectorLabels" -}}
app.kubernetes.io/name: {{ include "jitsi-scaler.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end -}}

{{/* Create the name of the service account to use */}}
{{- define "jitsi-scaler.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{-   .Values.serviceAccount.name | default (include "jitsi-scaler.fullname" .) -}}
{{- else -}}
{{-   .Values.serviceAccount.name | default "default" -}}
{{- end -}}
{{- end -}}
