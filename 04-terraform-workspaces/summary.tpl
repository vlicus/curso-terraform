# 📊 Resumen del Entorno: ${workspace}

**Proyecto:** ${project_name}  
**Entorno:** ${workspace}  
**Descripción:** ${description}  
**Creado:** ${created_at}

---

## 🖥️ Infraestructura Desplegada

### Servidores
- **Cantidad:** ${server_count} servidor${server_count > 1 ? "es" : ""}
- **Tamaño:** ${instance_size}

### Recursos por Servidor
- **CPU:** ${cpu} core${cpu > 1 ? "s" : ""}
- **Memoria:** ${memory}
- **Almacenamiento:** ${storage}

### Recursos Totales
- **CPU Total:** ${server_count * cpu} cores
- **Memoria Total:** ${server_count}x${memory}
- **Storage Total:** ${server_count}x${storage}

---

## ⚙️ Configuración del Entorno

### Características Habilitadas
- **Monitoreo:** ${monitoring ? "✅ Habilitado" : "❌ Deshabilitado"}
- **Backup:** ${backup ? "✅ Habilitado" : "❌ Deshabilitado"}
- **SSL:** ${ssl_enabled ? "✅ Habilitado" : "❌ Deshabilitado"}
- **Debug Mode:** ${debug_mode ? "✅ Habilitado" : "❌ Deshabilitado"}

### Configuración Específica
%{ if workspace == "prod" ~}
- **Nivel de Alerta:** Crítico
- **Retención de Backup:** 30 días
- **Nivel de Log:** ERROR
- **Timeout de Sesión:** 1 hora
- **Conexiones Máximas:** 1000
%{ else ~}
%{ if workspace == "staging" ~}
- **Nivel de Alerta:** Warning
- **Retención de Backup:** 7 días  
- **Nivel de Log:** INFO
- **Timeout de Sesión:** 30 minutos
- **Conexiones Máximas:** 500
%{ else ~}
- **Nivel de Alerta:** Info
- **Sin backup automático**
- **Nivel de Log:** DEBUG
- **Timeout de Sesión:** 15 minutos
- **Conexiones Máximas:** 100
%{ endif ~}
%{ endif ~}

---

## 📁 Archivos Generados

Este workspace ha generado los siguientes archivos:

### Configuración Principal
- `${project_name}-${workspace}-config.json` - Configuración general
- `${project_name}-${workspace}-RESUMEN.md` - Este archivo

### Servidores
%{ for i in range(server_count) ~}
- `${project_name}-${workspace}-server-${i + 1}.conf` - Servidor ${i + 1}
%{ endfor ~}

### Servicios Adicionales
%{ if monitoring ~}
- `${project_name}-${workspace}-monitoring.conf` - Configuración de monitoreo
%{ endif ~}
%{ if backup ~}
- `${project_name}-${workspace}-backup.conf` - Configuración de backups
%{ endif ~}

---

## 🎯 Comparación entre Entornos

| Característica | Development | Staging | Production |
|---------------|-------------|---------|------------|
| Servidores | 1 small | 2 medium | 3 large |
| CPU | 1 core | 2 cores | 4 cores |
| Memoria | 1GB | 4GB | 8GB |
| Monitoreo | ❌ | ✅ | ✅ |
| Backup | ❌ | ✅ | ✅ |
| SSL | ❌ | ❌ | ✅ |
| Debug | ✅ | ❌ | ❌ |

---

## 🚀 Comandos Útiles

### Gestión de Workspaces
```bash
# Ver workspace actual
terraform workspace show

# Listar workspaces
terraform workspace list

# Crear nuevo workspace
terraform workspace new [nombre]

# Cambiar workspace
terraform workspace select [nombre]

# Ver estado del workspace actual
terraform show
```

### Comparar Entornos
```bash
# Ver desarrollo
terraform workspace select default && terraform show

# Ver staging
terraform workspace select staging && terraform show

# Ver producción  
terraform workspace select prod && terraform show
```

---

## 💡 Próximos Pasos

1. **Experimenta:** Cambia entre workspaces y observa las diferencias
2. **Compara:** Revisa los archivos generados en cada entorno
3. **Modifica:** Ajusta las variables y ve cómo afecta cada workspace
4. **Escala:** Añade nuevos entornos o configuraciones

---

*Workspace: **${workspace}** | Generado por Terraform el ${created_at}*