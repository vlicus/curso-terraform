terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

# Archivo principal del proyecto
resource "local_file" "config" {
  filename = "${var.project_name}-${var.environment}.conf"
  content = templatefile("${path.module}/config.tpl", {
    project_name = var.project_name
    environment  = var.environment
    timestamp    = timestamp()
  })
}

# Archivo de backup condicional
resource "local_file" "backup" {
  count = var.create_backup ? 1 : 0
  
  filename = "${var.project_name}-${var.environment}-backup.conf"
  content  = "Backup creado el ${timestamp()}"
}

# Archivo de configuración principal
resource "local_file" "advanced_config" {
  filename = "${var.project_name}-${var.environment}-config.json"
  content = jsonencode({
    project = {
      name         = var.project_name
      environment  = var.environment
      created_at   = timestamp()
    }
    settings = {
      max_connections = var.max_connections
      features       = var.features
      debug_mode     = var.environment != "prod"
    }
  })
}

# Archivo para cada feature
resource "local_file" "feature_configs" {
  for_each = toset(var.features)
  
  filename = "${var.project_name}-${each.key}-config.txt"
  content  = "Configuración para ${each.key} en ${var.environment}"
}

# Configuración para cada base de datos
resource "local_file" "database_configs" {
  for_each = {
    for db in var.databases : db.name => db
  }
  
  filename = "${var.project_name}-db-${each.key}.conf"
  content = templatefile("${path.module}/database.tpl", {
    db_name     = each.value.name
    db_type     = each.value.type
    size_gb     = each.value.size_gb
    backup      = each.value.backup
    environment = var.environment
  })
}

# Configuración de servicios
resource "local_file" "services_config" {
  filename = "${var.project_name}-services.conf"
  content = templatefile("${path.module}/services.tpl", {
    ports       = var.service_ports
    environment = var.environment
    config      = var.config_by_env[var.environment]
  })
}

# Archivo de resumen
resource "local_file" "summary" {
  filename = "${var.project_name}-summary.md"
  content = templatefile("${path.module}/summary.tpl", {
    project_name   = var.project_name
    environment    = var.environment
    databases      = var.databases
    services       = var.service_ports
    env_config     = var.config_by_env[var.environment]
    total_dbs      = length(var.databases)
    backup_dbs     = length([for db in var.databases : db if db.backup])
  })
}

# Variables locales calculadas
locals {
  # Etiquetas estándar
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    CreatedAt   = timestamp()
  }
  
  # Configuración calculada
  is_production = var.environment == "prod"
  backup_suffix = local.is_production ? "prod-backup" : "dev-backup"
  
  # Total de storage necesario
  total_storage_gb = sum([for db in var.databases : db.size_gb])
  
  # Servicios públicos vs privados
  public_ports  = { for k, v in var.service_ports : k => v if v < 1000 }
  private_ports = { for k, v in var.service_ports : k => v if v >= 1000 }
  
  # Configuración derivada
  derived_config = {
    max_connections    = var.max_connections * var.config_by_env[var.environment].instance_count
    monitoring_enabled = var.config_by_env[var.environment].monitoring
    backup_retention   = local.is_production ? 30 : 7
  }
}

# Archivo con valores calculados
resource "local_file" "calculated_config" {
  filename = "${var.project_name}-calculated.json"
  content = jsonencode({
    metadata        = local.common_tags
    total_storage   = "${local.total_storage_gb}GB"
    is_production   = local.is_production
    derived_config  = local.derived_config
    port_analysis = {
      public_services  = keys(local.public_ports)
      private_services = keys(local.private_ports)
    }
  })
}