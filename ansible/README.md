# Laboratorio 01: Primeros pasos con Ansible

## Introducción

En este laboratorio aprenderás los conceptos fundamentales de Ansible mientras realizas tareas prácticas de configuración en servidores remotos. Trabajarás desde GitHub Codespaces y te conectarás a droplets de Digital Ocean para ejecutar tus primeros playbooks.

## Objetivos del laboratorio

Al finalizar este laboratorio serás capaz de:
- Comprender la arquitectura básica de Ansible
- Configurar el inventario de hosts
- Ejecutar comandos ad-hoc
- Crear y ejecutar tu primer playbook
- Utilizar variables y templates básicos
- Aplicar buenas prácticas desde el inicio

## Prerequisitos

- Acceso a GitHub Codespaces
- Al menos 2 droplets de Digital Ocean con Ubuntu 22.04
- Acceso SSH a los droplets mediante clave privada
- Conocimientos básicos de Linux y línea de comandos

## Estructura del laboratorio

```
~/Desktop/ansible-lab/
├── inventory/
│   └── hosts.yml
├── playbooks/
│   ├── 01-ping.yml
│   ├── 02-system-info.yml
│   ├── 03-install-packages.yml
│   └── 04-configure-nginx.yml
├── templates/
│   └── nginx-site.j2
├── ansible.cfg
└── README.md
```

## Paso 1: Preparación del entorno

### 1.1 Instalación de Ansible en Codespaces

Abre una terminal en tu Codespace y ejecuta:

```bash
# Actualizar el sistema
sudo apt-get update

# Instalar Ansible
sudo apt-get install -y software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Verificar la instalación
ansible --version
```

### 1.2 Crear la estructura de directorios

```bash
# Crear el directorio del laboratorio en el escritorio
mkdir -p ~/Desktop/ansible-lab/{inventory,playbooks,templates}
cd ~/Desktop/ansible-lab
```

### 1.3 Configurar las claves SSH

```bash
# Crear directorio para las claves si no existe
mkdir -p ~/.ssh

# Copiar tu clave privada (reemplaza con el contenido real)
cat > ~/.ssh/do_droplet_key << 'EOF'
-----BEGIN OPENSSH PRIVATE KEY-----
[Tu clave privada aquí]
-----END OPENSSH PRIVATE KEY-----
EOF

# Establecer permisos correctos
chmod 600 ~/.ssh/do_droplet_key
```

## Paso 2: Configuración básica de Ansible

### 2.1 Crear el archivo de configuración ansible.cfg

Este archivo define el comportamiento por defecto de Ansible en nuestro proyecto.

```bash
cat > ~/Desktop/ansible-lab/ansible.cfg << 'EOF'
[defaults]
# Ubicación del inventario
inventory = ./inventory/hosts.yml

# Usuario remoto por defecto
remote_user = root

# Clave SSH a utilizar
private_key_file = ~/.ssh/do_droplet_key

# Deshabilitar verificación de host (solo para laboratorio)
host_key_checking = False

# Número de conexiones paralelas
forks = 5

# Formato de salida más legible
stdout_callback = yaml

# Mostrar tiempo de ejecución de tareas
callback_whitelist = profile_tasks

[ssh_connection]
# Optimizaciones de SSH
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
pipelining = True
EOF
```

### 2.2 Crear el inventario de hosts

El inventario define los servidores que Ansible gestionará. Vamos a usar formato YAML por ser más legible.

```bash
cat > ~/Desktop/ansible-lab/inventory/hosts.yml << 'EOF'
all:
  children:
    webservers:
      hosts:
        web1:
          ansible_host: 10.0.0.1  # Reemplaza con la IP de tu primer droplet
          ansible_port: 22
        web2:
          ansible_host: 10.0.0.2  # Reemplaza con la IP de tu segundo droplet
          ansible_port: 22
      vars:
        ansible_python_interpreter: /usr/bin/python3
        
    databases:
      hosts:
        db1:
          ansible_host: 10.0.0.3  # Opcional: si tienes un tercer droplet
      vars:
        ansible_python_interpreter: /usr/bin/python3
EOF
```

**Importante**: Reemplaza las direcciones IP con las IPs reales de tus droplets de Digital Ocean.

## Paso 3: Primeros comandos Ad-Hoc

Los comandos ad-hoc son útiles para tareas rápidas sin necesidad de escribir un playbook.

### 3.1 Verificar conectividad

```bash
# Hacer ping a todos los hosts
ansible all -m ping

# Hacer ping solo a los webservers
ansible webservers -m ping
```

### 3.2 Obtener información del sistema

```bash
# Ver información detallada de los hosts
ansible all -m setup

# Ver solo la memoria disponible
ansible all -m setup -a "filter=ansible_memfree_mb"

# Ejecutar comandos shell
ansible all -m shell -a "df -h"
ansible webservers -m shell -a "uptime"
```

### 3.3 Gestión de paquetes

```bash
# Actualizar la caché de apt (equivalente a apt update)
ansible webservers -m apt -a "update_cache=yes" --become

# Instalar un paquete
ansible webservers -m apt -a "name=htop state=present" --become
```

## Paso 4: Tu primer Playbook

### 4.1 Playbook de verificación básica

```bash
cat > ~/Desktop/ansible-lab/playbooks/01-ping.yml << 'EOF'
---
# Este es tu primer playbook de Ansible
# Los tres guiones (---) indican el inicio de un documento YAML

- name: Verificar conectividad con todos los hosts
  hosts: all  # En qué hosts se ejecutará
  gather_facts: no  # No recopilar información del sistema (más rápido)
  
  tasks:
    - name: Hacer ping a los hosts
      ping:
      
    - name: Mostrar un mensaje
      debug:
        msg: "¡Conexión exitosa con {{ inventory_hostname }}!"
EOF
```

Ejecutar el playbook:
```bash
cd ~/Desktop/ansible-lab
ansible-playbook playbooks/01-ping.yml
```

### 4.2 Playbook para obtener información del sistema

```bash
cat > ~/Desktop/ansible-lab/playbooks/02-system-info.yml << 'EOF'
---
- name: Recopilar y mostrar información del sistema
  hosts: all
  gather_facts: yes  # Necesitamos los facts del sistema
  
  tasks:
    - name: Mostrar información básica del sistema
      debug:
        msg: |
          Hostname: {{ ansible_hostname }}
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
          Kernel: {{ ansible_kernel }}
          CPU cores: {{ ansible_processor_vcpus }}
          Memoria total: {{ ansible_memtotal_mb }} MB
          Memoria libre: {{ ansible_memfree_mb }} MB
          
    - name: Mostrar todas las interfaces de red
      debug:
        msg: "Interfaces: {{ ansible_interfaces }}"
        
    - name: Crear un reporte en archivo local
      local_action:
        module: copy
        content: |
          Reporte del sistema para {{ inventory_hostname }}
          ================================================
          Fecha: {{ ansible_date_time.iso8601 }}
          Hostname: {{ ansible_hostname }}
          IP: {{ ansible_default_ipv4.address }}
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }}
          Uptime: {{ ansible_uptime_seconds // 86400 }} días
        dest: "./reports/{{ inventory_hostname }}_info.txt"
      run_once: yes  # Solo crear el directorio una vez
      
    - name: Asegurar que el directorio reports existe
      local_action:
        module: file
        path: "./reports"
        state: directory
      run_once: yes
EOF
```

### 4.3 Playbook para instalar paquetes

```bash
cat > ~/Desktop/ansible-lab/playbooks/03-install-packages.yml << 'EOF'
---
- name: Instalar paquetes esenciales en los servidores web
  hosts: webservers
  become: yes  # Necesitamos privilegios de root
  
  vars:
    paquetes_basicos:
      - nginx
      - git
      - curl
      - wget
      - vim
      - htop
      - python3-pip
      
  tasks:
    - name: Actualizar caché de apt
      apt:
        update_cache: yes
        cache_valid_time: 3600  # Caché válida por 1 hora
        
    - name: Instalar paquetes básicos
      apt:
        name: "{{ paquetes_basicos }}"
        state: present
        
    - name: Asegurar que nginx está iniciado y habilitado
      systemd:
        name: nginx
        state: started
        enabled: yes
        
    - name: Verificar el estado de nginx
      command: systemctl status nginx
      register: nginx_status
      changed_when: false  # Este comando no cambia nada
      
    - name: Mostrar estado de nginx
      debug:
        msg: "Nginx está {{ 'activo' if 'active (running)' in nginx_status.stdout else 'inactivo' }}"
EOF
```

### 4.4 Playbook con templates

```bash
# Primero, crear el template
cat > ~/Desktop/ansible-lab/templates/nginx-site.j2 << 'EOF'
server {
    listen 80;
    server_name {{ ansible_hostname }}.example.com;
    
    root /var/www/{{ site_name }};
    index index.html;
    
    # Configuración generada por Ansible
    # Fecha: {{ ansible_date_time.iso8601 }}
    # Host: {{ inventory_hostname }}
    
    location / {
        try_files $uri $uri/ =404;
    }
    
    # Información del servidor
    location /server-info {
        add_header Content-Type text/plain;
        return 200 "Server: {{ ansible_hostname }}\nIP: {{ ansible_default_ipv4.address }}\nManaged by Ansible";
    }
}
EOF

# Crear el playbook que usa el template
cat > ~/Desktop/ansible-lab/playbooks/04-configure-nginx.yml << 'EOF'
---
- name: Configurar sitios web en Nginx
  hosts: webservers
  become: yes
  
  vars:
    site_name: "mi-primer-sitio"
    
  tasks:
    - name: Crear directorio para el sitio web
      file:
        path: "/var/www/{{ site_name }}"
        state: directory
        owner: www-data
        group: www-data
        mode: '0755'
        
    - name: Crear página index.html
      copy:
        content: |
          <!DOCTYPE html>
          <html>
          <head>
              <title>{{ site_name }} en {{ ansible_hostname }}</title>
          </head>
          <body>
              <h1>¡Bienvenido a {{ site_name }}!</h1>
              <p>Este sitio está alojado en: {{ ansible_hostname }}</p>
              <p>IP del servidor: {{ ansible_default_ipv4.address }}</p>
              <p>Configurado con Ansible el: {{ ansible_date_time.iso8601 }}</p>
          </body>
          </html>
        dest: "/var/www/{{ site_name }}/index.html"
        owner: www-data
        group: www-data
        mode: '0644'
        
    - name: Configurar el sitio en Nginx usando template
      template:
        src: ../templates/nginx-site.j2
        dest: "/etc/nginx/sites-available/{{ site_name }}"
        owner: root
        group: root
        mode: '0644'
      notify: reload nginx
      
    - name: Habilitar el sitio
      file:
        src: "/etc/nginx/sites-available/{{ site_name }}"
        dest: "/etc/nginx/sites-enabled/{{ site_name }}"
        state: link
      notify: reload nginx
      
    - name: Probar la configuración de Nginx
      command: nginx -t
      changed_when: false
      
  handlers:
    - name: reload nginx
      systemd:
        name: nginx
        state: reloaded
EOF
```

## Paso 5: Ejercicios prácticos

### Ejercicio 1: Comando Ad-Hoc
Usa comandos ad-hoc para:
1. Crear un usuario llamado "ansible-user" en todos los hosts
2. Instalar el paquete "tree" solo en web1
3. Mostrar el contenido de /etc/os-release en todos los hosts

### Ejercicio 2: Playbook básico
Crea un playbook que:
1. Instale Docker en los webservers
2. Asegure que el servicio Docker esté corriendo
3. Agregue el usuario "ansible-user" al grupo "docker"

### Ejercicio 3: Variables y condicionales
Modifica el playbook 03-install-packages.yml para:
1. Definir diferentes paquetes para Ubuntu y Debian
2. Instalar paquetes según la distribución detectada
3. Mostrar un mensaje diferente según el OS

### Ejercicio 4: Loops y templates
Crea un playbook que:
1. Configure múltiples sitios virtuales en Nginx usando un loop
2. Use variables para personalizar cada sitio
3. Cree un template más complejo con configuración SSL

## Soluciones a los ejercicios

### Solución Ejercicio 1:
```bash
# 1. Crear usuario en todos los hosts
ansible all -m user -a "name=ansible-user state=present shell=/bin/bash" --become

# 2. Instalar tree solo en web1
ansible web1 -m apt -a "name=tree state=present" --become

# 3. Mostrar contenido de /etc/os-release
ansible all -m command -a "cat /etc/os-release"
```

### Solución Ejercicio 2:

```yaml
---
# SOLUCIÓN - Ejercicio Docker: Instalar y configurar Docker
# Este playbook instala Docker en los servidores web

- name: Instalar y configurar Docker
  hosts: droplet # El grupo de hosts definido en tu inventario
  become: yes # Ejecutar todas las tareas de este 'play' con privilegios de sudo

  tasks:
    - name: Instalar dependencias de Docker
      apt:
        name:
          - apt-transport-https
          - ca-certificates
          - curl
          - software-properties-common
        state: present
        update_cache: yes # Actualiza la caché de paquetes de apt

    - name: Agregar clave GPG de Docker
      apt_key:
        url: https://download.docker.com/linux/ubuntu/gpg
        state: present # Asegura que la clave esté presente

    - name: Obtener arquitectura del sistema
      command: dpkg --print-architecture # Ejecuta un comando en el host remoto
      register: dpkg_architecture # Guarda la salida del comando en esta variable
      changed_when: false # Indica que esta tarea nunca debe reportar 'cambiado'

    - name: Agregar repositorio de Docker
      apt_repository:
        repo: "deb [arch={{ dpkg_architecture.stdout }}] https://download.docker.com/linux/ubuntu {{ ansible_distribution_release }} stable"
        state: present # Asegura que el repositorio esté presente

    - name: Instalar Docker Engine
      apt:
        name:
          - docker-ce
          - docker-ce-cli
          - containerd.io
        state: present
        update_cache: yes # Actualiza de nuevo la caché de paquetes

    - name: Asegurar que Docker está iniciado y habilitado
      systemd:
        name: docker
        state: started # Asegura que el servicio esté corriendo
        enabled: yes # Asegura que el servicio inicie automáticamente al arrancar
        daemon_reload: yes # Recarga las unidades de systemd si se han modificado

    - name: Instalar Docker SDK para Python (via apt)
      apt:
        name: python3-docker # El paquete que proporciona el SDK de Docker para Python
        state: present

    - name: Crear el usuario ansible-user si no existe
      user:
        name: ansible-user
        state: present
        shell: /bin/bash # Define el shell por defecto para el nuevo usuario

    - name: Agregar usuario ansible-user al grupo docker
      user:
        name: ansible-user
        groups: docker
        append: yes # Añade el usuario al grupo 'docker' sin eliminar otros grupos existentes

    - name: Verificar que Docker funciona
      docker_container:
        name: hello-world-test
        image: hello-world
        state: started # Inicia el contenedor
        auto_remove: yes # Elimina el contenedor una vez que se detiene
      register: docker_test # Guarda la salida de esta tarea para usarla en el 'debug'

    - name: Mostrar resultado de la prueba
      debug:
        msg: "Docker está funcionando correctamente en {{ inventory_hostname }}"
      when: docker_test is succeeded # Solo ejecuta esta tarea si la tarea anterior tuvo éxito
```

-----

#### Desglose y Conceptos Clave:

##### 1\. **`name: Instalar y configurar Docker`**

  * **Concepto:** `name` es una directiva en Ansible que proporciona una **descripción legible** para tu play y para cada tarea. Es crucial para entender qué hace tu automatización cuando lees la salida de Ansible en la terminal, o cuando alguien más revisa tu código.

##### 2\. **`hosts: droplet`**

  * **Concepto:** `hosts` define en qué **grupo de servidores (o hosts individuales)** de tu inventario se aplicarán las tareas de este play.
  * **En este playbook:** Se aplicará a todos los servidores que estén bajo el grupo `droplet` en tu archivo de inventario (`inventory/hosts`). Esto significa que todas las tareas subsiguientes se ejecutarán en esos hosts.

##### 3\. **`become: yes`**

  * **Concepto:** `become` es la forma en que Ansible maneja los **privilegios de elevación** (como `sudo` en sistemas Linux). Cuando `become: yes` está configurado para un play completo, todas las tareas dentro de ese play se ejecutarán con los privilegios elevados (generalmente como `root`).
  * **Por qué se usa aquí:** La instalación de Docker, la modificación de repositorios y la gestión de servicios (`systemd`) requieren permisos de `root`. En lugar de añadir `become: yes` a cada tarea individual, lo aplicamos al play completo.

##### 4\. **`tasks:`**

  * **Concepto:** La sección `tasks` es donde defines la **secuencia de acciones** que Ansible debe realizar en los hosts especificados. Cada elemento bajo `tasks` es una tarea individual.

##### 5\. **`apt:` (Módulo `apt`)**

  * **Concepto:** El módulo `apt` es fundamental para la **gestión de paquetes** en sistemas operativos basados en Debian (como Ubuntu, que es común en DigitalOcean Droplets).
  * **`name:`**: Aquí se especifica el nombre del paquete (o una lista de paquetes) a instalar.
  * **`state: present`**: Directiva común en muchos módulos. Le dice a Ansible que se asegure de que el paquete (o el archivo, o el servicio, etc.) esté **presente** en el sistema. Si ya está presente, Ansible no hará nada (idempotencia). Si no está, lo instalará.
  * **`update_cache: yes`**: Esta opción, específica del módulo `apt` (y otros módulos de paquetes), le indica a Ansible que ejecute `apt update` (o equivalente) antes de intentar instalar o gestionar paquetes. Esto asegura que la caché de paquetes del sistema esté actualizada con la información más reciente de los repositorios, permitiendo que `apt` encuentre los paquetes más recientes o recién añadidos.

##### 6\. **`apt_key:` (Módulo `apt_key`)**

  * **Concepto:** Utilizado para **añadir o eliminar claves GPG** a la lista de claves de confianza de `apt`. Las claves GPG se usan para verificar la autenticidad de los paquetes de los repositorios.
  * **`url:`**: La URL de donde se descargará la clave GPG.
  * **`state: present`**: Asegura que la clave esté presente en el sistema.

##### 7\. **`command:` (Módulo `command`)**

  * **Concepto:** El módulo `command` ejecuta **comandos arbitrarios** en el host remoto. Es útil para acciones simples que no tienen un módulo Ansible dedicado o para comandos que necesitan una salida específica.
  * **`register: dpkg_architecture`**:
      * **Concepto:** La directiva `register` guarda la salida estándar (`stdout`), el error estándar (`stderr`), el código de retorno y otros detalles de la ejecución de una tarea en una **variable de Ansible**.
      * **En este playbook:** La salida de `dpkg --print-architecture` (ej. `amd64` o `arm64`) se guarda en la variable `dpkg_architecture`.
  * **`changed_when: false`**:
      * **Concepto:** Ansible intenta determinar si una tarea ha "cambiado" el estado del sistema. Si el estado cambia, la tarea se muestra en amarillo (`CHANGED`). Si no cambia, en verde (`OK`). `changed_when: false` anula el comportamiento por defecto y **fuerza a Ansible a considerar que la tarea no ha producido cambios**, sin importar su salida.
      * **Por qué se usa aquí:** `dpkg --print-architecture` es un comando de solo lectura. No modifica el sistema, por lo que siempre debería ser `OK`. Si no usaras `changed_when: false`, cualquier salida del comando podría hacer que Ansible lo marcara como `CHANGED` incorrectamente, lo cual es confuso y puede afectar la activación de `handlers` o la lógica de `when` en tareas posteriores.

##### 8\. **`apt_repository:` (Módulo `apt_repository`)**

  * **Concepto:** Gestiona los **repositorios de software** en sistemas basados en Debian/Ubuntu. Esto es crucial para añadir repositorios de terceros (como el de Docker).
  * **`repo:`**: Define la línea del repositorio que se añadirá (ej. `deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable`).
      * **Variables Jinja2:** Observa el uso de `{{ dpkg_architecture.stdout }}` y `{{ ansible_distribution_release }}`. Ansible rellena estos valores dinámicamente con la arquitectura detectada y el nombre de la versión de Ubuntu (ej. `jammy` para Ubuntu 22.04).

##### 9\. **`systemd:` (Módulo `systemd`)**

  * **Concepto:** Gestiona **servicios y unidades de `systemd`** (el sistema de inicio y gestión de servicios moderno en la mayoría de las distribuciones Linux).
  * **`name: docker`**: El nombre del servicio de `systemd` a gestionar.
  * **`state: started`**: Asegura que el servicio esté **corriendo**. Si está detenido, lo iniciará. Si ya está corriendo, no hará nada.
  * **`enabled: yes`**: Asegura que el servicio esté **habilitado** para iniciarse automáticamente cuando el sistema arranque.
  * **`daemon_reload: yes`**: Si has añadido o modificado un archivo de unidad de `systemd` (aunque en este playbook no lo haces directamente, sino que Docker lo instala), es necesario recargar los demonios de `systemd` para que reconozcan los nuevos archivos. Esto es como ejecutar `systemctl daemon-reload`.

##### 10\. **`Instalar Docker SDK para Python (via apt)`**

  * **Problema resuelto:** Como se explicó en la guía anterior, esta tarea reemplaza el uso directo de `pip` para evitar el error `externally-managed-environment`.
  * **`apt: name: python3-docker`**: Se utiliza `apt` para instalar el paquete del SDK de Docker para Python, que es la forma recomendada y compatible con el sistema.

##### 11\. **`user:` (Módulo `user`)**

  * **Concepto:** Gestiona **cuentas de usuario** en el host remoto.
  * **`name: ansible-user`**: El nombre del usuario a crear o modificar.
  * **`state: present`**: Asegura que el usuario esté presente.
  * **`shell: /bin/bash`**: Define el shell por defecto para el usuario.
  * **`groups: docker`**: Añade el usuario a los grupos especificados.
  * **`append: yes`**: **Importante aquí.** Le dice a Ansible que si el usuario ya existe y tiene otros grupos, simplemente **añada** el grupo `docker` a su lista existente, en lugar de reemplazar todos sus grupos con solo `docker`.

##### 12\. **`docker_container:` (Módulo `community.docker.docker_container`)**

  * **Concepto:** Este es un módulo muy potente para gestionar **contenedores Docker**. Permite crear, iniciar, detener, eliminar y configurar contenedores.
  * **Requisito:** Este módulo (y otros módulos de Docker en Ansible) **requiere que el SDK de Docker para Python esté instalado en el host remoto**. Es por eso que se incluye la tarea `Instalar Docker SDK para Python`.
  * **`name: hello-world-test`**: El nombre que se le dará al contenedor.
  * **`image: hello-world`**: La imagen de Docker que se usará para crear el contenedor.
  * **`state: started`**: Asegura que el contenedor esté corriendo.
  * **`auto_remove: yes`**: Indica que el contenedor debe ser eliminado automáticamente una vez que se detiene (útil para pruebas como esta).
  * **`register: docker_test`**: Registra la salida de esta tarea en la variable `docker_test`.

##### 13\. **`debug:` (Módulo `debug`)**

  * **Concepto:** Un módulo simple pero invaluable para la **depuración**. Permite imprimir mensajes o el contenido de variables durante la ejecución del playbook.
  * **`msg:`**: El mensaje a mostrar. Puedes usar variables Jinja2 dentro del mensaje.
  * **`when: docker_test is succeeded`**:
      * **Concepto:** La directiva `when` permite que una tarea se ejecute **condicionalmente**. La tarea solo se ejecutará si la expresión de `when` es verdadera.
      * **En este playbook:** Esta tarea de depuración solo se ejecutará si la tarea anterior (`Verificar que Docker funciona`, cuyo resultado está en `docker_test`) fue **exitosa**. Esto es útil para mostrar mensajes de éxito o error basados en el resultado de tareas previas.


## Buenas prácticas aprendidas

1. **Organización**: Mantén tu código Ansible bien estructurado en directorios
2. **Idempotencia**: Los playbooks deben poder ejecutarse múltiples veces sin causar problemas
3. **Variables**: Usa variables para hacer tus playbooks reutilizables
4. **Handlers**: Usa handlers para acciones que solo deben ejecutarse cuando hay cambios
5. **Templates**: Usa templates Jinja2 para archivos de configuración dinámicos
6. **Documentación**: Comenta tu código y usa nombres descriptivos para las tareas

## Recursos adicionales

- [Documentación oficial de Ansible](https://docs.ansible.com/)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Roles compartidos por la comunidad
- [Mejores prácticas de Ansible](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

## Próximos pasos

En el siguiente laboratorio aprenderás:
- Roles de Ansible y su estructura
- Ansible Vault para gestionar secretos
- Estrategias de deployment más complejas
- Integración con CI/CD
- Monitorización y debugging avanzado

¡Felicidades por completar tu primer laboratorio de Ansible! 🎉