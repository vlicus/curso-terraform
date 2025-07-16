# Configuración de Servicios - ${environment}

## Puertos
%{ for service, port in ports ~}
${service}: ${port}
%{ endfor ~}

## Configuración del Entorno
instancias: ${config.instance_count}
log_level: ${config.log_level}
monitoring: ${config.monitoring ? "habilitado" : "deshabilitado"}