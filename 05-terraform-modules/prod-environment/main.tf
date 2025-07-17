# ===========================================
# ENTORNO DE PRODUCCIÓN - SISTEMA NÓMINAS
# ===========================================
# Este archivo usa el módulo payroll-app para crear
# un entorno de producción completo

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
  required_version = ">= 1.0"
}

# ===========================================
# LLAMADA AL MÓDULO
# ===========================================

module "payroll_system" {
  # Ruta relativa al módulo
  source = "../modules/payroll-app"
  
  # Variables requeridas
  company_name = var.company_name
  environment  = "prod"
  
  # Variables de negocio
  employee_count    = var.employee_count
  department_count  = var.department_count
  payroll_frequency = var.payroll_frequency
}

# ===========================================
# CONFIGURACIONES ADICIONALES DE PRODUCCIÓN
# ===========================================

# Checklist de producción
resource "local_file" "prod_checklist" {
  filename = "PRODUCTION-CHECKLIST.md"
  content = templatefile("${path.module}/prod-checklist.tpl", {
    company_name    = var.company_name
    app_info        = module.payroll_system.application_info
    infra_summary   = module.payroll_system.infrastructure_summary
    employee_count  = var.employee_count
    department_count = var.department_count
  })
}

# Script de monitoreo para producción
resource "local_file" "prod_monitoring_script" {
  filename = "monitor-production.sh"
  content = templatefile("${path.module}/monitoring-script.tpl", {
    company_name = var.company_name
    app_id      = module.payroll_system.application_info.app_id
  })
}

# Configuración de alertas críticas
resource "local_file" "prod_alerts_config" {
  filename = "critical-alerts.json"
  content = jsonencode({
    system = "payroll-production"
    company = var.company_name
    app_id = module.payroll_system.application_info.app_id
    
    critical_alerts = {
      database_down = {
        threshold = "1_minute"
        actions = ["email", "sms", "pager"]
        escalation = true
      }
      
      high_cpu_usage = {
        threshold = "85%_for_5_minutes"
        actions = ["email", "slack"]
        escalation = false
      }
      
      low_disk_space = {
        threshold = "90%_full"
        actions = ["email", "slack"]
        escalation = true
      }
      
      failed_payroll_processing = {
        threshold = "any_failure"
        actions = ["email", "sms", "pager", "slack"]
        escalation = true
      }
    }
    
    notification_channels = {
      email = ["admin@${var.company_name}.com", "devops@${var.company_name}.com"]
      slack = "#alerts-prod"
      pager_duty = "payroll-system-oncall"
    }
  })
}

# Configuración de backup verificado
resource "local_file" "prod_backup_verification" {
  filename = "backup-verification.conf"
  content = templatefile("${path.module}/backup-verification.tpl", {
    company_name = var.company_name
    environment  = "prod"
  })
}