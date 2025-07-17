# CHECKLIST DE PRODUCCION - ${company_name}

## ANTES DE DESPLEGAR EN PRODUCCION

**App ID:** ${app_info.app_id}  
**URL:** ${app_info.application_url}  
**Fecha:** ${app_info.deployment_date}

---

## SEGURIDAD - CRITICO

### SSL/TLS
- [ ] SSL habilitado (verificar manualmente)
- [ ] Certificados validos y actualizados
- [ ] Redireccion HTTP → HTTPS forzada
- [ ] Headers de seguridad configurados

### Acceso y Autenticacion
- [ ] Contraseñas seguras generadas automaticamente
- [ ] Acceso de administrador limitado
- [ ] Logs de acceso habilitados
- [ ] Firewall configurado correctamente

### Datos Sensibles
- [ ] Encriptacion en reposo habilitada
- [ ] Encriptacion en transito habilitada
- [ ] Datos de empleados protegidos (GDPR/LOPD)
- [ ] Acceso a datos auditado

---

## BACKUP Y RECUPERACION - CRITICO

### Backup
- [ ] Backup habilitado (verificar manualmente)
- [ ] Backup diario configurado
- [ ] Backup cross-region habilitado
- [ ] Retencion de 7 años para nominas
- [ ] **VERIFICAR ULTIMO BACKUP FUNCIONAL**

### Recuperacion
- [ ] Procedimientos de DR documentados
- [ ] RTO < 4 horas verificado
- [ ] RPO < 1 hora verificado
- [ ] Plan de recuperacion probado

---

## MONITOREO Y ALERTAS - CRITICO

### Monitoreo
- [ ] Monitoreo avanzado configurado
- [ ] Metricas de sistema configuradas
- [ ] Metricas de aplicacion configuradas
- [ ] Dashboards de produccion listos

### Alertas Criticas
- [ ] Alertas por email configuradas
- [ ] Alertas por SMS configuradas
- [ ] Integracion con PagerDuty
- [ ] Escalacion automatica habilitada
- [ ] **PROBAR TODAS LAS ALERTAS**

---

## INFRAESTRUCTURA

### Servidor
- [ ] Servidores configurados correctamente
- [ ] Auto-scaling configurado
- [ ] Load balancer configurado
- [ ] Health checks funcionando

### Base de Datos
- [ ] Base de datos optimizada
- [ ] Multi-AZ habilitado
- [ ] Conexiones limitadas apropiadamente
- [ ] Indices optimizados

### Red
- [ ] VPC aislada configurada
- [ ] Security groups restrictivos
- [ ] NAT Gateway para salida
- [ ] DNS interno configurado

---

## CUMPLIMIENTO Y LEGAL

### Regulaciones
- [ ] **SOX compliance** verificado
- [ ] **GDPR compliance** verificado
- [ ] **SOC 2** requirements cumplidos
- [ ] Retencion de datos segun ley

### Auditoria
- [ ] Logs de auditoria habilitados
- [ ] Trazabilidad de cambios
- [ ] Acceso a datos registrado
- [ ] Reportes de compliance listos

---

## TESTING PRE-PRODUCCION

### Funcional
- [ ] **Tests de nomina completos** ejecutados
- [ ] **Tests de integracion** pasados
- [ ] **Tests de carga** con ${employee_count} empleados
- [ ] **Tests de seguridad** completados

### Performance
- [ ] Tiempo de respuesta < 500ms verificado
- [ ] Throughput maximo probado
- [ ] Memory leaks descartados
- [ ] CPU usage normal bajo carga

---

## PROCEDIMIENTOS DE EMERGENCIA

### Contactos Criticos
- [ ] Lista de contactos 24/7 actualizada
- [ ] Escalacion definida claramente
- [ ] Canales de comunicacion probados

### Rollback
- [ ] **Plan de rollback documentado**
- [ ] **Backup pre-despliegue verificado**
- [ ] Procedimiento de rollback probado
- [ ] Tiempo estimado de rollback < 30 min

---

## APROBACIONES REQUERIDAS

### Tecnicas
- [ ] **DevOps Lead** - Infraestructura
- [ ] **Security Officer** - Seguridad
- [ ] **DBA** - Base de datos
- [ ] **QA Lead** - Testing

### Negocio
- [ ] **HR Director** - Funcionalidad
- [ ] **Finance Director** - Compliance
- [ ] **CTO** - Aprobacion tecnica final
- [ ] **CEO** - Aprobacion ejecutiva

---

## POST-DESPLIEGUE (PRIMERAS 24H)

### Monitoreo Intensivo
- [ ] Monitoreo continuo durante 24h
- [ ] Verificacion de metricas cada hora
- [ ] Revision de logs cada 2 horas
- [ ] Backup exitoso verificado

### Validacion de Negocio
- [ ] Procesamiento de nomina de prueba
- [ ] Acceso de usuarios validado
- [ ] Reportes generados correctamente
- [ ] Performance segun SLA

---

## CRITERIOS DE STOP

**DETENER INMEDIATAMENTE SI:**
- [ ] Tiempo de respuesta > 1000ms
- [ ] Errores > 1% de requests
- [ ] Datos de empleados expuestos
- [ ] Backup falla
- [ ] Alerts criticas no funcionan

---

## CONTACTOS DE EMERGENCIA

**DevOps On-Call:** +34-XXX-XXX-XXX  
**Security Team:** security@${company_name}.com  
**Business Owner:** hr-director@${company_name}.com  
**Escalation:** cto@${company_name}.com  

---

**RECORDATORIO: NO DESPLEGAR EN VIERNES O ANTES DE FESTIVOS**

**FIRMA DE APROBACION FINAL:**
- **Nombre:** ________________
- **Cargo:** ________________  
- **Fecha:** ________________
- **Hora:** ________________

---

*Generado automaticamente por Terraform para ${company_name}*
*Empleados: ${employee_count} | Departamentos: ${department_count}*
*Environment: ${app_info.environment}*
