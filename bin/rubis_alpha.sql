-- phpMyAdmin SQL Dump
-- version 4.2.12deb2+deb8u2
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Jeu 05 Janvier 2017 à 18:15
-- Version du serveur :  5.5.50-0+deb8u1
-- Version de PHP :  5.6.29-0+deb8u1

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
  `isInConstruction` enum('yes','no') NOT NULL,
  `buildingEnd` datetime NOT NULL,
  `currentLevel` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `buildingTime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
  `idFb` int(11) NOT NULL,
  `langue` enum('en','fr','','') NOT NULL,
  `hardCurrency` int(11) NOT NULL,
  `softCurrency` int(11) NOT NULL,
  `ressource` int(11) NOT NULL,
  `currentEnergy` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `xp` int(11) NOT NULL,
  `FTUEsteps:Int` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `buildingType`
--
ALTER TABLE `buildingType`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
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
