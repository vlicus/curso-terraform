terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.0"
}

# Configuración dinámica por workspace
locals {
  # Configuración específica por entorno
  environment_config = {
    default = {
      instance_count = 1
      instance_size  = "small"
      monitoring     = false
      backup_enabled = false
      description    = "Entorno de desarrollo"
    }
    
    staging = {
      instance_count = 2
      instance_size  = "medium"
      monitoring     = true
      backup_enabled = true
      description    = "Entorno de pruebas"
    }
    
    prod = {
      instance_count = 3
      instance_size  = "large"
      monitoring     = true
      backup_enabled = true
      description    = "Entorno de producción"
    }
  }
  
  # Obtener configuración del workspace actual
  current_config = local.environment_config[terraform.workspace]
  
  # Configuración de recursos por tamaño
  size_config = {
    small = {
      cpu    = 1
      memory = "1GB"
      storage = "10GB"
    }
    medium = {
      cpu    = 2
      memory = "4GB"
      storage = "50GB"
    }
    large = {
      cpu    = 4
      memory = "8GB"
      storage = "100GB"
    }
  }
  
  # Configuración actual de recursos
  current_size = local.size_config[local.current_config.instance_size]
  
  # Tags comunes
  common_tags = {
    Environment   = terraform.workspace
    Project       = var.project_name
    ManagedBy     = "terraform"
    Workspace     = terraform.workspace
    CreatedAt     = timestamp()
  }
}

# Archivo de configuración principal del entorno
resource "local_file" "environment_config" {
  filename = "${var.project_name}-${terraform.workspace}-config.json"
  content = jsonencode({
    environment = {
      name        = terraform.workspace
      description = local.current_config.description
      workspace   = terraform.workspace
      created_at  = timestamp()
    }
    
    infrastructure = {
      instance_count = local.current_config.instance_count
      instance_size  = local.current_config.instance_size
      cpu           = local.current_size.cpu
      memory        = local.current_size.memory
      storage       = local.current_size.storage
    }
    
    features = {
      monitoring     = local.current_config.monitoring
      backup_enabled = local.current_config.backup_enabled
      ssl_enabled    = terraform.workspace == "prod" ? true : false
      debug_mode     = terraform.workspace == "default" ? true : false
    }
    
    metadata = local.common_tags
  })
}

# Crear "servidores" simulados
resource "local_file" "servers" {
  count = local.current_config.instance_count
  
  filename = "${var.project_name}-${terraform.workspace}-server-${count.index + 1}.conf"
  content = templatefile("${path.module}/server.tpl", {
    server_id   = count.index + 1
    workspace   = terraform.workspace
    project     = var.project_name
    cpu         = local.current_size.cpu
    memory      = local.current_size.memory
    storage     = local.current_size.storage
    monitoring  = local.current_config.monitoring
    backup      = local.current_config.backup_enabled
    environment = local.current_config.description
  })
}

# Archivo de monitoreo (solo si está habilitado)
resource "local_file" "monitoring_config" {
  count = local.current_config.monitoring ? 1 : 0
  
  filename = "${var.project_name}-${terraform.workspace}-monitoring.conf"
  content = templatefile("${path.module}/monitoring.tpl", {
    workspace      = terraform.workspace
    server_count   = local.current_config.instance_count
    alert_level    = terraform.workspace == "prod" ? "critical" : "warning"
    check_interval = terraform.workspace == "prod" ? "1m" : "5m"
  })
}

# Configuración de backup (solo si está habilitado)
resource "local_file" "backup_config" {
  count = local.current_config.backup_enabled ? 1 : 0
  
  filename = "${var.project_name}-${terraform.workspace}-backup.conf"
  content = templatefile("${path.module}/backup.tpl", {
    workspace       = terraform.workspace
    retention_days  = terraform.workspace == "prod" ? 30 : 7
    backup_frequency = terraform.workspace == "prod" ? "daily" : "weekly"
    servers         = local.current_config.instance_count
  })
}

# Resumen del entorno
resource "local_file" "environment_summary" {
  filename = "${var.project_name}-${terraform.workspace}-RESUMEN.md"
  content = templatefile("${path.module}/summary.tpl", {
    project_name    = var.project_name
    workspace       = terraform.workspace
    description     = local.current_config.description
    server_count    = local.current_config.instance_count
    instance_size   = local.current_config.instance_size
    cpu             = local.current_size.cpu
    memory          = local.current_size.memory
    storage         = local.current_size.storage
    monitoring      = local.current_config.monitoring
    backup          = local.current_config.backup_enabled
    ssl_enabled     = terraform.workspace == "prod" ? true : false
    debug_mode      = terraform.workspace == "default" ? true : false
    created_at      = timestamp()
  })
}