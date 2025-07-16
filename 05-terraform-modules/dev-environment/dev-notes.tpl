# 🟢 NOTAS DE CONFIGURACIÓN - DESARROLLO

## Entorno de Desarrollo: ${company_name}

**App ID:** ${app_info.app_id}  
**URL:** ${app_info.application_url}  
**Desplegado:** ${app_info.deployment_date}

---

## 🛠️ Configuración para Desarrolladores

### ¿Qué se ha creado?
Tu entorno de desarrollo incluye:
- ✅ Servidor web configurado (modo debug)
- ✅ Base de datos con esquema inicial
- ✅ Almacenamiento para documentos
- ✅ Configuración básica de monitoreo
- ✅ Variables de entorno listas

### 📁 Archivos Importantes
%{ for file in files_created ~}
- `${file}`
%{ endfor ~}

---

## 🚀 Guía de Inicio Rápido

### 1. Configurar Variables de Entorno
```bash
# Cargar variables automáticamente
source .env.development

# O configurar manualmente:
export COMPANY_NAME="${company_name}"
export ENVIRONMENT="dev"
export APP_ID="${app_info.app_id}"
```

### 2. Conectar a la Base de Datos
```bash
# Credenciales en el archivo de configuración
cat ${company_name}-dev-database.conf

# Ejemplo de conexión (ajustar según tu herramienta)
mysql -h localhost -P 3306 -u payroll_admin -p ${company_name}_payroll
```

### 3. Estructura de la Base de Datos
```sql
-- Ver tablas creadas
SHOW TABLES;

-- Ver empleados de ejemplo
SELECT * FROM employees LIMIT 5;

-- Ver departamentos
SELECT * FROM departments;
```

### 4. Servidor Web
- **Puerto:** 80 (HTTP)
- **Debug:** Habilitado
- **SSL:** Deshabilitado (para facilitar desarrollo)
- **Logs:** Nivel DEBUG

---

## 💡 Tips para Desarrollo

### Configuración Optimizada para Dev:
- **Debug Mode:** ✅ Habilitado - logs verbosos
- **SSL:** ❌ Deshabilitado - conexiones HTTP simples
- **Backup:** ❌ Deshabilitado - no necesario en dev
- **Cache:** ❌ Deshabilitado - cambios inmediatos
- **Monitoreo:** Básico - solo métricas esenciales

### Datos de Prueba:
- **Empleados:** ${employee_count} empleados de ejemplo
- **Departamentos:** 4 departamentos configurados
- **Nóminas:** Esquema listo para pruebas

### Rendimiento Esperado:
- **Tiempo de respuesta:** ~2000ms (no optimizado)
- **Usuarios concurrentes:** ~25
- **Throughput:** Moderado

---

## 🔧 Comandos Útiles

### Ver Configuración
```bash
# Resumen completo
cat ${company_name}-dev-DEPLOYMENT-SUMMARY.md

# Configuración del servidor
cat ${company_name}-dev-web-server.conf

# Esquema de base de datos
head -50 ${company_name}-dev-schema.sql
```

### Desarrollo Local
```bash
# Iniciar servidor local (ejemplo)
npm run dev

# Conectar a base de datos
npm run db:connect

# Ejecutar migraciones
npm run db:migrate

# Cargar datos de prueba
npm run db:seed
```

### Testing
```bash
# Ejecutar tests unitarios
npm test

# Tests de integración
npm run test:integration

# Tests de la API
npm run test:api
```

---

## 📚 Recursos Adicionales

### Documentación:
- **API Docs:** `http://localhost:8080/docs`
- **Database Schema:** Ver archivo `${company_name}-dev-schema.sql`
- **Config Reference:** Ver archivos `.conf`

### Herramientas Recomendadas:
- **Base de datos:** MySQL Workbench, phpMyAdmin
- **API Testing:** Postman, Insomnia
- **Logs:** tail -f logs/app.log

### Escalamiento:
Cuando necesites más recursos:
1. Modifica `variables.tf` 
2. Ejecuta `terraform apply`
3. Los recursos se ajustarán automáticamente

---

## ⚠️ Recordatorios Importantes

### Datos de Desarrollo:
- ❌ **NO uses datos reales** de empleados
- ✅ **Usa datos ficticios** para pruebas
- ✅ **Password de DB generada** automáticamente

### Seguridad:
- ❌ **NO expongas** al internet público
- ❌ **NO uses en producción**
- ✅ **Solo para desarrollo local**

### Limpieza:
```bash
# Al terminar, limpia el entorno
terraform destroy
```

---

## 🎯 Próximos Pasos

1. **Familiarízate** con la estructura del proyecto
2. **Configura tu IDE** con las variables de entorno
3. **Ejecuta los tests** para verificar que todo funciona
4. **Empieza a desarrollar** nuevas funcionalidades
5. **Cuando esté listo**, despliega en staging

---

¡Happy coding! 🚀👨‍💻👩‍💻