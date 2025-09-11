{{/*
Expand the name of the chart.
*/}}
{{- define "vaultwarden.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "vaultwarden.fullname" -}}
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
{{- define "vaultwarden.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "vaultwarden.labels" -}}
helm.sh/chart: {{ include "vaultwarden.chart" . }}
{{ include "vaultwarden.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.customLabels }}
{{- toYaml .Values.customLabels | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "vaultwarden.selectorLabels" -}}
app.kubernetes.io/name: {{ include "vaultwarden.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Pod labels
*/}}
{{- define "vaultwarden.podLabels" -}}
{{ include "vaultwarden.selectorLabels" . }}
{{- if .Values.podLabels }}
{{- toYaml .Values.podLabels | nindent 0 }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "vaultwarden.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "vaultwarden.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret containing database credentials
*/}}
{{- define "vaultwarden.databaseSecretName" -}}
{{- if .Values.externalDatabase.mysql.enabled }}
{{- default (printf "%s-mysql" (include "vaultwarden.fullname" .)) .Values.externalDatabase.mysql.existingSecret }}
{{- else if .Values.externalDatabase.postgres.enabled }}
{{- default (printf "%s-postgres" (include "vaultwarden.fullname" .)) .Values.externalDatabase.postgres.existingSecret }}
{{- end }}
{{- end }}

{{/*
Generate database URL for external databases
*/}}
{{- define "vaultwarden.databaseUrl" -}}
{{- if .Values.externalDatabase.mysql.enabled }}
{{- printf "mysql://%s:$DB_PASSWORD@%s:%v/%s" .Values.externalDatabase.mysql.username .Values.externalDatabase.mysql.host .Values.externalDatabase.mysql.port .Values.externalDatabase.mysql.database }}
{{- else if .Values.externalDatabase.postgres.enabled }}
{{- printf "postgresql://%s:$DB_PASSWORD@%s:%v/%s" .Values.externalDatabase.postgres.username .Values.externalDatabase.postgres.host .Values.externalDatabase.postgres.port .Values.externalDatabase.postgres.database }}
{{- else }}
{{- .Values.vaultwarden.database.url }}
{{- end }}
{{- end }}

{{/*
Generate websocket service name
*/}}
{{- define "vaultwarden.websocketServiceName" -}}
{{- printf "%s-ws" (include "vaultwarden.fullname" .) }}
{{- end }}

{{/*
Generate admin token secret name
*/}}
{{- define "vaultwarden.adminTokenSecretName" -}}
{{- printf "%s-admin-token" (include "vaultwarden.fullname" .) }}
{{- end }}

{{/*
Generate SMTP credentials secret name
*/}}
{{- define "vaultwarden.smtpSecretName" -}}
{{- printf "%s-smtp" (include "vaultwarden.fullname" .) }}
{{- end }}