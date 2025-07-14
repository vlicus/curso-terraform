# Laboratorio 1: Mi Primer Proyecto con Terraform

## 🎯 ¿Qué vamos a hacer?

Crear nuestro primer archivo usando Terraform. Es como un "Hola Mundo" pero con infraestructura.

## 📋 Lo que necesitas

- Terraform instalado
- Un editor de texto
- 15 minutos de tu tiempo

## 🚀 Paso a Paso

### Paso 1: Crea tu primer archivo Terraform

Crea un archivo llamado `main.tf` y escribe esto:

```hcl
# Le decimos a Terraform que queremos usar el provider "local"
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }
}

# Creamos nuestro primer archivo
resource "local_file" "mi_primer_archivo" {
  filename = "hola-terraform.txt"
  content  = "¡Hola! Este archivo fue creado por Terraform"
}
```

### Paso 2: Ejecuta los comandos

Abre tu terminal en la carpeta donde creaste `main.tf` y ejecuta:

```bash
# 1. Inicializa Terraform (solo la primera vez)
terraform init

# 2. Ve qué va a hacer Terraform
terraform plan

# 3. Crea el archivo
terraform apply
```

Cuando te pregunte si quieres continuar, escribe `yes` y presiona Enter.

### Paso 3: ¡Comprueba el resultado!

Mira en tu carpeta. Debería aparecer un archivo llamado `hola-terraform.txt` con el contenido que definiste.

## 🧪 Experimentos

### Experimento 1: Cambia el contenido
1. Modifica el `content` en tu `main.tf`
2. Ejecuta `terraform apply` otra vez
3. Observa cómo Terraform actualiza el archivo

### Experimento 2: Crea más archivos
Añade esto a tu `main.tf`:

```hcl
resource "local_file" "otro_archivo" {
  filename = "segundo-archivo.txt"
  content  = "Este es mi segundo archivo con Terraform"
}
```

Ejecuta `terraform apply` y mira qué pasa.

## 🗑️ Limpieza

Cuando quieras eliminar todo lo que creaste:

```bash
terraform destroy
```

## 🤔 ¿Qué acabas de aprender?

- **Terraform** gestiona recursos (en este caso, archivos)
- **init** prepara tu proyecto
- **plan** te muestra qué va a cambiar
- **apply** ejecuta los cambios
- **destroy** elimina todo lo que Terraform creó

## 💡 Conceptos Clave

- **Provider**: La "herramienta" que Terraform usa (aquí usamos `local` para archivos)
- **Resource**: Lo que queremos crear (nuestro archivo)
- **Estado**: Terraform recuerda lo que ha creado

## 🎉 ¡Felicidades!

Has creado tu primera infraestructura con Terraform. Sí, es "solo" un archivo, pero has aprendido el flujo básico que usarás para crear servidores, bases de datos, y toda tu infraestructura.

---

**Próximo paso**: En el siguiente laboratorio crearemos recursos en la nube (AWS/Azure/GCP).