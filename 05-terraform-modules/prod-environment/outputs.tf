# ===========================================
# OUTPUTS DEL ENTORNO DE PRODUCCIÓN
# ===========================================

output "production_summary" {
  description = "Resumen del entorno de producción desplegado"
  value = {
    environment_type = "🔴 PRODUCCIÓN"
    company_name     = var.company_name
    status          = "Desplegado y monitoreado"
    access_info     = module.payroll_system.application_info
    security_level  = "MÁXIMO"
  }
}

output "critical_information" {
  description = "Información crítica para el equipo de operaciones"
  value = {
    application_url    = module.payroll_system.application_info.application_url
    infrastructure    = module.payroll_system.infrastructure_summary
    business_config   = module.payroll_system.business_configuration
    monitoring_files  = [
      local_file.prod_checklist.filename,
      local_file.prod_monitoring_script.filename,
      local_file.prod_alerts_config.filename
    ]
  }
}

output "production_files" {
  description = "Archivos específicos del entorno de producción"
  value = {
    checklist           = local_file.prod_checklist.filename
    monitoring_script   = local_file.prod_monitoring_script.filename
    alerts_config       = local_file.prod_alerts_config.filename
    backup_verification = local_file.prod_backup_verification.filename
    module_files        = module.payroll_system.files_created
  }
}

output "operational_procedures" {
  description = "Procedimientos operacionales críticos"
  value = [
    "🚨 CRÍTICO: Lee el checklist: cat ${local_file.prod_checklist.filename}",
    "📊 Monitoreo: bash ${local_file.prod_monitoring_script.filename}",
    "🔔 Alertas: cat ${local_file.prod_alerts_config.filename}",
    "💾 Backups: cat ${local_file.prod_backup_verification.filename}",
    "📋 Estado: cat ${module.payroll_system.connection_info.deployment_summary}",
    "⚠️  Nunca toques producción sin backup verificado!"
  ]
}

output "sla_commitments" {
  description = "Compromisos de nivel de servicio"
  value = {
    uptime_target        = "99.9%"
    response_time_target = "< 500ms"
    backup_frequency     = "Daily"
    recovery_time        = "< 4 hours"
    data_retention       = "7 years"
    security_compliance  = "SOX, GDPR, SOC2"
  }
}