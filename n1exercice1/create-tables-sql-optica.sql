-- MySQL Script generated by MySQL Workbench
-- Mon Mar 20 12:34:45 2023
-- Model: Optica Model    Version: 1.0
-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema optica
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `optica` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci ;
USE `optica` ;

-- -----------------------------------------------------
-- Table `optica`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL DEFAULT NULL,
  `fecha_registro` DATETIME NOT NULL,
  `recomendado_por_cliente_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_cliente`),
  INDEX `fk_clientes_clientes_idx` (`recomendado_por_cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_clientes`
    FOREIGN KEY (`recomendado_por_cliente_id`)
    REFERENCES `optica`.`clientes` (`id_cliente`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`proveedores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`proveedores` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `nif` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `fax` VARCHAR(45) NULL DEFAULT NULL,
  `telefono` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`direcciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`direcciones` (
  `id_direccion` INT NOT NULL AUTO_INCREMENT,
  `calle` VARCHAR(60) NOT NULL,
  `numero` VARCHAR(6) NOT NULL,
  `piso` VARCHAR(6) NULL DEFAULT NULL,
  `puerta` VARCHAR(6) NULL DEFAULT NULL,
  `ciudad` VARCHAR(45) NOT NULL,
  `cp` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `id_proveedor` INT NULL,
  `id_cliente` INT NULL,
  PRIMARY KEY (`id_direccion`),
  INDEX `fk_direcciones_proveedores1_idx` (`id_proveedor` ASC) VISIBLE,
  INDEX `fk_direcciones_clientes1_idx` (`id_cliente` ASC) VISIBLE,
  CONSTRAINT `fk_direcciones_proveedores1`
    FOREIGN KEY (`id_proveedor`)
    REFERENCES `optica`.`proveedores` (`id_proveedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_direcciones_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `optica`.`clientes` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`empleados` (
  `id_empleado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_empleado`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`marcas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`marcas` (
  `id_marca` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `proveedor_id` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_marca`),
  INDEX `fk_marcas_proveedores_idx` (`proveedor_id` ASC) VISIBLE,
  CONSTRAINT `fk_marcas_proveedores`
    FOREIGN KEY (`proveedor_id`)
    REFERENCES `optica`.`proveedores` (`id_proveedor`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`gafas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`gafas` (
  `id_gafas` INT NOT NULL AUTO_INCREMENT,
  `modelo` VARCHAR(45) NOT NULL,
  `montura` ENUM('flotante', 'pasta', 'metalica') NOT NULL,
  `color_montura` VARCHAR(45) NOT NULL,
  `color_cristales` VARCHAR(45) NOT NULL,
  `precio` DOUBLE NOT NULL,
  `graduacion_izq` VARCHAR(45) NOT NULL,
  `graduacion_der` VARCHAR(45) NOT NULL,
  `marca_id` INT NOT NULL,
  PRIMARY KEY (`id_gafas`),
  INDEX `fk_gafas_marcas_idx` (`marca_id` ASC) VISIBLE,
  CONSTRAINT `fk_gafas_marcas`
    FOREIGN KEY (`marca_id`)
    REFERENCES `optica`.`marcas` (`id_marca`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`pedidos` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `cliente_id` INT NOT NULL,
  `empleado_id` INT NOT NULL,
  `fecha_pedido` DATE NOT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedidos_clientes_idx` (`cliente_id` ASC) VISIBLE,
  INDEX `fk_pedidos_empleado_idx` (`empleado_id` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_clientes`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `optica`.`clientes` (`id_cliente`),
  CONSTRAINT `fk_pedido_empleado`
    FOREIGN KEY (`empleado_id`)
    REFERENCES `optica`.`empleados` (`id_empleado`))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;


-- -----------------------------------------------------
-- Table `optica`.`detalle_pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `optica`.`detalle_pedidos` (
  `gafas_id_gafas` INT NOT NULL,
  `pedidos_id_pedido` INT NOT NULL,
  PRIMARY KEY (`gafas_id_gafas`, `pedidos_id_pedido`),
  INDEX `fk_gafas_has_pedidos_pedidos1_idx` (`pedidos_id_pedido` ASC) VISIBLE,
  INDEX `fk_gafas_has_pedidos_gafas1_idx` (`gafas_id_gafas` ASC) VISIBLE,
  CONSTRAINT `fk_gafas_has_pedidos_gafas1`
    FOREIGN KEY (`gafas_id_gafas`)
    REFERENCES `optica`.`gafas` (`id_gafas`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_gafas_has_pedidos_pedidos1`
    FOREIGN KEY (`pedidos_id_pedido`)
    REFERENCES `optica`.`pedidos` (`id_pedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_spanish_ci;

