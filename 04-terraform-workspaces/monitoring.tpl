# Configuración de Monitoreo - ${workspace}

[monitoring]
environment=${workspace}
server_count=${server_count}
alert_level=${alert_level}
check_interval=${check_interval}

[alerts]
%{ if workspace == "prod" ~}
cpu_threshold=80
memory_threshold=85
disk_threshold=90
response_time_threshold=500ms
%{ else ~}
%{ if workspace == "staging" ~}
cpu_threshold=85
memory_threshold=90
disk_threshold=95
response_time_threshold=1000ms
%{ else ~}
cpu_threshold=90
memory_threshold=95
disk_threshold=98
response_time_threshold=2000ms
%{ endif ~}
%{ endif ~}

[notifications]
%{ if workspace == "prod" ~}
email=admin@empresa.com,devops@empresa.com
slack=#alerts-prod
sms=enabled
%{ else ~}
%{ if workspace == "staging" ~}
email=devops@empresa.com
slack=#alerts-staging
sms=disabled
%{ else ~}
email=dev@empresa.com
slack=#alerts-dev
sms=disabled
%{ endif ~}
%{ endif ~}

[checks]
- health_check
- database_connection
- api_response_time
- disk_space
- memory_usage
%{ if workspace == "prod" ~}
- ssl_certificate
- backup_status
- security_scan
%{ endif ~}