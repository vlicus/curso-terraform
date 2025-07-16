# Laboratorio 4: Workspaces en Terraform

## 🎯 ¿Qué son los Workspaces?

Los **workspaces** en Terraform te permiten mantener **múltiples entornos** (dev, staging, prod) usando el **mismo código** pero con **estados separados**.

### 🤔 Problema sin Workspaces:
```
proyecto-dev/     ← Código duplicado
├── main.tf
├── variables.tf
└── terraform.tfstate

proyecto-staging/ ← Código duplicado
├── main.tf
├── variables.tf
└── terraform.tfstate

proyecto-prod/    ← Código duplicado
├── main.tf
├── variables.tf
└── terraform.tfstate
```

### ✅ Solución con Workspaces:
```
proyecto/
├── main.tf          ← Un solo código
├── variables.tf
├── terraform.tfstate.d/
│   ├── dev/
│   │   └── terraform.tfstate
│   ├── staging/
│   │   └── terraform.tfstate
│   └── prod/
│       └── terraform.tfstate
```

## 💡 Conceptos Clave

- **Workspace = Entorno aislado**
- **Mismo código, diferentes estados**
- **Configuración dinámica por entorno**
- **Fácil cambio entre entornos**

---

## 🚀 Ejercicio Práctico

### Objetivo
Crear una aplicación que se comporta diferente según el entorno usando workspaces.

### Scenario
Tenemos una empresa que necesita:
- **Dev:** 1 servidor pequeño para desarrollo
- **Staging:** 2 servidores medianos para pruebas
- **Prod:** 5 servidores grandes para producción

---

## 📁 Estructura del Proyecto

```
terraform-workspaces-lab/
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
└── INSTRUCCIONES.md
```

---

## 🔧 Configuración por Entorno

### Variables Dinámicas por Workspace

Nuestro proyecto ajustará automáticamente:
- **Número de servidores**
- **Tamaño de instancias** 
- **Nombres de recursos**
- **Configuraciones específicas**

### Mapeo de Entornos:
- **default/dev:** 1x t2.micro (desarrollo)
- **staging:** 2x t2.small (pruebas)  
- **prod:** 3x t2.medium (producción)

---

## 🎮 Comandos de Workspaces

### Ver workspace actual:
```bash
terraform workspace show
```

### Listar todos los workspaces:
```bash
terraform workspace list
```

### Crear nuevo workspace:
```bash
terraform workspace new [nombre]
```

### Cambiar de workspace:
```bash
terraform workspace select [nombre]
```

### Eliminar workspace:
```bash
terraform workspace delete [nombre]
```

---

## 🧪 Paso a Paso

### 1. Explorar el workspace por defecto
```bash
cd ~/Desktop/terraform-workspaces-lab
terraform workspace show
terraform workspace list
```

### 2. Desplegar en desarrollo (default)
```bash
terraform init
terraform plan
terraform apply
```

### 3. Crear entorno de staging
```bash
terraform workspace new staging
terraform workspace show
terraform apply
```

### 4. Crear entorno de producción
```bash
terraform workspace new prod
terraform apply
```

### 5. Navegar entre entornos
```bash
# Ver desarrollo
terraform workspace select default
terraform show

# Ver staging  
terraform workspace select staging
terraform show

# Ver producción
terraform workspace select prod
terraform show
```

### 6. Limpiar todo
```bash
# Destruir prod
terraform workspace select prod
terraform destroy

# Destruir staging
terraform workspace select staging  
terraform destroy

# Destruir dev
terraform workspace select default
terraform destroy
```

---

## 🎯 Lo que aprenderás

✅ **Gestión de múltiples entornos** con un solo código  
✅ **Variables dinámicas** por workspace  
✅ **Estados separados** e independientes  
✅ **Buenas prácticas** de organización  
✅ **Workflow profesional** dev → staging → prod  

---

## 💡 Casos de Uso Reales

### 🏢 Empresa SaaS:
- **dev:** Desarrollo diario del equipo
- **staging:** Demos para clientes
- **prod:** Aplicación en vivo

### 🎮 Videojuego:
- **dev:** Servidor de desarrollo
- **beta:** Servidor para beta testers
- **live:** Servidores de producción

### 📱 App Móvil:
- **dev:** API para desarrollo
- **staging:** API para testing
- **prod:** API en producción

---

## 🏆 Buenas Prácticas

1. **Nunca trabajes directamente en prod** sin probar en staging
2. **Usa nombres descriptivos** para workspaces
3. **Mantén configuraciones específicas** por entorno
4. **Documenta las diferencias** entre entornos
5. **Haz backups** antes de cambios importantes

---

## ⚠️ Importante

- **Cada workspace tiene su propio estado**
- **Los recursos son independientes entre workspaces**
- **Destruir un workspace NO afecta otros**
- **El workspace "default" siempre existe**

---

## 🚀 ¡Empecemos!

1. Lee los archivos de configuración
2. Sigue el paso a paso
3. Experimenta cambiando entre workspaces
4. Observa cómo cambian los recursos

¡Al final serás un experto en gestión de entornos! 🎓