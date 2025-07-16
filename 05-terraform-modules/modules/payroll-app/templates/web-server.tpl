# =============================================
# CONFIGURACIÓN SERVIDOR WEB - SISTEMA NÓMINAS
# =============================================
# Empresa: ${company_name}
# Entorno: ${environment}
# App ID: ${app_id}
# Generado: ${timestamp()}

[server]
name=${company_name}-${environment}-payroll-web
type=web_server
environment=${environment}
app_id=${app_id}

[hardware]
size=${server_config.server_size}
cpu=${server_specs.cpu}
memory=${server_specs.memory}
storage=${server_specs.storage}
replicas=${server_config.replicas}

[application]
name=payroll-system
type=web_application
port=80
%{ if ssl_enabled ~}
ssl_port=443
ssl_enabled=true
%{ else ~}
ssl_enabled=false
%{ endif ~}

[payroll_config]
employees=${employee_count}
departments=${department_count}
%{ if employee_count < 50 ~}
performance_mode=standard
max_concurrent_users=25
%{ else ~}
%{ if employee_count < 200 ~}
performance_mode=optimized
max_concurrent_users=100
%{ else ~}
performance_mode=high_performance
max_concurrent_users=500
%{ endif ~}
%{ endif ~}

[monitoring]
level=${monitoring}
%{ if monitoring == "advanced" ~}
metrics_enabled=true
alerts_enabled=true
dashboard_enabled=true
log_level=INFO
%{ else ~}
%{ if monitoring == "standard" ~}
metrics_enabled=true
alerts_enabled=false
dashboard_enabled=true
log_level=WARN
%{ else ~}
metrics_enabled=false
alerts_enabled=false
dashboard_enabled=false
log_level=ERROR
%{ endif ~}
%{ endif ~}

[environment_specific]
%{ if environment == "prod" ~}
debug_mode=false
cache_enabled=true
session_timeout=3600
max_file_upload=50MB
%{ else ~}
%{ if environment == "staging" ~}
debug_mode=false
cache_enabled=true
session_timeout=1800
max_file_upload=25MB
%{ else ~}
debug_mode=true
cache_enabled=false
session_timeout=900
max_file_upload=10MB
%{ endif ~}
%{ endif ~}

[security]
%{ if ssl_enabled ~}
https_redirect=true
secure_cookies=true
%{ else ~}
https_redirect=false
secure_cookies=false
%{ endif ~}
%{ if environment == "prod" ~}
firewall_enabled=true
intrusion_detection=true
%{ else ~}
firewall_enabled=false
intrusion_detection=false
%{ endif ~}