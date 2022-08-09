{{/*
Expand the name of the chart.
*/}}
{{- define "golang-service-chart.name" -}}
{{- default .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "golang-service-chart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "golang-service-chart.labels" -}}
release-name: {{ .Release.Name }}
chart-name: {{ .Chart.Name }}
chart-version: {{ .Chart.Version }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "golang-service-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "golang-service-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "golang-service-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "golang-service-chart.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
