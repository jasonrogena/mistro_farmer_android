-- phpMyAdmin SQL Dump
-- version 3.5.8.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Sep 02, 2013 at 01:02 PM
-- Server version: 5.5.32-0ubuntu0.13.04.1
-- PHP Version: 5.4.9-4ubuntu2.2

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ilri_mistro`
--

-- --------------------------------------------------------

--
-- Table structure for table `breed`
--

CREATE TABLE IF NOT EXISTS `breed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cow_id` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cow_id` (`cow_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `breed`
--

INSERT INTO `breed` (`id`, `cow_id`, `text`, `date_added`) VALUES
(1, 26, 'Friesian', '2013-08-09 16:14:07');

-- --------------------------------------------------------

--
-- Table structure for table `cow`
--

CREATE TABLE IF NOT EXISTS `cow` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `farmer_id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ear_tag_number` varchar(255) NOT NULL,
  `date_of_birth` datetime DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `age_type` int(11) DEFAULT NULL COMMENT '0 for day, 1 for weeks, 2 for years',
  `sex` int(11) NOT NULL COMMENT '0 for female, 1 for male',
  `type` varchar(100) DEFAULT NULL,
  `sire_id` int(11) DEFAULT NULL,
  `dam_id` int(11) DEFAULT NULL,
  `service_type` int(11) DEFAULT NULL COMMENT '0=bull/cow, 1=AI/ET',
  `straw_number` varchar(100) DEFAULT NULL,
  `vet_used` varchar(255) DEFAULT NULL,
  `embryo_number` varchar(100) DEFAULT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `farmer_id_2` (`farmer_id`,`name`),
  KEY `farmer_id` (`farmer_id`),
  KEY `sire_id` (`sire_id`),
  KEY `dam_id` (`dam_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=27 ;

--
-- Dumping data for table `cow`
--

INSERT INTO `cow` (`id`, `farmer_id`, `name`, `ear_tag_number`, `date_of_birth`, `age`, `age_type`, `sex`, `type`, `sire_id`, `dam_id`, `service_type`, `straw_number`, `vet_used`, `embryo_number`, `date_added`) VALUES
(26, 40, 'Rosy', 'ros1', '0000-00-00 00:00:00', 2, 2, 0, 'cow', NULL, NULL, NULL, NULL, NULL, NULL, '2013-08-09 16:14:07');

-- --------------------------------------------------------

--
-- Table structure for table `cow_event`
--

CREATE TABLE IF NOT EXISTS `cow_event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cow_id` int(11) NOT NULL,
  `event_id` int(11) NOT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `event_date` date NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cow_id` (`cow_id`,`event_id`),
  KEY `event_id` (`event_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `cow_event`
--

INSERT INTO `cow_event` (`id`, `cow_id`, `event_id`, `remarks`, `event_date`, `date_added`) VALUES
(1, 26, 1, 'Test', '0000-00-00', '2013-09-02 12:13:01'),
(2, 26, 1, 'Test', '2013-08-28', '2013-09-02 12:15:49'),
(3, 26, 1, 'Test', '2013-08-22', '2013-09-02 12:16:21'),
(4, 26, 5, 'Test', '2013-08-22', '2013-09-02 12:17:42'),
(5, 26, 1, 'Test 2', '2013-08-28', '2013-09-02 12:47:05'),
(6, 26, 1, '', '2013-09-02', '2013-09-02 12:55:23');

-- --------------------------------------------------------

--
-- Table structure for table `deformity`
--

CREATE TABLE IF NOT EXISTS `deformity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cow_id` int(11) NOT NULL,
  `text` varchar(255) NOT NULL,
  `date_added` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `cow_id` (`cow_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=2 ;

--
-- Dumping data for table `deformity`
--

INSERT INTO `deformity` (`id`, `cow_id`, `text`, `date_added`) VALUES
(1, 26, '', '2013-08-09 16:14:07');

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

CREATE TABLE IF NOT EXISTS `event` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `event`
--

INSERT INTO `event` (`id`, `name`) VALUES
(1, 'Abortion'),
(2, 'Birth'),
(3, 'Lactation'),
(4, 'Bloat'),
(5, 'Sickness'),
(6, 'Death');

-- --------------------------------------------------------

--
-- Table structure for table `farmer`
--

CREATE TABLE IF NOT EXISTS `farmer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `mobile_no` varchar(50) NOT NULL,
  `location_county` varchar(255) DEFAULT NULL,
  `location_district` varchar(255) DEFAULT NULL,
  `gps_longitude` varchar(15) DEFAULT NULL,
  `gps_latitude` varchar(15) DEFAULT NULL,
  `date_added` datetime NOT NULL,
  `extension_personnel` varchar(255) DEFAULT NULL,
  `sim_card_sn` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mobile_no` (`mobile_no`),
  UNIQUE KEY `sim_card_sn` (`sim_card_sn`),
  KEY `sim_card_sn_2` (`sim_card_sn`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=41 ;

--
-- Dumping data for table `farmer`
--

INSERT INTO `farmer` (`id`, `name`, `mobile_no`, `location_county`, `location_district`, `gps_longitude`, `gps_latitude`, `date_added`, `extension_personnel`, `sim_card_sn`) VALUES
(40, 'Jason Rogena', '0715023805', NULL, NULL, '36.720797605812', '-1.267220000736', '2013-08-09 16:14:07', 'Frank Makau', '89254029541005994303');

-- --------------------------------------------------------

--
-- Table structure for table `milk_production`
--

CREATE TABLE IF NOT EXISTS `milk_production` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cow_id` int(11) NOT NULL,
  `time` int(11) NOT NULL COMMENT '0 - morning, 1 - afternoot, 2 - evening, 3 - combined',
  `quantity` int(11) NOT NULL,
  `date_added` datetime NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `cow_id_2` (`cow_id`,`time`,`date`),
  KEY `cow_id` (`cow_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `milk_production`
--

INSERT INTO `milk_production` (`id`, `cow_id`, `time`, `quantity`, `date_added`, `date`) VALUES
(3, 26, 1, 12, '2013-08-11 10:19:53', '2013-08-11'),
(6, 26, 0, 10, '2013-08-12 12:41:39', '2013-08-12'),
(7, 26, 0, 12, '2013-08-21 12:15:13', '2013-08-21'),
(9, 26, 3, 12, '2013-08-21 12:16:16', '2013-08-21'),
(10, 26, 1, 1, '2013-08-22 13:46:40', '2013-08-22');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `breed`
--
ALTER TABLE `breed`
  ADD CONSTRAINT `breed_ibfk_1` FOREIGN KEY (`cow_id`) REFERENCES `cow` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `cow`
--
ALTER TABLE `cow`
  ADD CONSTRAINT `cow_ibfk_1` FOREIGN KEY (`farmer_id`) REFERENCES `farmer` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cow_ibfk_2` FOREIGN KEY (`sire_id`) REFERENCES `cow` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `cow_event`
--
ALTER TABLE `cow_event`
  ADD CONSTRAINT `cow_event_ibfk_1` FOREIGN KEY (`cow_id`) REFERENCES `cow` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `cow_event_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `event` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `deformity`
--
ALTER TABLE `deformity`
  ADD CONSTRAINT `deformity_ibfk_1` FOREIGN KEY (`cow_id`) REFERENCES `cow` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `milk_production`
--
ALTER TABLE `milk_production`
  ADD CONSTRAINT `milk_production_ibfk_1` FOREIGN KEY (`cow_id`) REFERENCES `cow` (`id`) ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
