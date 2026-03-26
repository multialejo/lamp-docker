# Investigación Formal: Instalación del Stack LAMP de Forma Nativa en Debian

## Resumen

El presente documento tiene como objetivo documentar los procedimientos necesarios para implementar un entorno de desarrollo LAMP (Linux, Apache, MySQL, PHP) directamente en un sistema operativo Debian, sin utilizar tecnología de contenedores. Este enfoque tradicional permite comprender en profundidad la configuración de cada componente y su interacción con el sistema operativo.

---

## 1. Introducción

### 1.1 Contexto

El stack LAMP ha sido durante décadas la plataforma estándar para el desarrollo web. A diferencia del enfoque basado en contenedores, la instalación nativa implica configurar cada componente directamente en el sistema operativo, lo que requiere un conocimiento más profundo de la administración del sistema.

### 1.2 Objetivos

- Instalar Apache como servidor web
- Implementar MySQL/MariaDB como gestor de bases de datos
- Configurar PHP como lenguaje del lado del servidor
- Comprender la interacción entre los componentes del sistema

---

## 2. Marco Teórico

### 2.1 Instalación Nativa vs. Containerización

Antes de proceder, es importante comprender las diferencias fundamentales entre ambos enfoques:

**Instalación Nativa (Traditional):**
- Los paquetes se instalan directamente en el sistema operativo
- Los servicios se ejecutan como procesos del sistema
- La configuración se realiza mediante archivos en el sistema de archivos
- Requiere gestión manual de dependencias y versiones

**Containerización (Docker):**
- Los componentes operan en entornos aislados
- Cada servicio tiene sus propias dependencias
- La configuración se define mediante archivos de texto
- El sistema host permanece limpio

### 2.2 El Gestor de Paquetes APT

APT (Advanced Package Tool) es el sistema de gestión de paquetes de Debian y distribuciones derivadas. Permite:

- Instalar software desde repositorios oficiales
- Resolver dependencias automáticamente
- Mantener el sistema actualizado
- Gestionar la eliminación de paquetes

### 2.3 Componentes del Stack LAMP

| Componente | Paquete Debian | Función |
|------------|----------------|---------|
| **Apache** | `apache2` | Servidor web HTTP |
| **MySQL/MariaDB** | `mariadb-server` | Sistema gestor de bases de datos |
| **PHP** | `php`, `libapache2-mod-php` | Intérprete de PHP para Apache |

---

## 3. Procedimiento de Instalación

### 3.1 Requisitos Previos

- Sistema operativo Debian (versión 11 o 12)
- Privilegios de administrador (sudo)
- Conexión a internet
- Conocimientos básicos de línea de comandos

### 3.2 Preparación Inicial

Es fundamental comenzar actualizando el sistema para asegurar que todos los paquetes existentes estén en sus últimas versiones:

```bash
sudo apt update
sudo apt upgrade -y
```

**Explicación:**
- `apt update`: Actualiza la lista de paquetes disponibles desde los repositorios configurados
- `apt upgrade`: Instala las actualizaciones de los paquetes que ya están instalados
- `-y`: Responde "sí" automáticamente a todas las preguntas

### 3.3 Instalación del Servidor Apache

Apache es el servidor web más utilizado del mundo. En Debian, el paquete se llama `apache2`.

**Instalar Apache:**

```bash
sudo apt install -y apache2 apache2-utils
```

**Explicación de los paquetes:**
- `apache2`: El servidor web principal
- `apache2-utils`: Utilidades adicionales como `htpasswd`, `ab` (Apache Bench), etc.

**Verificar la instalación:**

```bash
apache2 -v
```

Deberías ver algo similar a:
```
Server version: Apache/2.4.XX (Debian)
Server built: XXXX-XX-XX XX:XX:XX
```

**Iniciar y habilitar Apache:**

```bash
sudo systemctl start apache2
sudo systemctl enable apache2
```

**Explicación:**
- `systemctl start`: Inicia el servicio inmediatamente
- `systemctl enable`: Configura el servicio para iniciar automáticamente al arrancar el sistema

**Verificar el estado:**

```bash
sudo systemctl status apache2
```

Deberías ver: `Active: active (running)`

**Prueba de funcionamiento:**

Abre un navegador y accede a:
```
http://localhost
```

Deberías ver la página por defecto de Apache en Debian: "It works!"

### 3.4 Configuración Básica de Apache

**Directorios importantes:**

| Ruta | Descripción |
|------|-------------|
| `/etc/apache2/` | Directorio de configuración principal |
| `/etc/apache2/apache2.conf` | Archivo de configuración global |
| `/etc/apache2/sites-available/` | Configuración de sitios disponibles |
| `/etc/apache2/sites-enabled/` | Sitios actualmente activos |
| `/var/www/html/` | Directorio raíz del sitio web |
| `/var/log/apache2/` | Archivos de log de Apache |

**Puertos de escucha:**

Por defecto, Apache escucha en el puerto 80. Para verificar:

```bash
sudo nano /etc/apache2/ports.conf
```

El contenido típico es:
```
Listen 80
```

### 3.5 Instalación de MariaDB (Reemplazo de MySQL)

En Debian, el paquete recomendado es `mariadb-server` en lugar de `mysql-server`. MariaDB es un fork de MySQL desarrollado por la comunidad, manteniéndose compatible y ofreciendo mejor rendimiento.

**Instalar MariaDB:**

```bash
sudo apt install -y mariadb-server mariadb-client
```

**Explicación:**
- `mariadb-server`: El servidor de base de datos
- `mariadb-client`: Cliente de línea de comandos para conectar al servidor

**Verificar la instalación:**

```bash
mariadb --version
```

**Iniciar y habilitar MariaDB:**

```bash
sudo systemctl start mariadb
sudo systemctl enable mariadb
```

**Verificar el estado:**

```bash
sudo systemctl status mariadb
```

### 3.6 Configuración de Seguridad de MariaDB

MariaDB viene con un script de seguridad que permite asegurar la instalación:

```bash
sudo mysql_secure_installation
```

Este script te fará las siguientes preguntas:

1. **Enter current password for root (enter for none):**
   - Presiona Enter (no hay contraseña inicial)

2. **Switch to unix_socket authentication [Y/n]:**
   - Responde `n` (usaremos autenticación tradicional)

3. **Change the root password? [Y/n]:**
   - Responde `Y` y ingresa una contraseña segura

4. **Remove anonymous users? [Y/n]:**
   - Responde `Y` (elimina usuarios anónimos)

5. **Disallow root login remotely? [Y/n]:**
   - Responde `Y` (no permitir root desde remoto)

6. **Remove test database and access to it? [Y/n]:**
   - Responde `Y` (eliminar base de datos de prueba)

7. **Reload privilege tables now? [Y/n]:**
   - Responde `Y` (recargar tablas de privilegios)

### 3.7 Prueba de Conexión a MariaDB

**Desde línea de comandos:**

```bash
sudo mysql -u root -p
```

Ingresa la contraseña que configuraste. Deberías ver el prompt de MariaDB:

```
Welcome to the MariaDB monitor. Commands end with ; or \g.
Your MariaDB connection id is XX
Server version: X.X.X-MariaDB Debian ...
MariaDB [(none)]>
```

**Comandos básicos de MariaDB:**

| Comando | Descripción |
|---------|-------------|
| `SHOW DATABASES;` | Ver bases de datos existentes |
| `USE nombre_db;` | Seleccionar una base de datos |
| `SHOW TABLES;` | Ver tablas de la base de datos actual |
| `EXIT;` o `QUIT;` | Salir del cliente |
| `HELP;` | Ver ayuda |

### 3.8 Instalación de PHP

PHP es el componente que permite crear páginas web dinámicas. En Debian, existen varias versiones disponibles.

**Instalar PHP básico:**

```bash
sudo apt install -y php libapache2-mod-php php-cli
```

**Explicación de paquetes:**
- `php`: Paquete principal de PHP
- `libapache2-mod-php`: Módulo de Apache para procesar PHP
- `php-cli`: Interfaz de línea de comandos para PHP

**Verificar la instalación:**

```bash
php -v
```

Deberías ver:
```
PHP X.X.X (cli) (built: ...)
Copyright (c) The PHP Group
Zend Engine X.X.X, Copyright (c) Zend Technologies
```

### 3.9 Instalación de Extensiones PHP para MySQL

Para que PHP pueda comunicarse con MySQL, necesitas instalar las extensiones correspondientes:

```bash
sudo apt install -y php-mysql php-xml php-mbstring php-curl php-zip php-json
```

**Explicación de extensiones:**
- `php-mysql`: Extensión MySQLi para PHP
- `php-xml`: Soporte para procesamiento XML
- `php-mbstring`: Funciones de cadenas multibyte
- `php-curl`: Client URL Library para hacer peticiones HTTP
- `php-zip`: Soporte para archivos comprimidos
- `php-json`: Soporte para JSON

**Verificar extensiones instaladas:**

```bash
php -m | grep -i mysql
php -m | grep -i mysqli
```

### 3.10 Reiniciar Apache

Después de instalar o modificar PHP, es necesario reiniciar Apache para que cargue los nuevos módulos:

```bash
sudo systemctl restart apache2
```

### 3.11 Verificar la Integración PHP-Apache

**Crear archivo de prueba:**

```bash
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php
```

**Acceder al archivo:**

Abre tu navegador y accede a:
```
http://localhost/info.php
```

Deberías ver una página con información detallada de PHP.

### 3.12 Probar la Conexión PHP-MySQL

**Crear archivo de prueba de conexión:**

```bash
sudo nano /var/www/html/test_db.php
```

**Contenido:**

```php
<?php
echo "<h1>Test de Conexión LAMP Nativo</h1>";
echo "<p>PHP Version: " . phpversion() . "</p>";

// Conexión a MySQL
$servername = "localhost";
$username = "root";
$password = "tu_contraseña_root";  // Cambia esto

try {
    $conn = new mysqli($servername, $username, $password);
    if ($conn->connect_error) {
        throw new Exception("Connection failed: " . $conn->connect_error);
    }
    echo "<p>Conexión a MySQL exitosa!</p>";
    
    // Mostrar versión de MySQL
    $result = $conn->query("SELECT VERSION()");
    $row = $result->fetch_row();
    echo "<p>Versión de MySQL: " . $row[0] . "</p>";
    
} catch (Exception $e) {
    echo "<p>Error de conexión: " . $e->getMessage() . "</p>";
}
?>
```

**Probar:**

Accede a: `http://localhost/test_db.php`

---

## 4. Gestión de Virtual Hosts

Los Virtual Hosts permiten servir múltiples sitios web desde un mismo servidor.

### 4.1 Crear un Virtual Host

**Crear directorio del sitio:**

```bash
sudo mkdir -p /var/www/misitio.local
sudo chown -R www-data:www-data /var/www/misitio.local
sudo chmod -R 755 /var/www/misitio.local
```

**Crear archivo de configuración:**

```bash
sudo nano /etc/apache2/sites-available/misitio.local.conf
```

**Contenido:**

```apache
<VirtualHost *:80>
    ServerAdmin admin@misitio.local
    ServerName misitio.local
    ServerAlias www.misitio.local
    DocumentRoot /var/www/misitio.local
    
    <Directory /var/www/misitio.local>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/misitio.local-error.log
    CustomLog ${APACHE_LOG_DIR}/misitio.local-access.log combined
</VirtualHost>
```

### 4.2 Habilitar el Sitio

```bash
sudo a2ensite misitio.local.conf
sudo systemctl reload apache2
```

### 4.3 Agregar al archivo hosts

Para que tu navegador resuelva el dominio localmente:

```bash
sudo nano /etc/hosts
```

Agrega la línea:
```
127.0.0.1    misitio.local
```

---

## 5. Instalación de phpMyAdmin (Opcional)

phpMyAdmin es una interfaz web para administrar MySQL.

### 5.1 Instalación

```bash
sudo apt install -y phpmyadmin
```

**Durante la instalación:**

1. **Web server to reconfigure automatically:**
   - Selecciona `apache2` usando la barra espaciadora

2. **Configure database for phpmyadmin with dbconfig-common?**
   - Responde `Yes`

3. **Password of the database's administrative user:**
   - Ingresa la contraseña root de MySQL

4. **MySQL application password for phpmyadmin:**
   - Ingresa una contraseña para phpMyAdmin o deja en blanco para una contraseña aleatoria

### 5.2 Configuración Adicional

**Habilitar extensiones PHP requeridas:**

```bash
sudo apt install -y php-mbstring php-zip php-gd php-json php-curl
sudo systemctl restart apache2
```

**Crear enlace simbólico (si es necesario):**

```bash
sudo ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
```

### 5.3 Acceder a phpMyAdmin

```
http://localhost/phpmyadmin
```

**Credenciales:**
- Usuario: `root`
- Contraseña: La que configuraste durante la instalación

---

## 6. Gestión de Servicios

### 6.1 Comandos Útiles para Apache

| Comando | Descripción |
|---------|-------------|
| `sudo systemctl start apache2` | Iniciar Apache |
| `sudo systemctl stop apache2` | Detener Apache |
| `sudo systemctl restart apache2` | Reiniciar Apache |
| `sudo systemctl reload apache2` | Recargar configuración |
| `sudo systemctl status apache2` | Ver estado |
| `sudo a2enmod modulo` | Habilitar módulo |
| `sudo a2dismod modulo` | Deshabilitar módulo |
| `sudo a2ensite sitio` | Habilitar sitio |
| `sudo a2dissite sitio` | Deshabilitar sitio |

### 6.2 Comandos Útiles para MariaDB

| Comando | Descripción |
|---------|-------------|
| `sudo systemctl start mariadb` | Iniciar MariaDB |
| `sudo systemctl stop mariadb` | Detener MariaDB |
| `sudo systemctl restart mariadb` | Reiniciar MariaDB |
| `sudo systemctl status mariadb` | Ver estado |
| `sudo mysql` | Conectar como root |

### 6.3 Comandos Útiles para PHP

| Comando | Descripción |
|---------|-------------|
| `php -v` | Ver versión de PHP |
| `php -m` | Ver módulos instalados |
| `php -i` | Ver información completa |
| `php -l archivo.php` | Verificar sintaxis |

---

## 7. Mantenimiento y Actualización

### 7.1 Actualizar el Sistema

```bash
sudo apt update
sudo apt upgrade -y
```

### 7.2 Verificar Paquetes Obsoletos

```bash
sudo apt autoremove -y
sudo apt autoclean
```

### 7.3 Respaldar Bases de Datos

**Respaldar una base de datos:**

```bash
sudo mysqldump -u root -p nombre_db > respaldo.sql
```

**Restaurar una base de datos:**

```bash
sudo mysql -u root -p nombre_db < respaldo.sql
```

---

## 8. Solución de Problemas Comunes

### 8.1 Apache no inicia

**Verificar errores de configuración:**

```bash
sudo apache2ctl configtest
```

**Ver logs:**

```bash
sudo tail -f /var/log/apache2/error.log
```

### 8.2 No se puede conectar a MySQL

**Verificar que MySQL esté corriendo:**

```bash
sudo systemctl status mariadb
```

**Verificar que el socket existe:**

```bash
ls -la /var/run/mysqld/
```

### 8.3 PHP no procesa archivos

**Verificar que el módulo PHP esté habilitado:**

```bash
sudo a2query -m php
```

**Si no está habilitado:**

```bash
sudo a2enmod php8.2  # Ajusta la versión
sudo systemctl restart apache2
```

### 8.4 Permisos de archivos

Si recibes errores de permisos:

```bash
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
```

---

## 9. Consideraciones de Seguridad

### 9.1 Firewall

Si usas ufw (Uncomplicated Firewall):

```bash
sudo apt install -y ufw
sudo ufw allow 80/tcp   # HTTP
sudo ufw allow 443/tcp  # HTTPS
sudo ufw enable
```

### 9.2 Ocultar información de Apache

Editar `/etc/apache2/conf-available/security.conf`:

```apache
ServerTokens Prod
ServerSignature Off
```

Reiniciar Apache:

```bash
sudo systemctl restart apache2
```

### 9.3 Deshabilitar PHP en directorios sensibles

Para prevenir la ejecución de archivos PHP subidos:

```apache
<Directory /var/www/uploads>
    php_flag engine off
    RemoveHandler .php .phtml .php3 .php4 .php5
    RemoveType .php .phtml .php3 .php4 .php5
</Directory>
```

---

## 10. Conclusiones

La instalación nativa del stack LAMP en Debian proporciona un control completo sobre cada componente del sistema. Este método es ideal para:

- Servidores de producción
- Entornos donde se requiere máximo rendimiento
- Aprendizaje profundo de administración de sistemas
- Situaciones donde no es posible usar contenedores

---

## 11. Comparación: Instalación Nativa vs. Docker

A continuación, se presenta un análisis detallado de las diferencias entre ambos enfoques:

### 11.1 Preparación del Entorno

| Aspecto | Instalación Nativa | Docker |
|---------|-------------------|--------|
| **Tiempo inicial** | 15-30 minutos | 5-10 minutos |
| **Complejidad** | Alta - múltiples pasos | Media - configuración centralizada |
| **Dependencias del sistema** | Se instalan directamente | Aisladas en contenedores |

### 11.2 Gestión de Componentes

| Aspecto | Instalación Nativa | Docker |
|---------|-------------------|--------|
| **Actualizaciones** | Actualiza todo el sistema con apt | Actualiza imágenes individuales |
| **Versiones** | Limitado a repositorios Debian | Múltiples versiones disponibles |
| **Conflictos** | Puede haber conflictos entre versiones | Cada contenedor tiene sus propias dependencias |

### 11.3 Recursos y Rendimiento

| Aspecto | Instalación Nativa | Docker |
|---------|-------------------|--------|
| **Uso de recursos** | Más eficiente | Overhead de contenedores |
| **Memoria** | Compartida con el SO | Memoria dedicada por contenedor |
| **Inicio** | Servicios del sistema | Contenedores (más rápido) |

### 11.4 Aislamiento

| Aspecto | Instalación Nativa | Docker |
|---------|-------------------|--------|
| **Separación de servicios** | Procesos del sistema | Contenedores aislados |
| **Conflictos de puertos** | Afecta al sistema directamente | Fácil de modificar |
| **Limpieza** | Eliminación manual de paquetes | `docker-compose down` |

### 11.5 Portabilidad

| Aspecto | Instalación Nativa | Docker |
|---------|-------------------|--------|
| **Replicación en otro equipo** | Repetir todos los pasos | Copiar archivos y ejecutar |
| **Documentación** | Anotar cada paso | Archivo docker-compose.yml |
| **Equipo diferente** | Puede variar por SO | Idéntico en cualquier SO |

### 11.6 Mantenimiento

| Aspecto | Instalación Nativa | Docker |
|---------|-------------------|--------|
| **Limpieza** | `apt autoremove` | `docker system prune` |
| **Errores** | Difíciles de aislar | Contenedor falla únicamente |
| **Rollback** | Complejo | Fácil de recrear |

### 11.7 Desarrollo vs. Producción

| Entorno | Recomendación | Justificación |
|---------|---------------|---------------|
| **Desarrollo local** | Docker | Rápido de configurar, fácil de replicar |
| **Producción** | Depende | Docker ofrece consistencia; nativo ofrece rendimiento |
| **Aprendizaje** | Nativo | Comprende cómo funciona el sistema |

### 11.8 Ventajas de la Instalación Nativa

1. **Mayor rendimiento**: Sin overhead de virtualización
2. **Depuración más directa**: Los procesos son visibles con herramientas estándar
3. **Menor consumo de recursos**: No hay duplicación de binarios
4. **Completo control**: Acceso total a configuraciones
5. **Aprendizaje**: Ideal para entender cómo funcionan los componentes

### 11.9 Ventajas de Docker

1. **Reproducibilidad**: Entorno idéntico en cualquier máquina
2. **Aislamiento**: Conflictos de dependencias resueltos
3. **Rapidez de despliegue**: Un comando para todo
4. **Facilidad de eliminación**: Entorno limpio al eliminar
5. **Escalabilidad**: Fácil de replicar para múltiples instancias

### 11.10 Cuándo Usar Cada Approach

**Usa instalación nativa cuando:**
- Necesites máximo rendimiento
- Ejecutes en servidores de producción con recursos limitados
- Requieras control total del sistema
- Estés aprendiendo administración de sistemas
- No puedas usar Docker por restricciones

**Usa Docker cuando:**
- Trabajes en equipo y necesites ambientes idénticos
- Quieres rapidez en configuración
- Necesites cambiar entre versiones frecuentemente
- Quieres facilidad para recrear el ambiente
- Estés desarrollando aplicaciones modernas

---

## 12. Referencias

- Documentación oficial de Debian: https://www.debian.org/doc/
- Apache HTTP Server Documentation: https://httpd.apache.org/docs/
- MariaDB Documentation: https://mariadb.com/kb/en/
- PHP Documentation: https://www.php.net/docs.php

---

*Documento elaborado con fines académicos - Curso de Administración de Bases de Datos*
