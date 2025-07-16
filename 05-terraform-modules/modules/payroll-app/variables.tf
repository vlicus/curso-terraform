# ===========================================
# VARIABLES DE ENTRADA DEL MÓDULO
# ===========================================

variable "company_name" {
  description = "Nombre de la empresa que usará el sistema de nóminas"
  type        = string
  
  validation {
    condition     = length(var.company_name) > 2 && length(var.company_name) < 30
    error_message = "El nombre de la empresa debe tener entre 3 y 29 caracteres."
  }
  
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.company_name))
    error_message = "El nombre debe empezar con letra y solo contener letras, números y guiones."
  }
}

variable "environment" {
  description = "Entorno donde se desplegará la aplicación"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser: dev, staging, o prod."
  }
}

variable "employee_count" {
  description = "Número aproximado de empleados en la empresa"
  type        = number
  default     = 50
  
  validation {
    condition     = var.employee_count >= 1 && var.employee_count <= 10000
    error_message = "El número de empleados debe estar entre 1 y 10,000."
  }
}

variable "department_count" {
  description = "Número de departamentos en la empresa"
  type        = number
  default     = 5
  
  validation {
    condition     = var.department_count >= 1 && var.department_count <= 100
    error_message = "El número de departamentos debe estar entre 1 y 100."
  }
}

variable "payroll_frequency" {
  description = "Frecuencia de procesamiento de nóminas"
  type        = string
  default     = "monthly"
  
  validation {
    condition     = contains(["weekly", "bi-weekly", "monthly"], var.payroll_frequency)
    error_message = "La frecuencia debe ser: weekly, bi-weekly, o monthly."
  }
}