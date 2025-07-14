# Laboratorio 2: Dominando Variables en Terraform

## 🎯 Objetivos de Aprendizaje

Al completar este laboratorio entenderás:
- Cómo usar variables para hacer código reutilizable
- Diferentes tipos de variables (string, number, bool, list, map, object)
- Validaciones y valores por defecto
- Formas de pasar valores a las variables
- Interpolación y funciones con variables

## 📚 Contexto

Las variables son fundamentales en Terraform. Te permiten crear configuraciones flexibles y reutilizables, igual que en programación.

---

## 🔍 Diferencia entre variables.tf y terraform.tfvars

Antes de empezar, es crucial entender la diferencia entre estos dos tipos de archivos:

### 📋 variables.tf - "Las Reglas"
- **Define QUÉ variables existen**
- Especifica el tipo de dato (string, number, bool, list, map, object)
- Establece validaciones y restricciones
- Proporciona descripciones
- Puede incluir valores por defecto
- Es como el "contrato" de tu configuración

```hcl
# variables.tf - Define la variable
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  validation {
    condition     = length(var.project_name) > 3
    error_message = "Mínimo 4 caracteres."
  }
}
```

### 📝 terraform.tfvars - "Los Valores"
- **Define QUÉ VALORES tienen las variables**
- Proporciona los datos reales
- Se puede tener múltiples archivos (.tfvars)
- Diferentes archivos para diferentes entornos
- Aquí van los valores específicos de tu proyecto

```hcl
# terraform.tfvars - Asigna el valor
project_name = "mi-app-fantastica"
```

### 🔄 Flujo de Trabajo
1. **variables.tf** → Define las reglas: "Necesito una variable llamada project_name que sea string"
2. **terraform.tfvars** → Proporciona el valor: "project_name vale 'mi-app'"
3. **main.tf** → Usa la variable: `filename = "${var.project_name}.conf"`

### 💡 Analogía
- **variables.tf** es como un formulario en blanco con las preguntas
- **terraform.tfvars** es el formulario rellenado con las respuestas


## 📝 Entendiendo las Templates en Terraform

Las **templates** son una herramienta poderosa que te permite generar contenido dinámico combinando texto estático con variables y lógica. Piensa en ellas como "plantillas" que se rellenan con datos.

### ¿Por qué usar templates?

1. **Separación de lógica y contenido**: Mantienes la configuración separada del contenido
2. **Reutilización**: Una template puede usarse con diferentes variables
3. **Mantenimiento**: Es más fácil cambiar el formato sin tocar el código Terraform
4. **Legibilidad**: El contenido es más claro y fácil de entender

### Tipos de Templates

#### 1. Templates Inline (en el código)
```hcl
content = "Hola ${var.nombre}, tu proyecto es ${var.proyecto}"
```

#### 2. Templates con templatefile()
```hcl
content = templatefile("${path.module}/mi-template.tpl", {
  nombre   = var.nombre
  proyecto = var.proyecto
})
```

### Sintaxis de Templates

#### Variables básicas:
```
Proyecto: ${project_name}
Entorno: ${environment}
```

#### Condicionales:
```
%{ if environment == "prod" ~}
Log Level: ERROR
%{ else ~}
Log Level: DEBUG
%{ endif ~}
```

#### Bucles:
```
Bases de datos:
%{ for db in databases ~}
- ${db.name}: ${db.type}
%{ endfor ~}
```

#### Funciones:
```
Timestamp: ${timestamp()}
Mayúsculas: ${upper(project_name)}
Longitud: ${length(databases)} bases de datos
```

### Control de espacios con ~

- `~}` elimina espacios en blanco al final
- `{~` elimina espacios en blanco al inicio

```
%{ if condition ~}
Texto sin espacios extra
%{ endif ~}
```

### Ejemplo Práctico Completo

**Template archivo (`config.tpl`):**
```
# Configuración ${project_name}
## Generado automáticamente - NO EDITAR

[general]
project=${project_name}
environment=${environment}
created=${timestamp()}

[database]
%{ for db in databases ~}
${db.name}_host=${environment}-${db.name}.db.com
${db.name}_port=${db.type == "postgresql" ? "5432" : "3306"}
%{ if db.backup ~}
${db.name}_backup=enabled
%{ endif ~}
%{ endfor ~}

[features]
%{ for feature in features ~}
${feature}=enabled
%{ endfor ~}

%{ if environment == "prod" ~}
[production]
ssl_required=true
debug_mode=false
%{ else ~}
[development]
ssl_required=false
debug_mode=true
%{ endif ~}
```

**Uso en Terraform:**
```hcl
resource "local_file" "config" {
  filename = "app.conf"
  content = templatefile("${path.module}/config.tpl", {
    project_name = "mi-app"
    environment  = "dev"
    databases = [
      { name = "users", type = "postgresql", backup = true },
      { name = "cache", type = "redis", backup = false }
    ]
    features = ["auth", "logging"]
  })
}
```

### Funciones Útiles en Templates

- `timestamp()`: Fecha y hora actual
- `upper()`, `lower()`: Cambiar mayúsculas/minúsculas
- `length()`: Longitud de listas/strings
- `join()`: Unir elementos de una lista
- `split()`: Dividir strings
- `replace()`: Reemplazar texto

---


## 🚀 Ejercicio 1: Variables Básicas

### Objetivo
Aprender a definir y usar variables básicas.

### Paso a Paso

**1. Crea la estructura del proyecto:**
```
terraform-variables/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── outputs.tf
```

**2. Define las variables (`variables.tf`):**
```hcl
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  # Sin default - será obligatorio
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}

variable "create_backup" {
  description = "¿Crear archivo de backup?"
  type        = bool
  default     = true
}
```

**3. Usa las variables (`main.tf`):**
```hcl
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

# Archivo principal del proyecto
resource "local_file" "config" {
  filename = "${var.project_name}-${var.environment}.conf"
  content = templatefile("${path.module}/config.tpl", {
    project_name = var.project_name
    environment  = var.environment
    timestamp    = timestamp()
  })
}

# Archivo de backup condicional
resource "local_file" "backup" {
  count = var.create_backup ? 1 : 0
  
  filename = "${var.project_name}-${var.environment}-backup.conf"
  content  = "Backup creado el ${timestamp()}"
}
```

**4. Plantilla (`config.tpl`):**
```
# Configuración del Proyecto
Proyecto: ${project_name}
Entorno: ${environment}
Creado: ${timestamp}

# Configuraciones específicas del entorno
database_host = ${environment}-db.example.com
log_level = ${environment == "prod" ? "ERROR" : "DEBUG"}
```

**5. Valores de las variables (`terraform.tfvars`):**
```hcl
project_name  = "mi-app-web"
environment   = "desarrollo"
create_backup = true
```

**6. Outputs (`outputs.tf`):**
```hcl
output "files_created" {
  description = "Archivos creados por Terraform"
  value = {
    config_file = local_file.config.filename
    backup_file = var.create_backup ? local_file.backup[0].filename : "No se creó backup"
  }
}
```

**7. Ejecuta:**
```bash
terraform init
terraform plan
terraform apply
```

### 🧪 Experimentos
- Cambia `create_backup = false` y ejecuta `terraform apply`
- Prueba sin `terraform.tfvars` (te pedirá los valores)
- Ejecuta `terraform apply -var="environment=produccion"`

---

## 🔥 Ejercicio 2: Variables Avanzadas con Validación

### Objetivo
Aprender validaciones, tipos complejos y mejores prácticas.

**Actualiza `variables.tf`:**
```hcl
variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  
  validation {
    condition     = length(var.project_name) > 3 && length(var.project_name) < 20
    error_message = "El nombre del proyecto debe tener entre 4 y 19 caracteres."
  }
  
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "El nombre debe empezar con letra minúscula, solo usar a-z, 0-9 y guiones."
  }
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment debe ser: dev, staging, o prod."
  }
}

variable "max_connections" {
  description = "Número máximo de conexiones"
  type        = number
  default     = 100
  
  validation {
    condition     = var.max_connections >= 10 && var.max_connections <= 1000
    error_message = "Las conexiones deben estar entre 10 y 1000."
  }
}

variable "features" {
  description = "Features habilitadas"
  type        = list(string)
  default     = ["auth", "logging"]
  
  validation {
    condition = alltrue([
      for feature in var.features : contains(["auth", "logging", "monitoring", "cache"], feature)
    ])
    error_message = "Features válidas: auth, logging, monitoring, cache."
  }
}
```

**Actualiza `main.tf`:**
```hcl
# Archivo de configuración principal
resource "local_file" "advanced_config" {
  filename = "${var.project_name}-${var.environment}-config.json"
  content = jsonencode({
    project = {
      name         = var.project_name
      environment  = var.environment
      created_at   = timestamp()
    }
    settings = {
      max_connections = var.max_connections
      features       = var.features
      debug_mode     = var.environment != "prod"
    }
  })
}

# Archivo para cada feature
resource "local_file" "feature_configs" {
  for_each = toset(var.features)
  
  filename = "${var.project_name}-${each.key}-config.txt"
  content  = "Configuración para ${each.key} en ${var.environment}"
}
```

### 🧪 Experimentos
- Prueba valores inválidos y observa los mensajes de error
- Intenta `project_name = "Mi-Proyecto"` (mayúsculas)
- Usa `max_connections = 2000` (fuera del rango)

---

## 🏗️ Ejercicio 3: Variables Complejas (Listas y Mapas)

### Objetivo
Trabajar con estructuras de datos complejas.

**Añade a `variables.tf`:**
```hcl
variable "databases" {
  description = "Configuración de bases de datos"
  type = list(object({
    name     = string
    type     = string
    size_gb  = number
    backup   = bool
  }))
  default = [
    {
      name     = "users"
      type     = "postgresql"
      size_gb  = 10
      backup   = true
    },
    {
      name     = "cache"
      type     = "redis"
      size_gb  = 2
      backup   = false
    }
  ]
}

variable "service_ports" {
  description = "Puertos de los servicios"
  type        = map(number)
  default = {
    web      = 80
    api      = 8080
    database = 5432
    cache    = 6379
  }
}

variable "config_by_env" {
  description = "Configuración específica por entorno"
  type = map(object({
    instance_count = number
    log_level     = string
    monitoring    = bool
  }))
  default = {
    dev = {
      instance_count = 1
      log_level     = "DEBUG"
      monitoring    = false
    }
    staging = {
      instance_count = 2
      log_level     = "INFO"
      monitoring    = true
    }
    prod = {
      instance_count = 5
      log_level     = "ERROR"
      monitoring    = true
    }
  }
}
```

**Actualiza `main.tf`:**
```hcl
# Configuración para cada base de datos
resource "local_file" "database_configs" {
  for_each = {
    for db in var.databases : db.name => db
  }
  
  filename = "${var.project_name}-db-${each.key}.conf"
  content = templatefile("${path.module}/database.tpl", {
    db_name     = each.value.name
    db_type     = each.value.type
    size_gb     = each.value.size_gb
    backup      = each.value.backup
    environment = var.environment
  })
}

# Configuración de servicios
resource "local_file" "services_config" {
  filename = "${var.project_name}-services.conf"
  content = templatefile("${path.module}/services.tpl", {
    ports       = var.service_ports
    environment = var.environment
    config      = var.config_by_env[var.environment]
  })
}

# Archivo de resumen
resource "local_file" "summary" {
  filename = "${var.project_name}-summary.md"
  content = templatefile("${path.module}/summary.tpl", {
    project_name   = var.project_name
    environment    = var.environment
    databases      = var.databases
    services       = var.service_ports
    env_config     = var.config_by_env[var.environment]
    total_dbs      = length(var.databases)
    backup_dbs     = length([for db in var.databases : db if db.backup])
  })
}
```

**Crea `database.tpl`:**
```
# Configuración Base de Datos: ${db_name}
tipo: ${db_type}
tamaño: ${size_gb}GB
backup: ${backup ? "habilitado" : "deshabilitado"}
entorno: ${environment}

# Configuración específica
%{ if db_type == "postgresql" ~}
conexiones_max: 100
ssl_mode: require
%{ endif ~}
%{ if db_type == "redis" ~}
persistencia: ${backup ? "rdb" : "none"}
timeout: 300
%{ endif ~}
```

**Crea `services.tpl`:**
```
# Configuración de Servicios - ${environment}

## Puertos
%{ for service, port in ports ~}
${service}: ${port}
%{ endfor ~}

## Configuración del Entorno
instancias: ${config.instance_count}
log_level: ${config.log_level}
monitoring: ${config.monitoring ? "habilitado" : "deshabilitado"}
```

**Crea `summary.tpl`:**
```
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
```

---

## 🎯 Ejercicio 4: Múltiples Formas de Pasar Variables

### Objetivo
Conocer todas las formas de proporcionar valores a las variables.

**Prueba estos métodos:**

```bash
# 1. Usando terraform.tfvars (ya lo hiciste)
terraform apply

# 2. Usando línea de comandos
terraform apply -var="project_name=app-cli" -var="environment=staging"

# 3. Usando archivo personalizado
echo 'project_name = "app-custom"' > custom.tfvars
terraform apply -var-file="custom.tfvars"

# 4. Usando variables de entorno
export TF_VAR_project_name="app-env"
export TF_VAR_environment="prod"
terraform apply

# 5. Modo interactivo (sin valores)
rm terraform.tfvars
unset TF_VAR_project_name TF_VAR_environment
terraform apply
```

---

## 📊 Ejercicio 5: Variables Locales y Cálculos

### Objetivo
Usar locals para cálculos y derivar valores.

**Añade a `main.tf`:**
```hcl
# Variables locales calculadas
locals {
  # Etiquetas estándar
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
    CreatedAt   = timestamp()
  }
  
  # Configuración calculada
  is_production = var.environment == "prod"
  backup_suffix = local.is_production ? "prod-backup" : "dev-backup"
  
  # Total de storage necesario
  total_storage_gb = sum([for db in var.databases : db.size_gb])
  
  # Servicios públicos vs privados
  public_ports  = { for k, v in var.service_ports : k => v if v < 1000 }
  private_ports = { for k, v in var.service_ports : k => v if v >= 1000 }
  
  # Configuración derivada
  derived_config = {
    max_connections    = var.max_connections * var.config_by_env[var.environment].instance_count
    monitoring_enabled = var.config_by_env[var.environment].monitoring
    backup_retention   = local.is_production ? 30 : 7
  }
}

# Archivo con valores calculados
resource "local_file" "calculated_config" {
  filename = "${var.project_name}-calculated.json"
  content = jsonencode({
    metadata        = local.common_tags
    total_storage   = "${local.total_storage_gb}GB"
    is_production   = local.is_production
    derived_config  = local.derived_config
    port_analysis = {
      public_services  = keys(local.public_ports)
      private_services = keys(local.private_ports)
    }
  })
}
```

**Actualiza `outputs.tf`:**
```hcl
output "project_summary" {
  description = "Resumen completo del proyecto"
  value = {
    project_info = {
      name        = var.project_name
      environment = var.environment
      is_prod     = local.is_production
    }
    
    storage = {
      databases_count = length(var.databases)
      total_gb       = local.total_storage_gb
      backup_enabled = length([for db in var.databases : db if db.backup])
    }
    
    services = {
      total_services = length(var.service_ports)
      public_count   = length(local.public_ports)
      private_count  = length(local.private_ports)
    }
  }
}

output "files_created" {
  description = "Lista de todos los archivos creados"
  value = concat(
    [local_file.advanced_config.filename],
    [local_file.services_config.filename],
    [local_file.summary.filename],
    [local_file.calculated_config.filename],
    [for file in local_file.database_configs : file.filename],
    [for file in local_file.feature_configs : file.filename]
  )
}
```

---


## 🎯 Retos Finales

### Reto 1: Validación Personalizada
Crea una variable que solo acepte emails válidos usando regex.

### Reto 2: Variables Sensibles
Investiga cómo marcar variables como `sensitive = true`.

### Reto 3: Variables Complejas
Crea una variable que describa una aplicación web completa con servidores, balanceador y base de datos.

---

## 📚 Conceptos Aprendidos

- **Variables básicas**: string, number, bool
- **Variables complejas**: list, map, object
- **Validaciones**: condition y error_message
- **Values sources**: tfvars, CLI, env vars, interactive
- **Locals**: cálculos y valores derivados
- **Interpolación**: ${} y funciones
- **Templates**: templatefile() y directivas
- **Iteración**: for_each, count, for expressions

## 🏆 Buenas Prácticas

1. **Siempre describe tus variables** con `description`
2. **Usa validaciones** para prevenir errores
3. **Proporciona defaults sensatos** cuando sea apropiado
4. **Separa variables en archivos** por funcionalidad
5. **Usa locals** para cálculos complejos
6. **Nombra consistentemente** (snake_case)
