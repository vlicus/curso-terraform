#!/bin/bash
# ===========================================
# SCRIPT DE INICIO - ENTORNO DESARROLLO
# ===========================================
# Empresa: TechStartup
# App ID: vimyyp
# Generado por Terraform

echo "🚀 Iniciando entorno de desarrollo para TechStartup..."
echo "App ID: vimyyp"
echo "=========================================="

# Verificar archivos de configuración
echo "📁 Verificando archivos de configuración..."
if [ -f "TechStartup-dev-web-server.conf" ]; then
    echo "✅ Configuración del servidor web encontrada"
else
    echo "❌ Archivo de configuración del servidor no encontrado"
    exit 1
fi

if [ -f "TechStartup-dev-database.conf" ]; then
    echo "✅ Configuración de base de datos encontrada"
else
    echo "❌ Archivo de configuración de BD no encontrado"
    exit 1
fi

# Cargar variables de entorno
echo "🔧 Cargando variables de entorno..."
if [ -f ".env.development" ]; then
    source .env.development
    echo "✅ Variables de entorno cargadas"
else
    echo "⚠️  Archivo .env.development no encontrado"
fi

# Verificar dependencias (simulado)
echo "📦 Verificando dependencias..."
echo "✅ Node.js: simulado OK"
echo "✅ MySQL: simulado OK"
echo "✅ NPM packages: simulado OK"

# Crear directorios necesarios
echo "📂 Creando directorios de trabajo..."
mkdir -p logs
mkdir -p temp
mkdir -p uploads
echo "✅ Directorios creados"

# Mostrar información de conexión
echo ""
echo "🌐 INFORMACIÓN DE CONEXIÓN"
echo "=========================================="
echo "Servidor web: http://localhost:8080"
echo "Base de datos: localhost:3306"
echo "Database: TechStartup_payroll"
echo "Usuario DB: payroll_admin"
echo "Logs: ./logs/app.log"

echo ""
echo "📋 COMANDOS ÚTILES"
echo "=========================================="
echo "Ver config servidor: cat TechStartup-dev-web-server.conf"
echo "Ver config BD: cat TechStartup-dev-database.conf"
echo "Ver resumen: cat TechStartup-dev-DEPLOYMENT-SUMMARY.md"
echo "Iniciar app: npm run dev"
echo "Tests: npm test"

echo ""
echo "🎯 PRÓXIMOS PASOS"
echo "=========================================="
echo "1. Leer las notas: cat DEV-SETUP-NOTES.md"
echo "2. Configurar IDE con variables de entorno"
echo "3. Conectar a la base de datos"
echo "4. Ejecutar: npm run dev"
echo "5. Abrir: http://localhost:8080"

echo ""
echo "✨ ¡Entorno de desarrollo listo para TechStartup!"
echo "Happy coding! 🚀"