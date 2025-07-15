# Archivo de configuración principal
resource "local_file" "advanced_config" {
  filename = "${var.project_name}-${var.environment}-config.json"
  content = jsonencode({
    project = {
      name         = var.project_name
      environment  = var.environment
      created_at   = timestamp()
    }
    settings = {
      max_connections = var.max_connections
      features       = var.features
      debug_mode     = var.environment != "prod"
    }
  })
}

# Archivo para cada feature
resource "local_file" "feature_configs" {
  for_each = toset(var.features)
  
  filename = "${var.project_name}-${each.key}-config.txt"
  content  = "Configuración para ${each.key} en ${var.environment}"
}