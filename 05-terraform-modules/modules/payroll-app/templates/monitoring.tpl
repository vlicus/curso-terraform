# =============================================
# CONFIGURACIÓN MONITOREO - SISTEMA NÓMINAS
# =============================================
# Empresa: ${company_name}
# Entorno: ${environment}
# Nivel: ${monitoring_level}

[monitoring]
environment=${environment}
level=${monitoring_level}
replicas=${replicas}
alerts_enabled=${alerts_enabled}

[metrics]
%{ if monitoring_level == "advanced" ~}
# Monitoreo avanzado
cpu_monitoring=enabled
memory_monitoring=enabled
disk_monitoring=enabled
network_monitoring=enabled
application_metrics=enabled
database_metrics=enabled
custom_metrics=enabled
%{ else ~}
%{ if monitoring_level == "standard" ~}
# Monitoreo estándar
cpu_monitoring=enabled
memory_monitoring=enabled
disk_monitoring=enabled
network_monitoring=disabled
application_metrics=enabled
database_metrics=basic
custom_metrics=disabled
%{ else ~}
# Monitoreo básico
cpu_monitoring=enabled
memory_monitoring=enabled
disk_monitoring=basic
network_monitoring=disabled
application_metrics=basic
database_metrics=disabled
custom_metrics=disabled
%{ endif ~}
%{ endif ~}

[thresholds]
%{ if environment == "prod" ~}
# Umbrales para producción (más estrictos)
cpu_warning=70
cpu_critical=85
memory_warning=75
memory_critical=90
disk_warning=80
disk_critical=95
response_time_warning=500ms
response_time_critical=1000ms
%{ else ~}
%{ if environment == "staging" ~}
# Umbrales para staging
cpu_warning=80
cpu_critical=90
memory_warning=80
memory_critical=95
disk_warning=85
disk_critical=98
response_time_warning=1000ms
response_time_critical=2000ms
%{ else ~}
# Umbrales para desarrollo (más relajados)
cpu_warning=90
cpu_critical=95
memory_warning=90
memory_critical=98
disk_warning=90
disk_critical=99
response_time_warning=2000ms
response_time_critical=5000ms
%{ endif ~}
%{ endif ~}

[alerts]
%{ if alerts_enabled ~}
alerts_enabled=true
%{ if environment == "prod" ~}
# Alertas para producción
email_notifications=admin@${company_name}.com,devops@${company_name}.com
slack_channel=#alerts-prod
pager_duty=enabled
sms_notifications=enabled
escalation_enabled=true
%{ else ~}
%{ if environment == "staging" ~}
# Alertas para staging
email_notifications=devops@${company_name}.com
slack_channel=#alerts-staging
pager_duty=disabled
sms_notifications=disabled
escalation_enabled=false
%{ else ~}
# Alertas para desarrollo
email_notifications=dev-team@${company_name}.com
slack_channel=#alerts-dev
pager_duty=disabled
sms_notifications=disabled
escalation_enabled=false
%{ endif ~}
%{ endif ~}
%{ else ~}
alerts_enabled=false
%{ endif ~}

[dashboards]
%{ if monitoring_level == "advanced" ~}
# Dashboards avanzados
system_dashboard=enabled
application_dashboard=enabled
business_dashboard=enabled
security_dashboard=enabled
performance_dashboard=enabled
%{ else ~}
%{ if monitoring_level == "standard" ~}
# Dashboards estándar
system_dashboard=enabled
application_dashboard=enabled
business_dashboard=disabled
security_dashboard=disabled
performance_dashboard=enabled
%{ else ~}
# Dashboards básicos
system_dashboard=enabled
application_dashboard=basic
business_dashboard=disabled
security_dashboard=disabled
performance_dashboard=disabled
%{ endif ~}
%{ endif ~}

[logging]
%{ if monitoring_level == "advanced" ~}
log_level=DEBUG
log_retention=90_days
structured_logging=enabled
log_shipping=enabled
%{ else ~}
%{ if monitoring_level == "standard" ~}
log_level=INFO
log_retention=30_days
structured_logging=enabled
log_shipping=disabled
%{ else ~}
log_level=WARN
log_retention=7_days
structured_logging=disabled
log_shipping=disabled
%{ endif ~}
%{ endif ~}