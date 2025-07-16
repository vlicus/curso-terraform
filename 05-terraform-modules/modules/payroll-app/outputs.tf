# ===========================================
# OUTPUTS DEL MÓDULO
# ===========================================

output "application_info" {
  description = "Información básica de la aplicación desplegada"
  value = {
    company_name    = var.company_name
    environment     = var.environment
    app_id         = random_string.app_id.result
    application_url = "https://${var.company_name}-${var.environment}-payroll.company.com"
    deployment_date = timestamp()
  }
}

output "infrastructure_summary" {
  description = "Resumen de la infraestructura creada"
  value = {
    server = {
      size     = local.current_config.server_size
      replicas = local.current_config.replicas
      specs    = local.server_specs[local.current_config.server_size]
    }
    
    database = {
      size  = local.current_config.db_size
      specs = local.db_specs[local.current_config.db_size]
    }
    
    features = {
      ssl_enabled    = local.current_config.ssl_enabled
      backup_enabled = local.current_config.backup_enabled
      monitoring     = local.current_config.monitoring
    }
  }
}

output "business_configuration" {
  description = "Configuración de negocio del sistema de nóminas"
  value = {
    employee_count    = var.employee_count
    department_count  = var.department_count
    payroll_frequency = var.payroll_frequency
    estimated_monthly_payrolls = var.payroll_frequency == "weekly" ? 4 : var.payroll_frequency == "bi-weekly" ? 2 : 1
  }
}

output "connection_info" {
  description = "Información de conexión y archivos generados"
  value = {
    web_server_config = local_file.web_server_config.filename
    database_config   = local_file.database_config.filename
    storage_config    = local_file.storage_config.filename
    deployment_summary = local_file.deployment_summary.filename
  }
}

output "security_info" {
  description = "Información de seguridad (contraseñas y configuración)"
  value = {
    database_password_file = "Contraseña generada automáticamente (ver archivos de configuración)"
    ssl_enabled           = local.current_config.ssl_enabled
    backup_enabled        = local.current_config.backup_enabled
    monitoring_level      = local.current_config.monitoring
  }
  sensitive = false
}

output "files_created" {
  description = "Lista de todos los archivos creados por el módulo"
  value = concat(
    [
      local_file.web_server_config.filename,
      local_file.payroll_app_config.filename,
      local_file.database_config.filename,
      local_file.database_schema.filename,
      local_file.storage_config.filename,
      local_file.deployment_summary.filename
    ],
    local.current_config.monitoring != "none" ? [local_file.monitoring_config[0].filename] : [],
    local.current_config.backup_enabled ? [local_file.backup_config[0].filename] : []
  )
}