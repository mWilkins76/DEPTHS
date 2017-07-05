-- phpMyAdmin SQL Dump
-- version 4.4.15.8
-- https://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Mer 01 Mars 2017 à 18:41
-- Version du serveur :  5.6.31
-- Version de PHP :  5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `rubis_gold`
--

-- --------------------------------------------------------

--
-- Structure de la table `AlienBuffer`
--

CREATE TABLE IF NOT EXISTS `AlienBuffer` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `buffType` varchar(255) NOT NULL,
  `nbUpgrade` int(11) NOT NULL,
  `cost` int(11) NOT NULL,
  `upgradeCost1` int(11) NOT NULL,
  `upgradeCost2` int(11) NOT NULL,
  `upgradeCost3` int(11) NOT NULL,
  `upgradeTime1` time NOT NULL,
  `upgradeTime2` time NOT NULL,
  `upgradeTime3` time NOT NULL,
  `levelReqUp1` int(11) NOT NULL,
  `levelReqUp2` int(11) NOT NULL,
  `levelReqUp3` int(11) NOT NULL,
  `buffCoef1` float NOT NULL,
  `buffCoef2` float NOT NULL,
  `buffCoef3` float NOT NULL,
  `buffCoef4` float NOT NULL,
  `time` time NOT NULL,
  `nomenclature` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `AlienBuffer`
--

INSERT INTO `AlienBuffer` (`id`, `type`, `name`, `buffType`, `nbUpgrade`, `cost`, `upgradeCost1`, `upgradeCost2`, `upgradeCost3`, `upgradeTime1`, `upgradeTime2`, `upgradeTime3`, `levelReqUp1`, `levelReqUp2`, `levelReqUp3`, `buffCoef1`, `buffCoef2`, `buffCoef3`, `buffCoef4`, `time`, `nomenclature`) VALUES
(1, 'AlienBuffer', 'Buffer1', 'energy', 2, 0, 3000, 9000, 0, '01:30:00', '02:40:00', '00:00:00', 17, 24, 0, 1, 2, 4, 0, '01:00:00', 'Test1'),
(2, 'AlienBuffer', 'Buffer2', 'gene', 2, 0, 3000, 9000, 0, '01:30:00', '02:40:00', '00:00:00', 17, 24, 0, 1, 2, 4, 0, '01:00:00', 'Test2'),
(3, 'AlienBuffer', 'Buffer3', 'mn', 2, 0, 3000, 9000, 0, '01:30:00', '02:40:00', '00:00:00', 17, 24, 0, 1, 2, 4, 0, '01:00:00', 'Test3');

-- --------------------------------------------------------

--
-- Structure de la table `AlienEsthetique`
--

CREATE TABLE IF NOT EXISTS `AlienEsthetique` (
  `id` int(11) NOT NULL,
  `nomenclature` tinytext NOT NULL,
  `name` tinytext NOT NULL,
  `type` tinytext NOT NULL,
  `time` time NOT NULL,
  `cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `AlienForeur`
--

CREATE TABLE IF NOT EXISTS `AlienForeur` (
  `id` int(11) NOT NULL,
  `nomenclature` tinytext NOT NULL,
  `name` tinytext NOT NULL,
  `type` tinytext NOT NULL,
  `power` tinytext NOT NULL,
  `stamina` int(11) NOT NULL,
  `time` time NOT NULL,
  `cost` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `AlienForeur`
--

INSERT INTO `AlienForeur` (`id`, `nomenclature`, `name`, `type`, `power`, `stamina`, `time`, `cost`) VALUES
(1, 'Bob', 'Basic1', 'AlienForeur', 'Driller', 10, '00:10:00', 0),
(2, 'Teluop', 'Basic2', 'AlienForeur', 'Driller', 10, '00:10:00', 0),
(3, 'Ertuol', 'Basic3', 'AlienForeur', 'Driller', 10, '00:10:00', 0),
(4, 'Suolubaf', 'LongRange1', 'AlienForeur', 'Bomber', 4, '00:36:30', 0),
(5, 'Elidocorc', 'LongRange2', 'AlienForeur', 'Bomber', 4, '00:36:30', 0),
(6, 'Epluop', 'LongRange3', 'AlienForeur', 'Bomber', 4, '00:36:30', 0),
(7, 'Abmup', 'Lave1', 'AlienForeur', 'Tank', 6, '01:30:00', 0),
(8, 'Nihcam', 'Lave2', 'AlienForeur', 'Tank', 6, '01:30:00', 0),
(9, 'Cotsam', 'Lave3', 'AlienForeur', 'Tank', 6, '01:30:00', 0),
(10, 'Revsorg', 'Heal1', 'AlienForeur', 'Healer', 8, '02:20:00', 0),
(11, 'Blub', 'Heal2', 'AlienForeur', 'Healer', 8, '02:20:00', 0),
(12, 'Tahcel', 'Heal3', 'AlienForeur', 'Healer', 8, '02:20:00', 0);

-- --------------------------------------------------------

--
-- Structure de la table `AlienProducer`
--

CREATE TABLE IF NOT EXISTS `AlienProducer` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `nomenclature` varchar(255) NOT NULL,
  `nbUpgrade` int(11) NOT NULL,
  `cost` int(11) NOT NULL,
  `upgradeCost1` int(11) NOT NULL,
  `upgradeCost2` int(11) NOT NULL,
  `upgradeCost3` int(11) NOT NULL,
  `upgradeTime1` time NOT NULL,
  `upgradeTime2` time NOT NULL,
  `upgradeTime3` time NOT NULL,
  `levelReqUp1` int(11) NOT NULL,
  `levelReqUp2` int(11) NOT NULL,
  `levelReqUp3` int(11) NOT NULL,
  `time` time NOT NULL,
  `maxProd` int(11) NOT NULL,
  `prodTime` int(11) NOT NULL,
  `prodByCycle` int(11) NOT NULL,
  `prodSpeed` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `AlienProducer`
--

INSERT INTO `AlienProducer` (`id`, `type`, `name`, `nomenclature`, `nbUpgrade`, `cost`, `upgradeCost1`, `upgradeCost2`, `upgradeCost3`, `upgradeTime1`, `upgradeTime2`, `upgradeTime3`, `levelReqUp1`, `levelReqUp2`, `levelReqUp3`, `time`, `maxProd`, `prodTime`, `prodByCycle`, `prodSpeed`) VALUES
(1, 'AlienProducer', 'Producer1', 'Mik', 1, 0, 1000, 0, 0, '00:15:00', '00:00:00', '00:00:00', 8, 0, 0, '00:10:00', 500, 1, 50, 10),
(2, 'AlienProducer', 'Producer2', 'Xela', 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0, '01:00:00', 5000, 1, 100, 60),
(3, 'AlienProducer', 'Producer3', 'Nimi', 2, 0, 3000, 9000, 0, '03:00:00', '05:25:00', '00:00:00', 17, 24, 0, '02:00:00', 2000, 1, 200, 10);

-- --------------------------------------------------------

--
-- Structure de la table `aliens`
--

CREATE TABLE IF NOT EXISTS `aliens` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `idAlien` tinytext NOT NULL,
  `idBuilding` tinytext NOT NULL,
  `type` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `nomPropre` varchar(255) NOT NULL,
  `level` int(11) NOT NULL,
  `mode` varchar(255) NOT NULL,
  `startTime` datetime NOT NULL,
  `endTime` datetime NOT NULL,
  `stamina` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=307 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `aliens`
--

INSERT INTO `aliens` (`id`, `idPlayer`, `idAlien`, `idBuilding`, `type`, `name`, `nomPropre`, `level`, `mode`, `startTime`, `endTime`, `stamina`) VALUES
(306, 86, 'Basic21488392499048', 'AlienIncubator1488389989359', 'AlienForeur', 'Basic2', 'Teluop', 1, 'Constructing', '2017-03-01 19:21:39', '2017-03-01 19:31:39', 6);

-- --------------------------------------------------------

--
-- Structure de la table `building`
--

CREATE TABLE IF NOT EXISTS `building` (
  `id` int(11) NOT NULL,
  `idBuildingType` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `idRegion` int(11) NOT NULL,
  `regionX` int(11) NOT NULL,
  `regionY` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `mode` varchar(255) NOT NULL,
  `buildingEnd` datetime NOT NULL,
  `currentLevel` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `globalX` int(11) NOT NULL,
  `globalY` int(11) NOT NULL,
  `layer` int(11) NOT NULL,
  `buildingStart` datetime NOT NULL,
  `buildingId` tinytext NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=701 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `building`
--

INSERT INTO `building` (`id`, `idBuildingType`, `idPlayer`, `idRegion`, `regionX`, `regionY`, `x`, `y`, `mode`, `buildingEnd`, `currentLevel`, `type`, `globalX`, `globalY`, `layer`, `buildingStart`, `buildingId`) VALUES
(687, 1, 85, 0, 0, 0, 7, 7, 'Wait', '2017-03-01 11:24:41', 1, 'UrbanHeadQuarter', 0, 700, 1, '2017-03-01 11:24:41', 'UrbanHeadQuarter0000000'),
(688, 4, 85, 0, 0, 0, 2, 14, 'Wait', '2017-03-01 12:25:49', 1, 'UrbanPowerStation', -1200, 800, 1, '2017-03-01 11:25:49', 'UrbanPowerStation1488363949460'),
(689, 3, 85, 0, 0, 0, 16, 7, 'Wait', '2017-03-01 13:56:12', 1, 'UrbanTranslation', 900, 1150, 1, '2017-03-01 11:26:12', 'UrbanTranslation1488363972546'),
(690, 16, 85, 0, 0, 0, 17, 10, 'Wait', '2017-03-01 12:08:42', 1, 'AlienIncubator', 700, 1350, 1, '2017-03-01 11:28:42', 'AlienIncubator1488364121575'),
(694, 22, 85, 0, 0, 0, 11, 15, 'Wait', '2017-03-01 14:20:18', 1, 'BuildingCosmeticCapsule3', -400, 1300, 1, '2017-03-01 14:20:18', 'BuildingCosmeticCapsule31488374418077'),
(695, 25, 85, 0, 0, 0, 10, 19, 'Wait', '2017-03-01 14:33:19', 1, 'BuildingCosmeticPlant3', -900, 1450, 1, '2017-03-01 14:33:19', 'BuildingCosmeticPlant31488375198904'),
(696, 6, 85, 0, 0, 0, 12, 2, 'Wait', '2017-03-01 15:54:11', 1, 'DrillingCenter', 1000, 700, 1, '2017-03-01 14:54:11', 'DrillingCenter1488376451276'),
(697, 1, 86, 0, 0, 0, 7, 7, 'Wait', '2017-03-01 18:36:26', 1, 'UrbanHeadQuarter', 0, 700, 1, '2017-03-01 18:36:26', 'UrbanHeadQuarter0000000'),
(698, 4, 86, 0, 0, 0, 6, 16, 'Wait', '2017-03-01 19:37:57', 1, 'UrbanPowerStation', -1000, 1100, 1, '2017-03-01 18:37:57', 'UrbanPowerStation1488389876617'),
(699, 16, 86, 0, 0, 0, 16, 9, 'Wait', '2017-03-01 19:19:49', 1, 'AlienIncubator', 700, 1250, 1, '2017-03-01 18:39:49', 'AlienIncubator1488389989359'),
(700, 3, 86, 0, 0, 0, 14, 4, 'Wait', '2017-03-01 21:09:58', 1, 'UrbanTranslation', 1000, 900, 1, '2017-03-01 18:39:58', 'UrbanTranslation1488389998251');

-- --------------------------------------------------------

--
-- Structure de la table `buildingType`
--

CREATE TABLE IF NOT EXISTS `buildingType` (
  `id` int(11) NOT NULL,
  `buildingName` tinytext NOT NULL,
  `description` text NOT NULL,
  `requiredPlayerLevel` int(11) NOT NULL,
  `category` enum('drill','urban','alien','cosmetic') NOT NULL,
  `softCurrencyCost` int(11) NOT NULL,
  `hardCurrencyCost` int(11) NOT NULL,
  `energyCost` int(11) NOT NULL,
  `ressourcesCost` int(11) NOT NULL,
  `buildingTime` time NOT NULL,
  `SellingCost` int(11) NOT NULL,
  `skipCDcostHC` int(11) NOT NULL,
  `upgradeNumber` int(11) NOT NULL,
  `levelUpgrade1` int(11) NOT NULL,
  `levelUpgrade2` int(11) NOT NULL,
  `levelUpgrade3` int(11) NOT NULL,
  `upgradeTime1` time NOT NULL,
  `upgradeTime2` time NOT NULL,
  `upgradeTime3` time NOT NULL,
  `upgradeCost1` int(11) NOT NULL,
  `upgradeCost2` int(11) NOT NULL,
  `upgradeCost3` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `buildingType`
--

INSERT INTO `buildingType` (`id`, `buildingName`, `description`, `requiredPlayerLevel`, `category`, `softCurrencyCost`, `hardCurrencyCost`, `energyCost`, `ressourcesCost`, `buildingTime`, `SellingCost`, `skipCDcostHC`, `upgradeNumber`, `levelUpgrade1`, `levelUpgrade2`, `levelUpgrade3`, `upgradeTime1`, `upgradeTime2`, `upgradeTime3`, `upgradeCost1`, `upgradeCost2`, `upgradeCost3`) VALUES
(1, 'UrbanHeadQuarter', 'LABEL_DESC_HQ', 1, 'urban', 10000, 8, 24, 350, '01:00:00', 2500, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(2, 'UrbanCommunication', 'LABEL_DESC_COMMUNICATION', 1, 'urban', 16000, 13, 8, 350, '02:10:00', 4000, 32, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(3, 'UrbanTranslation', 'LABEL_DESC_TRANSLATIONCENTER', 1, 'urban', 19500, 15, 8, 750, '02:30:00', 4875, 37, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(4, 'UrbanPowerStation', 'LABEL_DESC_POWERSTATION', 1, 'urban', 10000, 8, 0, 650, '01:00:00', 2500, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(5, 'UrbanAntenna', 'LABEL_DESC_ANTENNA', 1, 'urban', 1000, 3, 0, 150, '00:01:00', 875, 1, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(6, 'DrillingCenter', 'LABEL_DESC_DRILLINGCENTER', 1, 'drill', 15000, 12, 16, 500, '01:00:00', 3750, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(7, 'DrillingOutPost', 'LABEL_DESC_DRILLINGOUTPOST', 1, 'drill', 5500, 4, 12, 150, '00:30:00', 1375, 7, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(8, 'AlienPaddockTiny', 'LABEL_DESC_PADDOCKTINY', 1, 'alien', 4000, 3, 4, 100, '00:10:00', 1000, 2, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(9, 'AlienPaddockSmall', 'LABEL_DESC_PADDOCKSMALL', 1, 'alien', 8000, 6, 8, 175, '00:20:00', 2000, 5, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(10, 'AlienPaddockMedium', 'LABEL_DESC_PADDOCKMEDIUM', 1, 'alien', 10000, 8, 8, 200, '00:25:00', 2500, 6, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(11, 'AlienPaddockBig', 'LABEL_DESC_PADDOCKBIG', 1, 'alien', 15000, 12, 10, 250, '00:40:00', 3750, 10, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(12, 'AlienResearchCenter', 'LABEL_DESC_RESEARCH', 1, 'alien', 7500, 6, 14, 450, '01:00:00', 1375, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(13, 'AlienTrainingCenter', 'LABEL_DESC_TRAININGCENTER', 1, 'alien', 25000, 20, 12, 1000, '04:00:00', 6250, 60, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(14, 'AlienPaddock', '', 1, 'alien', 500, 1, 1, 1, '00:02:00', 100, 1, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(15, 'DrillingAutoOutPost', 'LABEL_DESC_DRILLINGAUTO', 1, 'drill', 7500, 6, 8, 650, '01:15:00', 1875, 18, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(16, 'AlienIncubator', 'LABEL_DESC_INCUBATOR', 1, 'alien', 12500, 10, 18, 300, '00:40:00', 3125, 10, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(18, 'CosmeticBuilding', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 1000, 2, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(19, 'AlienCryoCenter', 'LABEL_DESC_CRYOCENTER', 1, 'alien', 17500, 14, 10, 550, '01:50:00', 4375, 27, 3, 8, 12, 24, '10:00:00', '12:00:00', '20:00:00', 0, 0, 0),
(20, 'BuildingCosmeticCapsule1', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 0, 25, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(21, 'BuildingCosmeticCapsule2', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 0, 20, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(22, 'BuildingCosmeticCapsule3', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 0, 18, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(23, 'BuildingCosmeticPlant1', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 0, 5, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(24, 'BuildingCosmeticPlant2', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 0, 7, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(25, 'BuildingCosmeticPlant3', 'LABEL_DESC_COSMETIC', 1, 'cosmetic', 0, 10, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `codex`
--

CREATE TABLE IF NOT EXISTS `codex` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `bonus` enum('receipe','softCurrency','hardCurrency','ressource','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `dailyReward`
--

CREATE TABLE IF NOT EXISTS `dailyReward` (
  `id` int(11) NOT NULL,
  `value` int(11) NOT NULL,
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `dailyReward`
--

INSERT INTO `dailyReward` (`id`, `value`, `type`) VALUES
(1, 25, 'gene1'),
(2, 5000, 'SC'),
(3, 25, 'gene2'),
(4, 500, 'MN'),
(5, 25, 'gene3'),
(6, 10, 'HC'),
(7, 25, 'gene4');

-- --------------------------------------------------------

--
-- Structure de la table `destructable`
--

CREATE TABLE IF NOT EXISTS `destructable` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `idRegion` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `destructionTime` datetime NOT NULL,
  `endOfDestructionTime` datetime NOT NULL,
  `destructableId` tinytext NOT NULL,
  `layer` int(11) NOT NULL,
  `mode` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `idDestructableType` int(11) NOT NULL,
  `regionX` int(11) NOT NULL,
  `regionY` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `destructable`
--

INSERT INTO `destructable` (`id`, `idPlayer`, `idRegion`, `x`, `y`, `destructionTime`, `endOfDestructionTime`, `destructableId`, `layer`, `mode`, `type`, `idDestructableType`, `regionX`, `regionY`) VALUES
(1, 85, 0, 15, 15, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'DestructibleSkeleton0000001', 1, 'Waiting', 'DestructibleSkeleton', 23, 0, 0),
(2, 86, 0, 15, 15, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'DestructibleSkeleton0000001', 1, 'Waiting', 'DestructibleSkeleton', 23, 0, 0);

-- --------------------------------------------------------

--
-- Structure de la table `destructableType`
--

CREATE TABLE IF NOT EXISTS `destructableType` (
  `id` int(11) NOT NULL,
  `destructableName` tinytext NOT NULL,
  `softCurrencyCost` int(11) NOT NULL,
  `destructableTime` time NOT NULL,
  `skipCDcostHC` int(11) NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `destructableType`
--

INSERT INTO `destructableType` (`id`, `destructableName`, `softCurrencyCost`, `destructableTime`, `skipCDcostHC`, `width`, `height`) VALUES
(1, 'DestructibleRock1', 1000, '00:18:00', 5, 3, 3),
(2, 'DestructibleRock2', 1000, '00:12:00', 5, 2, 3),
(3, 'DestructibleRock3', 1000, '00:12:00', 5, 2, 3),
(4, 'DestructibleRock4', 1000, '00:18:00', 5, 3, 3),
(5, 'DestructibleRock5', 1000, '00:24:00', 5, 3, 4),
(6, 'DestructibleRock6', 1000, '00:08:00', 5, 2, 2),
(7, 'DestructibleRock7', 1000, '00:24:00', 5, 3, 4),
(8, 'DestructibleCrater1', 1000, '00:08:00', 5, 2, 2),
(9, 'DestructibleCrater2', 1000, '00:08:00', 5, 2, 2),
(10, 'DestructibleCrater3', 1000, '00:04:00', 5, 1, 2),
(11, 'DestructibleGeyser1', 1000, '00:08:00', 5, 2, 2),
(12, 'DestructiblePebbles1', 1000, '00:08:00', 5, 2, 2),
(13, 'DestructiblePebbles2', 1000, '00:08:00', 5, 2, 2),
(14, 'DestructiblePebbles3', 1000, '00:08:00', 5, 2, 2),
(15, 'DestructibleCoral1', 1000, '00:05:00', 5, 1, 1),
(16, 'DestructibleCoral2', 1000, '00:05:00', 5, 1, 1),
(17, 'DestructibleCoral3', 1000, '00:05:00', 5, 2, 2),
(18, 'DestructibleCoral4', 1000, '00:05:00', 5, 3, 3),
(19, 'DestructibleCoral5', 1000, '00:05:00', 5, 2, 3),
(20, 'DestructibleGeyser2', 1000, '00:08:00', 5, 1, 1),
(21, 'DestructibleMineral', 1000, '00:08:00', 5, 4, 4),
(22, 'DestructibleMineral2', 1000, '00:08:00', 5, 3, 3),
(23, 'DestructibleSkeleton', 25000, '00:24:00', 10, 5, 7),
(24, 'DestructibleTumor', 25000, '00:24:00', 10, 5, 5),
(25, 'DestructibleWreck', 25000, '00:24:00', 10, 5, 4),
(26, 'DestructibleRock8', 1000, '00:24:00', 5, 2, 2);

-- --------------------------------------------------------

--
-- Structure de la table `mission`
--

CREATE TABLE IF NOT EXISTS `mission` (
  `id` int(11) NOT NULL,
  `idRegion` int(11) NOT NULL,
  `missionNumber` int(11) NOT NULL,
  `idSchema` int(11) NOT NULL,
  `hardCurrency` int(11) NOT NULL,
  `softCurrency` int(11) NOT NULL,
  `gene1` int(11) NOT NULL,
  `gene2` int(11) NOT NULL,
  `gene3` int(11) NOT NULL,
  `gene4` int(11) NOT NULL,
  `gene5` int(11) NOT NULL,
  `darkMatter` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `player`
--

CREATE TABLE IF NOT EXISTS `player` (
  `id` int(11) NOT NULL,
  `idFb` varchar(1024) NOT NULL,
  `langue` enum('en','fr','','') NOT NULL,
  `hardCurrency` int(11) NOT NULL,
  `softCurrency` int(11) NOT NULL,
  `ressource` int(11) NOT NULL,
  `currentEnergy` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `xp` int(11) NOT NULL,
  `FTUEsteps` int(11) NOT NULL,
  `maxEnergy` int(11) NOT NULL,
  `gene1` int(11) NOT NULL,
  `gene2` int(11) NOT NULL,
  `gene3` int(11) NOT NULL,
  `gene4` int(11) NOT NULL,
  `gene5` int(11) NOT NULL,
  `schemas` int(11) NOT NULL,
  `dateConnexion` datetime NOT NULL,
  `daysPlayed` int(11) NOT NULL,
  `nameFb` varchar(255) NOT NULL,
  `timeFriendAlien` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `player`
--

INSERT INTO `player` (`id`, `idFb`, `langue`, `hardCurrency`, `softCurrency`, `ressource`, `currentEnergy`, `level`, `xp`, `FTUEsteps`, `maxEnergy`, `gene1`, `gene2`, `gene3`, `gene4`, `gene5`, `schemas`, `dateConnexion`, `daysPlayed`, `nameFb`, `timeFriendAlien`) VALUES
(86, '1305310572862075', 'en', 9864, 248000, 148950, 26, 0, 60, 1000, 50, 700, 700, 800, 900, 1000, 0, '2017-03-01 18:36:26', 0, 'Guillaume', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `playerSchemas`
--

CREATE TABLE IF NOT EXISTS `playerSchemas` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `idSchema` int(11) NOT NULL,
  `isLocked` tinyint(1) NOT NULL DEFAULT '1',
  `startDecrypt` datetime NOT NULL,
  `endDecrypt` datetime NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;

--
-- Contenu de la table `playerSchemas`
--

INSERT INTO `playerSchemas` (`id`, `idPlayer`, `idSchema`, `isLocked`, `startDecrypt`, `endDecrypt`) VALUES
(73, 86, 5, 0, '2017-03-01 19:38:12', '0000-00-00 00:00:00'),
(75, 86, 6, 0, '2017-03-01 19:38:10', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Structure de la table `region`
--

CREATE TABLE IF NOT EXISTS `region` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `ressourcesType`
--

CREATE TABLE IF NOT EXISTS `ressourcesType` (
  `id` int(11) NOT NULL,
  `ressourceType` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- Contenu de la table `ressourcesType`
--

INSERT INTO `ressourcesType` (`id`, `ressourceType`) VALUES
(1, 'HardCurrency'),
(2, 'SoftCurrency'),
(5, 'DarkMatter'),
(8, 'gene1'),
(9, 'gene2'),
(10, 'gene3'),
(11, 'gene4'),
(12, 'gene5'),
(13, 'schema');

-- --------------------------------------------------------

--
-- Structure de la table `schemasUnlockRules`
--

CREATE TABLE IF NOT EXISTS `schemasUnlockRules` (
  `id` int(11) NOT NULL,
  `idRegion` int(11) NOT NULL,
  `idMission` int(11) NOT NULL,
  `idSchema` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Structure de la table `schemasXenos`
--

CREATE TABLE IF NOT EXISTS `schemasXenos` (
  `id` int(11) NOT NULL,
  `gene1` int(11) NOT NULL,
  `gene2` int(11) NOT NULL,
  `gene3` int(11) NOT NULL,
  `tableXenos` tinytext NOT NULL,
  `type` varchar(255) NOT NULL,
  `decryptTime` time NOT NULL,
  `skipHCCost` int(11) NOT NULL,
  `gene1quant` int(11) NOT NULL,
  `gene2quant` int(11) NOT NULL,
  `gene3quant` int(11) NOT NULL,
  `xenoName` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `schemasXenos`
--

INSERT INTO `schemasXenos` (`id`, `gene1`, `gene2`, `gene3`, `tableXenos`, `type`, `decryptTime`, `skipHCCost`, `gene1quant`, `gene2quant`, `gene3quant`, `xenoName`) VALUES
(1, 1, 3, 2, 'AlienEsthetique', 'Esthetique1', '00:00:06', 0, 300, 300, 300, 'Est1'),
(2, 4, 5, 1, 'AlienEsthetique', 'Esthetique2', '00:00:07', 0, 400, 400, 400, 'Est2'),
(3, 4, 5, 2, 'AlienEsthetique', 'Esthetique3', '00:00:05', 0, 600, 600, 600, 'Est3'),
(4, 3, 5, 4, 'AlienEsthetique', 'Esthetique4', '00:00:04', 0, 700, 700, 700, 'Est4'),
(5, 1, 2, 4, 'SpecialFeatureAliens', 'Basic1', '00:10:07', 0, 100, 100, 100, 'Bob'),
(6, 3, 2, 1, 'SpecialFeatureAliens', 'Basic2', '00:00:05', 0, 200, 200, 200, 'Teluop'),
(7, 5, 1, 2, 'SpecialFeatureAliens', 'Basic3', '00:00:04', 0, 300, 300, 300, 'Ertuol'),
(8, 3, 1, 2, 'SpecialFeatureAliens', 'LongRange1', '00:00:04', 0, 100, 100, 100, 'Suolubaf'),
(9, 1, 3, 5, 'SpecialFeatureAliens', 'LongRange2', '00:00:06', 0, 200, 200, 200, 'Elidocorc'),
(10, 4, 5, 3, 'SpecialFeatureAliens', 'LongRange3', '00:00:06', 0, 300, 300, 300, 'Epluop'),
(11, 2, 4, 1, 'SpecialFeatureAliens', 'Lave1', '00:00:06', 0, 200, 200, 200, 'Abmup'),
(12, 5, 1, 3, 'SpecialFeatureAliens', 'Lave2', '00:00:06', 0, 300, 300, 300, 'Nihcam'),
(13, 2, 1, 5, 'SpecialFeatureAliens', 'Lave3', '00:00:08', 0, 400, 400, 400, 'Cotsam'),
(14, 1, 2, 3, 'SpecialFeatureAliens', 'Heal1', '00:00:10', 0, 300, 300, 300, 'Revsorg'),
(15, 1, 5, 2, 'SpecialFeatureAliens', 'Heal2', '00:00:06', 0, 400, 400, 400, 'Blub'),
(16, 5, 3, 4, 'SpecialFeatureAliens', 'Heal3', '00:00:12', 0, 500, 500, 500, 'Tahcel'),
(17, 1, 3, 2, 'AlienProducer', 'Producer1', '00:00:08', 0, 100, 100, 100, 'Mik'),
(18, 3, 4, 1, 'AlienProducer', 'Producer2', '00:00:20', 0, 300, 300, 300, 'Xela'),
(19, 2, 1, 5, 'AlienProducer', 'Producer3', '00:00:12', 0, 500, 500, 500, 'Nimi'),
(20, 2, 1, 3, 'AlienBuffer', 'Buffer1', '00:00:21', 0, 100, 100, 100, 'Oeht'),
(21, 2, 5, 3, 'AlienBuffer', 'Buffer2', '00:00:04', 0, 300, 300, 300, 'Yrya'),
(22, 4, 1, 2, 'AlienBuffer', 'Buffer3', '00:00:06', 0, 200, 200, 200, 'Ecila');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `playerID` int(11) NOT NULL,
  `userName` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `eMail` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `confirmation_token` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_token` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `confirmed_at` date DEFAULT NULL,
  `reset_at` date DEFAULT NULL,
  `cookie_token` varchar(250) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `users`
--

INSERT INTO `users` (`id`, `playerID`, `userName`, `password`, `eMail`, `confirmation_token`, `reset_token`, `confirmed_at`, `reset_at`, `cookie_token`) VALUES
(23, 0, 'test2', '$2y$10$M/YCNJ5.yxJ3Q7etlVEP..xeA21Y7M6srHUxoq19fu3GBPmQaqaDO', 'test2@gmail.com', 'gIdd8F4sVFHKmcQ05yUmeD7bQeQK3mFIJSjoUfsaZ5dpJxdJwhMe4sJ5SpM8', NULL, NULL, NULL, '');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `AlienBuffer`
--
ALTER TABLE `AlienBuffer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `AlienEsthetique`
--
ALTER TABLE `AlienEsthetique`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `AlienForeur`
--
ALTER TABLE `AlienForeur`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `AlienProducer`
--
ALTER TABLE `AlienProducer`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `aliens`
--
ALTER TABLE `aliens`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `building`
--
ALTER TABLE `building`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `buildingType`
--
ALTER TABLE `buildingType`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `codex`
--
ALTER TABLE `codex`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `dailyReward`
--
ALTER TABLE `dailyReward`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `destructable`
--
ALTER TABLE `destructable`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `destructableType`
--
ALTER TABLE `destructableType`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `mission`
--
ALTER TABLE `mission`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `playerSchemas`
--
ALTER TABLE `playerSchemas`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `ressourcesType`
--
ALTER TABLE `ressourcesType`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `schemasUnlockRules`
--
ALTER TABLE `schemasUnlockRules`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `schemasXenos`
--
ALTER TABLE `schemasXenos`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `AlienBuffer`
--
ALTER TABLE `AlienBuffer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `AlienEsthetique`
--
ALTER TABLE `AlienEsthetique`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `AlienProducer`
--
ALTER TABLE `AlienProducer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `aliens`
--
ALTER TABLE `aliens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=307;
--
-- AUTO_INCREMENT pour la table `building`
--
ALTER TABLE `building`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=701;
--
-- AUTO_INCREMENT pour la table `buildingType`
--
ALTER TABLE `buildingType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT pour la table `codex`
--
ALTER TABLE `codex`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `dailyReward`
--
ALTER TABLE `dailyReward`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT pour la table `destructable`
--
ALTER TABLE `destructable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT pour la table `destructableType`
--
ALTER TABLE `destructableType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=27;
--
-- AUTO_INCREMENT pour la table `player`
--
ALTER TABLE `player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=87;
--
-- AUTO_INCREMENT pour la table `playerSchemas`
--
ALTER TABLE `playerSchemas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=76;
--
-- AUTO_INCREMENT pour la table `region`
--
ALTER TABLE `region`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `ressourcesType`
--
ALTER TABLE `ressourcesType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT pour la table `schemasUnlockRules`
--
ALTER TABLE `schemasUnlockRules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `schemasXenos`
--
ALTER TABLE `schemasXenos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=23;
--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
