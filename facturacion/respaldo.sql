-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Servidor: mysql:3306
-- Tiempo de generación: 26-03-2026 a las 14:58:13
-- Versión del servidor: 8.0.45
-- Versión de PHP: 8.3.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `lamp_db`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`lamp_user`@`%` PROCEDURE `ObtenerArticulosPorPrecio` (IN `precioMin` DECIMAL(10,2), IN `precioMax` DECIMAL(10,2))   BEGIN
    SELECT codart, descrip, precio, stock
    FROM articulos
    WHERE precio BETWEEN precioMin AND precioMax;
END$$

CREATE DEFINER=`lamp_user`@`%` PROCEDURE `ObtenerArticulosPorPrecio2` (IN `precioMin` DECIMAL(10,2), IN `precioMax` DECIMAL(10,2))   BEGIN
    SELECT codart, descrip, precio
    FROM articulos
    WHERE precio BETWEEN precioMin AND precioMax;
END$$

CREATE DEFINER=`lamp_user`@`%` PROCEDURE `ObtenerFacturasPorRangoFecha` (IN `fecha_inicio` DATE, IN `fecha_fin` DATE)   BEGIN
    SELECT * 
    FROM facturas
    WHERE fecha BETWEEN fecha_inicio AND fecha_fin
    ORDER BY fecha;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `articulos`
--

CREATE TABLE `articulos` (
  `codart` varchar(8) NOT NULL,
  `descrip` varchar(100) NOT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock` int DEFAULT '0',
  `stock_min` int DEFAULT '0'
) ;

--
-- Volcado de datos para la tabla `articulos`
--

INSERT INTO `articulos` (`codart`, `descrip`, `precio`, `stock`, `stock_min`) VALUES
('11111110', 'Tallarín', 1.00, 50, 3),
('11111111', 'Aceite', 2.00, 15, 5),
('22222220', 'Manteca', 3.00, 30, 4),
('22222222', 'Jabón', 0.50, 10, 2),
('33333330', 'Jabón tocador', 1.00, 100, 5),
('33333333', 'Pasta colgate', 1.00, 15, 5),
('44444440', 'Rinse', 5.00, 20, 1),
('44444444', 'Champú', 3.00, 20, 5),
('55555550', 'Mermelada', 1.00, 10, 2),
('55555555', 'Azúcar', 40.00, 100, 10),
('66666660', 'Detergente', 5.00, 20, 6),
('66666666', 'Arroz', 50.00, 200, 20),
('77777770', 'Cloro', 2.00, 28, 8),
('77777777', 'Atún', 60.00, 150, 2),
('88888880', 'Papel higiénico', 5.00, 40, 9),
('88888888', 'Fideos', 3.00, 30, 10),
('99999990', 'Lavavajilla', 0.00, 34, 2),
('99999999', 'Chocolate', 5.00, 23, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `codcli` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `direccion` varchar(100) NOT NULL,
  `codpostal` varchar(5) DEFAULT NULL,
  `codpue` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`codcli`, `nombre`, `direccion`, `codpostal`, `codpue`) VALUES
('11110', 'Carlos Villavicencio', 'Av. Del Séneca', '28609', '28609'),
('11111', 'María Pinto', 'Av. Del Séneca', '03014', '03014'),
('22220', 'Juan Perez', 'C. del Tutor', '03014', '03014'),
('22222', 'Luis Salazar ', 'Calle de Francisco Lozano', '03050', '03050'),
('33330', 'Rosa Vasquez', 'C. de Quintana', '03050', '03050'),
('33333', 'Juanita Robles', 'C. de Ferraz', '28430', '28430'),
('44440', 'Ana Pinto', 'C. del Rey Francisco', '28430', '28430'),
('44444', 'Klever Palma', 'C. de Altamirano', '28320', '28320'),
('55550', 'Juan Travez', 'C. de Juan Alvarez', '28320', '28320'),
('55555', 'Lucy Reyes', 'C. de Benito Gutierrez', '28609', '28609'),
('66666', 'Anibal Guerrero', 'C. del Tutor', '03014', '03014'),
('77777', 'Pedro Torres', 'C. de Quintana', '03050', '03050'),
('88888', 'Mila Zambrano', 'C. del Rey Francisco', '28430', '28430'),
('99999', 'Julio Rodríguez', 'C. de Juan Alvarez', '28320', '28320');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `codfac` varchar(6) NOT NULL,
  `fecha` date NOT NULL,
  `codcli` varchar(5) NOT NULL,
  `codven` varchar(5) NOT NULL,
  `iva` decimal(5,2) NOT NULL DEFAULT '0.00',
  `dto` decimal(5,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `facturas`
--

INSERT INTO `facturas` (`codfac`, `fecha`, `codcli`, `codven`, `iva`, `dto`) VALUES
('111110', '2020-01-03', '33330', '99998', 10.00, 2.00),
('111111', '2023-01-12', '44444', '99992', 10.00, 5.00),
('111112', '2023-02-15', '77777', '99993', 12.00, 2.00),
('111113', '2023-03-18', '88888', '99994', 0.00, 2.00),
('111114', '2020-01-25', '66666', '99992', 0.00, 4.00),
('111115', '2023-06-05', '44444', '99992', 10.00, 5.00),
('111116', '2019-03-02', '44444', '99992', 10.00, 0.00),
('111117', '2021-04-29', '44440', '99999', 14.00, 3.00),
('111119', '2022-05-30', '55550', '99990', 16.00, 5.00),
('222222', '2021-06-10', '44444', '99992', 10.00, 2.00),
('222223', '2022-07-15', '77777', '99993', 0.00, 0.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `lineas_fac`
--

CREATE TABLE `lineas_fac` (
  `codfac` varchar(6) NOT NULL,
  `codlinea` char(2) NOT NULL,
  `codart` varchar(8) NOT NULL,
  `cant` int NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `dto` decimal(10,2) NOT NULL DEFAULT '0.00'
) ;

--
-- Volcado de datos para la tabla `lineas_fac`
--

INSERT INTO `lineas_fac` (`codfac`, `codlinea`, `codart`, `cant`, `precio`, `dto`) VALUES
('111110', '01', '77777770', 10, 2.00, 0.00),
('111110', '02', '88888880', 5, 5.00, 1.00),
('111111', '01', '22222222', 5, 2.50, 0.00),
('111112', '01', '55555555', 2, 80.00, 0.00),
('111112', '02', '66666666', 6, 300.00, 0.00),
('111113', '01', '22222222', 2, 1.00, 0.00),
('111113', '02', '55555555', 3, 120.00, 0.00),
('111113', '03', '22222222', 5, 2.50, 0.00),
('111114', '01', '11111111', 5, 10.00, 0.00),
('111115', '01', '22222222', 3, 2.50, 0.00),
('111115', '02', '55555555', 2, 120.00, 2.00),
('111115', '03', '22222222', 1, 2.50, 3.00),
('111116', '01', '55555555', 1, 120.00, 0.00),
('111116', '02', '22222222', 2, 2.50, 0.00),
('111117', '01', '55555550', 10, 1.00, 2.00),
('111119', '01', '88888880', 5, 5.00, 1.00),
('111119', '02', '99999990', 6, 2.00, 1.00),
('222222', '01', '22222222', 5, 2.50, 0.00),
('222223', '01', '11111111', 5, 10.00, 0.00);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincias`
--

CREATE TABLE `provincias` (
  `codpro` char(2) NOT NULL,
  `nombre` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `provincias`
--

INSERT INTO `provincias` (`codpro`, `nombre`) VALUES
('03', 'Alicante'),
('04', 'Cataluña'),
('05', 'Ávila'),
('08', 'Barcelona'),
('14', 'Córdoba'),
('18', 'Granada'),
('26', 'La Rioja'),
('28', 'Madrid'),
('30', 'Murcia'),
('41', 'Sevilla');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pueblos`
--

CREATE TABLE `pueblos` (
  `codpue` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `codpro` char(2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `pueblos`
--

INSERT INTO `pueblos` (`codpue`, `nombre`, `codpro`) VALUES
('03014', 'Alicante', '03'),
('03050', 'Campello', '03'),
('28320', 'Pinto', '28'),
('28430', 'Alpedrete', '28'),
('28609', 'Sevilla la Nueva', '28'),
('41001', 'Aguadulce', '41'),
('41002', 'Alanis', '41'),
('41021', 'Camas', '41');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendedores`
--

CREATE TABLE `vendedores` (
  `codven` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `direccion` varchar(100) NOT NULL,
  `codpostal` varchar(5) DEFAULT NULL,
  `codpue` varchar(5) NOT NULL,
  `codjefe` varchar(5) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `vendedores`
--

INSERT INTO `vendedores` (`codven`, `nombre`, `direccion`, `codpostal`, `codpue`, `codjefe`) VALUES
('99990', 'Rosa Trujillo', 'Calle de Sta. María', '28609', '28609', '99995'),
('99991', 'Jaime Naranjo', 'C. de San Ricardo', '03014', '03014', '99995'),
('99992', 'Eugenia Lara', 'C. de Atocha', '03050', '03050', '99995'),
('99993', 'Oscar Peña', 'Calle de la Magdalena', '28430', '28430', '99995'),
('99994', 'Carlos Velasco', 'C de Moratín', '28320', '28320', '99995'),
('99995', 'Ana Perez', 'Calle de Sta. María', '28609', '28609', '99995'),
('99996', 'Veronica Torres', 'C. de San Ricardo', '03014', '03014', '99995'),
('99997', 'Pedro Torres', 'C. de Atocha', '03050', '03050', '99995'),
('99998', 'Kléver Ramírez', 'Calle de la Magdalena', '28430', '28430', '99995'),
('99999', 'Lucía Galán ', 'C de Moratín', '28320', '28320', '99995');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `articulos`
--
ALTER TABLE `articulos`
  ADD PRIMARY KEY (`codart`);

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`codcli`),
  ADD KEY `codpue` (`codpue`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`codfac`),
  ADD KEY `codcli` (`codcli`),
  ADD KEY `codven` (`codven`);

--
-- Indices de la tabla `lineas_fac`
--
ALTER TABLE `lineas_fac`
  ADD PRIMARY KEY (`codfac`,`codlinea`),
  ADD KEY `codart` (`codart`);

--
-- Indices de la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD PRIMARY KEY (`codpro`);

--
-- Indices de la tabla `pueblos`
--
ALTER TABLE `pueblos`
  ADD PRIMARY KEY (`codpue`),
  ADD KEY `codpro` (`codpro`);

--
-- Indices de la tabla `vendedores`
--
ALTER TABLE `vendedores`
  ADD PRIMARY KEY (`codven`),
  ADD KEY `codpue` (`codpue`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`codpue`) REFERENCES `pueblos` (`codpue`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`codcli`) REFERENCES `clientes` (`codcli`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`codven`) REFERENCES `vendedores` (`codven`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `lineas_fac`
--
ALTER TABLE `lineas_fac`
  ADD CONSTRAINT `lineas_fac_ibfk_1` FOREIGN KEY (`codfac`) REFERENCES `facturas` (`codfac`) ON DELETE RESTRICT ON UPDATE CASCADE,
  ADD CONSTRAINT `lineas_fac_ibfk_2` FOREIGN KEY (`codart`) REFERENCES `articulos` (`codart`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `pueblos`
--
ALTER TABLE `pueblos`
  ADD CONSTRAINT `pueblos_ibfk_1` FOREIGN KEY (`codpro`) REFERENCES `provincias` (`codpro`) ON DELETE RESTRICT ON UPDATE CASCADE;

--
-- Filtros para la tabla `vendedores`
--
ALTER TABLE `vendedores`
  ADD CONSTRAINT `vendedores_ibfk_1` FOREIGN KEY (`codpue`) REFERENCES `pueblos` (`codpue`) ON DELETE RESTRICT ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
