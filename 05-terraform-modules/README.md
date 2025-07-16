# Laboratorio 5: Módulos en Terraform

## 🎯 ¿Qué son los Módulos?

Los **módulos** en Terraform son como **"piezas de LEGO reutilizables"** para tu infraestructura. Te permiten:

- 📦 **Empaquetar** configuraciones comunes
- 🔄 **Reutilizar** código entre proyectos
- 🎭 **Abstraer** complejidad técnica
- 🏗️ **Estandarizar** arquitecturas

### 🤔 Problema sin Módulos:
```
proyecto-1/
├── main.tf (500 líneas de código duplicado)
└── variables.tf

proyecto-2/  
├── main.tf (las mismas 500 líneas)
└── variables.tf

proyecto-3/
├── main.tf (otra vez las mismas 500 líneas)
└── variables.tf
```

### ✅ Solución con Módulos:
```
modules/
└── web-server/          ← Módulo reutilizable
    ├── main.tf
    ├── variables.tf
    └── outputs.tf

proyecto-1/
├── main.tf (5 líneas usando el módulo)
└── variables.tf

proyecto-2/
├── main.tf (5 líneas usando el módulo)
└── variables.tf
```

---

## 🏗️ Arquitectura del Laboratorio

### 🎯 Lo que vamos a construir:

```
📁 terraform-modules-lab/
├── 📁 modules/
│   └── 📁 payroll-app/          ← NUESTRO MÓDULO
│       ├── main.tf              ← Lógica del módulo
│       ├── variables.tf         ← Inputs del módulo
│       └── outputs.tf           ← Outputs del módulo
├── 📁 dev-environment/          ← USAR el módulo (desarrollo)
│   ├── main.tf
│   └── variables.tf
├── 📁 prod-environment/         ← USAR el módulo (producción)
│   ├── main.tf
│   └── variables.tf
└── README.md
```

### 🎭 Escenario Real:
Trabajas en una empresa que tiene una **aplicación de nóminas** que necesita:
- Servidor web para la interfaz
- Base de datos para los datos de empleados
- Bucket S3 para documentos y PDFs de nóminas

Esta misma aplicación se despliega en **desarrollo** y **producción** con configuraciones diferentes.

---

## 🧩 Anatomía de un Módulo

### 📥 **Inputs (variables.tf):**
Los "parámetros" que le pasas al módulo
```hcl
variable "environment" {
  description = "Entorno (dev, prod)"
  type        = string
}

variable "company_name" {
  description = "Nombre de la empresa"
  type        = string
}
```

### ⚙️ **Logic (main.tf):**
El "cerebro" que crea los recursos
```hcl
resource "local_file" "web_server" {
  filename = "${var.company_name}-${var.environment}-web.conf"
  content  = "Servidor web para ${var.company_name}"
}
```

### 📤 **Outputs (outputs.tf):**
Los "resultados" que devuelve el módulo
```hcl
output "web_server_config" {
  value = local_file.web_server.filename
}
```

### 🔗 **Usage (en tus proyectos):**
Cómo "llamas" al módulo
```hcl
module "payroll" {
  source       = "../modules/payroll-app"
  environment  = "dev"
  company_name = "TechCorp"
}
```

---

## 💡 Analogías para Entender

### 🏠 **Módulo = Plano de Casa**
- **Plano (módulo):** Define cómo construir una casa estándar
- **Casa real (instancia):** Cada vez que usas el plano construyes una casa
- **Personalización (variables):** Color, tamaño, ubicación
- **Resultado (outputs):** Dirección, número de habitaciones

### 🍕 **Módulo = Receta de Pizza**
- **Receta (módulo):** Ingredientes y pasos para hacer pizza
- **Pizza real (instancia):** Cada pizza que horneas
- **Personalización (variables):** Tamaño, ingredientes extras
- **Resultado (outputs):** Pizza lista, tiempo de cocción

### 🏭 **Módulo = Molde Industrial**
- **Molde (módulo):** Forma para crear productos idénticos
- **Producto (instancia):** Cada pieza fabricada
- **Ajustes (variables):** Material, color, tamaño
- **Control de calidad (outputs):** Especificaciones del producto

---

## 🎮 Comandos del Laboratorio

### 1. **Explorar la estructura:**
```bash
cd ~/Desktop/terraform-modules-lab
tree
# o
find . -type f -name "*.tf" | head -10
```

### 2. **Desplegar desarrollo:**
```bash
cd dev-environment
terraform init
terraform plan
terraform apply
```

### 3. **Desplegar producción:**
```bash
cd ../prod-environment
terraform init
terraform apply
```

### 4. **Comparar resultados:**
```bash
# Ver archivos de desarrollo
ls -la ../dev-environment/*

# Ver archivos de producción  
ls -la ../prod-environment/*

# Comparar configuraciones
diff ../dev-environment/*.conf ../prod-environment/*.conf
```

### 5. **Limpiar:**
```bash
# Desde cada directorio
terraform destroy
```

---

## 🏆 Beneficios de los Módulos

### 🔄 **Reutilización:**
- Un módulo, múltiples proyectos
- Misma lógica, diferentes configuraciones
- Ahorro de tiempo y esfuerzo

### 🎯 **Consistencia:**
- Arquitecturas estandarizadas
- Menos errores humanos
- Mejores prácticas aplicadas automáticamente

### 🧹 **Mantenimiento:**
- Cambio en un lugar, se aplica everywhere
- Versionado centralizado
- Fácil actualización

### 👥 **Colaboración:**
- Equipos pueden compartir módulos
- Abstracciones simples para usuarios
- Complejidad oculta en el módulo

---

## 📊 Comparación: Sin vs Con Módulos

| Aspecto | Sin Módulos | Con Módulos |
|---------|-------------|-------------|
| **Código duplicado** | 500+ líneas x3 = 1500 líneas | 100 líneas módulo + 15 líneas uso |
| **Mantenimiento** | Cambiar en 3 lugares | Cambiar en 1 lugar |
| **Consistencia** | Errores manuales | Automática |
| **Onboarding** | Leer 1500 líneas | Entender 1 módulo simple |
| **Testing** | Probar 3 implementaciones | Probar 1 módulo |

---

## 🎯 Casos de Uso Reales

### 🏢 **Empresa SaaS:**
```hcl
module "microservice" {
  source = "git::https://github.com/empresa/terraform-microservice"
  
  service_name = "user-api"
  environment  = "prod"
  replicas     = 5
}
```

### 🏪 **E-commerce:**
```hcl
module "store_frontend" {
  source = "../modules/web-app"
  
  app_name    = "tienda-online"
  domain      = "mitienda.com"
  ssl_enabled = true
}
```

### 🎮 **Gaming Company:**
```hcl
module "game_server" {
  source = "registry.terraform.io/company/game-server/aws"
  
  game_title = "super-mario-battle"
  region     = "us-east-1"
  players    = 1000
}
```

---

## 🚀 Fuentes de Módulos

### 📍 **Local (este lab):**
```hcl
source = "../modules/payroll-app"
```

### 🌐 **Git Repository:**
```hcl
source = "git::https://github.com/usuario/terraform-modules.git//aws-vpc"
```

### 📦 **Terraform Registry:**
```hcl
source = "terraform-aws-modules/vpc/aws"
version = "~> 3.0"
```

### 🏢 **Registry Privado:**
```hcl
source = "app.terraform.io/empresa/vpc/aws"
version = "1.0.0"
```

---

## 💡 Mejores Prácticas

### ✅ **DO:**
- Usa nombres descriptivos para módulos
- Documenta inputs y outputs
- Incluye ejemplos de uso
- Versiona tus módulos
- Haz módulos pequeños y enfocados

### ❌ **DON'T:**
- No hagas módulos gigantes que hacen todo
- No hardcodees valores específicos
- No ignores el versionado
- No olvides documentar

---

## 🎓 Lo que Aprenderás

Al completar este laboratorio entenderás:

✅ **Cómo crear** módulos reutilizables  
✅ **Cómo usar** módulos en tus proyectos  
✅ **Inputs, logic y outputs** de módulos  
✅ **Versionado y sources** de módulos  
✅ **Casos de uso reales** profesionales  
✅ **Mejores prácticas** de la industria  

---

## 🚀 ¡Empecemos!

1. **Lee** la estructura del laboratorio
2. **Explora** el módulo `payroll-app`
3. **Ejecuta** los entornos paso a paso
4. **Compara** los resultados
5. **Experimenta** modificando variables

¿Listo para crear tu primer módulo? ¡Vamos! 🎯