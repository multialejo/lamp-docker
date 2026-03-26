# LAMP Stack con Docker

Stack LAMP (Linux, Apache, MySQL, PHP) containerizado con Docker Compose para desarrollo local.

## Requisitos

- Sistema operativo Debian (versión 11 o 12)
- Docker instalado y en ejecución en el sistema host.
- Privilegios de administrador (sudo)
- Conexión a internet
- Conocimientos básicos de línea de comandos

## Quick Start

### Ubicar contenidos
Muevete hacia donde hayas descargado de la carpeta `lamp` de este repositorio.

### Iniciar servicios
```bash
docker compose up -d --build
```

### Verificar estado
```bash
docker compose ps
```
## Estructura del Proyecto

```
lamp/
├── apache/Dockerfile    # Imagen personalizada de Apache + PHP
├── php/Dockerfile       # Imagen PHP-FPM (si se usa arquitectura separada)
├── www/                 # Archivos de la aplicación
│   └── index.php
├── mysql/               # Datos persistentes de MySQL
└── docker-compose.yml   # Definición de servicios
```

## Configuración

### Variables de Entorno (docker-compose.yml)

| Variable              | Valor por defecto | Descripción           |
| --------------------- | ----------------- | --------------------- |
| `MYSQL_ROOT_PASSWORD` | `rootpass`        | Contraseña root       |
| `MYSQL_DATABASE`      | `lamp_db`         | Base de datos inicial |
| `MYSQL_USER`          | `lamp_user`       | Usuario de aplicación |
| `MYSQL_PASSWORD`      | `lamp_pass`       | Contraseña de usuario |

### Puertos

| Servicio   | Puerto      |
| ---------- | ----------- |
| Apache     | `8080:80`   |
| MySQL      | `3306:3306` |
| phpMyAdmin | `8081:80`   |

## Acceso

- **Aplicación:** http://localhost:8080
- **phpMyAdmin:** http://localhost:8081
  - Usuario: `lamp_user`
  - Contraseña: `lamp_pass`

## Comandos Útiles

```bash
# Iniciar servicios
docker compose up -d

# Detener servicios
docker compose down

# Detener y eliminar volúmenes (borra datos)
docker compose down -v

# Reiniciar
docker compose restart

# Ver logs
docker compose logs -f

# Ver logs de un servicio específico
docker compose logs -f mysql

# Acceder al shell de un contenedor
docker compose exec mysql bash

# Acceder a MySQL CLI
docker compose exec mysql mysql -u root -p

# Reconstruir imágenes
docker compose build --no-cache

# Ver estado
docker compose ps
```

## Troubleshooting

### Puerto en uso

```bash
# Ver qué proceso usa el puerto
sudo netstat -tulpn | grep 8080

# Cambiar puerto en docker-compose.yml
ports:
  - "8082:80"
```

### MySQL no conecta

```bash
# Verificar que MySQL está corriendo
docker compose ps

# Revisar logs (MySQL tarda ~30s en inicializar)
docker compose logs mysql

# Esperar y reintentar
sleep 30
```

### Error de permisos

```bash
sudo chown -R $USER:$USER www/
```

### Docker no está corriendo

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

## Seguridad

- [ ] Cambiar credenciales por defecto antes de usar en producción
- [ ] No exponer puerto MySQL (3306) en entornos de producción
- [ ] Usar Secrets de Docker para contraseñas sensibles

## Recursos

- [Docker Docs](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [PHP Docker Images](https://hub.docker.com/_/php)
- [MySQL Docker Images](https://hub.docker.com/_/mysql)
