# ===========================================
# ENTORNO DE DESARROLLO - SISTEMA NÓMINAS
# ===========================================
# Este archivo usa el módulo payroll-app para crear
# un entorno de desarrollo completo

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
  environment  = "dev"
  
  # Variables de negocio
  employee_count    = var.employee_count
  department_count  = var.department_count
  payroll_frequency = var.payroll_frequency
}

# ===========================================
# CONFIGURACIONES ADICIONALES DE DESARROLLO
# ===========================================

# Archivo específico para desarrollo con configuraciones extra
resource "local_file" "dev_notes" {
  filename = "DEV-SETUP-NOTES.md"
  content = templatefile("${path.module}/dev-notes.tpl", {
    company_name     = var.company_name
    app_info         = module.payroll_system.application_info
    files_created    = module.payroll_system.files_created
    employee_count   = var.employee_count
    department_count = var.department_count
  })
}

# Script de inicio para desarrolladores
resource "local_file" "dev_startup_script" {
  filename = "start-dev-environment.sh"
  content = templatefile("${path.module}/startup-script.tpl", {
    company_name = var.company_name
    app_id      = module.payroll_system.application_info.app_id
  })
  
  # Hacer el script ejecutable (simulado con permisos en el contenido)
}

# Configuración de variables de entorno para desarrollo
resource "local_file" "dev_env_vars" {
  filename = ".env.development"
  content = templatefile("${path.module}/env-vars.tpl", {
    company_name = var.company_name
    environment  = "dev"
    app_info     = module.payroll_system.application_info
    db_info      = module.payroll_system.connection_info
  })
}