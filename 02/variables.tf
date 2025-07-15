variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  
  validation {
    condition     = length(var.project_name) > 3 && length(var.project_name) < 20
    error_message = "El nombre del proyecto debe tener entre 4 y 19 caracteres."
  }
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "El nombre debe empezar con letra minúscula, solo usar a-z, 0-9 y guiones."
  }
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging, o prod."
  }
}

variable "max_connections" {
  description = "Número máximo de conexiones"
  type        = number
  default     = 100
  
  validation {
    condition     = var.max_connections >= 10 && var.max_connections <= 1000
    error_message = "Las conexiones deben estar entre 10 y 1000."
  }
}

variable "features" {
  description = "Features habilitadas"
  type        = list(string)
  default     = ["auth", "logging"]
  
  validation {
    condition = alltrue([
      for feature in var.features : contains(["auth", "logging", "monitoring", "cache"], feature)
    ])
    error_message = "Features válidas: auth, logging, monitoring, cache."
  }
}