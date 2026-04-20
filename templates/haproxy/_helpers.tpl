{{- define "jitsi-scaler.haproxy.fullname" -}}
{{ include "jitsi-scaler.fullname" . }}-haproxy
{{- end -}}

{{- define "jitsi-scaler.haproxy.labels" -}}
{{ include "jitsi-scaler.labels" . }}
app.kubernetes.io/component: "haproxy"
{{- end -}}

{{- define "jitsi-scaler.haproxy.selectorLabels" -}}
{{ include "jitsi-scaler.selectorLabels" . }}
app.kubernetes.io/component: "haproxy"
{{- end -}}
