# ===========================================
# OUTPUTS DEL ENTORNO DE DESARROLLO
# ===========================================

output "development_summary" {
  description = "Resumen del entorno de desarrollo desplegado"
  value = {
    environment_type = "🟢 DESARROLLO"
    company_name     = var.company_name
    status          = "Desplegado exitosamente"
    access_info     = module.payroll_system.application_info
  }
}

output "module_outputs" {
  description = "Todas las salidas del módulo payroll-app"
  value = {
    application_info       = module.payroll_system.application_info
    infrastructure_summary = module.payroll_system.infrastructure_summary
    business_configuration = module.payroll_system.business_configuration
    connection_info       = module.payroll_system.connection_info
  }
}

output "development_files" {
  description = "Archivos específicos del entorno de desarrollo"
  value = {
    dev_notes        = local_file.dev_notes.filename
    startup_script   = local_file.dev_startup_script.filename
    env_variables    = local_file.dev_env_vars.filename
    module_files     = module.payroll_system.files_created
  }
}

output "quick_start_guide" {
  description = "Guía rápida para empezar con el desarrollo"
  value = [
    "1. Lee las notas de desarrollo: cat ${local_file.dev_notes.filename}",
    "2. Configura variables de entorno: source ${local_file.dev_env_vars.filename}",
    "3. Ejecuta el script de inicio: bash ${local_file.dev_startup_script.filename}",
    "4. Revisa la configuración: cat ${module.payroll_system.connection_info.deployment_summary}",
    "5. ¡Empieza a desarrollar! 🚀"
  ]
}