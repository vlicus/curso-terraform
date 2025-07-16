variable "company_name" {
  description = "Nombre de la empresa para el entorno de desarrollo"
  type        = string
  default     = "TechStartup"
  
  validation {
    condition     = length(var.company_name) > 2 && length(var.company_name) < 30
    error_message = "El nombre de la empresa debe tener entre 3 y 29 caracteres."
  }
}

variable "employee_count" {
  description = "Número de empleados para pruebas en desarrollo"
  type        = number
  default     = 25
  
  validation {
    condition     = var.employee_count >= 1 && var.employee_count <= 100
    error_message = "Para desarrollo, máximo 100 empleados."
  }
}

variable "department_count" {
  description = "Número de departamentos para pruebas"
  type        = number
  default     = 4
  
  validation {
    condition     = var.department_count >= 1 && var.department_count <= 20
    error_message = "Para desarrollo, máximo 20 departamentos."
  }
}

variable "payroll_frequency" {
  description = "Frecuencia de nóminas para pruebas"
  type        = string
  default     = "monthly"
  
  validation {
    condition     = contains(["weekly", "bi-weekly", "monthly"], var.payroll_frequency)
    error_message = "La frecuencia debe ser: weekly, bi-weekly, o monthly."
  }
}