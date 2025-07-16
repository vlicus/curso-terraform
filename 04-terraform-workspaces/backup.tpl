# Configuración de Backup - ${workspace}

[backup]
environment=${workspace}
retention_days=${retention_days}
backup_frequency=${backup_frequency}
servers_to_backup=${servers}

[schedule]
%{ if workspace == "prod" ~}
daily_backup=02:00
weekly_full_backup=sunday_01:00
monthly_archive=first_sunday_00:00
%{ else ~}
%{ if workspace == "staging" ~}
weekly_backup=sunday_03:00
monthly_cleanup=first_monday_02:00
%{ else ~}
weekly_backup=saturday_23:00
%{ endif ~}
%{ endif ~}

[storage]
%{ if workspace == "prod" ~}
location=s3://prod-backups/
encryption=enabled
compression=enabled
verification=enabled
%{ else ~}
%{ if workspace == "staging" ~}
location=s3://staging-backups/
encryption=enabled
compression=enabled
verification=disabled
%{ else ~}
location=local:/backup/
encryption=disabled
compression=enabled
verification=disabled
%{ endif ~}
%{ endif ~}

[retention_policy]
%{ if workspace == "prod" ~}
daily_backups=${retention_days}_days
weekly_backups=12_weeks
monthly_backups=12_months
%{ else ~}
%{ if workspace == "staging" ~}
weekly_backups=${retention_days / 7}_weeks
monthly_cleanup=enabled
%{ else ~}
keep_last=${retention_days / 7}_backups
auto_cleanup=enabled
%{ endif ~}
%{ endif ~}