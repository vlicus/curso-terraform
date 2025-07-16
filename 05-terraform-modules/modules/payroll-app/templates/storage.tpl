# =============================================
# CONFIGURACIÓN ALMACENAMIENTO - SISTEMA NÓMINAS
# =============================================
# Empresa: ${company_name}
# Entorno: ${environment}
# App ID: ${app_id}

[storage]
name=${company_name}-${environment}-payroll-storage
type=s3_bucket
app_id=${app_id}
purpose=payroll_documents

[bucket_config]
bucket_name=${company_name}-${environment}-payroll-docs-${app_id}
region=us-east-1
%{ if versioning ~}
versioning=enabled
%{ else ~}
versioning=disabled
%{ endif ~}

[security]
%{ if encryption ~}
encryption=AES256
server_side_encryption=enabled
%{ else ~}
encryption=none
server_side_encryption=disabled
%{ endif ~}
public_access=blocked
cors_enabled=true

[folders]
# Estructura de carpetas para documentos de nómina
payroll_reports=/reports/
employee_documents=/employees/
tax_forms=/tax-forms/
contracts=/contracts/
policies=/policies/
%{ if environment == "prod" ~}
audit_logs=/audit/
compliance_docs=/compliance/
%{ endif ~}

[file_types]
# Tipos de archivos permitidos
allowed_extensions=.pdf,.xlsx,.docx,.csv,.txt
max_file_size=50MB
%{ if environment == "prod" ~}
virus_scanning=enabled
%{ else ~}
virus_scanning=disabled
%{ endif ~}

[retention_policy]
%{ if environment == "prod" ~}
# Política de retención para producción
payroll_reports=7_years
employee_documents=permanent
tax_forms=7_years
contracts=permanent
audit_logs=10_years
%{ else ~}
%{ if environment == "staging" ~}
# Política de retención para staging
payroll_reports=1_year
employee_documents=2_years
tax_forms=1_year
contracts=2_years
%{ else ~}
# Política de retención para desarrollo
payroll_reports=30_days
employee_documents=90_days
tax_forms=30_days
contracts=90_days
%{ endif ~}
%{ endif ~}

[access_control]
%{ if environment == "prod" ~}
# Control de acceso estricto para producción
read_access=hr_team,finance_team,managers
write_access=hr_admin,payroll_admin
delete_access=hr_admin
audit_logging=enabled
%{ else ~}
%{ if environment == "staging" ~}
# Control de acceso para staging
read_access=hr_team,finance_team,testers
write_access=hr_admin,test_admin
delete_access=test_admin
audit_logging=enabled
%{ else ~}
# Control de acceso para desarrollo
read_access=developers,hr_team
write_access=developers
delete_access=developers
audit_logging=disabled
%{ endif ~}
%{ endif ~}

[backup]
%{ if versioning ~}
backup_enabled=true
%{ if environment == "prod" ~}
backup_frequency=daily
cross_region_replication=enabled
backup_retention=indefinite
%{ else ~}
backup_frequency=weekly
cross_region_replication=disabled
backup_retention=90_days
%{ endif ~}
%{ else ~}
backup_enabled=false
%{ endif ~}