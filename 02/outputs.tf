output "project_summary" {
  description = "Resumen completo del proyecto"
  value = {
    project_info = {
      name        = var.project_name
      environment = var.environment
      is_prod     = local.is_production
    }
    
    storage = {
      databases_count = length(var.databases)
      total_gb       = local.total_storage_gb
      backup_enabled = length([for db in var.databases : db if db.backup])
    }
    
    services = {
      total_services = length(var.service_ports)
      public_count   = length(local.public_ports)
      private_count  = length(local.private_ports)
    }
  }
}

output "files_created" {
  description = "Lista de todos los archivos creados"
  value = concat(
    [local_file.config.filename],
    [local_file.advanced_config.filename],
    [local_file.services_config.filename],
    [local_file.summary.filename],
    [local_file.calculated_config.filename],
    [for file in local_file.database_configs : file.filename],
    [for file in local_file.feature_configs : file.filename],
    var.create_backup ? [local_file.backup[0].filename] : []
  )
}

output "backup_status" {
  description = "Estado del backup"
  value = var.create_backup ? "Backup habilitado" : "Backup deshabilitado"
}