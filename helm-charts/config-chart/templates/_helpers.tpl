{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the config.
*/}}
{{- define "config.name" -}}
{{- $name := default "config" .Values.config.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified config name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "config.fullname" -}}
{{- if .Values.config.fullnameOverride -}}
{{- .Values.config.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "config" .Values.config.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- if contains .Values.meta.env .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.meta.env | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- if contains .Values.meta.env .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.meta.env | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the secret.
*/}}
{{- define "secret.name" -}}
{{- $name := default "config" .Values.secret.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified secret name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "secret.fullname" -}}
{{- if .Values.secret.fullnameOverride -}}
{{- .Values.secret.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "config" .Values.secret.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- if contains .Values.meta.env .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.meta.env | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- if contains .Values.meta.env .Release.Name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name .Values.meta.env | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "config.labels" -}}
app-name: {{ .Values.meta.name }}
release-name: {{ .Release.Name }}
env: {{ .Values.meta.env }}
chart-name: {{ .Chart.Name }}
chart-version: {{ .Chart.Version }}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "tplValue" (dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
