-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Pracownicy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pracownicy` (
  `id_Pracownika` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Imię` VARCHAR(45) NOT NULL,
  `Nazwisko` VARCHAR(45) NOT NULL,
  `Adres` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `PESEL` CHAR(11) NOT NULL,
  `Pensja` DECIMAL(7,2) NULL,
  `zarobek_dla_firmy` INT(10) NULL,
  PRIMARY KEY (`id_Pracownika`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  UNIQUE INDEX `PESEL_UNIQUE` (`PESEL` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = ascii;


-- -----------------------------------------------------
-- Table `mydb`.`Klienci`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Klienci` (
  `id_Klienta` INT NOT NULL,
  `Adres` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `Numer telefonu` INT(11) NOT NULL,
  PRIMARY KEY (`id_Klienta`),
  UNIQUE INDEX `Numer telefonu_UNIQUE` (`Numer telefonu` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sprzęt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sprzęt` (
  `id_Sprzętu` INT NOT NULL AUTO_INCREMENT,
  `typ_Urządzenia` VARCHAR(45) NOT NULL,
  `kondycja_Urządzenia` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_Sprzętu`),
  UNIQUE INDEX `id_Sprzętu_UNIQUE` (`id_Sprzętu` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Serwis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Serwis` (
  `Pracownicy_id_Pracownika` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Sprzęt_id_Sprzętu` INT NOT NULL,
  INDEX `fk_Serwis_Sprzęt1_idx` (`Sprzęt_id_Sprzętu` ASC) VISIBLE,
  CONSTRAINT `fk_Serwis_Pracownicy`
    FOREIGN KEY (`Pracownicy_id_Pracownika`)
    REFERENCES `mydb`.`Pracownicy` (`id_Pracownika`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Serwis_Sprzęt1`
    FOREIGN KEY (`Sprzęt_id_Sprzętu`)
    REFERENCES `mydb`.`Sprzęt` (`id_Sprzętu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = armscii8;


-- -----------------------------------------------------
-- Table `mydb`.`Pracownia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Pracownia` (
  `id_produktu` INT NOT NULL AUTO_INCREMENT,
  `Sprzęt_id_Sprzętu` INT NOT NULL,
  `rodzaj_Produktu` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_produktu`),
  INDEX `fk_Warsztat_Sprzęt1_idx` (`Sprzęt_id_Sprzętu` ASC) VISIBLE,
  CONSTRAINT `fk_Warsztat_Sprzęt1`
    FOREIGN KEY (`Sprzęt_id_Sprzętu`)
    REFERENCES `mydb`.`Sprzęt` (`id_Sprzętu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Sprzedaż`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Sprzedaż` (
  `Klienci_id_Klienta` INT NOT NULL,
  `Ilość` VARCHAR(20) NOT NULL,
  `Cena` INT(15) NOT NULL,
  `Rodzaj` VARCHAR(20) NOT NULL,
  `ilosc_zamowien` INT NOT NULL,
  INDEX `fk_Sprzedaż_Klienci1_idx` (`Klienci_id_Klienta` ASC) VISIBLE,
  PRIMARY KEY (`Klienci_id_Klienta`),
  CONSTRAINT `fk_Sprzedaż_Klienci1`
    FOREIGN KEY (`Klienci_id_Klienta`)
    REFERENCES `mydb`.`Klienci` (`id_Klienta`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb` ;

-- -----------------------------------------------------
-- procedure ranking_pracownikow
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE PROCEDURE `ranking_pracownikow` (OUT Ranking varchar(50))
BEGIN
Select concat(imię , nazwisko) INTO Ranking from Pracownicy order by zarobek_dla_firmy;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function pensje
-- -----------------------------------------------------

DELIMITER $$
USE `mydb`$$
CREATE FUNCTION `pensje` ()
RETURNS DECIMAL
BEGIN
DECLARE ilosc DECIMAL;
SELECT COUNT(*) INTO @ilosc FROM pensja;
RETURN @ilosc;
END$$

DELIMITER ;
USE `mydb`;

DELIMITER $$
USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`Sprzęt_BEFORE_INSERT` BEFORE INSERT ON `Sprzęt` FOR EACH ROW
BEGIN
DECLARE stan varchar(30);
DECLARE potrzeba_naprawy bool;
SET stan = 'dobry';
IF stan NOT in ('dobry')
THEN
SET potzeba_naprawy = true;
END IF;
END$$

USE `mydb`$$
CREATE DEFINER = CURRENT_USER TRIGGER `mydb`.`zniżka_dla_stałych` AFTER INSERT ON `Sprzedaż` FOR EACH ROW
BEGIN
IF ilosc_zamowien > 10
THEN
SET sprzedaż.cena = sprzedaż.cena*0.8;
END IF;

END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
