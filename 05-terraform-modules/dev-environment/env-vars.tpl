# ===========================================
# VARIABLES DE ENTORNO - DESARROLLO
# ===========================================
# Archivo generado automáticamente por Terraform
# Para cargar: source .env.development

# Información básica
export COMPANY_NAME="${company_name}"
export ENVIRONMENT="${environment}"
export APP_ID="${app_info.app_id}"

# URLs de la aplicación
export APP_URL="${app_info.application_url}"
export API_URL="http://localhost:8080/api/v1"
export WEB_URL="http://localhost:8080"

# Base de datos
export DB_HOST="localhost"
export DB_PORT="3306"
export DB_NAME="${company_name}_payroll"
export DB_USER="payroll_admin"
export DB_PASSWORD_FILE="${db_info.database_config}"

# Configuración de la aplicación
export DEBUG_MODE="true"
export LOG_LEVEL="DEBUG"
export SSL_ENABLED="false"
export CACHE_ENABLED="false"

# Archivos de configuración
export WEB_CONFIG_FILE="${db_info.web_server_config}"
export DB_CONFIG_FILE="${db_info.database_config}"
export STORAGE_CONFIG_FILE="${db_info.storage_config}"

# Configuración de desarrollo
export NODE_ENV="development"
export PORT="8080"
export SESSION_TIMEOUT="900"
export MAX_FILE_UPLOAD="10MB"

# Paths útiles
export LOGS_DIR="./logs"
export TEMP_DIR="./temp"
export UPLOADS_DIR="./uploads"

# Configuración de testing
export TEST_DB_NAME="${company_name}_payroll_test"
export ENABLE_TEST_DATA="true"

echo "✅ Variables de entorno cargadas para ${company_name} (${environment})"