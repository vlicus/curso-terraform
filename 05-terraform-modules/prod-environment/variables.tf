variable "company_name" {
  description = "Nombre de la empresa para el entorno de producción"
  type        = string
  default     = "Enterprise-Corp"
  
  validation {
    condition     = length(var.company_name) > 2 && length(var.company_name) < 30
    error_message = "El nombre de la empresa debe tener entre 3 y 29 caracteres."
  }
}

variable "employee_count" {
  description = "Número real de empleados en la empresa"
  type        = number
  default     = 500
  
  validation {
    condition     = var.employee_count >= 10 && var.employee_count <= 10000
    error_message = "Para producción, entre 10 y 10,000 empleados."
  }
}

variable "department_count" {
  description = "Número real de departamentos"
  type        = number
  default     = 15
  
  validation {
    condition     = var.department_count >= 1 && var.department_count <= 100
    error_message = "Para producción, máximo 100 departamentos."
  }
}

variable "payroll_frequency" {
  description = "Frecuencia real de procesamiento de nóminas"
  type        = string
  default     = "bi-weekly"
  
  validation {
    condition     = contains(["weekly", "bi-weekly", "monthly"], var.payroll_frequency)
    error_message = "La frecuencia debe ser: weekly, bi-weekly, o monthly."
  }
}