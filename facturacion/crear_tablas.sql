-- Tablas para el sistema de facturación

CREATE TABLE provincias (
    codpro CHAR(2) NOT NULL,
    nombre VARCHAR(50) NOT NULL DEFAULT '',
    CONSTRAINT pk_provincias PRIMARY KEY (codpro)
);

CREATE TABLE pueblos (
    codpue VARCHAR(5) NOT NULL,
    nombre VARCHAR(100) NOT NULL DEFAULT '',
    codpro CHAR(2) NOT NULL,
    CONSTRAINT pk_pueblos PRIMARY KEY (codpue),
    FOREIGN KEY (codpro) REFERENCES provincias(codpro)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE clientes (
    codcli VARCHAR(5) NOT NULL,
    nombre VARCHAR(100) NOT NULL DEFAULT '',
    direccion VARCHAR(100) NOT NULL,
    codpostal VARCHAR(5),
    codpue VARCHAR(5) NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (codcli),
    FOREIGN KEY (codpue) REFERENCES pueblos(codpue)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE vendedores (
    codven VARCHAR(5) NOT NULL,
    nombre VARCHAR(100) NOT NULL DEFAULT '',
    direccion VARCHAR(100) NOT NULL,
    codpostal VARCHAR(5),
    codpue VARCHAR(5) NOT NULL,
    codjefe VARCHAR(5) DEFAULT NULL,
    CONSTRAINT pk_vendedores PRIMARY KEY (codven),
    FOREIGN KEY (codpue) REFERENCES pueblos(codpue)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE articulos (
    codart VARCHAR(8) NOT NULL,
    descrip VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL DEFAULT 0.0,
    stock INT DEFAULT 0,
    stock_min INT DEFAULT 0,
    CONSTRAINT pk_articulos PRIMARY KEY (codart),
    CONSTRAINT ch_precio_articulos CHECK (precio >= 0.0),
    CONSTRAINT ch_stockmin_articulos CHECK (COALESCE(stock_min, 0) >= 0),
    CONSTRAINT ch_stock_articulos CHECK (COALESCE(stock, 0) >= 0)
);

CREATE TABLE facturas (
    codfac VARCHAR(6) NOT NULL,
    fecha DATE NOT NULL,
    codcli VARCHAR(5) NOT NULL,
    codven VARCHAR(5) NOT NULL,
    iva DECIMAL(5,2) NOT NULL DEFAULT 0,
    dto DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_facturas PRIMARY KEY (codfac),
    FOREIGN KEY (codcli) REFERENCES clientes(codcli)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    FOREIGN KEY (codven) REFERENCES vendedores(codven)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE lineas_fac (
    codfac VARCHAR(6) NOT NULL,
    codlinea CHAR(2) NOT NULL,
    codart VARCHAR(8) NOT NULL,
    cant INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    dto DECIMAL(10,2) NOT NULL DEFAULT 0.0,
    CONSTRAINT pk_lineas_facturas PRIMARY KEY (codfac, codlinea),
    CONSTRAINT ch_cant_positiva CHECK (cant > 0),
    FOREIGN KEY (codfac) REFERENCES facturas(codfac)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    FOREIGN KEY (codart) REFERENCES articulos(codart)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);
