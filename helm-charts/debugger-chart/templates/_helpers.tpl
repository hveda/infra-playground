{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "debugger.name" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

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
{{- define "debugger.labels" -}}
release-name: {{ .Release.Name }}
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
