#!/bin/bash
# ===========================================
# SCRIPT DE MONITOREO - PRODUCCION
# ===========================================
# Empresa: ${company_name}
# App ID: ${app_id}
# Generado por Terraform

echo "MONITOREO DE PRODUCCION - ${company_name}"
echo "App ID: ${app_id}"
echo "========================================"

# Configuracion
LOG_FILE="monitoring-$$(date +%Y%m%d-%H%M%S).log"
ALERT_THRESHOLD_CPU=85
ALERT_THRESHOLD_MEMORY=90
ALERT_THRESHOLD_DISK=95

# Funcion de logging
log() {
    echo "[$$(date '+%Y-%m-%d %H:%M:%S')] $$1" | tee -a "$$LOG_FILE"
}

# Funcion de alerta
alert() {
    local severity=$$1
    local message=$$2
    log "[$$severity] $$message"
    
    # En produccion real, aqui enviarias a PagerDuty, Slack, etc.
    echo "ALERT: [$$severity] $$message" >> alerts.log
}

log "Iniciando monitoreo de sistema de nominas..."

# Verificar archivos de configuracion
log "Verificando configuracion..."
if [ -f "${company_name}-prod-web-server.conf" ]; then
    log "Configuracion de servidor web encontrada"
else
    alert "CRITICAL" "Archivo de configuracion del servidor no encontrado"
    exit 1
fi

if [ -f "${company_name}-prod-database.conf" ]; then
    log "Configuracion de base de datos encontrada"
else
    alert "CRITICAL" "Archivo de configuracion de BD no encontrado"
    exit 1
fi

# Simular verificacion de CPU
log "Verificando uso de CPU..."
CPU_USAGE=$$(( RANDOM % 100 ))
log "CPU Usage: $$CPU_USAGE%"

if [ $$CPU_USAGE -gt $$ALERT_THRESHOLD_CPU ]; then
    alert "WARNING" "Alto uso de CPU: $$CPU_USAGE%"
elif [ $$CPU_USAGE -gt 95 ]; then
    alert "CRITICAL" "Uso critico de CPU: $$CPU_USAGE%"
else
    log "CPU usage normal: $$CPU_USAGE%"
fi

# Simular verificacion de memoria
log "Verificando uso de memoria..."
MEMORY_USAGE=$$(( RANDOM % 100 ))
log "Memory Usage: $$MEMORY_USAGE%"

if [ $$MEMORY_USAGE -gt $$ALERT_THRESHOLD_MEMORY ]; then
    alert "WARNING" "Alto uso de memoria: $$MEMORY_USAGE%"
elif [ $$MEMORY_USAGE -gt 98 ]; then
    alert "CRITICAL" "Uso critico de memoria: $$MEMORY_USAGE%"
else
    log "Memory usage normal: $$MEMORY_USAGE%"
fi

# Simular verificacion de disco
log "Verificando espacio en disco..."
DISK_USAGE=$$(( RANDOM % 100 ))
log "Disk Usage: $$DISK_USAGE%"

if [ $$DISK_USAGE -gt $$ALERT_THRESHOLD_DISK ]; then
    alert "CRITICAL" "Espacio en disco critico: $$DISK_USAGE%"
elif [ $$DISK_USAGE -gt 85 ]; then
    alert "WARNING" "Poco espacio en disco: $$DISK_USAGE%"
else
    log "Disk usage normal: $$DISK_USAGE%"
fi

# Verificar conectividad de base de datos
log "Verificando conexion a base de datos..."
# Simulacion de test de conexion
if [ $$(( RANDOM % 10 )) -gt 1 ]; then
    log "Conexion a base de datos OK"
else
    alert "CRITICAL" "No se puede conectar a la base de datos"
fi

# Verificar respuesta de aplicacion web
log "Verificando respuesta de aplicacion web..."
RESPONSE_TIME=$$(( 200 + RANDOM % 800 ))
log "Response Time: $$RESPONSE_TIME ms"

if [ $$RESPONSE_TIME -gt 1000 ]; then
    alert "CRITICAL" "Tiempo de respuesta critico: $$RESPONSE_TIME ms"
elif [ $$RESPONSE_TIME -gt 500 ]; then
    alert "WARNING" "Tiempo de respuesta alto: $$RESPONSE_TIME ms"
else
    log "Response time normal: $$RESPONSE_TIME ms"
fi

# Verificar procesos criticos
log "Verificando procesos criticos..."

# Lista de procesos (evitando sintaxis de array compleja)
PROCESS_LIST="payroll-web payroll-api database backup-service"

for process in $$PROCESS_LIST; do
    # Simulacion de verificacion de proceso
    if [ $$(( RANDOM % 20 )) -gt 1 ]; then
        log "Proceso $$process running"
    else
        alert "CRITICAL" "Proceso $$process no esta ejecutandose"
    fi
done

# Verificar ultimo backup
log "Verificando ultimo backup..."
BACKUP_AGE=$$(( RANDOM % 48 ))
log "Ultimo backup hace: $$BACKUP_AGE horas"

if [ $$BACKUP_AGE -gt 25 ]; then
    alert "CRITICAL" "Backup muy antiguo: $$BACKUP_AGE horas"
elif [ $$BACKUP_AGE -gt 20 ]; then
    alert "WARNING" "Backup no reciente: $$BACKUP_AGE horas"
else
    log "Backup reciente: $$BACKUP_AGE horas"
fi

# Verificar certificados SSL
log "Verificando certificados SSL..."
SSL_DAYS=$$(( 30 + RANDOM % 300 ))
log "Certificado SSL expira en: $$SSL_DAYS dias"

if [ $$SSL_DAYS -lt 7 ]; then
    alert "CRITICAL" "Certificado SSL expira pronto: $$SSL_DAYS dias"
elif [ $$SSL_DAYS -lt 30 ]; then
    alert "WARNING" "Certificado SSL expira en: $$SSL_DAYS dias"
else
    log "Certificado SSL valido: $$SSL_DAYS dias restantes"
fi

# Resumen final
log "RESUMEN DE MONITOREO"
log "======================="
log "CPU: $$CPU_USAGE% | Memoria: $$MEMORY_USAGE% | Disco: $$DISK_USAGE%"
log "Response Time: $$RESPONSE_TIME ms"
log "Backup: hace $$BACKUP_AGE h | SSL: $$SSL_DAYS dias"

# Contar alertas
ALERTS_COUNT=$$(grep -c "ALERT:" alerts.log 2>/dev/null || echo "0")
log "Total alertas generadas: $$ALERTS_COUNT"

if [ $$ALERTS_COUNT -eq 0 ]; then
    log "Sistema funcionando correctamente"
    exit 0
elif [ $$ALERTS_COUNT -lt 3 ]; then
    log "Algunas alertas detectadas - revisar"
    exit 1
else
    log "Multiples alertas criticas - intervencion necesaria"
    exit 2
fi
