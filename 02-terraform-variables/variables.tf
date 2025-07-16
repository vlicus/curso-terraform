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

variable "create_backup" {
  description = "¿Crear archivo de backup?"
  type        = bool
  default     = true
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

variable "databases" {
  description = "Configuración de bases de datos"
  type = list(object({
    name     = string
    type     = string
    size_gb  = number
    backup   = bool
  }))
  default = [
    {
      name     = "users"
      type     = "postgresql"
      size_gb  = 10
      backup   = true
    },
    {
      name     = "cache"
      type     = "redis"
      size_gb  = 2
      backup   = false
    }
  ]
}

variable "service_ports" {
  description = "Puertos de los servicios"
  type        = map(number)
  default = {
    web      = 80
    api      = 8080
    database = 5432
    cache    = 6379
  }
}

variable "config_by_env" {
  description = "Configuración específica por entorno"
  type = map(object({
    instance_count = number
    log_level     = string
    monitoring    = bool
  }))
  default = {
    dev = {
      instance_count = 1
      log_level     = "DEBUG"
      monitoring    = false
    }
    staging = {
      instance_count = 2
      log_level     = "INFO"
      monitoring    = true
    }
    prod = {
      instance_count = 5
      log_level     = "ERROR"
      monitoring    = true
    }
  }
}