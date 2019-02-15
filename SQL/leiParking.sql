-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema parking
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema parking
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `parking` DEFAULT CHARACTER SET utf8 ;
USE `parking` ;

-- -----------------------------------------------------
-- Table `parking`.`Cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parking`.`Cliente` ;

CREATE TABLE IF NOT EXISTS `parking`.`Cliente` (
  `idCliente` INT(11) NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parking`.`LugaresParque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parking`.`LugaresParque` ;

CREATE TABLE IF NOT EXISTS `parking`.`LugaresParque` (
  `id_lugar` INT(11) NOT NULL AUTO_INCREMENT,
  `piso` INT(11) NOT NULL,
  `ocupado` TINYINT(1) NULL DEFAULT NULL,
  `Parque_idParque` INT(11) NOT NULL,
  PRIMARY KEY (`id_lugar`),
  INDEX `fk_LugaresPaque_Parque1_idx` (`Parque_idParque` ASC) VISIBLE,
  CONSTRAINT `fk_LugaresParque_Parque`
    FOREIGN KEY (`Parque_idParque`)
    REFERENCES `parking`.`parque` (`idparque`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parking`.`Pagamento`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parking`.`Pagamento` ;

CREATE TABLE IF NOT EXISTS `parking`.`Pagamento` (
  `idPagamento` INT(11) NOT NULL AUTO_INCREMENT,
  `taxa` FLOAT NOT NULL,
  `preco` FLOAT NOT NULL,
  `multa` FLOAT NOT NULL,
  PRIMARY KEY (`idPagamento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parking`.`Parque`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parking`.`Parque` ;

CREATE TABLE IF NOT EXISTS `parking`.`Parque` (
  `idParque` INT(11) NOT NULL AUTO_INCREMENT,
  `capacidade` INT(11) NOT NULL,
  `distrito` VARCHAR(32) NOT NULL,
  `cidade` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`idParque`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parking`.`Reserva`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parking`.`Reserva` ;

CREATE TABLE IF NOT EXISTS `parking`.`Reserva` (
  `idReserva` INT(11) NOT NULL AUTO_INCREMENT,
  `data_inicio` DATETIME NOT NULL,
  `data_fim` DATETIME NOT NULL,
  `Veiculo_matricula` VARCHAR(24) NOT NULL,
  `Pagamento_idPagamento` INT(11) NOT NULL,
  `LugaresParque_lugar` INT(11) NOT NULL,
  `ativa` TINYINT(1) NOT NULL,
  PRIMARY KEY (`idReserva`),
  INDEX `fk_Reserva_Pagamento_idx` (`Pagamento_idPagamento` ASC) VISIBLE,
  INDEX `fk_Reserva_Veiculo1_idx` (`Veiculo_matricula` ASC) VISIBLE,
  INDEX `fk_Reserva_Lugar_idx` (`LugaresParque_lugar` ASC) VISIBLE,
  CONSTRAINT `fk_Reserva_Lugar`
    FOREIGN KEY (`LugaresParque_lugar`)
    REFERENCES `parking`.`lugaresparque` (`id_lugar`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Reserva_Pagamento`
    FOREIGN KEY (`Pagamento_idPagamento`)
    REFERENCES `parking`.`pagamento` (`idpagamento`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Reserva_Veiculo`
    FOREIGN KEY (`Veiculo_matricula`)
    REFERENCES `parking`.`veiculo` (`matricula`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `parking`.`Veiculo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `parking`.`Veiculo` ;

CREATE TABLE IF NOT EXISTS `parking`.`Veiculo` (
  `matricula` VARCHAR(24) NOT NULL,
  `tipo` INT(11) NOT NULL,
  `Cliente_idCliente` INT(11) NOT NULL,
  PRIMARY KEY (`matricula`),
  INDEX `fk_Veiculo_Cliente_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Veiculo_Cliente`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `parking`.`cliente` (`idcliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `parking` ;

-- -----------------------------------------------------
-- function tempoveiculo
-- -----------------------------------------------------

USE `parking`;
DROP function IF EXISTS `parking`.`tempoveiculo`;

DELIMITER $$
USE `parking`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `tempoveiculo`(reserva_id INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE tempo_inicial DATETIME;
DECLARE tempo_final DATETIME;
DECLARE tempo INT;
DECLARE reserva_id INT;

SET reserva_id = (select idReserva FROM Reserva ORDER BY idReserva DESC LIMIT 1);
SET tempo_inicial = (select data_inicio FROM Reserva WHERE Reserva.idReserva=reserva_id);
SET tempo_final = (select data_fim FROM Reserva WHERE Reserva.idReserva=reserva_id);
SET tempo =(SELECT TIMESTAMPDIFF(MINUTE,tempo_inicial,tempo_final));
RETURN tempo;

END$$

DELIMITER ;

-- -----------------------------------------------------
-- function tipoveiculo
-- -----------------------------------------------------

USE `parking`;
DROP function IF EXISTS `parking`.`tipoveiculo`;

DELIMITER $$
USE `parking`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `tipoveiculo`(reserva_id INT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE tipo_veiculo INT;
DECLARE matricula_aux VARCHAR(45);

SET matricula_aux = (SELECT Veiculo_matricula FROM Reserva
										WHERE idReserva=reserva_id);
SET tipo_veiculo = (SELECT tipo FROM Veiculo
										WHERE matricula=matricula_aux);

RETURN tipo_veiculo;

END$$

DELIMITER ;
USE `parking`;

DELIMITER $$

USE `parking`$$
DROP TRIGGER IF EXISTS `parking`.`updateCapacidade` $$
USE `parking`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `parking`.`updateCapacidade`
AFTER INSERT ON `parking`.`LugaresParque`
FOR EACH ROW
BEGIN
	UPDATE Parque
    SET capacidade = capacidade + 1
    WHERE Parque.idParque = NEW.Parque_idParque;
END$$


USE `parking`$$
DROP TRIGGER IF EXISTS `parking`.`geraPagamentoCliente` $$
USE `parking`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `parking`.`geraPagamentoCliente`
AFTER INSERT ON `parking`.`Reserva`
FOR EACH ROW
BEGIN
    DECLARE tipo_veiculo INT;
    DECLARE pagamento_id INT;
    DECLARE tempo FLOAT;
    DECLARE tx_1 FLOAT;
	DECLARE tx_2 FLOAT;
    
    SET tx_1 = 1.2;
	SET tx_2 = 1.5; 
	SET tipo_veiculo = tipoveiculo(NEW.idReserva);
    SET tempo = tempoveiculo(NEW.idReserva);
	
    IF (tipo_veiculo = 1) THEN
		INSERT INTO Pagamento (idPagamento,taxa, preco, multa)
				VALUES (idPagamento, tx_1-1, tx_1*0.1*tempo, 0);
	ELSE 
		INSERT INTO Pagamento (idPagamento,taxa, preco, multa)
				VALUES (idPagamento, tx_2-1, tx_2*0.1*tempo, 0);
	END IF;    
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
