-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: lamp_db
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `articulos`
--

DROP TABLE IF EXISTS `articulos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articulos` (
  `codart` varchar(8) NOT NULL,
  `descrip` varchar(100) NOT NULL,
  `precio` decimal(10,2) NOT NULL DEFAULT '0.00',
  `stock` int DEFAULT '0',
  `stock_min` int DEFAULT '0',
  PRIMARY KEY (`codart`),
  CONSTRAINT `ch_precio_articulos` CHECK ((`precio` >= 0.0)),
  CONSTRAINT `ch_stock_articulos` CHECK ((coalesce(`stock`,0) >= 0)),
  CONSTRAINT `ch_stockmin_articulos` CHECK ((coalesce(`stock_min`,0) >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `articulos`
--

LOCK TABLES `articulos` WRITE;
/*!40000 ALTER TABLE `articulos` DISABLE KEYS */;
INSERT INTO `articulos` VALUES ('11111110','Tallarín',1.00,50,3),('11111111','Aceite',2.00,15,5),('22222220','Manteca',3.00,30,4),('22222222','Jabón',0.50,10,2),('33333330','Jabón tocador',1.00,100,5),('33333333','Pasta colgate',1.00,15,5),('44444440','Rinse',5.00,20,1),('44444444','Champú',3.00,20,5),('55555550','Mermelada',1.00,10,2),('55555555','Azúcar',40.00,100,10),('66666660','Detergente',5.00,20,6),('66666666','Arroz',50.00,200,20),('77777770','Cloro',2.00,28,8),('77777777','Atún',60.00,150,2),('88888880','Papel higiénico',5.00,40,9),('88888888','Fideos',3.00,30,10),('99999990','Lavavajilla',0.00,34,2),('99999999','Chocolate',5.00,23,2);
/*!40000 ALTER TABLE `articulos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codcli` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `direccion` varchar(100) NOT NULL,
  `codpostal` varchar(5) DEFAULT NULL,
  `codpue` varchar(5) NOT NULL,
  PRIMARY KEY (`codcli`),
  KEY `codpue` (`codpue`),
  CONSTRAINT `clientes_ibfk_1` FOREIGN KEY (`codpue`) REFERENCES `pueblos` (`codpue`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES ('11110','Carlos Villavicencio','Av. Del Séneca','28609','28609'),('11111','María Pinto','Av. Del Séneca','03014','03014'),('22220','Juan Perez','C. del Tutor','03014','03014'),('22222','Luis Salazar ','Calle de Francisco Lozano','03050','03050'),('33330','Rosa Vasquez','C. de Quintana','03050','03050'),('33333','Juanita Robles','C. de Ferraz','28430','28430'),('44440','Ana Pinto','C. del Rey Francisco','28430','28430'),('44444','Klever Palma','C. de Altamirano','28320','28320'),('55550','Juan Travez','C. de Juan Alvarez','28320','28320'),('55555','Lucy Reyes','C. de Benito Gutierrez','28609','28609'),('66666','Anibal Guerrero','C. del Tutor','03014','03014'),('77777','Pedro Torres','C. de Quintana','03050','03050'),('88888','Mila Zambrano','C. del Rey Francisco','28430','28430'),('99999','Julio Rodríguez','C. de Juan Alvarez','28320','28320');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `facturas`
--

DROP TABLE IF EXISTS `facturas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `facturas` (
  `codfac` varchar(6) NOT NULL,
  `fecha` date NOT NULL,
  `codcli` varchar(5) NOT NULL,
  `codven` varchar(5) NOT NULL,
  `iva` decimal(5,2) NOT NULL DEFAULT '0.00',
  `dto` decimal(5,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`codfac`),
  KEY `codcli` (`codcli`),
  KEY `codven` (`codven`),
  CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`codcli`) REFERENCES `clientes` (`codcli`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`codven`) REFERENCES `vendedores` (`codven`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `facturas`
--

LOCK TABLES `facturas` WRITE;
/*!40000 ALTER TABLE `facturas` DISABLE KEYS */;
INSERT INTO `facturas` VALUES ('111110','2020-01-03','33330','99998',10.00,2.00),('111111','2023-01-12','44444','99992',10.00,5.00),('111112','2023-02-15','77777','99993',12.00,2.00),('111113','2023-03-18','88888','99994',0.00,2.00),('111114','2020-01-25','66666','99992',0.00,4.00),('111115','2023-06-05','44444','99992',10.00,5.00),('111116','2019-03-02','44444','99992',10.00,0.00),('111117','2021-04-29','44440','99999',14.00,3.00),('111119','2022-05-30','55550','99990',16.00,5.00),('222222','2021-06-10','44444','99992',10.00,2.00),('222223','2022-07-15','77777','99993',0.00,0.00);
/*!40000 ALTER TABLE `facturas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lineas_fac`
--

DROP TABLE IF EXISTS `lineas_fac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lineas_fac` (
  `codfac` varchar(6) NOT NULL,
  `codlinea` char(2) NOT NULL,
  `codart` varchar(8) NOT NULL,
  `cant` int NOT NULL,
  `precio` decimal(10,2) NOT NULL,
  `dto` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`codfac`,`codlinea`),
  KEY `codart` (`codart`),
  CONSTRAINT `lineas_fac_ibfk_1` FOREIGN KEY (`codfac`) REFERENCES `facturas` (`codfac`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `lineas_fac_ibfk_2` FOREIGN KEY (`codart`) REFERENCES `articulos` (`codart`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ch_cant_positiva` CHECK ((`cant` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lineas_fac`
--

LOCK TABLES `lineas_fac` WRITE;
/*!40000 ALTER TABLE `lineas_fac` DISABLE KEYS */;
INSERT INTO `lineas_fac` VALUES ('111110','01','77777770',10,2.00,0.00),('111110','02','88888880',5,5.00,1.00),('111111','01','22222222',5,2.50,0.00),('111112','01','55555555',2,80.00,0.00),('111112','02','66666666',6,300.00,0.00),('111113','01','22222222',2,1.00,0.00),('111113','02','55555555',3,120.00,0.00),('111113','03','22222222',5,2.50,0.00),('111114','01','11111111',5,10.00,0.00),('111115','01','22222222',3,2.50,0.00),('111115','02','55555555',2,120.00,2.00),('111115','03','22222222',1,2.50,3.00),('111116','01','55555555',1,120.00,0.00),('111116','02','22222222',2,2.50,0.00),('111117','01','55555550',10,1.00,2.00),('111119','01','88888880',5,5.00,1.00),('111119','02','99999990',6,2.00,1.00),('222222','01','22222222',5,2.50,0.00),('222223','01','11111111',5,10.00,0.00);
/*!40000 ALTER TABLE `lineas_fac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `provincias`
--

DROP TABLE IF EXISTS `provincias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `provincias` (
  `codpro` char(2) NOT NULL,
  `nombre` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`codpro`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `provincias`
--

LOCK TABLES `provincias` WRITE;
/*!40000 ALTER TABLE `provincias` DISABLE KEYS */;
INSERT INTO `provincias` VALUES ('03','Alicante'),('04','Cataluña'),('05','Ávila'),('08','Barcelona'),('14','Córdoba'),('18','Granada'),('26','La Rioja'),('28','Madrid'),('30','Murcia'),('41','Sevilla');
/*!40000 ALTER TABLE `provincias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pueblos`
--

DROP TABLE IF EXISTS `pueblos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pueblos` (
  `codpue` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `codpro` char(2) NOT NULL,
  PRIMARY KEY (`codpue`),
  KEY `codpro` (`codpro`),
  CONSTRAINT `pueblos_ibfk_1` FOREIGN KEY (`codpro`) REFERENCES `provincias` (`codpro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pueblos`
--

LOCK TABLES `pueblos` WRITE;
/*!40000 ALTER TABLE `pueblos` DISABLE KEYS */;
INSERT INTO `pueblos` VALUES ('03014','Alicante','03'),('03050','Campello','03'),('28320','Pinto','28'),('28430','Alpedrete','28'),('28609','Sevilla la Nueva','28'),('41001','Aguadulce','41'),('41002','Alanis','41'),('41021','Camas','41');
/*!40000 ALTER TABLE `pueblos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vendedores`
--

DROP TABLE IF EXISTS `vendedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendedores` (
  `codven` varchar(5) NOT NULL,
  `nombre` varchar(100) NOT NULL DEFAULT '',
  `direccion` varchar(100) NOT NULL,
  `codpostal` varchar(5) DEFAULT NULL,
  `codpue` varchar(5) NOT NULL,
  `codjefe` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`codven`),
  KEY `codpue` (`codpue`),
  CONSTRAINT `vendedores_ibfk_1` FOREIGN KEY (`codpue`) REFERENCES `pueblos` (`codpue`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendedores`
--

LOCK TABLES `vendedores` WRITE;
/*!40000 ALTER TABLE `vendedores` DISABLE KEYS */;
INSERT INTO `vendedores` VALUES ('99990','Rosa Trujillo','Calle de Sta. María','28609','28609','99995'),('99991','Jaime Naranjo','C. de San Ricardo','03014','03014','99995'),('99992','Eugenia Lara','C. de Atocha','03050','03050','99995'),('99993','Oscar Peña','Calle de la Magdalena','28430','28430','99995'),('99994','Carlos Velasco','C de Moratín','28320','28320','99995'),('99995','Ana Perez','Calle de Sta. María','28609','28609','99995'),('99996','Veronica Torres','C. de San Ricardo','03014','03014','99995'),('99997','Pedro Torres','C. de Atocha','03050','03050','99995'),('99998','Kléver Ramírez','Calle de la Magdalena','28430','28430','99995'),('99999','Lucía Galán ','C de Moratín','28320','28320','99995');
/*!40000 ALTER TABLE `vendedores` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-18 23:18:48
