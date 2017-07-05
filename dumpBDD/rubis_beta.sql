-- phpMyAdmin SQL Dump
-- version 4.4.15.8
-- https://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Lun 13 Février 2017 à 09:09
-- Version du serveur :  5.6.31
-- Version de PHP :  5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données :  `rubis_beta`
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
  `time` time NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `AlienBuffer`
--

INSERT INTO `AlienBuffer` (`id`, `type`, `name`, `buffType`, `nbUpgrade`, `cost`, `upgradeCost1`, `upgradeCost2`, `upgradeCost3`, `upgradeTime1`, `upgradeTime2`, `upgradeTime3`, `levelReqUp1`, `levelReqUp2`, `levelReqUp3`, `buffCoef1`, `buffCoef2`, `buffCoef3`, `buffCoef4`, `time`) VALUES
(1, 'AlienBuffer', 'buffer1', 'energy', 2, 0, 3000, 9000, 0, '01:30:00', '02:40:00', '00:00:00', 17, 24, 0, 1, 2, 4, 0, '01:00:00'),
(2, 'AlienBuffer', 'buffer2', 'gene', 2, 0, 3000, 9000, 0, '01:30:00', '02:40:00', '00:00:00', 17, 24, 0, 1, 2, 4, 0, '01:00:00'),
(3, 'AlienBuffer', 'buffer3', 'mn', 2, 0, 3000, 9000, 0, '01:30:00', '02:40:00', '00:00:00', 17, 24, 0, 1, 2, 4, 0, '01:00:00');

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `AlienEsthetique`
--

INSERT INTO `AlienEsthetique` (`id`, `nomenclature`, `name`, `type`, `time`, `cost`) VALUES
(1, '', 'esthetique1', 'AlienEsthetique', '00:10:00', 0),
(2, '', 'esthetique2', 'AlienEsthetique', '00:36:30', 0),
(3, '', 'esthetique3', 'AlienEsthetique', '01:30:00', 0),
(4, '', 'esthetique4', 'AlienEsthetique', '02:20:00', 0);

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
(1, '', 'Basic1', 'AlienForeur', 'Driller', 10, '00:10:00', 0),
(2, '', 'Basic2', 'AlienForeur', 'Driller', 10, '00:10:00', 0),
(3, '', 'Basic3', 'AlienForeur', 'Driller', 10, '00:10:00', 0),
(4, '', 'LongRange1', 'AlienForeur', 'Bomber', 4, '00:36:30', 0),
(5, '', 'LongRange2', 'AlienForeur', 'Bomber', 4, '00:36:30', 0),
(6, '', 'LongRange3', 'AlienForeur', 'Bomber', 4, '00:36:30', 0),
(7, '', 'Lave1', 'AlienForeur', 'Tank', 6, '01:30:00', 0),
(8, '', 'Lave2', 'AlienForeur', 'Tank', 6, '01:30:00', 0),
(9, '', 'Lave3', 'AlienForeur', 'Tank', 6, '01:30:00', 0),
(10, '', 'Heal1', 'AlienForeur', 'Healer', 8, '02:20:00', 0),
(11, '', 'Heal2', 'AlienForeur', 'Healer', 8, '02:20:00', 0),
(12, '', 'Heal3', 'AlienForeur', 'Healer', 8, '02:20:00', 0);

-- --------------------------------------------------------

--
-- Structure de la table `AlienProducer`
--

CREATE TABLE IF NOT EXISTS `AlienProducer` (
  `id` int(11) NOT NULL,
  `type` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
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

INSERT INTO `AlienProducer` (`id`, `type`, `name`, `nbUpgrade`, `cost`, `upgradeCost1`, `upgradeCost2`, `upgradeCost3`, `upgradeTime1`, `upgradeTime2`, `upgradeTime3`, `levelReqUp1`, `levelReqUp2`, `levelReqUp3`, `time`, `maxProd`, `prodTime`, `prodByCycle`, `prodSpeed`) VALUES
(1, 'AlienProducer', 'Producteur1', 1, 0, 1000, 0, 0, '00:15:00', '00:00:00', '00:00:00', 8, 0, 0, '00:10:00', 500, 1, 50, 10),
(2, 'AlienProducer', 'Producteur2', 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0, '01:00:00', 5000, 1, 100, 60),
(3, 'AlienProducer', 'Producteur3', 2, 0, 3000, 9000, 0, '03:00:00', '05:25:00', '00:00:00', 17, 24, 0, '02:00:00', 2000, 1, 200, 10);

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `aliens`
--

INSERT INTO `aliens` (`id`, `idPlayer`, `idAlien`, `idBuilding`, `type`, `name`, `nomPropre`, `level`, `mode`, `startTime`, `endTime`, `stamina`) VALUES
(1, 11, 'Heal11486942040005', 'AlienIncubator1486925817258', 'AlienForeur', 'Heal1', '', 1, 'Constructing', '2017-02-13 00:27:20', '2017-02-13 02:47:20', 8);

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
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `building`
--

INSERT INTO `building` (`id`, `idBuildingType`, `idPlayer`, `idRegion`, `regionX`, `regionY`, `x`, `y`, `mode`, `buildingEnd`, `currentLevel`, `type`, `globalX`, `globalY`, `layer`, `buildingStart`, `buildingId`) VALUES
(242, 5, 11, 0, 0, 0, 10, 10, 'Wait', '2017-02-12 19:24:18', 1, 'UrbanAntenna', 0, 1000, 1, '2017-02-12 19:23:18', 'UrbanAntenna1486923798133'),
(243, 5, 11, 0, 0, 0, 0, 0, 'Wait', '2017-02-12 19:26:02', 1, 'UrbanAntenna', 0, 0, 1, '2017-02-12 19:25:02', 'UrbanAntenna1486923902202'),
(244, 16, 11, 0, 0, 0, 0, 2, 'Wait', '2017-02-12 20:36:57', 1, 'AlienIncubator', -200, 100, 1, '2017-02-12 19:56:57', 'AlienIncubator1486925817258'),
(245, 5, 11, 0, 0, 0, 19, 0, 'Wait', '2017-02-12 21:59:33', 1, 'UrbanAntenna', 1900, 950, 1, '2017-02-12 21:58:33', 'UrbanAntenna1486933113171'),
(246, 5, 11, 0, 0, 0, 0, 6, 'Wait', '2017-02-12 22:04:40', 1, 'UrbanAntenna', -600, 300, 1, '2017-02-12 22:03:40', 'UrbanAntenna1486933420086');

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
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `buildingType`
--

INSERT INTO `buildingType` (`id`, `buildingName`, `description`, `requiredPlayerLevel`, `category`, `softCurrencyCost`, `hardCurrencyCost`, `energyCost`, `ressourcesCost`, `buildingTime`, `SellingCost`, `skipCDcostHC`, `upgradeNumber`, `levelUpgrade1`, `levelUpgrade2`, `levelUpgrade3`, `upgradeTime1`, `upgradeTime2`, `upgradeTime3`, `upgradeCost1`, `upgradeCost2`, `upgradeCost3`) VALUES
(1, 'UrbanHeadQuarter', '', 1, 'urban', 10000, 8, 24, 350, '01:00:00', 2500, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(2, 'UrbanCommunication', '', 1, 'urban', 16000, 13, 8, 350, '02:10:00', 4000, 32, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(3, 'UrbanTranslation', '', 1, 'urban', 19500, 15, 8, 750, '02:30:00', 4875, 37, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(4, 'UrbanPowerStation', '', 1, 'urban', 10000, 8, 0, 650, '01:00:00', 2500, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(5, 'UrbanAntenna', '', 1, 'urban', 1000, 3, 0, 150, '00:01:00', 875, 1, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(6, 'DrillingCenter', '', 1, 'drill', 15000, 12, 16, 500, '01:00:00', 3750, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(7, 'DrillingOutPost', '', 1, 'drill', 5500, 4, 12, 150, '00:30:00', 1375, 7, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(8, 'AlienPaddockTiny', '', 1, 'alien', 4000, 3, 4, 100, '00:10:00', 1000, 2, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(9, 'AlienPaddockSmall', '', 1, 'alien', 8000, 6, 8, 175, '00:20:00', 2000, 5, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(10, 'AlienPaddockMedium', '', 1, 'alien', 10000, 8, 8, 200, '00:25:00', 2500, 6, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(11, 'AlienPaddockBig', '', 1, 'alien', 15000, 12, 10, 250, '00:40:00', 3750, 10, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(12, 'AlienResearchCenter', '', 1, 'alien', 7500, 6, 14, 450, '01:00:00', 1375, 15, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(13, 'AlienTrainingCenter', '', 1, 'alien', 25000, 20, 12, 1000, '04:00:00', 6250, 60, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(14, 'AlienPaddock', '', 1, 'alien', 500, 1, 1, 1, '00:02:00', 100, 1, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(15, 'DrillingAutoOutPost', '', 1, 'drill', 7500, 6, 8, 650, '01:15:00', 1875, 18, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(16, 'AlienIncubator', '', 1, 'alien', 12500, 10, 18, 300, '00:40:00', 3125, 10, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0),
(18, 'CosmeticBuilding', '', 1, 'cosmetic', 1000, 2, 0, 0, '00:00:00', 0, 0, 0, 0, 0, 0, '00:00:00', '00:00:00', '00:00:00', 0, 0, 0);

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `destructable`
--

INSERT INTO `destructable` (`id`, `idPlayer`, `idRegion`, `x`, `y`, `destructionTime`, `endOfDestructionTime`, `destructableId`, `layer`, `mode`, `type`, `idDestructableType`, `regionX`, `regionY`) VALUES
(1, 11, 0, 1, 2, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'DestructibleRock21486975221218', 1, 'Waiting', 'DestructibleRock2', 2, 0, -1),
(2, 11, 0, 9, 11, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'DestructibleRock71486975221217', 1, 'Waiting', 'DestructibleRock7', 7, 0, -1),
(3, 11, 0, 11, 2, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'DestructibleGeyser1486975221216', 1, 'Waiting', 'DestructibleGeyser', 11, 0, -1),
(4, 11, 0, 7, 4, '0000-00-00 00:00:00', '0000-00-00 00:00:00', 'DestructibleRock61486975221218', 1, 'Waiting', 'DestructibleRock6', 6, 0, -1);

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
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;

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
(11, 'DestructibleGeyser', 1000, '00:08:00', 5, 2, 2),
(12, 'DestructiblePebbles1', 1000, '00:08:00', 5, 2, 2),
(13, 'DestructiblePebbles2', 1000, '00:08:00', 5, 2, 2),
(14, 'DestructiblePebbles3', 1000, '00:08:00', 5, 2, 2);

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
  `gene5` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `player`
--

INSERT INTO `player` (`id`, `idFb`, `langue`, `hardCurrency`, `softCurrency`, `ressource`, `currentEnergy`, `level`, `xp`, `FTUEsteps`, `maxEnergy`, `gene1`, `gene2`, `gene3`, `gene4`, `gene5`) VALUES
(11, '1263140297079103', 'en', 49905, 456750, 496770, 120, 6, 520, 0, 265, 1700, 1700, 1700, 1000, 1000);

-- --------------------------------------------------------

--
-- Structure de la table `region`
--

CREATE TABLE IF NOT EXISTS `region` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `region`
--

INSERT INTO `region` (`id`, `idPlayer`, `x`, `y`) VALUES
(11, 11, 1, 0),
(12, 11, 0, -1);

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
  `type` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `schemasXenos`
--

INSERT INTO `schemasXenos` (`id`, `gene1`, `gene2`, `gene3`, `tableXenos`, `type`) VALUES
(1, 4, 3, 2, 'AlienEsthetique', 'Esthetique1'),
(2, 4, 5, 1, 'AlienEsthetique', 'Esthetique2'),
(3, 4, 5, 2, 'AlienEsthetique', 'Esthetique3'),
(4, 3, 5, 4, 'AlienEsthetique', 'Esthetique4'),
(5, 1, 2, 4, 'SpecialFeatureAliens', 'Basic1'),
(6, 3, 2, 1, 'SpecialFeatureAliens', 'Basic2'),
(7, 5, 1, 2, 'SpecialFeatureAliens', 'Basic3'),
(8, 3, 1, 2, 'SpecialFeatureAliens', 'LongRange1'),
(9, 1, 3, 5, 'SpecialFeatureAliens', 'LongRange2'),
(10, 4, 5, 3, 'SpecialFeatureAliens', 'LongRange3'),
(11, 2, 4, 1, 'SpecialFeatureAliens', 'Lave1'),
(12, 5, 1, 3, 'SpecialFeatureAliens', 'Lave2'),
(13, 2, 1, 5, 'SpecialFeatureAliens', 'Lave3'),
(14, 1, 2, 3, 'SpecialFeatureAliens', 'Heal1'),
(15, 1, 5, 2, 'SpecialFeatureAliens', 'Heal2'),
(16, 5, 3, 4, 'SpecialFeatureAliens', 'Heal3'),
(17, 1, 3, 2, 'AlienProducer', 'Producteur1'),
(18, 3, 4, 1, 'AlienProducer', 'Producteur2'),
(19, 2, 1, 5, 'AlienProducer', 'Producteur3'),
(20, 2, 1, 3, 'AlienBuffer', 'buffer1'),
(21, 2, 5, 3, 'AlienBuffer', 'buffer2'),
(22, 4, 1, 2, 'AlienBuffer', 'buffer3');

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
-- Index pour la table `player`
--
ALTER TABLE `player`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `region`
--
ALTER TABLE `region`
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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT pour la table `AlienProducer`
--
ALTER TABLE `AlienProducer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT pour la table `aliens`
--
ALTER TABLE `aliens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT pour la table `building`
--
ALTER TABLE `building`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=247;
--
-- AUTO_INCREMENT pour la table `buildingType`
--
ALTER TABLE `buildingType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=19;
--
-- AUTO_INCREMENT pour la table `codex`
--
ALTER TABLE `codex`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `destructable`
--
ALTER TABLE `destructable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT pour la table `destructableType`
--
ALTER TABLE `destructableType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT pour la table `player`
--
ALTER TABLE `player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT pour la table `region`
--
ALTER TABLE `region`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
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
