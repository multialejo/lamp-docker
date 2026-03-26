## Configuracion del entorno

1. El primer paso es correr los contendores usando

```bash
docker compose up -d --build
```

- La opcion `build` se utiliza solo la primera vez
- Esperar unos segundos hasta que la base de datos de inicialize correctamente.

1. Se corre el script de SQL para la creacion de las respectivas tablas.

2. Se popula la base de datos con los archivos CSV proporcionados.

- Cada tabla de la base de datos se corresponde con un archivo CSV.
- Por la condicion de CASCADA, algunas tablas deben ser populadas antes que otras.
- Se recomienda avanzar de forma secuencial, de modo que si alguna tabla depende de otra, entonces se le da prioridad a esta ultima en la cola.
- No olvidar indicar que el header debe ser ignorado.

## Import CSV files to MYSQL using the CLI

This method copies the CSV file from your host machine to a specific location within the running MySQL container.
Copy the file: On your host machine, use the following command:

```bash
docker cp /path/to/your/csv [container_name]:/var/lib/mysql-files/
```

Access the container:

```bash
docker exec -it [container_name] bash
mysql --local-infile=1 -u root -p
```

```sql
USE lamp_db
```

Execute the LOAD DATA INFILE command: Inside the container's MySQL client, run the following SQL command, referencing the path inside the container:

```sql

LOAD DATA INFILE '/var/lib/mysql-files/csv/clientes.csv'
INTO TABLE clientes
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

```

### Notas

- El directorio `lamp/mysql` es unico para cada proyecto.

LOAD DATA INFILE '/var/lib/mysql-files/csv/provincias.csv'
INTO TABLE provincias
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

