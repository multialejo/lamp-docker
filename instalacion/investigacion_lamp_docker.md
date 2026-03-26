# Investigación Formal: Instalación del Stack LAMP mediante Docker en Debian

## Resumen

El presente documento tiene como objetivo documentar los procedimientos necesarios para implementar un entorno de desarrollo LAMP (Linux, Apache, MySQL, PHP) en un sistema operativo Debian utilizando contenedores Docker, ademas de brindar un marco teorico abarcando algunos de los ambitos involucrados. 

---

## 1. Introducción

### 1.1 Contexto

El stack LAMP constituye una de las plataformas más utilizadas para el desarrollo y alojamiento de aplicaciones web dinámicas. La arquitectura tradicional requiere la instalación directa de cada componente en el sistema operativo host. Sin embargo, la containerización mediante Docker permite encapsular cada servicio en contenedores independientes, facilitando su gestión y despliegue.

### 1.2 Objetivos

- Instalar Docker y Docker Compose en Debian
- Configurar el servidor Apache mediante contenedores
- Implementar el gestor de bases de datos MySQL/MariaDB
- Configurar el lenguaje PHP para procesamiento del lado del servidor

---

## 2. Marco Teórico

### 2.1 Concepto de Containerización

La **containerización** es una tecnología de virtualización a nivel de sistema operativo que permite empaquetar una aplicación junto con todas sus dependencias (bibliotecas, configuraciones, archivos) en un unidad aislada llamada **contenedor**. Esta unidad es ligera, portable y se ejecuta de manera consistente en cualquier entorno.

#### Diferencia entre Virtualización y Containerización

Para entender mejor la containerización, es útil compararla con la virtualización tradicional:

**Virtualización (Máquinas Virtuales):**

- Cada máquina virtual (VM) incluye un sistema operativo completo
- Ocupa varios gigabytes de almacenamiento
- Tarda minutos en iniciar
- Mayor overhead (recursos del host consumidos por múltiples SO)

**Containerización:**

- Los contenedores comparten el kernel del sistema operativo host
- Ocupa megabytes (típicamente 10-100 MB)
- Inicia en segundos
- Eficiencia máxima de recursos

#### ¿Qué es un Contenedor?

Un contenedor es una instancia ejecutable de una imagen. Piensa en él como un proceso aislado que tiene su propio sistema de archivos, configuración de red y variables de entorno, pero que comparte el kernel del sistema operativo con otros contenedores.

### 2.2 ¿Qué es Docker?

**Docker** es la plataforma de código abierto más popular para la containerización. Fue lanzada en 2013 y ha revolucionado la forma en que desarrollamos, probamos y desplegamos aplicaciones.

#### Componentes Fundamentales de Docker

**Docker Engine:**
Es el núcleo de la plataforma. Es un daemon (servicio en segundo plano) que se ejecuta en el sistema operativo y gestiona los contenedores. El cliente Docker (CLI) se comunica con este daemon.

**Imágenes Docker:**
Son plantillas de solo lectura que contienen el sistema de archivos y la configuración necesaria para crear un contenedor. Las imágenes se construyen capa por capa, y cada capa representa una instrucción en el Dockerfile. Por ejemplo:

```
Imagen Base (OS) → Capa PHP → Capa Apache → Capa Mi Aplicación
```

**Dockerfile:**
Es un archivo de texto que contiene instrucciones para construir una imagen Docker. Cada instrucción crea una nueva capa en la imagen.

**Contenedores:**
Son instancias ejecutables de imágenes. Puedes crear, iniciar, detener y eliminar contenedores. Un contenedor es fundamentalmente diferente de una imagen: mientras la imagen es estática, el contenedor es dinámica.

**Docker Hub / Registros:**
Son repositorios donde se almacenan y distribuyen las imágenes Docker. Docker Hub es el registro público más conocido, pero existen otros como Google Container Registry, Amazon ECR, etc.

#### Conceptos Clave de Docker

**Puertos (Ports):**
Los contenedores Docker pueden exponer puertos para comunicarse con el exterior. Por ejemplo, si ejecutas un servidor web en el puerto 80 dentro del contenedor, necesitas "mapear" ese puerto a un puerto en tu máquina host (por ejemplo, 8080:80).

**Volúmenes (Volumes):**
Son mecanismos para persistir datos generados por el contenedor. Los volúmenes permiten que los datos sobrevivan cuando el contenedor se elimina, y también facilitan compartir datos entre el host y el contenedor.

**Redes (Networks):**
Docker proporciona capacidades de red que permiten a los contenedores comunicarse entre sí o con el mundo exterior.

### 2.3 ¿Qué es Docker Compose?

**Docker Compose** es una herramienta que permite definir y ejecutar aplicaciones multi-contenedor. Mientras Docker es ideal para gestionar contenedores individuales, Docker Compose facilita la orquestación de aplicaciones complejas que requieren múltiples servicios trabajando juntos.

#### ¿Por qué usar Docker Compose?

Imaginemos una aplicación web típica que necesita:

- Un servidor web (Apache/Nginx)
- Un interprete de PHP
- Una base de datos (MySQL)
- Un servidor de caché (Redis)

Con Docker puro, tendrías que ejecutar múltiples comandos `docker run` y configurar manualmente las redes y volúmenes. Con Docker Compose, defines todo esto en un único archivo YAML.

**El archivo docker compose.yml:**
En este archivo declaras:

- Qué servicios (contenedores) necesita tu aplicación
- Qué imagen usar para cada servicio
- Cómo se conectan entre sí
- Qué puertos exponer
- Qué volúmenes montar
- Variables de entorno necesarias

### 2.4 Componentes del Stack LAMP

Ahora que entendemos Docker y Docker Compose, exploremos cada componente del stack LAMP:

| Componente | Función | Concepto Docker |
|------------|---------|-----------------|
| **Apache** | Servidor web HTTP que sirve páginas web a los clientes. Recibe solicitudes HTTP y devuelve contenido estático o procesa scripts PHP. | Contenedor basado en imagen `php:apache` o `httpd` |
| **MySQL/MariaDB** | Sistema gestor de bases de datos relacionales (RDBMS). Almacena los datos de la aplicación de manera estructurada. MariaDB es un fork de MySQL desarrollado por la comunidad. | Contenedor basado en imagen `mysql` o `mariadb` |
| **PHP** | Lenguaje de programación del lado del servidor. Procesa la lógica de negocio, conecta con la base de datos y genera contenido dinámico. | Contenedor basado en imagen `php:fpm` |

#### ¿Por qué usar PHP-FPM en lugar de Apache con PHP módulos?

PHP-FPM (FastCGI Process Manager) es una implementación alternativa del Protocolo FastCGI. Ofrece características avanzadas especialmente útiles para sitios de alto tráfico:

- Mejor gestión de procesos
- Logging avanzado
- Rotación de logs
- Inicio rápido
- Capacidad de ejecutar PHP en un contenedor separado de Apache

---

## 3. Procedimiento de Instalación

### 3.1 Requisitos Previos

- Sistema operativo Debian (versión 11 o 12)
- Privilegios de administrador (sudo)
- Conexión a internet
- Conocimientos básicos de línea de comandos

### 3.2 Instalación de Docker Engine

El proceso de instalación de Docker en Debian implica agregar el repositorio oficial de Docker e instalar los paquetes necesarios.

**Actualizar el sistema:**

```bash
sudo apt update
sudo apt upgrade -y
```

**Instalar dependencias necesarias:**

```bash
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
```

Estas dependencias son necesarias porque:

- `apt-transcript-https`: Permite usar repositorios HTTPS
- `ca-certificates`: Certificados raíz para conexiones seguras
- `curl`: Herramienta para descargar archivos
- `gnupg`: Sistema de encriptación para verificar claves GPG
- `lsb-release`: Información de la distribución

**Agregar la clave GPG oficial de Docker:**

```bash
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

Este comando descarga la clave GPG de Docker y la convierte al formato que apt puede usar. Esto asegura que los paquetes de Docker provienen realmente de Docker Inc.

**Configurar el repositorio stable:**

```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Este comando:

- Configura el repositorio de Docker para tu versión de Debian (`$(lsb_release -cs)` devuelve el nombre en clave, como "bookworm" para Debian 12)
- Especifica arquitectura amd64
- Usa la clave GPG que agregamos anteriormente

**Instalar Docker Engine:**

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

Los paquetes instalados son:

- `docker-ce`: Docker Community Edition (el motor principal)
- `docker-ce-cli`: Interfaz de línea de comandos de Docker
- `containerd.io`: Runtime de contenedores de bajo nivel

**Verificar la instalación:**

```bash
docker --version
```

Deberías ver algo como: `Docker version 24.0.0, build xxxxxx`

### 3.3 Instalación de Docker Compose

Las versiones recientes de Docker (desde Docker Engine 1.27.0) incluyen Docker Compose v2 como subcomando integrado (`docker compose`). Esto significa que puedes usar `docker compose` en lugar de `docker-compose`.

**Verificar si Docker Compose está disponible:**

```bash
docker compose version
```

### 3.4 Iniciar el servicio Docker

Docker funciona como un servicio del sistema. Necesitas iniciarlo y configurarlo para que arranque automáticamente:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

Comandos útiles para Docker:

- `sudo systemctl status docker`: Ver el estado del servicio
- `sudo systemctl stop docker`: Detener el servicio
- `sudo systemctl restart docker`: Reiniciar el servicio

### 3.5 Ejecutar Docker sin sudo (Opcional)

Por defecto, solo el usuario root puede usar Docker. Para permitir que tu usuario regular use Docker:

```bash
sudo usermod -aG docker $USER
```

Después de ejecutar este comando, cierra sesión y vuelve a entrar para que los cambios tengan efecto.

---

## 4. Configuración del Stack LAMP con Docker Compose

### 4.1 ¿Por qué necesitamos múltiples contenedores?

En nuestra arquitectura LAMP con Docker, cada servicio principal (Apache, PHP, MySQL) correrá en su propio contenedor por las siguientes razones:

1. **Aislamiento**: Si un servicio falla, los demás continúan funcionando
2. **Escalabilidad**: Puedes escalar cada servicio independientemente
3. **Mantenimiento**: Actualizar un servicio no afecta a los demás
4. **Recursos**: Asignar recursos específicos a cada servicio
5. **Simplicidad**: Cada contenedor hace una cosa y la hace bien

### 4.2 Estructura del Proyecto

Crear la estructura de directorios:

```bash
mkdir -p lamp-docker/{apache,php,www,mysql}
cd lamp-docker
```

Explicación de la estructura:

```
lamp-docker/
├── apache/         # Dockerfile de Apache con PHP
├── php/            # Dockerfile de PHP-FPM
├── www/            # Archivos PHP de tu aplicación
├── mysql/          # Datos de MySQL (persistente)
└── docker compose.yml
```

### 4.3 Archivo docker-compose.yml

Este es el archivo central que define todos nuestros servicios. Créalo en el directorio raíz del proyecto:

```yaml
services:
  # Servicio Apache con PHP
  apache:
    build:
      context: ./apache
      dockerfile: Dockerfile
    container_name: lamp_apache
    ports:
      - "8080:80"
    volumes:
      - ./www:/var/www/html
    depends_on:
      - mysql
    networks:
      - lamp_network
    restart: unless-stopped

  # Servicio MySQL
  mysql:
    image: mysql:8.0
    container_name: lamp_mysql
    environment:
      MYSQL_ROOT_PASSWORD: rootpass
      MYSQL_DATABASE: lamp_db
      MYSQL_USER: lamp_user
      MYSQL_PASSWORD: lamp_pass
    volumes:
      - ./mysql:/var/lib/mysql
    ports:
      - "3306:3306"
    networks:
      - lamp_network
    restart: unless-stopped

  # phpMyAdmin (interfaz gráfica para MySQL)
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: lamp_phpmyadmin
    environment:
      PMA_HOST: mysql
      PMA_PORT: 3306
      PMA_USER: lamp_user
      PMA_PASSWORD: lamp_pass
    ports:
      - "8081:80"
    depends_on:
      - mysql
    networks:
      - lamp_network
    restart: unless-stopped

networks:
  lamp_network:
    driver: bridge
```

#### Explicación de cada sección

**services:**
Define todos los contenedores que queremos ejecutar.

**apache:**

- `build: ./apache`: Construye la imagen desde el Dockerfile personalizado
- `container_name`: Nombre legible para identificar el contenedor
- `ports: "8080:80"`: Mapea el puerto 80 del contenedor al 8080 del host
- `volumes`: Monta el directorio local `./www` en `/var/www/html` del contenedor
- `depends_on`: Este servicio espera a que mysql esté listo
- `networks`: Conecta el contenedor a la red definida
- `restart: unless-stopped`: Reinicia automáticamente si se detiene (excepto si lo detienes manualmente)

**mysql:**

- `image: mysql:8.0`: Imagen oficial de MySQL versión 8
- `environment`: Variables de entorno para configuración inicial
  - `MYSQL_ROOT_PASSWORD`: Contraseña del usuario root
  - `MYSQL_DATABASE`: Crea una base de datos automáticamente
  - `MYSQL_USER` y `MYSQL_PASSWORD`: Crea un usuario adicional
- `volumes: ./mysql:/var/lib/mysql`: Persiste la base de datos incluso si el contenedor se elimina

**phpmyadmin:**

- Interfaz web para administrar MySQL visualmente
- Se conecta al servicio mysql usando el nombre del contenedor como host

**networks:**

- Crea una red bridge que permite la comunicación entre contenedores

### 4.4 Dockerfile para Apache con PHP

Las imágenes oficiales de PHP no incluyen todas las extensiones necesarias para conectar con MySQL. Por eso creamos un Dockerfile personalizado en `apache/Dockerfile`:

```dockerfile
FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    libzip-dev unzip \
    && docker-php-ext-install pdo pdo_mysql mysqli zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN a2enmod rewrite headers
```

**Explicación:**

- `FROM php:8.2-apache`: Imagen base de PHP 8.2 con Apache incluido
- `RUN docker-php-ext-install pdo pdo_mysql mysqli`: Instala extensiones para conectar con MySQL
  - PDO (PHP Data Objects): Interfaz uniforme para acceder a bases de datos
  - pdo_mysql: Driver PDO para MySQL
  - mysqli: Extensión mejorada de MySQL
- `RUN apt-get update...`: Instala librerías necesarias para la extensión ZIP
- `RUN docker-php-ext-install zip`: Habilita soporte para comprimir archivos ZIP
- `COPY --from=composer`: Instala Composer para gestión de dependencias PHP
- `a2enmod rewrite headers`: Habilita módulos de Apache necesarios

### 4.5 Archivo de prueba PHP

Crear archivo `www/index.php` para probar la instalación:

```php
<?php
echo "<h1>LAMP Stack con Docker</h1>";
echo "<p>PHP Version: " . phpversion() . "</p>";

// Conexión a MySQL
$servername = "mysql";
$username = "lamp_user";
$password = "lamp_pass";
$dbname = "lamp_db";

try {
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    echo "<p>Conexión a MySQL exitosa!</p>";
} catch (Exception $e) {
    echo "<p>Error de conexión: " . $e->getMessage() . "</p>";
}
?>
```

Este script:

1. Muestra información de PHP
2. Intenta conectarse a MySQL usando mysqli
3. Muestra si la conexión fue exitosa o falló

### 4.6 Iniciar los contenedores

```bash
docker compose up -d --build
```

**Explicación:**

- `docker compose`: Herramienta para orquestar contenedores
- `up`: Crea y ejecuta los contenedores
- `-d`: Modo "detached" (en segundo plano)
- `--build`: Fuerza la construcción de las imágenes (necesario la primera vez)

La primera vez que ejecutes esto, Docker descargará las imágenes necesarias (puede tomar unos minutos dependiendo de tu conexión).

### 4.7 Verificar el estado de los contenedores

```bash
docker compose ps
```

Deberías ver algo como:

```
NAME            IMAGE          COMMAND              STATUS
lamp_apache     lamp-docker    "docker-php-entry..."  Up
lamp_mysql      mysql:8.0      "docker-entrypoint..." Up
lamp_phpmyadmin phpmyadmin     "/docker-entrypoint..." Up
```

**Ver logs en tiempo real:**

```bash
docker compose logs -f
```

Esto es muy útil para depurar problemas. Presiona Ctrl+C para salir.

---

## 5. Verificación de la Instalación

### 5.1 Verificar Apache y PHP

Abre tu navegador web y accede a:

```
http://localhost:8080
```

Deberías ver:

- El título "LAMP Stack con Docker"
- La versión de PHP instalada
- Un mensaje indicando si la conexión a MySQL fue exitosa

Si ves la página pero la conexión a MySQL falla, espera unos segundos más ya que MySQL puede tardar en inicializar completamente.

### 5.2 Verificar phpMyAdmin

phpMyAdmin es una herramienta web para administrar MySQL visualmente. Accede a:

```
http://localhost:8081
```

**Credenciales de acceso:**

- Usuario: `lamp_user`
- Contraseña: `lamp_pass`

phpMyAdmin te permitirá:

- Ver las bases de datos existentes
- Crear nuevas bases de datos
- Ejecutar consultas SQL
- Administrar tablas y registros

### 5.3 Verificar la versión de PHP

También puedes verificar la información de PHP creando un archivo de info:

```bash
echo "<?php phpinfo(); ?>" > www/info.php
```

Y accede a: `http://localhost:8080/info.php`

Esto mostrará una página completa con toda la configuración de PHP.

---

## 6. Comandos Esenciales de Docker Compose

A continuación, una referencia de los comandos más utilizados:

| Comando | Descripción |
|---------|-------------|
| `docker compose up -d` | Iniciar todos los servicios en segundo plano |
| `docker compose down` | Detener y eliminar todos los contenedores |
| `docker compose down -v` | Además de detener, elimina los volúmenes (datos) |
| `docker compose restart` | Reiniciar todos los servicios |
| `docker compose logs -f` | Ver logs en tiempo real |
| `docker compose logs -f [servicio]` | Ver logs de un servicio específico |
| `docker compose ps` | Ver estado de los contenedores |
| `docker compose exec [servicio] bash` | Acceder al shell del contenedor |
| `docker compose exec php sh` | Acceso rápido al contenedor PHP |
| `docker compose build` | Reconstruir las imágenes |
| `docker compose pull` | Descargar últimas versiones de imágenes |

### 6.1 Ejemplos Prácticos

**Acceder al contenedor MySQL:**

```bash
docker compose exec mysql bash
```

Dentro del contenedor, puedes usar el cliente MySQL:

```bash
mysql -u root -p
```

**Ver qué procesos están corriendo dentro de un contenedor:**

```bash
docker compose exec php ps aux
```

**Copiar archivos desde el contenedor al host:**

```bash
docker compose cp mysql:/var/lib/mysql ./backup/
```

---

## 7. Conceptos Avanzados

### 7.1 Volumes (Volúmenes)

Los volúmenes en Docker son mecanismos de almacenamiento persistentes. En nuestro setup:

- `./mysql:/var/lib/mysql`: Guarda la base de datos en tu disco local
- `./www:/var/www/html`: Sincroniza tus archivos PHP con el contenedor

**Tipos de volúmenes:**

1. **Volumes bind**: Montan directorios del host (como ./www)
2. **Named volumes**: Volumes gestionados por Docker (mysql_data:)
3. **tmpfs**: Almacenamiento en memoria (para datos sensibles temporales)

### 7.2 Redes (Networks)

Por defecto, Docker crea una red bridge para cada proyecto. En nuestro caso, `lamp_network` permite que:

- Los contenedores se comuniquen entre sí usando sus nombres como hostnames
- `apache` puede alcanzar a `mysql` conectándose a `mysql:3306`
- `php` puede alcanzar a `mysql` conectándose a `mysql:3306`

**Tipos de redes en Docker:**

- **bridge**: Red por defecto para contenedores aislados
- **host**: Elimina el aislamiento de red (contenedor usa la red del host)
- **overlay**: Para conectar contenedores en múltiples hosts (Swarm)
- **none**: Sin red

### 7.3 Reinicio Automático (restart policy)

La opción `restart: unless-stopped` es importante porque:

- `no`: No reiniciar automáticamente
- `always`: Siempre reiniciar si se detiene
- `on-failure`: Reiniciar solo si sale con código de error
- `unless-stopped`: Reiniciar siempre excepto si se detuvo manualmente

---

## 8. Consideraciones de Seguridad

### 8.1 Credenciales

**MUY IMPORTANTE:** Las credenciales usadas en este tutorial son de ejemplo. En un entorno de producción o incluso desarrollo compartido, cámbialas:

```yaml
environment:
  MYSQL_ROOT_PASSWORD: una_contraseña_muy_larga_y_segura
  MYSQL_PASSWORD: otra_contraseña_segura
```

### 8.2 Puertos

Verifica que los puertos 8080, 3306 y 8081 no estén siendo usados por otras aplicaciones:

```bash
sudo netstat -tulpn | grep -E ':(8080|3306|8081)'
```

### 8.3 Permisos

En sistemas Linux, el directorio www debe tener los permisos correctos:

```bash
sudo chown -R $USER:$USER www/
```

Esto asegura que tu usuario pueda escribir archivos en ese directorio.

### 8.4 No exponer puertos innecesariamente

En un entorno de producción:

- Expón solo el puerto 80/443 para HTTP/HTTPS
- No expongas MySQL (puerto 3306) directamente a internet
- Considera usar un proxy reverso como Nginx

---

## 9. Solución de Problemas Comunes

### 9.1 "Puerto ya está en uso"

Si obtienes un error de puerto:

```bash
Error starting userland proxy: listen tcp4 0.0.0.0:8080: bind: address already in use
```

Solución: Cambia el puerto en docker compose.yml:

```yaml
ports:
  - "8082:80"  # Usa otro puerto
```

### 9.2 "No se puede conectar a MySQL"

Si la conexión a MySQL falla:

1. Verifica que el contenedor MySQL esté corriendo: `docker compose ps`
2. Revisa los logs: `docker compose logs mysql`
3. Espera a que MySQL inicialice completamente (puede tomar 30-60 segundos)

### 9.3 "Permiso denegado" en archivos

En Linux, si no puedes escribir en el directorio www:

```bash
sudo chown -R $USER:$USER www/
```

### 9.4 Verificar que Docker esté corriendo

```bash
sudo systemctl status docker
```

Si no está corriendo:

```bash
sudo systemctl start docker
```

---

## 10. Conclusiones

La implementación del stack LAMP mediante Docker proporciona un entorno de desarrollo aislado, reproducible y fácil de gestionar. Los pasos documentados en esta investigación permiten configurar Apache, MySQL y PHP en contenedores Docker sobre un sistema Debian, cumpliendo con los requisitos establecidos para la administración de bases de datos.

### Beneficios del enfoque containerizado

1. **Reproducibilidad**: Cualquier miembro del equipo puede recrear el mismo ambiente con un comando
2. **Aislamiento**: Los servicios no interfieren entre sí ni con el sistema host
3. **Portabilidad**: El ambiente funciona igual en Windows, Mac o Linux
4. **Facilidad de limpieza**: Con `docker compose down` se elimina todo
5. **Aprendizaje**: Ideal para entender cómo funcionan los componentes de una aplicación web

### Próximos pasos sugeridos

- Experimentar con diferentes configuraciones de PHP
- Aprender sobre Docker Swarm o Kubernetes para producción
- Explorar el uso de Nginx como alternativa a Apache
- Implementar HTTPS con Let's Encrypt

---

## 11. Referencias

- Docker Official Documentation: <https://docs.docker.com/>
- Docker Compose Documentation: <https://docs.docker.com/compose/>
- PHP Official Docker Images: <https://hub.docker.com/_/php>
- MySQL Official Docker Images: <https://hub.docker.com/_/mysql>
- Docker Hub (imágenes disponibles): <https://hub.docker.com/>

---

*Documento elaborado con fines académicos - Curso de Administración de Bases de Datos*
