output "workspace_info" {
  description = "Información del workspace actual"
  value = {
    current_workspace = terraform.workspace
    description      = local.current_config.description
    server_count     = local.current_config.instance_count
    instance_size    = local.current_config.instance_size
    monitoring       = local.current_config.monitoring
    backup_enabled   = local.current_config.backup_enabled
  }
}

output "infrastructure_summary" {
  description = "Resumen de infraestructura desplegada"
  value = {
    environment = terraform.workspace
    total_servers = local.current_config.instance_count
    resources_per_server = {
      cpu     = local.current_size.cpu
      memory  = local.current_size.memory
      storage = local.current_size.storage
    }
    total_resources = {
      total_cpu     = local.current_size.cpu * local.current_config.instance_count
      total_memory  = "${local.current_size.cpu * local.current_config.instance_count}x${local.current_size.memory}"
      total_storage = "${local.current_size.cpu * local.current_config.instance_count}x${local.current_size.storage}"
    }
  }
}

output "files_created" {
  description = "Lista de archivos creados para este workspace"
  value = concat(
    [local_file.environment_config.filename],
    [local_file.environment_summary.filename],
    [for server in local_file.servers : server.filename],
    local.current_config.monitoring ? [local_file.monitoring_config[0].filename] : [],
    local.current_config.backup_enabled ? [local_file.backup_config[0].filename] : []
  )
}

output "environment_comparison" {
  description = "Comparación entre todos los entornos disponibles"
  value = {
    for env_name, env_config in local.environment_config : env_name => {
      servers    = env_config.instance_count
      size       = env_config.instance_size
      monitoring = env_config.monitoring
      backup     = env_config.backup_enabled
    }
  }
}

output "next_steps" {
  description = "Próximos pasos sugeridos"
  value = [
    "1. Revisa el archivo: ${local_file.environment_summary.filename}",
    "2. Compara con otros workspaces usando: terraform workspace list",
    "3. Cambia de workspace con: terraform workspace select [nombre]",
    "4. Observa cómo cambian los recursos entre entornos"
  ]
}