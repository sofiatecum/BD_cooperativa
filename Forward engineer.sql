-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema cooperativa_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema cooperativa_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `cooperativa_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `cooperativa_db` ;

-- -----------------------------------------------------
-- Table `cooperativa_db`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`usuarios` (
  `id_usuario` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(150) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo_electronico` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `tipo_usuario` ENUM('SOCIO', 'EMPLEADO', 'ADMIN') NOT NULL,
  `estado` ENUM('ACTIVO', 'INACTIVO') NULL DEFAULT 'ACTIVO',
  PRIMARY KEY (`id_usuario`),
  UNIQUE INDEX `correo_electronico` (`correo_electronico` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`auditoria`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`auditoria` (
  `id_auditoria` INT NOT NULL AUTO_INCREMENT,
  `usuario_responsable` INT NULL DEFAULT NULL,
  `tabla_afectada` VARCHAR(50) NULL DEFAULT NULL,
  `operacion` ENUM('INSERT', 'UPDATE', 'DELETE') NULL DEFAULT NULL,
  `id_registro_afectado` INT NULL DEFAULT NULL,
  `fecha_operacion` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `detalles` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id_auditoria`),
  INDEX `usuario_responsable` (`usuario_responsable` ASC) VISIBLE,
  CONSTRAINT `auditoria_ibfk_1`
    FOREIGN KEY (`usuario_responsable`)
    REFERENCES `cooperativa_db`.`usuarios` (`id_usuario`)
    ON DELETE SET NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`informacion_solicitante_credito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`informacion_solicitante_credito` (
  `id_solicitante` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `direccion` VARCHAR(255) NOT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo_electronico` VARCHAR(100) NULL DEFAULT NULL,
  `estado_civil` VARCHAR(20) NULL DEFAULT NULL,
  `ocupacion` VARCHAR(100) NULL DEFAULT NULL,
  `ingresos_promedio` DECIMAL(10,2) NULL DEFAULT NULL,
  `historial_crediticio` TEXT NULL DEFAULT NULL,
  `bienes_inmuebles` TEXT NULL DEFAULT NULL,
  `referencias_personales` TEXT NULL DEFAULT NULL,
  `otros_datos` TEXT NULL DEFAULT NULL,
  `usuarios_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_solicitante`),
  INDEX `fk_informacion_solicitante_credito_usuarios1_idx` (`usuarios_id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_informacion_solicitante_credito_usuarios1`
    FOREIGN KEY (`usuarios_id_usuario`)
    REFERENCES `cooperativa_db`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`bienes_inmuebles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`bienes_inmuebles` (
  `id_bien` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `tipo` VARCHAR(50) NOT NULL,
  `valor` DECIMAL(12,2) NOT NULL,
  `ubicacion` VARCHAR(200) NOT NULL,
  `hipoteca` TINYINT(1) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_bien`),
  INDEX `fk_bienes_inmuebles_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_bienes_inmuebles_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`bitacora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`bitacora` (
  `id_bitacora` INT NOT NULL AUTO_INCREMENT,
  `accion` VARCHAR(255) NOT NULL,
  `tabla_afectada` VARCHAR(50) NOT NULL,
  `tipo_accion` ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
  `fecha` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `detalles` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`id_bitacora`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`cuentas_aportes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`cuentas_aportes` (
  `id_cuenta_aporte` INT NOT NULL AUTO_INCREMENT,
  `monto_aportacion` DECIMAL(12,2) NULL DEFAULT NULL,
  `saldo` DECIMAL(12,2) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `socios_id_socio` INT NOT NULL,
  PRIMARY KEY (`id_cuenta_aporte`),
  INDEX `fk_cuentas_aportes_socios1_idx` (`socios_id_socio` ASC) VISIBLE,
  CONSTRAINT `fk_cuentas_aportes_socios1`
    FOREIGN KEY (`socios_id_socio`)
    REFERENCES `cooperativa_db`.`socios` (`id_socio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`socios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`socios` (
  `id_socio` INT NOT NULL AUTO_INCREMENT,
  `primer_nombre` VARCHAR(200) NOT NULL,
  `segundo_nombre` VARCHAR(200) NULL DEFAULT NULL,
  `otros_nombres` VARCHAR(200) NULL DEFAULT NULL,
  `primer_apellido` VARCHAR(250) NOT NULL,
  `segundo_apellido` VARCHAR(250) NULL DEFAULT NULL,
  `otros_apellidos` VARCHAR(250) NULL DEFAULT NULL,
  `departamento` VARCHAR(300) NOT NULL,
  `municipio` VARCHAR(300) NOT NULL,
  `zona` VARCHAR(300) NOT NULL,
  `grupo_habitacional` VARCHAR(300) NOT NULL,
  `vialidad` VARCHAR(300) NOT NULL,
  `numero_casa` VARCHAR(300) NOT NULL,
  `prefijo` VARCHAR(10) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo_electronico` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `estado` ENUM('ACTIVO', 'INACTIVO') NULL DEFAULT 'ACTIVO',
  `cuentas_aportes_id_cuenta_aporte` INT NOT NULL,
  PRIMARY KEY (`id_socio`),
  UNIQUE INDEX `correo_electronico` (`correo_electronico` ASC) VISIBLE,
  INDEX `fk_socios_cuentas_aportes1_idx` (`cuentas_aportes_id_cuenta_aporte` ASC) VISIBLE,
  CONSTRAINT `fk_socios_cuentas_aportes1`
    FOREIGN KEY (`cuentas_aportes_id_cuenta_aporte`)
    REFERENCES `cooperativa_db`.`cuentas_aportes` (`id_cuenta_aporte`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`cuentas_ahorro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`cuentas_ahorro` (
  `id_cuenta_ahorro` INT NOT NULL AUTO_INCREMENT,
  `saldo` DECIMAL(2,0) NULL DEFAULT '0',
  `tasa_interes` DECIMAL(2,0) NULL DEFAULT NULL,
  `fecha_apertura` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `socios_id_socio` INT NOT NULL,
  PRIMARY KEY (`id_cuenta_ahorro`),
  INDEX `fk_cuentas_ahorro_socios1_idx` (`socios_id_socio` ASC) VISIBLE,
  CONSTRAINT `fk_cuentas_ahorro_socios1`
    FOREIGN KEY (`socios_id_socio`)
    REFERENCES `cooperativa_db`.`socios` (`id_socio`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`porcentajes_intereses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`porcentajes_intereses` (
  `id_interes` INT NOT NULL AUTO_INCREMENT,
  `tipo_cuenta` VARCHAR(50) NOT NULL,
  `porcentaje` DECIMAL(5,2) NOT NULL,
  `fecha_vigencia` DATE NOT NULL,
  `cuentas_ahorro_id_cuenta_ahorro` INT NOT NULL,
  PRIMARY KEY (`id_interes`),
  INDEX `fk_porcentajes_intereses_cuentas_ahorro1_idx` (`cuentas_ahorro_id_cuenta_ahorro` ASC) VISIBLE,
  CONSTRAINT `fk_porcentajes_intereses_cuentas_ahorro1`
    FOREIGN KEY (`cuentas_ahorro_id_cuenta_ahorro`)
    REFERENCES `cooperativa_db`.`cuentas_ahorro` (`id_cuenta_ahorro`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`prestamos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`prestamos` (
  `id_prestamo` INT NOT NULL AUTO_INCREMENT,
  `monto_solicitado` DECIMAL(15,2) NULL DEFAULT NULL,
  `monto_aprobado` DECIMAL(15,2) NULL DEFAULT NULL,
  `intereses` DECIMAL(5,2) NULL DEFAULT NULL,
  `fecha_solicitud` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_aprobacion` TIMESTAMP NULL DEFAULT NULL,
  `fecha_pago` TIMESTAMP NULL DEFAULT NULL,
  `saldo_pendiente` DECIMAL(15,2) NULL DEFAULT NULL,
  `estado` ENUM('PENDIENTE', 'APROBADO', 'PAGADO', 'CANCELADO') NULL DEFAULT 'PENDIENTE',
  `porcentajes_intereses_id_interes` INT NOT NULL,
  PRIMARY KEY (`id_prestamo`),
  INDEX `fk_prestamos_porcentajes_intereses1_idx` (`porcentajes_intereses_id_interes` ASC) VISIBLE,
  CONSTRAINT `fk_prestamos_porcentajes_intereses1`
    FOREIGN KEY (`porcentajes_intereses_id_interes`)
    REFERENCES `cooperativa_db`.`porcentajes_intereses` (`id_interes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`catalogoconceptos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`catalogoconceptos` (
  `IDConcepto` INT NOT NULL AUTO_INCREMENT,
  `Descripcion` VARCHAR(50) NOT NULL,
  `TipoConcepto` VARCHAR(20) NOT NULL,
  `prestamos_id_prestamo` INT NOT NULL,
  PRIMARY KEY (`IDConcepto`),
  INDEX `fk_catalogoconceptos_prestamos1_idx` (`prestamos_id_prestamo` ASC) VISIBLE,
  CONSTRAINT `fk_catalogoconceptos_prestamos1`
    FOREIGN KEY (`prestamos_id_prestamo`)
    REFERENCES `cooperativa_db`.`prestamos` (`id_prestamo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 31
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`manejo_chequera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`manejo_chequera` (
  `id_chequera` INT NOT NULL AUTO_INCREMENT,
  `numero_chequera` VARCHAR(20) NOT NULL,
  `estado` VARCHAR(20) NOT NULL,
  `fecha_emision` DATE NOT NULL,
  `monto` DECIMAL(10,2) NULL DEFAULT NULL,
  PRIMARY KEY (`id_chequera`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`chequera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`chequera` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATE NOT NULL,
  `numero_cheque` VARCHAR(20) NOT NULL,
  `descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `debito` DECIMAL(10,2) NULL DEFAULT '0.00',
  `saldo` DECIMAL(10,2) NOT NULL,
  `manejo_chequera_id_chequera` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_chequera_manejo_chequera1_idx` (`manejo_chequera_id_chequera` ASC) VISIBLE,
  CONSTRAINT `fk_chequera_manejo_chequera1`
    FOREIGN KEY (`manejo_chequera_id_chequera`)
    REFERENCES `cooperativa_db`.`manejo_chequera` (`id_chequera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`clientes` (
  `id_clientes` INT NOT NULL AUTO_INCREMENT,
  `primer_nombre` VARCHAR(200) NOT NULL,
  `segundo_nombre` VARCHAR(200) NULL DEFAULT NULL,
  `otros_nombres` VARCHAR(200) NULL DEFAULT NULL,
  `primer_apellido` VARCHAR(250) NOT NULL,
  `segundo_apellido` VARCHAR(250) NULL DEFAULT NULL,
  `otros_apellidos` VARCHAR(250) NULL DEFAULT NULL,
  `departamento` VARCHAR(300) NOT NULL,
  `municipio` VARCHAR(300) NOT NULL,
  `zona` VARCHAR(300) NOT NULL,
  `grupo_habitacional` VARCHAR(300) NOT NULL,
  `vialidad` VARCHAR(300) NOT NULL,
  `numero_casa` VARCHAR(300) NOT NULL,
  `prefijo` VARCHAR(10) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo_electronico` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `estado` ENUM('ACTIVO', 'INACTIVO') NULL DEFAULT 'ACTIVO',
  `manejo_chequera_id_chequera` INT NOT NULL,
  PRIMARY KEY (`id_clientes`),
  UNIQUE INDEX `correo_electronico` (`correo_electronico` ASC) VISIBLE,
  INDEX `fk_clientes_manejo_chequera1_idx` (`manejo_chequera_id_chequera` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_manejo_chequera1`
    FOREIGN KEY (`manejo_chequera_id_chequera`)
    REFERENCES `cooperativa_db`.`manejo_chequera` (`id_chequera`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`clientes_individuales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`clientes_individuales` (
  `id_cliente_individual` INT NOT NULL AUTO_INCREMENT,
  `primer_nombre` VARCHAR(200) NOT NULL,
  `segundo_nombre` VARCHAR(200) NULL DEFAULT NULL,
  `otros_nombres` VARCHAR(200) NULL DEFAULT NULL,
  `primer_apellido` VARCHAR(250) NOT NULL,
  `segundo_apellido` VARCHAR(250) NULL DEFAULT NULL,
  `otros_apellidos` VARCHAR(250) NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `estado` ENUM('ACTIVO', 'INACTIVO') NULL DEFAULT 'ACTIVO',
  `clientes_id_clientes` INT NOT NULL,
  PRIMARY KEY (`id_cliente_individual`, `clientes_id_clientes`),
  INDEX `fk_clientes_individuales_clientes1_idx` (`clientes_id_clientes` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_individuales_clientes1`
    FOREIGN KEY (`clientes_id_clientes`)
    REFERENCES `cooperativa_db`.`clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`clientesjuridicos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`clientesjuridicos` (
  `id_ClienteJuridico` INT NOT NULL AUTO_INCREMENT,
  `nombre_comercial` VARCHAR(255) NOT NULL,
  `razon_social` VARCHAR(255) NULL DEFAULT NULL,
  `NIT` VARCHAR(13) NOT NULL,
  `direccion_fiscal` VARCHAR(255) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `mail` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_constitucion` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `representante_legal` VARCHAR(255) NULL DEFAULT NULL,
  `clientes_id_clientes` INT NOT NULL,
  PRIMARY KEY (`id_ClienteJuridico`, `clientes_id_clientes`),
  INDEX `fk_clientesjuridicos_clientes1_idx` (`clientes_id_clientes` ASC) VISIBLE,
  CONSTRAINT `fk_clientesjuridicos_clientes1`
    FOREIGN KEY (`clientes_id_clientes`)
    REFERENCES `cooperativa_db`.`clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`cuentas_monetarias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`cuentas_monetarias` (
  `id_cuenta_monetaria` INT NOT NULL AUTO_INCREMENT,
  `saldo` DECIMAL(12,2) NULL DEFAULT '0.00',
  `tarjeta_debito` VARCHAR(20) NULL DEFAULT NULL,
  `chequera` VARCHAR(20) NULL DEFAULT NULL,
  `fecha_creacion` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cuenta_monetaria`),
  UNIQUE INDEX `tarjeta_debito` (`tarjeta_debito` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`cuotas_prestamos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`cuotas_prestamos` (
  `id_pago_cuota` INT NOT NULL AUTO_INCREMENT,
  `id_prestamo` INT NULL DEFAULT NULL,
  `monto_pago` DECIMAL(12,2) NULL DEFAULT NULL,
  `fecha_pago` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `estado` ENUM('PENDIENTE', 'PAGADO') NULL DEFAULT 'PENDIENTE',
  PRIMARY KEY (`id_pago_cuota`),
  INDEX `id_prestamo` (`id_prestamo` ASC) VISIBLE,
  CONSTRAINT `cuotas_prestamos_ibfk_1`
    FOREIGN KEY (`id_prestamo`)
    REFERENCES `cooperativa_db`.`prestamos` (`id_prestamo`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`documentosclientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`documentosclientes` (
  `IDDocumento` INT NOT NULL AUTO_INCREMENT,
  `URLDocumento` VARCHAR(255) NOT NULL,
  `TipoDocumento` VARCHAR(50) NOT NULL,
  `FechaSubida` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `clientes_id_clientes` INT NOT NULL,
  PRIMARY KEY (`IDDocumento`),
  INDEX `fk_documentosclientes_clientes1_idx` (`clientes_id_clientes` ASC) VISIBLE,
  CONSTRAINT `fk_documentosclientes_clientes1`
    FOREIGN KEY (`clientes_id_clientes`)
    REFERENCES `cooperativa_db`.`clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`empleados` (
  `id_empleados` INT NOT NULL AUTO_INCREMENT,
  `primer_nombre` VARCHAR(200) NOT NULL,
  `segundo_nombre` VARCHAR(200) NULL DEFAULT NULL,
  `otros_nombres` VARCHAR(200) NULL DEFAULT NULL,
  `primer_apellido` VARCHAR(250) NOT NULL,
  `segundo_apellido` VARCHAR(250) NULL DEFAULT NULL,
  `otros_apellidos` VARCHAR(250) NULL DEFAULT NULL,
  `departamento` VARCHAR(300) NOT NULL,
  `municipio` VARCHAR(300) NOT NULL,
  `zona` VARCHAR(300) NOT NULL,
  `grupo_habitacional` VARCHAR(300) NOT NULL,
  `vialidad` VARCHAR(300) NOT NULL,
  `numero_casa` VARCHAR(300) NOT NULL,
  `prefijo` VARCHAR(10) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `correo_electronico` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `estado` ENUM('ACTIVO', 'INACTIVO') NULL DEFAULT 'ACTIVO',
  `puesto` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`id_empleados`),
  UNIQUE INDEX `correo_electronico` (`correo_electronico` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`empleo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`empleo` (
  `id_empleo` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `empresa` VARCHAR(100) NOT NULL,
  `puesto` VARCHAR(50) NOT NULL,
  `antiguedad` INT NOT NULL,
  `salario` DECIMAL(10,2) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_empleo`),
  INDEX `fk_empleo_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_empleo_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`historial_crediticio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`historial_crediticio` (
  `id_historial` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `tipo_credito` VARCHAR(50) NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `estatus` VARCHAR(20) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_historial`),
  INDEX `fk_historial_crediticio_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_historial_crediticio_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`historial_movimientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`historial_movimientos` (
  `id_movimiento` INT NOT NULL AUTO_INCREMENT,
  `id_cuenta_ahorro` INT NULL DEFAULT NULL,
  `id_cuenta_monetaria` INT NULL DEFAULT NULL,
  `id_prestamo` INT NULL DEFAULT NULL,
  `tipo_movimiento` ENUM('DEPOSITO', 'RETIRO', 'TRANSFERENCIA', 'PAGO_PRÉSTAMO', 'PAGO_INTERESES', 'CUOTA_PRÉSTAMO') NOT NULL,
  `monto` DECIMAL(12,2) NULL DEFAULT NULL,
  `fecha` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarios_id_usuario` INT NOT NULL,
  `bitacora_id_bitacora` INT NOT NULL,
  PRIMARY KEY (`id_movimiento`),
  INDEX `id_cuenta_ahorro` (`id_cuenta_ahorro` ASC) VISIBLE,
  INDEX `id_cuenta_monetaria` (`id_cuenta_monetaria` ASC) VISIBLE,
  INDEX `id_prestamo` (`id_prestamo` ASC) VISIBLE,
  INDEX `fk_historial_movimientos_usuarios1_idx` (`usuarios_id_usuario` ASC) VISIBLE,
  INDEX `fk_historial_movimientos_bitacora1_idx` (`bitacora_id_bitacora` ASC) VISIBLE,
  CONSTRAINT `historial_movimientos_ibfk_2`
    FOREIGN KEY (`id_cuenta_ahorro`)
    REFERENCES `cooperativa_db`.`cuentas_ahorro` (`id_cuenta_ahorro`)
    ON DELETE SET NULL,
  CONSTRAINT `historial_movimientos_ibfk_3`
    FOREIGN KEY (`id_cuenta_monetaria`)
    REFERENCES `cooperativa_db`.`cuentas_monetarias` (`id_cuenta_monetaria`)
    ON DELETE SET NULL,
  CONSTRAINT `historial_movimientos_ibfk_4`
    FOREIGN KEY (`id_prestamo`)
    REFERENCES `cooperativa_db`.`prestamos` (`id_prestamo`)
    ON DELETE SET NULL,
  CONSTRAINT `fk_historial_movimientos_usuarios1`
    FOREIGN KEY (`usuarios_id_usuario`)
    REFERENCES `cooperativa_db`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_historial_movimientos_bitacora1`
    FOREIGN KEY (`bitacora_id_bitacora`)
    REFERENCES `cooperativa_db`.`bitacora` (`id_bitacora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`imagenescheques`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`imagenescheques` (
  `Id_cheque` INT NOT NULL AUTO_INCREMENT,
  `url_cheque` VARCHAR(255) NOT NULL,
  `num_cheque` VARCHAR(50) NOT NULL,
  `FechaSubida` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `chequera_id` INT NOT NULL,
  PRIMARY KEY (`Id_cheque`),
  INDEX `fk_imagenescheques_chequera1_idx` (`chequera_id` ASC) VISIBLE,
  CONSTRAINT `fk_imagenescheques_chequera1`
    FOREIGN KEY (`chequera_id`)
    REFERENCES `cooperativa_db`.`chequera` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`ingresos_familiares`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`ingresos_familiares` (
  `id_ingreso` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `tipo_ingreso` VARCHAR(50) NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_ingreso`),
  INDEX `fk_ingresos_familiares_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_ingresos_familiares_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`manejo_tarjeta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`manejo_tarjeta` (
  `id_tarjeta` INT NOT NULL AUTO_INCREMENT,
  `numero_tarjeta` VARCHAR(20) NOT NULL,
  `tipo_tarjeta` VARCHAR(20) NOT NULL,
  `fecha_emision` DATE NOT NULL,
  `fecha_vencimiento` DATE NOT NULL,
  `estado` VARCHAR(20) NOT NULL,
  `monto` DECIMAL(10,2) NULL DEFAULT NULL,
  `clientes_id_clientes` INT NOT NULL,
  PRIMARY KEY (`id_tarjeta`),
  INDEX `fk_manejo_tarjeta_clientes1_idx` (`clientes_id_clientes` ASC) VISIBLE,
  CONSTRAINT `fk_manejo_tarjeta_clientes1`
    FOREIGN KEY (`clientes_id_clientes`)
    REFERENCES `cooperativa_db`.`clientes` (`id_clientes`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`operaciones_bancarias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`operaciones_bancarias` (
  `id_operacion` INT NOT NULL AUTO_INCREMENT,
  `id_cuenta_ahorro` INT NULL DEFAULT NULL,
  `id_cuenta_monetaria` INT NULL DEFAULT NULL,
  `tipo_operacion` ENUM('DEPOSITO', 'RETIRO', 'TRANSFERENCIA', 'PAGO_PRÉSTAMO') NOT NULL,
  `monto` DECIMAL(12,2) NULL DEFAULT NULL,
  `fecha` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `usuarios_id_usuario` INT NOT NULL,
  `bitacora_id_bitacora` INT NOT NULL,
  PRIMARY KEY (`id_operacion`),
  INDEX `id_cuenta_ahorro` (`id_cuenta_ahorro` ASC) VISIBLE,
  INDEX `id_cuenta_monetaria` (`id_cuenta_monetaria` ASC) VISIBLE,
  INDEX `fk_operaciones_bancarias_usuarios1_idx` (`usuarios_id_usuario` ASC) VISIBLE,
  INDEX `fk_operaciones_bancarias_bitacora1_idx` (`bitacora_id_bitacora` ASC) VISIBLE,
  CONSTRAINT `operaciones_bancarias_ibfk_1`
    FOREIGN KEY (`id_cuenta_ahorro`)
    REFERENCES `cooperativa_db`.`cuentas_ahorro` (`id_cuenta_ahorro`)
    ON DELETE SET NULL,
  CONSTRAINT `operaciones_bancarias_ibfk_2`
    FOREIGN KEY (`id_cuenta_monetaria`)
    REFERENCES `cooperativa_db`.`cuentas_monetarias` (`id_cuenta_monetaria`)
    ON DELETE SET NULL,
  CONSTRAINT `fk_operaciones_bancarias_usuarios1`
    FOREIGN KEY (`usuarios_id_usuario`)
    REFERENCES `cooperativa_db`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_operaciones_bancarias_bitacora1`
    FOREIGN KEY (`bitacora_id_bitacora`)
    REFERENCES `cooperativa_db`.`bitacora` (`id_bitacora`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`otros_ingresos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`otros_ingresos` (
  `id_otro_ingreso` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `fuente` VARCHAR(100) NOT NULL,
  `monto` DECIMAL(10,2) NOT NULL,
  `frecuencia` VARCHAR(50) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_otro_ingreso`),
  INDEX `fk_otros_ingresos_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_otros_ingresos_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`pagos_intereses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`pagos_intereses` (
  `id_pago_interes` INT NOT NULL AUTO_INCREMENT,
  `id_cuenta_ahorro` INT NULL DEFAULT NULL,
  `monto_interes` DECIMAL(12,2) NULL DEFAULT NULL,
  `fecha_pago` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_pago_interes`),
  INDEX `id_cuenta_ahorro` (`id_cuenta_ahorro` ASC) VISIBLE,
  CONSTRAINT `pagos_intereses_ibfk_1`
    FOREIGN KEY (`id_cuenta_ahorro`)
    REFERENCES `cooperativa_db`.`cuentas_ahorro` (`id_cuenta_ahorro`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`referencias_personales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`referencias_personales` (
  `id_referencia` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `nombre` VARCHAR(100) NOT NULL,
  `telefono` VARCHAR(15) NOT NULL,
  `parentesco` VARCHAR(50) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_referencia`),
  INDEX `fk_referencias_personales_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_referencias_personales_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`solicitud_apertura_cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`solicitud_apertura_cuenta` (
  `id_solicitud` INT NOT NULL AUTO_INCREMENT,
  `tipo_cuenta` VARCHAR(50) NOT NULL,
  `fecha_solicitud` DATE NOT NULL,
  `estado_solicitud` VARCHAR(20) NOT NULL,
  `usuarios_id_usuario` INT NOT NULL,
  PRIMARY KEY (`id_solicitud`),
  INDEX `fk_solicitud_apertura_cuenta_usuarios1_idx` (`usuarios_id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_solicitud_apertura_cuenta_usuarios1`
    FOREIGN KEY (`usuarios_id_usuario`)
    REFERENCES `cooperativa_db`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `cooperativa_db`.`vehiculos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `cooperativa_db`.`vehiculos` (
  `id_vehiculo` INT NOT NULL AUTO_INCREMENT,
  `id_cliente` INT NULL DEFAULT NULL,
  `marca` VARCHAR(50) NOT NULL,
  `modelo` VARCHAR(50) NOT NULL,
  `año` INT NOT NULL,
  `valor` DECIMAL(10,2) NOT NULL,
  `financiado` TINYINT(1) NOT NULL,
  `informacion_solicitante_credito_id_solicitante` INT NOT NULL,
  PRIMARY KEY (`id_vehiculo`),
  INDEX `fk_vehiculos_informacion_solicitante_credito1_idx` (`informacion_solicitante_credito_id_solicitante` ASC) VISIBLE,
  CONSTRAINT `fk_vehiculos_informacion_solicitante_credito1`
    FOREIGN KEY (`informacion_solicitante_credito_id_solicitante`)
    REFERENCES `cooperativa_db`.`informacion_solicitante_credito` (`id_solicitante`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
