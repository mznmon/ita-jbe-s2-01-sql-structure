-- Thu Mar 16 18:45:34 2023
-- Model: mini spotify    Version: 1.0


-- -----------------------------------------------------
-- Schema spotify
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `spotify` ;
USE `spotify` ;

-- -----------------------------------------------------
-- Table `spotify`.`usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuarios` (
  `id_usuario` INT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `nombre_usuario` VARCHAR(45) NOT NULL,
  `fecha_nacimiento` DATE NOT NULL,
  `sexo` ENUM('M', 'F', 'OTRO') NULL,
  `país` VARCHAR(45) NOT NULL,
  `cp` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_usuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`tarjetas_crédito`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`tarjetas_crédito` (
  `id_tarjeta` INT NOT NULL,
  `número_tarjeta` VARCHAR(20) NOT NULL,
  `caducidad` DATE NOT NULL,
  `código_seguridad` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`id_tarjeta`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`paypal` (
  `id_paypal` INT NOT NULL,
  `nombre_usuario` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_paypal`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`usuarios_premium`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuarios_premium` (
  `id_usuario` INT NOT NULL,
  `fk_tarjeta` INT NULL,
  `fk_paypal` INT NULL,
  INDEX `fk_usuario_premium_usuarios_idx` (`id_usuario` ASC) VISIBLE,
  PRIMARY KEY (`id_usuario`),
  INDEX `fk_usuario_premium_tarjeta_crédito1_idx` (`fk_tarjeta` ASC) VISIBLE,
  INDEX `fk_usuario_premium_paypal1_idx` (`fk_paypal` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_premium_usuarios`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `spotify`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_premium_tarjeta_crédito1`
    FOREIGN KEY (`fk_tarjeta`)
    REFERENCES `spotify`.`tarjetas_crédito` (`id_tarjeta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_premium_paypal1`
    FOREIGN KEY (`fk_paypal`)
    REFERENCES `spotify`.`paypal` (`id_paypal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artistas` (
  `id_artista` INT NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `imagen` BLOB NULL,
  PRIMARY KEY (`id_artista`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`álbumes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`álbumes` (
  `id_álbum` INT NOT NULL,
  `título` VARCHAR(45) NOT NULL,
  `año_publicación` DATE NOT NULL,
  `portada` BLOB NULL,
  `artista_id` INT NOT NULL,
  PRIMARY KEY (`id_álbum`),
  INDEX `fk_álbum_artista1_idx` (`artista_id` ASC) VISIBLE,
  CONSTRAINT `fk_álbum_artista1`
    FOREIGN KEY (`artista_id`)
    REFERENCES `spotify`.`artistas` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`canciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`canciones` (
  `id_canción` INT NOT NULL,
  `título` VARCHAR(45) NOT NULL,
  `duración` TIME NOT NULL,
  `reproducciones` INT NOT NULL,
  `álbum_id_álbum` INT NOT NULL,
  PRIMARY KEY (`id_canción`),
  INDEX `fk_canción_álbum1_idx` (`álbum_id_álbum` ASC) VISIBLE,
  CONSTRAINT `fk_canción_álbum1`
    FOREIGN KEY (`álbum_id_álbum`)
    REFERENCES `spotify`.`álbumes` (`id_álbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist` (
  `id_playlist` INT NOT NULL,
  `título` VARCHAR(45) NOT NULL,
  `número_canciones` INT NOT NULL,
  `fecha_creación` DATE NOT NULL,
  `fecha_inactiva` DATE NULL,
  `fk_usuario` INT NOT NULL,
  PRIMARY KEY (`id_playlist`),
  INDEX `fk_playlist_usuarios1_idx` (`fk_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_usuarios1`
    FOREIGN KEY (`fk_usuario`)
    REFERENCES `spotify`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`suscripciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`suscripciones` (
  `id_suscripción` INT NOT NULL,
  `fecha_inicio` DATE NOT NULL,
  `fecha_renovación` DATE NULL,
  PRIMARY KEY (`id_suscripción`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`pagos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`pagos` (
  `número_orden` INT NOT NULL AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_suscripción` INT NOT NULL,
  `total` DOUBLE NOT NULL,
  PRIMARY KEY (`número_orden`, `id_usuario`, `id_suscripción`),
  INDEX `fk_usuario_premium_has_suscripción_suscripción1_idx` (`id_suscripción` ASC) VISIBLE,
  INDEX `fk_usuario_premium_has_suscripción_usuario_premium1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_usuario_premium_has_suscripción_usuario_premium1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `spotify`.`usuarios_premium` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuario_premium_has_suscripción_suscripción1`
    FOREIGN KEY (`id_suscripción`)
    REFERENCES `spotify`.`suscripciones` (`id_suscripción`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist_tiene_canciones`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist_tiene_canciones` (
  `id_playlist` INT NOT NULL,
  `id_canción` INT NOT NULL,
  PRIMARY KEY (`id_playlist`, `id_canción`),
  INDEX `fk_playlist_has_canciones_canciones1_idx` (`id_canción` ASC) VISIBLE,
  INDEX `fk_playlist_has_canciones_playlist1_idx` (`id_playlist` ASC) VISIBLE,
  CONSTRAINT `fk_playlist_has_canciones_playlist1`
    FOREIGN KEY (`id_playlist`)
    REFERENCES `spotify`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlist_has_canciones_canciones1`
    FOREIGN KEY (`id_canción`)
    REFERENCES `spotify`.`canciones` (`id_canción`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`playlist_compartidas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`playlist_compartidas` (
  `id_playlist` INT NOT NULL,
  `id_usuario` INT NOT NULL,
  `id_canción` INT NOT NULL,
  `fecha` DATE NOT NULL,
  PRIMARY KEY (`id_playlist`, `id_usuario`, `id_canción`),
  INDEX `fk_usuarios_has_playlist_playlist1_idx` (`id_playlist` ASC) VISIBLE,
  INDEX `fk_usuarios_has_playlist_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  INDEX `fk_playlist_compartida_canciones1_idx` (`id_canción` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_has_playlist_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `spotify`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuarios_has_playlist_playlist1`
    FOREIGN KEY (`id_playlist`)
    REFERENCES `spotify`.`playlist` (`id_playlist`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_playlist_compartida_canciones1`
    FOREIGN KEY (`id_canción`)
    REFERENCES `spotify`.`canciones` (`id_canción`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`artistas_relacionados`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`artistas_relacionados` (
  `id_artista` INT NOT NULL,
  `id_artista_relacionado` INT NOT NULL,
  PRIMARY KEY (`id_artista`, `id_artista_relacionado`),
  INDEX `fk_artistas_has_artistas_artistas2_idx` (`id_artista_relacionado` ASC) VISIBLE,
  INDEX `fk_artistas_has_artistas_artistas1_idx` (`id_artista` ASC) VISIBLE,
  CONSTRAINT `fk_artistas_has_artistas_artistas1`
    FOREIGN KEY (`id_artista`)
    REFERENCES `spotify`.`artistas` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_artistas_has_artistas_artistas2`
    FOREIGN KEY (`id_artista_relacionado`)
    REFERENCES `spotify`.`artistas` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`usuarios_siguen_artistas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`usuarios_siguen_artistas` (
  `id_usuario` INT NOT NULL,
  `id_artista` INT NOT NULL,
  PRIMARY KEY (`id_usuario`, `id_artista`),
  INDEX `fk_usuarios_has_artistas_artistas1_idx` (`id_artista` ASC) VISIBLE,
  INDEX `fk_usuarios_has_artistas_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_has_artistas_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `spotify`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuarios_has_artistas_artistas1`
    FOREIGN KEY (`id_artista`)
    REFERENCES `spotify`.`artistas` (`id_artista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`álbumes_favoritos_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`álbumes_favoritos_usuarios` (
  `id_usuario` INT NOT NULL,
  `id_álbum` INT NOT NULL,
  PRIMARY KEY (`id_usuario`, `id_álbum`),
  INDEX `fk_usuarios_has_álbumes_álbumes1_idx` (`id_álbum` ASC) VISIBLE,
  INDEX `fk_usuarios_has_álbumes_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_has_álbumes_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `spotify`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuarios_has_álbumes_álbumes1`
    FOREIGN KEY (`id_álbum`)
    REFERENCES `spotify`.`álbumes` (`id_álbum`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `spotify`.`canciones_favoritas_usuarios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `spotify`.`canciones_favoritas_usuarios` (
  `id_usuario` INT NOT NULL,
  `id_canción` INT NOT NULL,
  PRIMARY KEY (`id_usuario`, `id_canción`),
  INDEX `fk_usuarios_has_canciones_canciones1_idx` (`id_canción` ASC) VISIBLE,
  INDEX `fk_usuarios_has_canciones_usuarios1_idx` (`id_usuario` ASC) VISIBLE,
  CONSTRAINT `fk_usuarios_has_canciones_usuarios1`
    FOREIGN KEY (`id_usuario`)
    REFERENCES `spotify`.`usuarios` (`id_usuario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_usuarios_has_canciones_canciones1`
    FOREIGN KEY (`id_canción`)
    REFERENCES `spotify`.`canciones` (`id_canción`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

