-- MySQL Script generated by MySQL Workbench
-- Mon Mar 20 17:39:05 2023
-- Model: Pizzeria Model    Version: 1.0
-- MySQL Workbench Forward Engineering


-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_spanish_ci;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`provincias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`provincias` (
  `id_provincia` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_provincia`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`localidades`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`localidades` (
  `id_localidad` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `id_provincia` INT NOT NULL,
  PRIMARY KEY (`id_localidad`, `id_provincia`),
  INDEX `fk_localidades_provincias1_idx` (`id_provincia` ASC) VISIBLE,
  CONSTRAINT `fk_localidades_provincias1`
    FOREIGN KEY (`id_provincia`)
    REFERENCES `pizzeria`.`provincias` (`id_provincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`direcciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`direcciones` (
  `id_direccion` INT NOT NULL AUTO_INCREMENT,
  `direccion` VARCHAR(45) NOT NULL,
  `cp` VARCHAR(45) NOT NULL,
  `id_localidad` INT NOT NULL,
  `id_provincia` INT NOT NULL,
  PRIMARY KEY (`id_direccion`, `id_localidad`, `id_provincia`),
  INDEX `fk_direcciones_localidades1_idx` (`id_localidad` ASC, `id_provincia` ASC) VISIBLE,
  CONSTRAINT `fk_direcciones_localidades1`
    FOREIGN KEY (`id_localidad` , `id_provincia`)
    REFERENCES `pizzeria`.`localidades` (`id_localidad` , `id_provincia`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`establecimientos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`establecimientos` (
  `id_establecimiento` INT NOT NULL AUTO_INCREMENT,
  `id_direccion` INT NOT NULL,
  PRIMARY KEY (`id_establecimiento`),
  INDEX `fk_establecimientos_direcciones1_idx` (`id_direccion` ASC) VISIBLE,
  CONSTRAINT `fk_establecimientos_direcciones1`
    FOREIGN KEY (`id_direccion`)
    REFERENCES `pizzeria`.`direcciones` (`id_direccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`productos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`productos` (
  `id_producto` INT NOT NULL AUTO_INCREMENT,
  `tipo` ENUM('PIZZA', 'BEBIDA', 'HAMBURGUESA') NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `descripcion` VARCHAR(200) NULL DEFAULT NULL,
  `imagen` BLOB NOT NULL,
  `precio` DOUBLE NOT NULL,
  `id_establecimientos` INT NOT NULL,
  PRIMARY KEY (`id_producto`),
  INDEX `fk_productos_establecimientos1_idx` (`id_establecimientos` ASC) VISIBLE,
  CONSTRAINT `fk_productos_establecimientos1`
    FOREIGN KEY (`id_establecimientos`)
    REFERENCES `pizzeria`.`establecimientos` (`id_establecimiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`categorias`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`categorias` (
  `id_categoria` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_categoria`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pizza` (
  `id_producto` INT NOT NULL,
  `id_categoria` INT NOT NULL,
  PRIMARY KEY (`id_producto`, `id_categoria`),
  INDEX `fk_pizza_categorias1_idx` (`id_categoria` ASC) VISIBLE,
  CONSTRAINT `fk_pizza_productos`
    FOREIGN KEY (`id_producto`)
    REFERENCES `pizzeria`.`productos` (`id_producto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pizza_categorias1`
    FOREIGN KEY (`id_categoria`)
    REFERENCES `pizzeria`.`categorias` (`id_categoria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`clientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NULL DEFAULT NULL,
  `apellidos` VARCHAR(45) NULL DEFAULT NULL,
  `telefono` VARCHAR(20) NULL DEFAULT NULL,
  `id_direccion` INT NOT NULL,
  PRIMARY KEY (`id_cliente`),
  INDEX `fk_clientes_direcciones1_idx` (`id_direccion` ASC) VISIBLE,
  CONSTRAINT `fk_clientes_direcciones1`
    FOREIGN KEY (`id_direccion`)
    REFERENCES `pizzeria`.`direcciones` (`id_direccion`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`empleados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`empleados` (
  `id_empleado` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `nif` VARCHAR(9) NOT NULL,
  `telefono` VARCHAR(20) NOT NULL,
  `es_repartidor` TINYINT NULL DEFAULT NULL,
  `id_establecimientos` INT NOT NULL,
  PRIMARY KEY (`id_empleado`),
  INDEX `fk_empleados_establecimientos_idx` (`id_establecimientos` ASC) VISIBLE,
  CONSTRAINT `fk_empleados_establecimientos`
    FOREIGN KEY (`id_establecimientos`)
    REFERENCES `pizzeria`.`establecimientos` (`id_establecimiento`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pedidos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pedidos` (
  `id_pedido` INT NOT NULL AUTO_INCREMENT,
  `fecha_pedido` DATETIME NOT NULL,
  `a_domicilio` TINYINT NOT NULL,
  `precio_total` DOUBLE NOT NULL,
  `n_hamburguesas` INT NOT NULL,
  `n_bebidas` INT NOT NULL,
  `n_pizzas` INT NOT NULL,
  `hora_entrega` DATETIME NULL DEFAULT NULL,
  `id_cliente` INT NOT NULL,
  `id_empleado_repartidor` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_pedido`),
  INDEX `fk_pedidos_clientes1_idx` (`id_cliente` ASC) VISIBLE,
  INDEX `fk_pedidos_empleados1_idx` (`id_empleado_repartidor` ASC) VISIBLE,
  CONSTRAINT `fk_pedidos_clientes1`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `pizzeria`.`clientes` (`id_cliente`),
  CONSTRAINT `fk_pedidos_empleados1`
    FOREIGN KEY (`id_empleado_repartidor`)
    REFERENCES `pizzeria`.`empleados` (`id_empleado`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`detalle_pedido` (
  `id_detalle_pedido` INT NOT NULL,
  `id_productos` INT NOT NULL,
  `id_pedidos` INT NOT NULL,
  PRIMARY KEY (`id_detalle_pedido`),
  INDEX `fk_detalle_pedido_pedidos1_idx` (`id_pedidos` ASC) VISIBLE,
  INDEX `fk_detalle_pedido_productos1_idx` (`id_productos` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_pedido_pedidos1`
    FOREIGN KEY (`id_pedidos`)
    REFERENCES `pizzeria`.`pedidos` (`id_pedido`),
  CONSTRAINT `fk_detalle_pedido_productos1`
    FOREIGN KEY (`id_productos`)
    REFERENCES `pizzeria`.`productos` (`id_producto`))
ENGINE = InnoDB;

