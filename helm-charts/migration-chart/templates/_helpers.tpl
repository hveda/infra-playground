{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the migration.
*/}}
{{- define "migration.name" -}}
{{- $name := default "migration" .Values.migration.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified migration name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "migration.fullname" -}}
{{- if .Values.migration.fullnameOverride -}}
{{- .Values.migration.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "migration" .Values.migration.nameOverride -}}
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
Filter version to prenvent number-like string from accidentally parsed into float64.
https://github.com/helm/helm/issues/1707
*/}}
{{- define "meta.version" -}}
{{- $version :=  .Values.meta.version -}}
{{- $type := printf "%T" $version -}}
{{- if eq $type "float64" -}}
{{- printf "%.0f" $version | quote -}}
{{- else }}
{{- $version | quote -}}
{{- end -}}
{{- end }}

{{/*
Filter image tag to prenvent number-like string from accidentally parsed into float64.
https://github.com/helm/helm/issues/1707
*/}}
{{- define "image.tag" -}}
{{- $tag :=  .Values.image.tag -}}
{{- $type := printf "%T" $tag -}}
{{- if eq $type "float64" -}}
{{- printf "%.0f" $tag -}}
{{- else }}
{{- $tag -}}
{{- end -}}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "migration.labels" -}}
app-name: {{ .Values.meta.name }}
release-name: {{ .Release.Name }}
version: {{ include "meta.version" . }}
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
