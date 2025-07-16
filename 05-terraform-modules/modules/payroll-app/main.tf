# ===========================================
# MÓDULO: PAYROLL APP
# ===========================================
# Este módulo crea una aplicación de nóminas completa
# con servidor web, base de datos y almacenamiento

terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

# ===========================================
# CONFIGURACIÓN LOCAL Y CÁLCULOS
# ===========================================

locals {
  # Configuración específica por entorno
  env_config = {
    dev = {
      server_size    = "small"
      db_size       = "micro"
      backup_enabled = false
      ssl_enabled   = false
      monitoring    = "basic"
      replicas      = 1
    }
    
    staging = {
      server_size    = "medium"
      db_size       = "small"
      backup_enabled = true
      ssl_enabled   = true
      monitoring    = "standard"
      replicas      = 2
    }
    
    prod = {
      server_size    = "large"
      db_size       = "medium"
      backup_enabled = true
      ssl_enabled   = true
      monitoring    = "advanced"
      replicas      = 3
    }
  }
  
  # Configuración actual basada en el entorno
  current_config = local.env_config[var.environment]
  
  # Configuración de recursos por tamaño
  server_specs = {
    small  = { cpu = "1", memory = "2GB", storage = "20GB" }
    medium = { cpu = "2", memory = "4GB", storage = "50GB" }
    large  = { cpu = "4", memory = "8GB", storage = "100GB" }
  }
  
  db_specs = {
    micro  = { cpu = "1", memory = "1GB", storage = "10GB" }
    small  = { cpu = "1", memory = "2GB", storage = "20GB" }
    medium = { cpu = "2", memory = "4GB", storage = "50GB" }
  }
  
  # Tags comunes para todos los recursos
  common_tags = {
    Environment   = var.environment
    Company       = var.company_name
    Application   = "payroll"
    ManagedBy     = "terraform"
    Module        = "payroll-app"
    CreatedAt     = timestamp()
  }
}

# ===========================================
# RECURSOS ALEATORIOS
# ===========================================

# ID único para nombrar recursos
resource "random_string" "app_id" {
  length  = 6
  special = false
  upper   = false
}

# Contraseña segura para la base de datos
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# ===========================================
# SERVIDOR WEB
# ===========================================

# Configuración principal del servidor web
resource "local_file" "web_server_config" {
  filename = "${var.company_name}-${var.environment}-web-server.conf"
  content = templatefile("${path.module}/templates/web-server.tpl", {
    company_name    = var.company_name
    environment     = var.environment
    app_id         = random_string.app_id.result
    server_config  = local.current_config
    server_specs   = local.server_specs[local.current_config.server_size]
    employee_count = var.employee_count
    department_count = var.department_count
    ssl_enabled    = local.current_config.ssl_enabled
    monitoring     = local.current_config.monitoring
  })
}

# Configuración de la aplicación de nóminas
resource "local_file" "payroll_app_config" {
  filename = "${var.company_name}-${var.environment}-payroll-app.json"
  content = jsonencode({
    application = {
      name         = "payroll-system"
      version      = "2.1.0"
      environment  = var.environment
      company      = var.company_name
      app_id       = random_string.app_id.result
    }
    
    server = {
      size         = local.current_config.server_size
      replicas     = local.current_config.replicas
      cpu          = local.server_specs[local.current_config.server_size].cpu
      memory       = local.server_specs[local.current_config.server_size].memory
      storage      = local.server_specs[local.current_config.server_size].storage
    }
    
    features = {
      ssl_enabled    = local.current_config.ssl_enabled
      backup_enabled = local.current_config.backup_enabled
      monitoring     = local.current_config.monitoring
      auto_scaling   = var.environment == "prod" ? true : false
    }
    
    business = {
      employee_count   = var.employee_count
      department_count = var.department_count
      payroll_frequency = var.payroll_frequency
    }
    
    metadata = local.common_tags
  })
}

# ===========================================
# BASE DE DATOS
# ===========================================

# Configuración de la base de datos
resource "local_file" "database_config" {
  filename = "${var.company_name}-${var.environment}-database.conf"
  content = templatefile("${path.module}/templates/database.tpl", {
    company_name  = var.company_name
    environment   = var.environment
    app_id       = random_string.app_id.result
    db_config    = local.current_config
    db_specs     = local.db_specs[local.current_config.db_size]
    db_password  = random_password.db_password.result
  })
}

# Script SQL de inicialización
resource "local_file" "database_schema" {
  filename = "${var.company_name}-${var.environment}-schema.sql"
  content = templatefile("${path.module}/templates/schema.sql.tpl", {
    company_name     = var.company_name
    environment      = var.environment
    employee_count   = var.employee_count
    department_count = var.department_count
  })
}

# ===========================================
# ALMACENAMIENTO (S3 simulado)
# ===========================================

# Configuración del bucket para documentos
resource "local_file" "storage_config" {
  filename = "${var.company_name}-${var.environment}-storage.conf"
  content = templatefile("${path.module}/templates/storage.tpl", {
    company_name = var.company_name
    environment  = var.environment
    app_id      = random_string.app_id.result
    versioning  = local.current_config.backup_enabled
    encryption  = local.current_config.ssl_enabled
  })
}

# ===========================================
# MONITOREO (condicional)
# ===========================================

# Configuración de monitoreo (solo si está habilitado)
resource "local_file" "monitoring_config" {
  count = local.current_config.monitoring != "none" ? 1 : 0
  
  filename = "${var.company_name}-${var.environment}-monitoring.conf"
  content = templatefile("${path.module}/templates/monitoring.tpl", {
    company_name = var.company_name
    environment  = var.environment
    monitoring_level = local.current_config.monitoring
    replicas     = local.current_config.replicas
    alerts_enabled = var.environment == "prod"
  })
}

# ===========================================
# BACKUP (condicional)
# ===========================================

# Configuración de backup (solo si está habilitado)
resource "local_file" "backup_config" {
  count = local.current_config.backup_enabled ? 1 : 0
  
  filename = "${var.company_name}-${var.environment}-backup.conf"
  content = templatefile("${path.module}/templates/backup.tpl", {
    company_name = var.company_name
    environment  = var.environment
    retention_days = var.environment == "prod" ? 365 : 30
    frequency    = var.environment == "prod" ? "daily" : "weekly"
  })
}

# ===========================================
# RESUMEN DE DESPLIEGUE
# ===========================================

# Resumen completo del despliegue
resource "local_file" "deployment_summary" {
  filename = "${var.company_name}-${var.environment}-DEPLOYMENT-SUMMARY.md"
  content = templatefile("${path.module}/templates/summary.md.tpl", {
    company_name     = var.company_name
    environment      = var.environment
    app_id          = random_string.app_id.result
    current_config  = local.current_config
    server_specs    = local.server_specs[local.current_config.server_size]
    db_specs        = local.db_specs[local.current_config.db_size]
    employee_count  = var.employee_count
    department_count = var.department_count
    payroll_frequency = var.payroll_frequency
    created_at      = timestamp()
  })
}