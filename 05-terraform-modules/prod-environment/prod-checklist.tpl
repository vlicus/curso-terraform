# 🔴 CHECKLIST DE PRODUCCIÓN - ${company_name}

## ⚠️ ANTES DE DESPLEGAR EN PRODUCCIÓN

**App ID:** ${app_info.app_id}  
**URL:** ${app_info.application_url}  
**Fecha:** ${app_info.deployment_date}

---

## 🔐 SEGURIDAD - CRÍTICO

### SSL/TLS
- [ ] ✅ SSL habilitado: ${infra_summary.server.ssl_enabled ? "SÍ" : "❌ FALTA"}
- [ ] Certificados válidos y actualizados
- [ ] Redirección HTTP → HTTPS forzada
- [ ] Headers de seguridad configurados

### Acceso y Autenticación
- [ ] Contraseñas seguras generadas automáticamente
- [ ] Acceso de administrador limitado
- [ ] Logs de acceso habilitados
- [ ] Firewall configurado correctamente

### Datos Sensibles
- [ ] Encriptación en reposo habilitada
- [ ] Encriptación en tránsito habilitada
- [ ] Datos de empleados protegidos (GDPR/LOPD)
- [ ] Acceso a datos auditado

---

## 💾 BACKUP Y RECUPERACIÓN - CRÍTICO

### Backup
- [ ] ✅ Backup habilitado: ${infra_summary.server.backup_enabled ? "SÍ" : "❌ FALTA"}
- [ ] Backup diario configurado
- [ ] Backup cross-region habilitado
- [ ] Retención de 7 años para nóminas
- [ ] **VERIFICAR ÚLTIMO BACKUP FUNCIONAL**

### Recuperación
- [ ] Procedimientos de DR documentados
- [ ] RTO < 4 horas verificado
- [ ] RPO < 1 hora verificado
- [ ] Plan de recuperación probado

---

## 📊 MONITOREO Y ALERTAS - CRÍTICO

### Monitoreo
- [ ] ✅ Monitoreo avanzado: ${infra_summary.server.monitoring == "advanced" ? "SÍ" : "❌ FALTA"}
- [ ] Métricas de sistema configuradas
- [ ] Métricas de aplicación configuradas
- [ ] Dashboards de producción listos

### Alertas Críticas
- [ ] Alertas por email configuradas
- [ ] Alertas por SMS configuradas
- [ ] Integración con PagerDuty
- [ ] Escalación automática habilitada
- [ ] **PROBAR TODAS LAS ALERTAS**

---

## 🏗️ INFRAESTRUCTURA

### Servidor
- [ ] ✅ Servidores: ${infra_summary.server.replicas} x ${infra_summary.server.size}
- [ ] Auto-scaling configurado
- [ ] Load balancer configurado
- [ ] Health checks funcionando

### Base de Datos
- [ ] ✅ Base de datos: ${infra_summary.database.size} (${infra_summary.database.specs.cpu} CPU, ${infra_summary.database.specs.memory})
- [ ] Multi-AZ habilitado
- [ ] Conexiones limitadas apropiadamente
- [ ] Índices optimizados

### Red
- [ ] VPC aislada configurada
- [ ] Security groups restrictivos
- [ ] NAT Gateway para salida
- [ ] DNS interno configurado

---

## 📋 CUMPLIMIENTO Y LEGAL

### Regulaciones
- [ ] **SOX compliance** verificado
- [ ] **GDPR compliance** verificado
- [ ] **SOC 2** requirements cumplidos
- [ ] Retención de datos según ley

### Auditoría
- [ ] Logs de auditoría habilitados
- [ ] Trazabilidad de cambios
- [ ] Acceso a datos registrado
- [ ] Reportes de compliance listos

---

## 🧪 TESTING PRE-PRODUCCIÓN

### Funcional
- [ ] **Tests de nómina completos** ejecutados
- [ ] **Tests de integración** pasados
- [ ] **Tests de carga** con ${employee_count} empleados
- [ ] **Tests de seguridad** completados

### Performance
- [ ] Tiempo de respuesta < 500ms verificado
- [ ] Throughput máximo probado
- [ ] Memory leaks descartados
- [ ] CPU usage normal bajo carga

---

## 🚨 PROCEDIMIENTOS DE EMERGENCIA

### Contactos Críticos
- [ ] Lista de contactos 24/7 actualizada
- [ ] Escalación definida claramente
- [ ] Canales de comunicación probados

### Rollback
- [ ] **Plan de rollback documentado**
- [ ] **Backup pre-despliegue verificado**
- [ ] Procedimiento de rollback probado
- [ ] Tiempo estimado de rollback < 30 min

---

## ✅ APROBACIONES REQUERIDAS

### Técnicas
- [ ] **DevOps Lead** - Infraestructura ✅
- [ ] **Security Officer** - Seguridad ✅  
- [ ] **DBA** - Base de datos ✅
- [ ] **QA Lead** - Testing ✅

### Negocio
- [ ] **HR Director** - Funcionalidad ✅
- [ ] **Finance Director** - Compliance ✅
- [ ] **CTO** - Aprobación técnica final ✅
- [ ] **CEO** - Aprobación ejecutiva ✅

---

## 🎯 POST-DESPLIEGUE (PRIMERAS 24H)

### Monitoreo Intensivo
- [ ] Monitoreo continuo durante 24h
- [ ] Verificación de métricas cada hora
- [ ] Revisión de logs cada 2 horas
- [ ] Backup exitoso verificado

### Validación de Negocio
- [ ] Procesamiento de nómina de prueba
- [ ] Acceso de usuarios validado
- [ ] Reportes generados correctamente
- [ ] Performance según SLA

---

## ⚠️ CRITERIOS DE STOP

**DETENER INMEDIATAMENTE SI:**
- [ ] ❌ Tiempo de respuesta > 1000ms
- [ ] ❌ Errores > 1% de requests
- [ ] ❌ Datos de empleados expuestos
- [ ] ❌ Backup falla
- [ ] ❌ Alerts críticas no funcionan

---

## 📞 CONTACTOS DE EMERGENCIA

**DevOps On-Call:** +34-XXX-XXX-XXX  
**Security Team:** security@${company_name}.com  
**Business Owner:** hr-director@${company_name}.com  
**Escalation:** cto@${company_name}.com  

---

**🚨 RECORDATORIO: NO DESPLEGAR EN VIERNES O ANTES DE FESTIVOS**

**✅ FIRMA DE APROBACIÓN FINAL:**
- **Nombre:** ________________
- **Cargo:** ________________  
- **Fecha:** ________________
- **Hora:** ________________

---

*Generado automáticamente por Terraform para ${company_name}*