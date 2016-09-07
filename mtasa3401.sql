-- phpMyAdmin SQL Dump
-- version 3.3.7deb10
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Czas wygenerowania: 07 Wrz 2016, 17:25
-- Wersja serwera: 5.1.73
-- Wersja PHP: 5.3.3-7+squeeze28

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Baza danych: `mtasa3401`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla  `rpg_accounts`
--

CREATE TABLE IF NOT EXISTS `rpg_accounts` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `username` text COLLATE utf8_polish_ci NOT NULL,
  `password` text COLLATE utf8_polish_ci NOT NULL,
  `email` text COLLATE utf8_polish_ci NOT NULL,
  `regdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastlogin` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `serial` text COLLATE utf8_polish_ci NOT NULL,
  `ip` text COLLATE utf8_polish_ci NOT NULL,
  `health` int(11) NOT NULL DEFAULT '100',
  `armor` int(11) NOT NULL DEFAULT '0',
  `skin` int(11) NOT NULL DEFAULT '0',
  `position` text COLLATE utf8_polish_ci NOT NULL COMMENT 'x,y,z,rz,i,d',
  `money` int(11) NOT NULL DEFAULT '0',
  `bankmoney` int(11) NOT NULL DEFAULT '0',
  `gamescore` int(11) NOT NULL DEFAULT '0',
  `premium` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `job` int(11) NOT NULL DEFAULT '0',
  `jobmoney` int(11) NOT NULL DEFAULT '0',
  `pjA` int(11) NOT NULL DEFAULT '0',
  `pjB` int(11) NOT NULL DEFAULT '0',
  `pjC` int(11) NOT NULL DEFAULT '0',
  `onlinetime` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=5 ;

--
-- Zrzut danych tabeli `rpg_accounts`
--

INSERT INTO `rpg_accounts` (`uid`, `username`, `password`, `email`, `regdate`, `lastlogin`, `serial`, `ip`, `health`, `armor`, `skin`, `position`, `money`, `bankmoney`, `gamescore`, `premium`, `job`, `jobmoney`, `pjA`, `pjB`, `pjC`, `onlinetime`) VALUES
(1, 'value', '5ac4c7205f2bdc5bc45348eb0c820dd7', 'value2k@gmail.com', '2016-08-23 11:15:29', '0000-00-00 00:00:00', '1F36F20E57028600C193191B83BB8483', '192.168.56.1', 100, 0, 39, '-1900.9326171875, 928.6376953125, 34.728317260742, 90.06591796875, 0, 0', 90487, 44321, 223, '2018-08-29 17:00:00', 0, 0, 1, 1, 1, 104952),
(2, 'DreamsXX2PL', 'F801E0458851628209F1B4F65825FCCB', 'dreamsxx2@wp.pl', '2016-08-27 17:27:23', '0000-00-00 00:00:00', '85B995F2E0AA6921EBE8DA27AC85FCA1', '88.199.45.108', 100, 0, 81, '2724.169921875, -2122.9501953125, 26.212211608887, 111.52117919922, 0, 0', 0, 128374, 0, '2019-08-27 00:00:00', 0, 0, 1, 1, 1, 24317),
(3, 'AL0N', '202CB962AC59075B964B07152D234B70', 'yosukestream@gmail.com', '2016-08-28 11:05:35', '0000-00-00 00:00:00', '75137E78BF9493EDC2D214722770B053', '77.254.34.86', 100, 0, 37, '-1812.4345703125, 920.5615234375, 24.447202682495, 272.74725341797, 0, 0', 99994728, 0, 0, '2018-08-29 00:00:00', 0, 0, 1, 1, 0, 30676),
(4, 'Karuzo', '2A10AB244BD9AAF776832117BF7E69F2', 'Majkel6023@onet.pl', '2016-08-31 16:38:29', '0000-00-00 00:00:00', '67B39C8BA7CD6254002C2BD0D25B36F2', '37.47.8.187', 94, 0, 33, '-2710.193359375, 357.1572265625, 4.0733036994934, 203.03297424316, 0, 0', 654, 0, 0, '0000-00-00 00:00:00', 2, 89, 0, 1, 1, 7150);

-- --------------------------------------------------------

--
-- Struktura tabeli dla  `rpg_admins`
--

CREATE TABLE IF NOT EXISTS `rpg_admins` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `pmoney` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do komend pieniędzy (give,set,take)',
  `tp` int(11) NOT NULL DEFAULT '0' COMMENT 'Tp do pojazdów/graczy',
  `res` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do zasobu (start,stop,restart,refresh)',
  `pkary` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do nakładania kar (kick,ban,warn,etc.)',
  `vdata` int(11) NOT NULL DEFAULT '0' COMMENT 'Zarządzanie podstawowymi danymi pojazd (przebieg,paliwo,hp,etc.)',
  `vtuning` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do zarządzania tuningiem pojazdu',
  `pgs` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do zarządzania punktami GS gracza',
  `ppj` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do zarządzania prawem jazdy gracza',
  `pdata` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do zarządzania podstawowymi elementami gracza (skin, etc.)',
  `echo` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do podsłuchu graczy',
  `ahud` int(11) NOT NULL DEFAULT '0' COMMENT 'Hud admina z informacjami o graczach',
  `gchat` int(11) NOT NULL DEFAULT '0' COMMENT 'Dostęp do czatu globalnego',
  `devmode` int(11) NOT NULL DEFAULT '0' COMMENT 'Tryb developera',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=4 ;

--
-- Zrzut danych tabeli `rpg_admins`
--

INSERT INTO `rpg_admins` (`uid`, `user`, `level`, `pmoney`, `tp`, `res`, `pkary`, `vdata`, `vtuning`, `pgs`, `ppj`, `pdata`, `echo`, `ahud`, `gchat`, `devmode`) VALUES
(1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
(3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);

-- --------------------------------------------------------

--
-- Struktura tabeli dla  `rpg_bany`
--

CREATE TABLE IF NOT EXISTS `rpg_bany` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) NOT NULL,
  `serial` text NOT NULL,
  `admin` int(11) NOT NULL,
  `reason` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `enddate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=7 ;

--
-- Zrzut danych tabeli `rpg_bany`
--

INSERT INTO `rpg_bany` (`uid`, `userid`, `serial`, `admin`, `reason`, `date`, `enddate`) VALUES
(6, 3, '75137E78BF9493EDC2D214722770B053', 1, 'test, xd', '2016-08-30 13:06:44', '2016-08-30 13:07:44');

-- --------------------------------------------------------

--
-- Struktura tabeli dla  `rpg_interiors`
--

CREATE TABLE IF NOT EXISTS `rpg_interiors` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8_polish_ci NOT NULL,
  `en_marker` text COLLATE utf8_polish_ci NOT NULL COMMENT 'x,y,z,i,d - miejsce markera wejscia',
  `en_tp` text COLLATE utf8_polish_ci NOT NULL COMMENT 'x,y,z,rz,i,d - miejsce gdzie nas marker wejscia tepnie',
  `ex_marker` text COLLATE utf8_polish_ci NOT NULL COMMENT 'x,y,z,i,d - miejsce markera wyjscia',
  `ex_tp` text COLLATE utf8_polish_ci NOT NULL COMMENT 'x,y,z,rz,i,d - miejsce gdzie nas marker wyjscia tepnie',
  `locked` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci AUTO_INCREMENT=4 ;

--
-- Zrzut danych tabeli `rpg_interiors`
--

INSERT INTO `rpg_interiors` (`uid`, `name`, `en_marker`, `en_tp`, `ex_marker`, `ex_tp`, `locked`) VALUES
(1, 'Victim', '-1694.16882, 951.03772, 24.89063, 0, 0', '226.0615234375, -8.099609375, 1002.2109375, 90, 5, 1', '227.5634765625, -8.1005859375, 1002.2109375, 5, 1', '-1696.09070, 949.49786, 24.89063, 133, 0, 0', 0),
(2, 'Szkoła jazdy', '-2026.513671875, -102.0654296875, 35.1640625, 0, 0', '-2029.7265625, -118.59375, 1035.171875, 0, 3, 2', '-2029.8154296875, -119.623046875, 1035.171875, 3, 2', '-2026.724609375, -99.6015625, 35.1640625, 0, 0, 0', 0),
(3, 'Urząd miasta', '-2766.55078125, 375.552734375, 6.3346824645996, 0, 0', '-2773.1000976563, 367.39999389648, 98.900001525879, 90, 69, 3', '-2771.8999023438, 367.39999389648, 98.900001525879, 69, 3', '-2764.8212890625, 375.6005859375, 6.3423900604248, 270, 0, 0', 0);

-- --------------------------------------------------------

--
-- Struktura tabeli dla  `rpg_serials`
--

CREATE TABLE IF NOT EXISTS `rpg_serials` (
  `serial` text COLLATE utf8_polish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;

--
-- Zrzut danych tabeli `rpg_serials`
--

INSERT INTO `rpg_serials` (`serial`) VALUES
('1F36F20E57028600C193191B83BB8483'),
('75137E78BF9493EDC2D214722770B053'),
('85B995F2E0AA6921EBE8DA27AC85FCA1'),
('67B39C8BA7CD6254002C2BD0D25B36F2');

-- --------------------------------------------------------

--
-- Struktura tabeli dla  `rpg_vehicles`
--

CREATE TABLE IF NOT EXISTS `rpg_vehicles` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `model` int(11) NOT NULL,
  `owner` int(11) NOT NULL,
  `przecho` int(11) NOT NULL DEFAULT '1',
  `pos` text NOT NULL COMMENT 'x,y,z,rx,ry,rz,i,d',
  `plate` text NOT NULL,
  `upgrades` text NOT NULL,
  `distance` int(11) NOT NULL DEFAULT '0',
  `color1` text NOT NULL,
  `color2` text NOT NULL,
  `color3` text NOT NULL,
  `color4` text NOT NULL,
  PRIMARY KEY (`uid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin2 AUTO_INCREMENT=5 ;

--
-- Zrzut danych tabeli `rpg_vehicles`
--

INSERT INTO `rpg_vehicles` (`uid`, `model`, `owner`, `przecho`, `pos`, `plate`, `upgrades`, `distance`, `color1`, `color2`, `color3`, `color4`) VALUES
(1, 604, 1, 0, '-1546.921875, 931.4814453125, 6.7423343658447, 0.0054931640625, 359.9560546875, 62.149658203125, 0, 0', '', '1001, 1080, 1020', 118271, '0, 0, 0', '0, 0, 0', '0, 0, 0', '0, 0, 0'),
(2, 604, 3, 1, '-2436.251953125, 1034.2646484375, 50.094638824463, 358.91235351562, 358.154296875, 167.57446289062, 0, 0', '', '', 70618, '123, 10, 42', '0, 0, 0', '0, 0, 0', '0, 0, 0'),
(3, 491, 2, 1, '-2022.283203125, 158.4658203125, 28.366491317749, 185.42724609375, 0.1702880859375, 9.7283935546875, 0, 0', '', '', 118945, '34, 25, 24', '0, 0, 0', '0, 0, 0', '0, 0, 0'),
(4, 491, 1, 1, '-2437.8583984375, 1034.2001953125, 50.143615722656, 359.23645019531, 5.9710693359375, 153.68225097656, 0, 0', '', '', 92771, '77, 98, 104', '0, 0, 0', '0, 0, 0', '0, 0, 0');
