# Configuración del Proyecto
Proyecto: ${project_name}
Entorno: ${environment}
Creado: ${timestamp}

# Configuraciones específicas del entorno
database_host = ${environment}-db.example.com
log_level = ${environment == "prod" ? "ERROR" : "DEBUG"}