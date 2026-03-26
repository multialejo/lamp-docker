# Informe de Demostración: Servidor Web LAMP en Debian con Docker

## 1. Introducción

El presente informe documenta el proceso de demostración para la **instalación manual** de un servidor web LAMP (Linux, Apache, MariaDB, PHP) en un sistema operativo Debian. Se utilizaron contenedores Docker, los cuales permiten ejecutar un entorno Debian aislado dentro de cualquier otro sistema operativo, *simulando el proceso que se llevaría a cabo en un servidor real o máquina virtual*.

---

## 2. Instalación de LAMP en Contenedor Debian

### 2.1 Requisitos Previos

- Docker instalado y en ejecución en el sistema host (se recomienda la versión estable más reciente).
- Acceso a internet para descargar la imagen base de Debian desde Docker Hub.
- Conocimientos básicos de línea de comandos Linux (navegación, permisos y gestión de paquetes).

Una **imagen Docker** es un paquete de solo lectura que contiene todo lo necesario para ejecutar una aplicación (sistema operativo base, paquetes, configuración). Un **contenedor** es una instancia ejecutable de esa imagen, con su propio sistema de archivos aislado.

### 2.2 Pasos de la Demostración

#### Paso 1: Crear e Iniciar el Contenedor Debian

Se inicia un contenedor interactivo basado en la imagen oficial `debian:latest`. El comando completo es:

```bash
docker run -it --name lamp-container -p 8080:80 debian:latest /bin/bash
```

Una vez ejecutado el comando, se encontrará dentro del contenedor, con un entorno Debian completamente aislado.

#### Paso 2: Actualizar Repositorios dentro del Contenedor

```bash
apt update
```

Este comando actualiza la caché local de paquetes disponibles en los repositorios de Debian. 


#### Paso 3: Verificar que los Paquetes no Estén Instalados

```bash
apache2 -v
mariadb --version
php -v
```


Este paso permite confirmar el estado inicial del sistema y evita instalaciones redundantes.

#### Paso 4: Instalar Apache (Servidor Web)

```bash
apt install -y apache2
service apache2 start
```


Apache es el servidor web HTTP más utilizado del mundo. El paquete `apache2` instala el servidor, sus módulos base y la configuración predeterminada.  

#### Paso 5: Instalar MariaDB (Sistema de Gestión de Bases de Datos)

```bash
apt install -y mariadb-server
service mariadb start
```


MariaDB es un sistema de gestión de bases de datos relacionales compatible con MySQL. 

#### Paso 6: Instalar PHP y los Módulos de Integración

```bash
apt install -y php libapache2-mod-php php-mysql
```


PHP es el lenguaje que permite generar páginas con el procesamiento dinámico de solicitudes web.

#### Paso 7: Verificar que los Servicios Estén Activos

```bash
service apache2 status
service mariadb status
```


Estos comandos muestran el estado actual de los servicios (active/running). 

---

## 3. Verificación del Stack LAMP

Para confirmar que todos los componentes funcionan de manera integrada, se crea una página de prueba sencilla que combina Apache, PHP y (opcionalmente) una conexión a MariaDB.

Crear el archivo `/var/www/html/index.php` (directorio raíz por defecto de Apache):

```php
<?php
echo '<h1>Servidor LAMP en Debian con Docker</h1>';
echo '<p>Versión de PHP: ' . phpversion() . '</p>';
phpinfo();
?>
```

Acceder desde el navegador del host:

**http://localhost:8080/index.php**

Si se visualiza correctamente la página con el encabezado y la tabla detallada de configuración de PHP, se confirma que el **stack LAMP completo** está operativo.


Además, se puede acceder al cliente de MariaDB para verificar la conexión:

```bash
mysql -u root
```


(En este entorno de demostración, la contraseña de root está vacía por defecto; en producción se debe configurar una contraseña segura).

---

## 4. Automatización con Dockerfile

Un Dockerfile es un archivo de texto plano que contiene instrucciones para construir una imagen Docker. En entornos reales la instalación manual se reemplaza por un *Dockerfile*, que permite construir imágenes reproducibles de forma automática.

A continuación se presenta un Dockerfile completo y optimizado:

```dockerfile
FROM debian:12

# Evita preguntas interactivas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar todos los paquetes LAMP en una sola capa
RUN apt-get update && \
    apt-get install -y apache2 mariadb-server php libapache2-mod-php php-mysql && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crear página de prueba PHP
RUN echo '<?php echo "<h1>Servidor LAMP en Debian con Docker</h1>"; phpinfo(); ?>' > /var/www/html/index.php

# Documentar el puerto que usará el contenedor
EXPOSE 80

# Comando que se ejecutará al iniciar el contenedor
CMD service mariadb start && apache2ctl -D FOREGROUND
```

**Explicación línea por línea**:
- `FROM debian:12`: Define la imagen base.
- `ENV DEBIAN_FRONTEND=noninteractive`: Configuración de entorno que evita prompts interactivos durante `apt`.
- `RUN ...`: Ejecuta comandos durante la construcción de la imagen. Se combinan varias operaciones en una sola capa para reducir el tamaño final.
- `RUN echo ...`: Crea automáticamente la página de prueba.
- `EXPOSE 80`: Documenta (no publica) que el contenedor escuchará en el puerto 80.
- `CMD ...`: Comando predeterminado que inicia MariaDB y Apache en primer plano (necesario para que el contenedor no se detenga inmediatamente).

Construcción y ejecución (terminal abierta en el mismo directorio del *Dockerfile*):

```bash
docker build -t lamp-debian .
docker run -d -p 8080:80 --name lamp-container lamp-debian
```


---

## 5. Diferencias entre Contenedor, Máquina Virtual y Servidor Físico

| Aspecto                     | Servidor Físico       | Máquina Virtual (VM)                | Contenedor Docker                                            |
| --------------------------- | --------------------- | ----------------------------------- | ------------------------------------------------------------ |
| **Nivel de virtualización** | Hardware físico real  | Emulación completa de hardware y SO | Virtualización a nivel de SO (kernel compartido)             |
| **Consumo de recursos**     | Alto (dedicado 100 %) | Medio-alto (overhead de hipervisor) | Muy bajo (solo proceso aislado)                              |
| **Tiempo de arranque**      | Minutos a horas       | 30 segundos a varios minutos        | 1-5 segundos                                                 |
| **Aislamiento**             | Total (físico)        | Fuerte (hipervisor)                 | Bueno (namespaces y cgroups)                                 |
| **Portabilidad**            | Muy baja              | Media (formato OVA/VMX)             | Muy alta (imágenes reproducibles en cualquier host con Docker) |

## 6. Conclusión

La presente demostración ha permitido comprender, de forma práctica y estructurada, los fundamentos del stack LAMP y la tecnología de contenedores Docker. A través de la instalación manual se ha interiorizado el rol de cada componente y la importancia del orden de los pasos, mientras que el Dockerfile ha ilustrado las buenas prácticas de automatización y reproducibilidad que se exigen en la industria actual.
