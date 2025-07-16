# =============================================
# CONFIGURACIÓN BASE DE DATOS - SISTEMA NÓMINAS
# =============================================
# Empresa: ${company_name}
# Entorno: ${environment}
# App ID: ${app_id}

[database]
name=${company_name}_${environment}_payroll_db
type=mysql
version=8.0
app_id=${app_id}

[hardware]
size=${db_config.db_size}
cpu=${db_specs.cpu}
memory=${db_specs.memory}
storage=${db_specs.storage}

[connection]
host=${company_name}-${environment}-db.internal
port=3306
database=${company_name}_payroll
username=payroll_admin
password=${db_password}

[performance]
%{ if db_config.db_size == "micro" ~}
max_connections=50
buffer_pool_size=128MB
query_cache_size=32MB
%{ else ~}
%{ if db_config.db_size == "small" ~}
max_connections=100
buffer_pool_size=256MB
query_cache_size=64MB
%{ else ~}
max_connections=200
buffer_pool_size=512MB
query_cache_size=128MB
%{ endif ~}
%{ endif ~}

[backup]
%{ if db_config.backup_enabled ~}
backup_enabled=true
%{ if environment == "prod" ~}
backup_frequency=daily
backup_retention=365_days
point_in_time_recovery=true
%{ else ~}
backup_frequency=weekly
backup_retention=30_days
point_in_time_recovery=false
%{ endif ~}
%{ else ~}
backup_enabled=false
%{ endif ~}

[security]
%{ if environment == "prod" ~}
ssl_enabled=true
encryption_at_rest=true
access_logging=true
%{ else ~}
%{ if environment == "staging" ~}
ssl_enabled=true
encryption_at_rest=false
access_logging=true
%{ else ~}
ssl_enabled=false
encryption_at_rest=false
access_logging=false
%{ endif ~}
%{ endif ~}