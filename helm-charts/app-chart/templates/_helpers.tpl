{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the app.
*/}}
{{- define "app.name" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "app.fullname" -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- if contains .Values.meta.env .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.meta.env | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- if contains .Values.meta.env .Release.Name -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name .Chart.Name .Values.meta.env | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the server.
*/}}
{{- define "server.name" -}}
{{- $name := default "server" .Values.server.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified server name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "server.fullname" -}}
{{- if .Values.server.fullnameOverride -}}
{{- .Values.server.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "server" .Values.server.nameOverride -}}
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
Set server port based on values.
*/}}
{{- define "server.port" -}}
{{- if .Values.server.portOverride -}}
{{- index .Values.server.portOverride 0 "containerPort" -}}
{{- else -}}
{{- .Values.server.port -}}
{{- end -}}
{{- end -}}

{{/*
Set minReplicas based on environtment.
*/}}
{{- define "server.minReplicas" -}}
{{- if eq .Values.meta.env "prod" -}}
{{ default 3 .Values.autoscaling.minReplicas }}
{{- else -}}
{{ default 1 .Values.autoscaling.minReplicas }}
{{- end -}}
{{- end -}}

{{/*
Set maxReplicas based on environtment.
*/}}
{{- define "server.maxReplicas" -}}
{{- if or (eq .Values.meta.env "prod") (eq .Values.meta.env "uat") -}}
{{ default 50 .Values.autoscaling.maxReplicas }}
{{- else -}}
{{ default 3 .Values.autoscaling.maxReplicas }}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the worker.
*/}}
{{- define "worker.name" -}}
{{- $name := default "worker" .Values.worker.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}


{{/*
Create a default fully qualified worker name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "worker.fullname" -}}
{{- if .Values.worker.fullnameOverride -}}
{{- .Values.worker.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "worker" .Values.worker.nameOverride -}}
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
{{- define "app.labels" -}}
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
