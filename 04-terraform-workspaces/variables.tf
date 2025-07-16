variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "mi-aplicacion"
  
  validation {
    condition     = length(var.project_name) > 2 && length(var.project_name) < 20
    error_message = "El nombre del proyecto debe tener entre 3 y 19 caracteres."
  }
}