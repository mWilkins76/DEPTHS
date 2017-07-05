-- phpMyAdmin SQL Dump
-- version 4.3.13.1
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Mer 11 Janvier 2017 à 22:06
-- Version du serveur :  5.6.25
-- Version de PHP :  5.6.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `rubis_alpha`
--

-- --------------------------------------------------------

--
-- Structure de la table `AlienDrill`
--

CREATE TABLE IF NOT EXISTS `AlienDrill` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `alienType` enum('driller','exploser','acrobat','magician') NOT NULL,
  `alienLevel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `alienPaddock`
--

CREATE TABLE IF NOT EXISTS `alienPaddock` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `idBuilding` int(11) NOT NULL,
  `alienType` enum('buffProducer','buffEnergy','buffSoftCurency','buffRange','buffTimer','buffDarkMatter','buffGenetic') NOT NULL,
  `alienName` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `layer` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `building`
--

INSERT INTO `building` (`id`, `idBuildingType`, `idPlayer`, `idRegion`, `regionX`, `regionY`, `x`, `y`, `mode`, `buildingEnd`, `currentLevel`, `type`, `globalX`, `globalY`, `layer`) VALUES
(33, 5, 5, 0, 0, 0, 9, 8, 'Constructing', '2017-01-11 22:57:57', 1, 'UrbanAntenna', 100, 850, 1);

-- --------------------------------------------------------

--
-- Structure de la table `buildingType`
--

CREATE TABLE IF NOT EXISTS `buildingType` (
  `id` int(11) NOT NULL,
  `buildingName` tinytext NOT NULL,
  `requiredPlayerLevel` int(11) NOT NULL,
  `category` enum('drill','urban','alien','cosmetic') NOT NULL,
  `softCurrencyCost` int(11) NOT NULL,
  `hardCurrencyCost` int(11) NOT NULL,
  `energyCost` int(11) NOT NULL,
  `ressourcesCost` int(11) NOT NULL,
  `upgradable` enum('yes','no') NOT NULL,
  `buildingTime` time NOT NULL,
  `SellingCost` int(11) NOT NULL,
  `skipCDcostHC` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `buildingType`
--

INSERT INTO `buildingType` (`id`, `buildingName`, `requiredPlayerLevel`, `category`, `softCurrencyCost`, `hardCurrencyCost`, `energyCost`, `ressourcesCost`, `upgradable`, `buildingTime`, `SellingCost`, `skipCDcostHC`) VALUES
(1, 'UrbanHeadQuarter', 1, 'urban', 10000, 8, 24, 350, 'yes', '01:00:00', 2500, 15),
(2, 'UrbanCommunication', 1, 'urban', 16000, 13, 8, 350, 'no', '02:10:00', 4000, 32),
(3, 'UrbanTranslation', 1, 'urban', 19500, 15, 8, 750, 'no', '02:30:00', 4875, 37),
(4, 'UrbanPowerStation', 1, 'urban', 10000, 8, 0, 650, 'yes', '01:00:00', 2500, 15),
(5, 'UrbanAntenna', 1, 'urban', 1000, 3, 0, 150, 'no', '00:01:00', 875, 1),
(6, 'DrillingCenter', 1, 'drill', 15000, 12, 16, 500, 'yes', '01:00:00', 3750, 15),
(7, 'DrillingOutPost', 1, 'drill', 5500, 4, 12, 150, 'yes', '00:30:00', 1375, 7),
(8, 'AlienPaddock1', 1, 'alien', 4000, 3, 4, 100, 'no', '00:10:00', 1000, 2),
(9, 'AlienPaddock2', 1, 'alien', 8000, 6, 8, 175, 'yes', '00:20:00', 2000, 5),
(10, 'AlienPaddock3', 1, 'alien', 10000, 8, 8, 200, 'yes', '00:25:00', 2500, 6),
(11, 'AlienPaddock4', 1, 'alien', 15000, 12, 10, 250, 'yes', '00:40:00', 3750, 10),
(12, 'AlienReseachCenter', 1, 'alien', 7500, 6, 14, 450, 'yes', '01:00:00', 1375, 15),
(13, 'AlienTrainingCenter', 1, 'alien', 25000, 20, 12, 1000, 'yes', '04:00:00', 6250, 60);

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
  `destuctionTime` datetime NOT NULL,
  `endOfDestructionTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `maxEnergy` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Contenu de la table `player`
--

INSERT INTO `player` (`id`, `idFb`, `langue`, `hardCurrency`, `softCurrency`, `ressource`, `currentEnergy`, `level`, `xp`, `FTUEsteps`, `maxEnergy`) VALUES
(1, '100001', 'fr', 0, 0, 500, 500, 1, 1, 0, 10),
(2, '101547', 'en', 1, 1, 1, 1, 1, 1, 1, 1),
(3, 'rzqr', 'en', 1, 1, 1, 1, 1, 1, 0, 1),
(5, '10154767559052348', 'en', 0, 5000, 0, 0, 0, 0, 0, 100);

-- --------------------------------------------------------

--
-- Structure de la table `region`
--

CREATE TABLE IF NOT EXISTS `region` (
  `id` int(11) NOT NULL,
  `idPlayer` int(11) NOT NULL,
  `x` int(11) NOT NULL,
  `y` int(11) NOT NULL,
  `unlocked` enum('yes','no') NOT NULL,
  `backgroundType` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Index pour la table `AlienDrill`
--
ALTER TABLE `AlienDrill`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `alienPaddock`
--
ALTER TABLE `alienPaddock`
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
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `AlienDrill`
--
ALTER TABLE `AlienDrill`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `alienPaddock`
--
ALTER TABLE `alienPaddock`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `building`
--
ALTER TABLE `building`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT pour la table `buildingType`
--
ALTER TABLE `buildingType`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=14;
--
-- AUTO_INCREMENT pour la table `codex`
--
ALTER TABLE `codex`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `destructable`
--
ALTER TABLE `destructable`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `player`
--
ALTER TABLE `player`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT pour la table `region`
--
ALTER TABLE `region`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
