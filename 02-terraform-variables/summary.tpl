# Resumen del Proyecto: ${project_name}

**Entorno:** ${environment}
**Total Bases de Datos:** ${total_dbs}
**Bases con Backup:** ${backup_dbs}

## Bases de Datos
%{ for db in databases ~}
- **${db.name}** (${db.type}): ${db.size_gb}GB ${db.backup ? "✅" : "❌"}
%{ endfor ~}

## Servicios
%{ for service, port in services ~}
- **${service}**: puerto ${port}
%{ endfor ~}

## Configuración del Entorno
- **Instancias:** ${env_config.instance_count}
- **Log Level:** ${env_config.log_level}
- **Monitoring:** ${env_config.monitoring ? "✅ Habilitado" : "❌ Deshabilitado"}