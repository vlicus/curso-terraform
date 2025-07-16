# =============================================
# CONFIGURACIÓN BACKUP - SISTEMA NÓMINAS
# =============================================
# Empresa: ${company_name}
# Entorno: ${environment}
# Retención: ${retention_days} días
# Frecuencia: ${frequency}

[backup]
environment=${environment}
retention_days=${retention_days}
frequency=${frequency}

[schedule]
%{ if frequency == "daily" ~}
# Backup diario
database_backup=02:00
files_backup=03:00
config_backup=04:00
full_system_backup=sunday_01:00
%{ else ~}
# Backup semanal
database_backup=sunday_02:00
files_backup=sunday_03:00
config_backup=sunday_04:00
full_system_backup=first_sunday_01:00
%{ endif ~}

[storage]
%{ if environment == "prod" ~}
# Almacenamiento para producción
primary_location=s3://prod-backups-${company_name}/
secondary_location=s3://prod-backups-${company_name}-dr/
encryption=AES256
compression=enabled
verification=enabled
cross_region_replication=enabled
%{ else ~}
%{ if environment == "staging" ~}
# Almacenamiento para staging
primary_location=s3://staging-backups-${company_name}/
secondary_location=disabled
encryption=AES256
compression=enabled
verification=enabled
cross_region_replication=disabled
%{ else ~}
# Almacenamiento para desarrollo
primary_location=local:/backups/${company_name}/
secondary_location=disabled
encryption=disabled
compression=enabled
verification=disabled
cross_region_replication=disabled
%{ endif ~}
%{ endif ~}

[retention_policy]
%{ if environment == "prod" ~}
# Política de retención para producción
daily_backups=${retention_days}_days
weekly_backups=52_weeks
monthly_backups=60_months
yearly_backups=7_years
legal_hold=enabled
%{ else ~}
%{ if environment == "staging" ~}
# Política de retención para staging
weekly_backups=${retention_days / 7}_weeks
monthly_cleanup=enabled
legal_hold=disabled
%{ else ~}
# Política de retención para desarrollo
recent_backups=${retention_days}_days
auto_cleanup=enabled
legal_hold=disabled
%{ endif ~}
%{ endif ~}

[backup_types]
database=enabled
application_files=enabled
configuration_files=enabled
user_uploads=enabled
logs=enabled
%{ if environment == "prod" ~}
system_state=enabled
certificates=enabled
%{ else ~}
system_state=disabled
certificates=disabled
%{ endif ~}

[restoration]
%{ if environment == "prod" ~}
# Restauración para producción
rpo_target=1_hour
rto_target=4_hours
automated_testing=weekly
disaster_recovery=enabled
%{ else ~}
%{ if environment == "staging" ~}
# Restauración para staging
rpo_target=24_hours
rto_target=8_hours
automated_testing=monthly
disaster_recovery=disabled
%{ else ~}
# Restauración para desarrollo
rpo_target=7_days
rto_target=24_hours
automated_testing=disabled
disaster_recovery=disabled
%{ endif ~}
%{ endif ~}