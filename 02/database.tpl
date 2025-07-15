# Configuración Base de Datos: ${db_name}
tipo: ${db_type}
tamaño: ${size_gb}GB
backup: ${backup ? "habilitado" : "deshabilitado"}
entorno: ${environment}

# Configuración específica
%{ if db_type == "postgresql" ~}
conexiones_max: 100
ssl_mode: require
%{ endif ~}
%{ if db_type == "redis" ~}
persistencia: ${backup ? "rdb" : "none"}
timeout: 300
%{ endif ~}