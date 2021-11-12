-- MySQL dump 10.13  Distrib 5.7.24, for Linux (x86_64)
--
-- Host: localhost    Database: pyr_nevetica_dev
-- ------------------------------------------------------
-- Server version	5.7.24-0ubuntu0.18.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `audits`
--

DROP TABLE IF EXISTS `audits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auditable_id` int(11) DEFAULT NULL,
  `auditable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `associated_id` int(11) DEFAULT NULL,
  `associated_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `audited_changes` text COLLATE utf8_unicode_ci,
  `version` int(11) DEFAULT '0',
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remote_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `request_uuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `auditable_index` (`auditable_id`,`auditable_type`),
  KEY `associated_index` (`associated_id`,`associated_type`),
  KEY `user_index` (`user_id`,`user_type`),
  KEY `index_audits_on_request_uuid` (`request_uuid`),
  KEY `index_audits_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `checksums`
--

DROP TABLE IF EXISTS `checksums`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checksums` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sha1sum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data` mediumtext COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ckeditor_assets`
--

DROP TABLE IF EXISTS `ckeditor_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ckeditor_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `data_file_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_file_size` int(11) DEFAULT NULL,
  `assetable_id` int(11) DEFAULT NULL,
  `assetable_type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iso2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iso3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numcode` int(11) DEFAULT NULL,
  `telephone_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `delayed_jobs`
--

DROP TABLE IF EXISTS `delayed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `delayed_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT '0',
  `attempts` int(11) DEFAULT '0',
  `handler` longtext COLLATE utf8_unicode_ci,
  `last_error` text COLLATE utf8_unicode_ci,
  `run_at` datetime DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `failed_at` datetime DEFAULT NULL,
  `locked_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `queue` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etl_account_users`
--

DROP TABLE IF EXISTS `etl_account_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `etl_account_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `distributor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `full_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `home_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enrollment_date` date DEFAULT NULL,
  `termination_date` date DEFAULT NULL,
  `distributor_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pvq_flag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `renewal_date` date DEFAULT NULL,
  `requalification_flag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `associate_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank_promotion_date` date DEFAULT NULL,
  `pv` decimal(10,2) DEFAULT '0.00',
  `gv` decimal(10,2) DEFAULT '0.00',
  `pgpv` decimal(10,2) DEFAULT '0.00',
  `points_needed` int(11) DEFAULT NULL,
  `sponsor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sponsor_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_login_date` date DEFAULT NULL,
  `contact_flag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `max_associate_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nickname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_order_date` date DEFAULT NULL,
  `website_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website_expdate` date DEFAULT NULL,
  `subscription_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `website_signupdate` date DEFAULT NULL,
  `min_purchase_flag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `startupoption` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `option3purchaseflag` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `option3purchasedate` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twv` decimal(10,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etl_properties`
--

DROP TABLE IF EXISTS `etl_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `etl_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `etl_volume`
--

DROP TABLE IF EXISTS `etl_volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `etl_volume` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `distributor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `period_id` int(11) DEFAULT NULL,
  `pwv` decimal(10,2) DEFAULT '0.00',
  `gwv` decimal(10,2) DEFAULT '0.00',
  `newplan_paid_as` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `newplan_badge_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `newplan_title_date` date DEFAULT NULL,
  `safetynet_paid_as` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `safetynet_badge_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active_legs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `downline_sales` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plan_total` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `earnings_calculation_under_pre_plan` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pct_adjustment_supplement` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total_eligible_earnings_under_pre_plan` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `safety_net_amount_paid_by_cl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total_earnings` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adjustments` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `earning_total` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `white_car_eligible` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `white_months_qualified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `car_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pre_car_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `silver_car_eligible` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `silver_months_qualified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `silver_car_qualified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `black_car_eilgible` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `black_months_qualified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `black_car_qualified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lease_submitted` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `um1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `um2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ed1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ed3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sed` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nd` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_year_ed1s` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `promote_up_date` date DEFAULT NULL,
  `twelve_month_pwv` decimal(10,2) DEFAULT '0.00',
  `legs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `commission` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sponsor_default_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `white_car_qualified` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dirlegs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ed2legs` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recruit_value_12` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `requalify_date` date DEFAULT NULL,
  `promote_up_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total_quickstarts_recruit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `career_recruit` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dgt_points` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `region` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `true_structure_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `event_request_refreshers`
--

DROP TABLE IF EXISTS `event_request_refreshers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_request_refreshers` (
  `event_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `event_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`event_id`,`event_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `follows`
--

DROP TABLE IF EXISTS `follows`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `follows` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `followable_id` int(11) NOT NULL,
  `followable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `follower_id` int(11) NOT NULL,
  `follower_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `blocked` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_follows` (`follower_id`,`follower_type`),
  KEY `fk_followables` (`followable_id`,`followable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `fresh_benies`
--

DROP TABLE IF EXISTS `fresh_benies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fresh_benies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_id` int(11) DEFAULT NULL,
  `method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `card_number` int(11) DEFAULT NULL,
  `card_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friendly_id_slugs`
--

DROP TABLE IF EXISTS `friendly_id_slugs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `friendly_id_slugs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sluggable_id` int(11) NOT NULL,
  `sluggable_type` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope` (`slug`,`sluggable_type`,`scope`),
  KEY `index_friendly_id_slugs_on_sluggable_id` (`sluggable_id`),
  KEY `index_friendly_id_slugs_on_slug_and_sluggable_type` (`slug`,`sluggable_type`),
  KEY `index_friendly_id_slugs_on_sluggable_type` (`sluggable_type`),
  KEY `index_friendly_id_slugs_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `languages`
--

DROP TABLE IF EXISTS `languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iso2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=137 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `limit_definitions`
--

DROP TABLE IF EXISTS `limit_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `limit_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `aspect` varchar(50) COLLATE utf8_unicode_ci DEFAULT 'default',
  `role` varchar(50) COLLATE utf8_unicode_ci DEFAULT 'default',
  `interval_expression` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interval_seconds` int(11) DEFAULT NULL,
  `allowance` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_limit_definitions_on_aspect_and_role_and_interval_seconds` (`aspect`,`role`,`interval_seconds`),
  KEY `index_limit_definitions_on_aspect_and_role` (`aspect`,`role`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `old_passwords`
--

DROP TABLE IF EXISTS `old_passwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `old_passwords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password_salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_archivable_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `password_archivable_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_password_archivable` (`password_archivable_type`,`password_archivable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_abuse_histories`
--

DROP TABLE IF EXISTS `pyr_abuse_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_abuse_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_abuse_histories_on_user_id` (`user_id`),
  KEY `index_pyr_abuse_histories_on_target_id_and_target_type` (`target_id`,`target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_abuse_report_actions`
--

DROP TABLE IF EXISTS `pyr_abuse_report_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_abuse_report_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `abuse_item_id` int(11) DEFAULT NULL,
  `abuse_item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_reported` datetime DEFAULT NULL,
  `date_of_action` datetime DEFAULT NULL,
  `action_taken` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `to` text COLLATE utf8_unicode_ci,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reason` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_pyr_abuse_report_actions_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_abuse_reports`
--

DROP TABLE IF EXISTS `pyr_abuse_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_abuse_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `abuse_reason` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_abuse_reports_on_user_id` (`user_id`),
  KEY `index_pyr_abuse_reports_on_target_id_and_target_type` (`target_id`,`target_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_action_chain_steps`
--

DROP TABLE IF EXISTS `pyr_action_chain_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_action_chain_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `deferred_action_chain_id` int(11) DEFAULT NULL,
  `waiting_on_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `waiting_on_id` int(11) DEFAULT NULL,
  `step_number` int(11) DEFAULT NULL,
  `continuation_strategy` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `continued_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pyr_action_chain_waiting_on` (`waiting_on_type`,`waiting_on_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_activities`
--

DROP TABLE IF EXISTS `pyr_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `trackable_id` int(11) DEFAULT NULL,
  `trackable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `visibility_id` int(11) DEFAULT NULL,
  `flags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_activities_on_user_id` (`user_id`),
  KEY `index_pyr_activities_on_trackable_id` (`trackable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_addresses`
--

DROP TABLE IF EXISTS `pyr_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_primary_address` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `address3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_addresses_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_admin_exams`
--

DROP TABLE IF EXISTS `pyr_admin_exams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_admin_exams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `training_series_id` int(11) DEFAULT NULL,
  `question_group_id` int(11) DEFAULT NULL,
  `is_certification` tinyint(1) DEFAULT NULL,
  `percentage` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_admin_faqs`
--

DROP TABLE IF EXISTS `pyr_admin_faqs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_admin_faqs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` text COLLATE utf8_unicode_ci,
  `answer` text COLLATE utf8_unicode_ci,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `faq_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_app_settings`
--

DROP TABLE IF EXISTS `pyr_app_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_app_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_asset_shares`
--

DROP TABLE IF EXISTS `pyr_asset_shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_asset_shares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_id` int(11) DEFAULT NULL,
  `asset_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `containable_id` int(11) DEFAULT NULL,
  `containable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_asset_shares_on_asset_type_and_asset_id` (`asset_type`,`asset_id`),
  KEY `index_pyr_asset_shares_on_containable_type_and_containable_id` (`containable_type`,`containable_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_authentications`
--

DROP TABLE IF EXISTS `pyr_authentications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_authentications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `uid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token_secret` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `profile_pic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `opts` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_background_jobs`
--

DROP TABLE IF EXISTS `pyr_background_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_background_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `job_uuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `job_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Queued',
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_background_jobs_on_job_uuid` (`job_uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_badword_emails`
--

DROP TABLE IF EXISTS `pyr_badword_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_badword_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_badword_phrases`
--

DROP TABLE IF EXISTS `pyr_badword_phrases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_badword_phrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phrasable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `phrasable_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_badwords`
--

DROP TABLE IF EXISTS `pyr_badwords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_badwords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `values` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `display_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'default',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_banner_positions`
--

DROP TABLE IF EXISTS `pyr_banner_positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_banner_positions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  `market_language_id` int(11) DEFAULT NULL,
  `banner_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_banners`
--

DROP TABLE IF EXISTS `pyr_banners`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `banner_type` int(11) DEFAULT '0',
  `banner_kind` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `video_text` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_billing_details`
--

DROP TABLE IF EXISTS `pyr_billing_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_billing_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name_on_card` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `card_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expiration_month` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expiration_year` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subscription_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_billing_details_on_subscription_id` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_billing_histories`
--

DROP TABLE IF EXISTS `pyr_billing_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_billing_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `next_billing_date` datetime DEFAULT NULL,
  `entry_date` datetime DEFAULT NULL,
  `billing_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prev_next_billing_date` datetime DEFAULT NULL,
  `billing_cycle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `merchant_gateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pg_transaction_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `ran_by` int(11) DEFAULT NULL,
  `subscription_plan_id` int(11) DEFAULT NULL,
  `transaction_type` int(11) DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `plan_price` decimal(10,2) DEFAULT NULL,
  `plan_setup_fee` decimal(10,2) DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_pyr_billing_histories_on_subscription_id` (`subscription_id`),
  KEY `index_pyr_billing_histories_on_user_id` (`user_id`),
  KEY `index_pyr_billing_histories_on_pg_transaction_id` (`pg_transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_blockable_fields`
--

DROP TABLE IF EXISTS `pyr_blockable_fields`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_blockable_fields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `blocked` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_blog_images`
--

DROP TABLE IF EXISTS `pyr_blog_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_blog_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `image_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumb_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `post_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_blogs`
--

DROP TABLE IF EXISTS `pyr_blogs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_blogs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `disqus_shortname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `background_tile` tinyint(1) DEFAULT '1',
  `background_blur` int(11) DEFAULT '0',
  `footer` text COLLATE utf8_unicode_ci,
  `description` text COLLATE utf8_unicode_ci,
  `twitter` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `google_analytics` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `background_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_uid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_calendar_types`
--

DROP TABLE IF EXISTS `pyr_calendar_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_calendar_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_call_scripts`
--

DROP TABLE IF EXISTS `pyr_call_scripts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_call_scripts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `script_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publish_on` datetime DEFAULT NULL,
  `script_content` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_call_scripts_languages`
--

DROP TABLE IF EXISTS `pyr_call_scripts_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_call_scripts_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `call_script_id` int(11) DEFAULT NULL,
  `market_language_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_chat_channels`
--

DROP TABLE IF EXISTS `pyr_chat_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_chat_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_chat_channels_on_name` (`name`),
  UNIQUE KEY `index_pyr_chat_channels_on_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_chat_messages`
--

DROP TABLE IF EXISTS `pyr_chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_chat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text COLLATE utf8_unicode_ci,
  `chat_channel_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `archived` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_chat_messages_on_chat_channel_id` (`chat_channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_client_contacts`
--

DROP TABLE IF EXISTS `pyr_client_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_client_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_comments`
--

DROP TABLE IF EXISTS `pyr_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8_unicode_ci,
  `commentable_id` int(11) DEFAULT NULL,
  `commentable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `abuse_reports_count` int(11) DEFAULT '0',
  `commented_by_id` int(11) DEFAULT NULL,
  `commented_by_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_comments_on_commentable_id_and_commentable_type` (`commentable_id`,`commentable_type`),
  KEY `index_pyr_comments_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_company_news`
--

DROP TABLE IF EXISTS `pyr_company_news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_company_news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` text COLLATE utf8_unicode_ci,
  `content` text COLLATE utf8_unicode_ci,
  `publish_date` datetime DEFAULT NULL,
  `archive_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `thumbnail_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `thumbnail_file_size` int(11) DEFAULT NULL,
  `thumbnail_updated_at` datetime DEFAULT NULL,
  `excerpt` text COLLATE utf8_unicode_ci,
  `draft` tinyint(1) DEFAULT '0',
  `featured` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `file_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_file_size` int(11) DEFAULT NULL,
  `file_updated_at` datetime DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `is_highlight` tinyint(1) NOT NULL DEFAULT '0',
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `asset_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `consultant_ids` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_company_news_on_slug` (`slug`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_constraint_dropdowns`
--

DROP TABLE IF EXISTS `pyr_constraint_dropdowns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_constraint_dropdowns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `column_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dropdown_method` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_contact_categories`
--

DROP TABLE IF EXISTS `pyr_contact_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_contact_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `contacts_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_contact_categories_on_category_name` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_contact_emails`
--

DROP TABLE IF EXISTS `pyr_contact_emails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_contact_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preferred` tinyint(1) DEFAULT NULL,
  `undeliverable_count` int(11) DEFAULT '0',
  `spam_reported_count` int(11) DEFAULT '0',
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_contact_emails_on_contact_id` (`contact_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_contact_phone_numbers`
--

DROP TABLE IF EXISTS `pyr_contact_phone_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_contact_phone_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `phone_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unformatted_phone_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dialing_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_contact_phone_numbers_on_contact_id` (`contact_id`),
  KEY `index_pyr_contact_phone_numbers_on_unformatted_phone_number` (`unformatted_phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_contact_sources`
--

DROP TABLE IF EXISTS `pyr_contact_sources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_contact_sources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `linked_account_id` int(11) DEFAULT NULL,
  `system_type` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `linked_provider_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_contact_sources_on_contact_id_and_linked_account_id` (`contact_id`,`linked_account_id`),
  KEY `index_pyr_contact_sources_on_system_type` (`system_type`),
  KEY `index_pyr_contact_sources_on_contact_id` (`contact_id`),
  KEY `index_pyr_contact_sources_on_linked_provider_id` (`linked_provider_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_contacts`
--

DROP TABLE IF EXISTS `pyr_contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_type` int(11) DEFAULT NULL,
  `source` int(11) DEFAULT NULL,
  `level_of_interest` int(11) DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `birthday` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  `last_contacted` date DEFAULT NULL,
  `customer_person_id_esuite` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `info` text COLLATE utf8_unicode_ci,
  `is_downline_contact` tinyint(1) DEFAULT '0',
  `downline_contact_lft` int(11) DEFAULT NULL,
  `opt_in` tinyint(1) DEFAULT NULL,
  `tree_user_id` int(11) DEFAULT NULL,
  `custom_json_data` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_contacts_on_is_downline_contact` (`is_downline_contact`),
  KEY `index_pyr_contacts_on_downline_contact_lft` (`downline_contact_lft`),
  KEY `index_pyr_contacts_on_user_id` (`user_id`),
  KEY `index_pyr_contacts_on_customer_person_id_esuite` (`customer_person_id_esuite`),
  KEY `index_pyr_contacts_on_tree_user_id` (`tree_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_contacts_contact_categories`
--

DROP TABLE IF EXISTS `pyr_contacts_contact_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_contacts_contact_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `contact_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `contact_contact_category_ids` (`contact_id`,`contact_category_id`),
  KEY `index_pyr_contacts_contact_categories_on_contact_category_id` (`contact_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_coupon_templates`
--

DROP TABLE IF EXISTS `pyr_coupon_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_coupon_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `header` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `coupon_type` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `default` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_credit_cards`
--

DROP TABLE IF EXISTS `pyr_credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_credit_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_method_id` int(11) DEFAULT NULL,
  `card_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `card_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expire_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_on_card` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `external_payment_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `merchant_gateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_credit_cards_on_payment_method_id` (`payment_method_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_dashboard_widgets`
--

DROP TABLE IF EXISTS `pyr_dashboard_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_dashboard_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dashboard_json` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_dashboard_widgets_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_deferred_action_chains`
--

DROP TABLE IF EXISTS `pyr_deferred_action_chains`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_deferred_action_chains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event` text COLLATE utf8_unicode_ci,
  `action_chain_results` text COLLATE utf8_unicode_ci,
  `completed_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_deferred_action_chains_on_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_deployment_actions`
--

DROP TABLE IF EXISTS `pyr_deployment_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_deployment_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `partition_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_revision` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_branch` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pyr_revision` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pyr_branch` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `schema_revision` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `required_migrations` tinyint(1) DEFAULT '0',
  `required_bundle_install` tinyint(1) DEFAULT '0',
  `required_assets_precompile` tinyint(1) DEFAULT '0',
  `required_security_load` tinyint(1) DEFAULT '0',
  `required_route_pages` tinyint(1) DEFAULT '0',
  `required_cms_model_overrides` tinyint(1) DEFAULT '0',
  `extras` mediumtext COLLATE utf8_unicode_ci,
  `event` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `command` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `command_results` mediumtext COLLATE utf8_unicode_ci,
  `log_file` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `exit_status` int(11) DEFAULT NULL,
  `exit_status2` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_device_registrations`
--

DROP TABLE IF EXISTS `pyr_device_registrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_device_registrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gcm_registration_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ios_registration_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `endpoint_arn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subscription_arn` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_device_registrations_on_user_id` (`user_id`),
  KEY `index_pyr_device_registrations_on_device_id` (`device_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_direct_message_recipients`
--

DROP TABLE IF EXISTS `pyr_direct_message_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_direct_message_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `direct_message_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `viewed_at` datetime DEFAULT NULL,
  `favorite` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_direct_message_recipients_on_direct_message_id` (`direct_message_id`),
  KEY `index_pyr_direct_message_recipients_on_recipient_id` (`recipient_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_direct_messages`
--

DROP TABLE IF EXISTS `pyr_direct_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_direct_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_dismissed_corporate_events`
--

DROP TABLE IF EXISTS `pyr_dismissed_corporate_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_dismissed_corporate_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `deleted_days` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_document_resources`
--

DROP TABLE IF EXISTS `pyr_document_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_document_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `document_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_document_resources_on_document_id` (`document_id`),
  KEY `index_pyr_document_resources_on_document_type` (`document_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_dynamic_menu_overrides`
--

DROP TABLE IF EXISTS `pyr_dynamic_menu_overrides`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_dynamic_menu_overrides` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `override_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `eval` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `guid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecard_categories`
--

DROP TABLE IF EXISTS `pyr_ecard_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecard_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `parent_category_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecard_template_images`
--

DROP TABLE IF EXISTS `pyr_ecard_template_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecard_template_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uploaded_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_id` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecard_template_templates`
--

DROP TABLE IF EXISTS `pyr_ecard_template_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecard_template_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uploaded_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_id` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecard_templates`
--

DROP TABLE IF EXISTS `pyr_ecard_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecard_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `html_content` text COLLATE utf8_unicode_ci,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `merge_fields` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ecard_blocks` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `allow_share` tinyint(1) DEFAULT '1',
  `ecard_editor` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `site_template_id` int(11) DEFAULT '0',
  `draft` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `favorites_count` int(11) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `report_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecard_templates_categories`
--

DROP TABLE IF EXISTS `pyr_ecard_templates_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecard_templates_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ecard_template_id` int(11) DEFAULT NULL,
  `ecard_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecards`
--

DROP TABLE IF EXISTS `pyr_ecards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ecard_template_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `html_content` text COLLATE utf8_unicode_ci,
  `thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `merge_fields` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ecard_blocks` text COLLATE utf8_unicode_ci,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `scheduled_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `footer` text COLLATE utf8_unicode_ci,
  `html_as_image_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recipients` text COLLATE utf8_unicode_ci,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `views_count` int(11) DEFAULT '0',
  `favorites_count` int(11) DEFAULT '0',
  `downloads_count` int(11) DEFAULT '0',
  `site_template_id` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecards_background_categories`
--

DROP TABLE IF EXISTS `pyr_ecards_background_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecards_background_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `parent_category_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecards_images_categories`
--

DROP TABLE IF EXISTS `pyr_ecards_images_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecards_images_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `parent_category_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_ecards_view_counts`
--

DROP TABLE IF EXISTS `pyr_ecards_view_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_ecards_view_counts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ecard_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `view_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_email_signatures`
--

DROP TABLE IF EXISTS `pyr_email_signatures`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_email_signatures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `merge_fields` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system_only` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `user_editable` tinyint(1) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_email_template_originators`
--

DROP TABLE IF EXISTS `pyr_email_template_originators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_email_template_originators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email_template_id` int(11) DEFAULT NULL,
  `originator_id` int(11) DEFAULT NULL,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_email_template_orginators_orig_id_type` (`originator_id`,`originator_type`),
  KEY `index_pyr_email_template_originators_on_email_template_id` (`email_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_email_templates`
--

DROP TABLE IF EXISTS `pyr_email_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_email_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `html_blocks` text COLLATE utf8_unicode_ci,
  `merge_fields` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system_only` tinyint(1) DEFAULT NULL,
  `signature` tinyint(1) DEFAULT NULL,
  `context` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mailer_layout_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_enrollment_credit_cards`
--

DROP TABLE IF EXISTS `pyr_enrollment_credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_enrollment_credit_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `enrollment_id` int(11) DEFAULT NULL,
  `card_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cvv` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expire_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_enrollment_order_products`
--

DROP TABLE IF EXISTS `pyr_enrollment_order_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_enrollment_order_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `enrollment_order_id` int(11) DEFAULT NULL,
  `enrollment_product_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `unit_price` decimal(8,2) DEFAULT NULL,
  `temp_ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_enrollment_orders`
--

DROP TABLE IF EXISTS `pyr_enrollment_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_enrollment_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `enrollment_id` int(11) DEFAULT NULL,
  `order_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `temp_ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_enrollment_products`
--

DROP TABLE IF EXISTS `pyr_enrollment_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_enrollment_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` text COLLATE utf8_unicode_ci,
  `short_description` text COLLATE utf8_unicode_ci,
  `long_description` text COLLATE utf8_unicode_ci,
  `price` decimal(8,2) DEFAULT NULL,
  `product_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `volume` decimal(8,2) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_enrollments`
--

DROP TABLE IF EXISTS `pyr_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_enrollments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `tax_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `business_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `day_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `primary_language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `workflow_step` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sk_sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `temp_ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_auth_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `market_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_event_images`
--

DROP TABLE IF EXISTS `pyr_event_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_event_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_event_images_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_event_invitations`
--

DROP TABLE IF EXISTS `pyr_event_invitations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_event_invitations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `invitee_id` int(11) DEFAULT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sent_at` datetime DEFAULT NULL,
  `response` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `invitee_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `accepted_event_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_event_recurrences`
--

DROP TABLE IF EXISTS `pyr_event_recurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_event_recurrences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `frequency` int(11) DEFAULT '1',
  `period` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `starts` datetime DEFAULT NULL,
  `ends` datetime DEFAULT NULL,
  `repeat` int(11) DEFAULT NULL,
  `all_day` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ends_type` int(11) DEFAULT NULL,
  `deleted_days` text COLLATE utf8_unicode_ci,
  `days` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `month_type` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_event_resources`
--

DROP TABLE IF EXISTS `pyr_event_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_event_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comment` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `photo_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `video_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `video_thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `contact_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_event_types`
--

DROP TABLE IF EXISTS `pyr_event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_event_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `color` varchar(255) COLLATE utf8_unicode_ci DEFAULT '#d5d5d5',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_events`
--

DROP TABLE IF EXISTS `pyr_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `ends_at` datetime DEFAULT NULL,
  `all_day` tinyint(1) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `bg_color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `txt_color` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `calendar_type_id` int(11) DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `speakers` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact_info` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` decimal(8,2) DEFAULT '0.00',
  `event_recur_id` int(11) DEFAULT NULL,
  `event_type_id` int(11) DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `landing` tinyint(1) DEFAULT NULL,
  `corporate_event` tinyint(1) DEFAULT '0',
  `in_timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` tinyint(1) DEFAULT NULL,
  `text` tinyint(1) DEFAULT NULL,
  `phone` tinyint(1) DEFAULT NULL,
  `alert` int(11) DEFAULT NULL,
  `guest` tinyint(1) DEFAULT NULL,
  `pwp` tinyint(1) DEFAULT NULL,
  `views_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_events_on_user_id` (`user_id`),
  KEY `index_pyr_events_on_event_recur_id` (`event_recur_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_external_server_auths`
--

DROP TABLE IF EXISTS `pyr_external_server_auths`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_external_server_auths` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `auth_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_faq_categories`
--

DROP TABLE IF EXISTS `pyr_faq_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_faq_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_favorites`
--

DROP TABLE IF EXISTS `pyr_favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_favorites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` int(11) DEFAULT NULL,
  `favoritable_id` int(11) DEFAULT NULL,
  `favoritable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_favorites_on_favoritable_id_and_favoritable_type` (`favoritable_id`,`favoritable_type`),
  KEY `index_pyr_favorites_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_featured_items`
--

DROP TABLE IF EXISTS `pyr_featured_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_featured_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `featureable_id` int(11) DEFAULT NULL,
  `featureable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_featured_items_on_featureable_id_and_featureable_type` (`featureable_id`,`featureable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_feedbacks`
--

DROP TABLE IF EXISTS `pyr_feedbacks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_feedbacks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `feedback_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `comments_count` int(11) DEFAULT '0',
  `vote_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_field_validation_examples`
--

DROP TABLE IF EXISTS `pyr_field_validation_examples`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_field_validation_examples` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `example` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `example_regex` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_field_validations`
--

DROP TABLE IF EXISTS `pyr_field_validations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_field_validations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `validation_regex` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `format` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_fresh_benies_enrollments`
--

DROP TABLE IF EXISTS `pyr_fresh_benies_enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_fresh_benies_enrollments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `middle_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birth_date` datetime DEFAULT NULL,
  `mobile_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` int(11) DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fresh_benie_add_ons` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `basic_plan` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `next_billing_date` datetime DEFAULT NULL,
  `last_billing_date` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `unique_identifier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `recurring` tinyint(1) DEFAULT NULL,
  `next_plan` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `fk_rails_50f7d52f7d` (`user_id`),
  CONSTRAINT `fk_rails_50f7d52f7d` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_future_actions`
--

DROP TABLE IF EXISTS `pyr_future_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_future_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `run_at` datetime DEFAULT NULL,
  `contingent_script` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `run_at_expression` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unique_expression` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recurring_expression` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_handler` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context_mapping` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `template` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `priority` int(11) DEFAULT '0',
  `unique_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `processed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_future_actions_on_unique_id` (`unique_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_goal_tasks`
--

DROP TABLE IF EXISTS `pyr_goal_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_goal_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `goal_id` int(11) DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_goals`
--

DROP TABLE IF EXISTS `pyr_goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_goals` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `complete_by` date DEFAULT NULL,
  `show_on_board` tinyint(1) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `flags` int(11) NOT NULL DEFAULT '0',
  `top_position` int(11) DEFAULT '0',
  `left_position` int(11) DEFAULT '0',
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_goals_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_honey_pot_logs`
--

DROP TABLE IF EXISTS `pyr_honey_pot_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_honey_pot_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `browser` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `browser_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `request_info` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_html_templates`
--

DROP TABLE IF EXISTS `pyr_html_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_html_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `html_content` text COLLATE utf8_unicode_ci,
  `merge_fields` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editable_blocks` text COLLATE utf8_unicode_ci,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_labeled_items`
--

DROP TABLE IF EXISTS `pyr_labeled_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_labeled_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_labels`
--

DROP TABLE IF EXISTS `pyr_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_labels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_labels_on_user_id_and_category_and_name` (`user_id`,`category`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_landing_pages`
--

DROP TABLE IF EXISTS `pyr_landing_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_landing_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `featured` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_languages`
--

DROP TABLE IF EXISTS `pyr_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `native_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iso639_1_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `language_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_languages_on_iso639_1_code` (`iso639_1_code`),
  KEY `index_pyr_languages_on_language_code` (`language_code`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_leads`
--

DROP TABLE IF EXISTS `pyr_leads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_leads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lead_group` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `comments` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_leads_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_likes`
--

DROP TABLE IF EXISTS `pyr_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` int(11) DEFAULT '1',
  `likeable_id` int(11) DEFAULT NULL,
  `likeable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `liked_by_id` int(11) DEFAULT NULL,
  `liked_by_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_likes_on_likeable_id_and_likeable_type` (`likeable_id`,`likeable_type`),
  KEY `index_pyr_likes_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_link_visit_targets`
--

DROP TABLE IF EXISTS `pyr_link_visit_targets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_link_visit_targets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `link_visit_id` int(11) DEFAULT NULL,
  `target_id` int(11) DEFAULT NULL,
  `target_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_link_visit_targets_on_target_type_and_target_id` (`target_type`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_link_visits`
--

DROP TABLE IF EXISTS `pyr_link_visits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_link_visits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `link_id` int(11) DEFAULT NULL,
  `visitor_id` int(11) DEFAULT NULL,
  `visitor_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_agent` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `referrer` text COLLATE utf8_unicode_ci,
  `original_url` text COLLATE utf8_unicode_ci,
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_link_visits_on_visitor_type_and_visitor_id` (`visitor_type`,`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_linked_account_users`
--

DROP TABLE IF EXISTS `pyr_linked_account_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_linked_account_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authentication_id` int(11) DEFAULT NULL,
  `source` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `profile_picture` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` datetime DEFAULT NULL,
  `first_name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(18) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `relation` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_linked_account_users_on_source_and_source_id` (`source`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_links`
--

DROP TABLE IF EXISTS `pyr_links`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_links` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_share_id` int(11) DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `asset_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_guid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link_destination` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `view_count` int(11) DEFAULT NULL,
  `site_id` int(11) DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `containable_id` int(11) DEFAULT NULL,
  `containable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `channel_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_links_on_asset_type_and_asset_id` (`asset_type`,`asset_id`),
  KEY `index_pyr_links_on_containable_type_and_containable_id` (`containable_type`,`containable_id`),
  KEY `index_pyr_links_on_channel_type_and_channel_id` (`channel_type`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_login_histories`
--

DROP TABLE IF EXISTS `pyr_login_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_login_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_agent` varchar(1024) COLLATE utf8_unicode_ci DEFAULT NULL,
  `browser` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `browser_version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `platform` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `proxied_by_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_login_histories_on_user_id` (`user_id`),
  KEY `index_pyr_login_histories_on_proxied_by_id` (`proxied_by_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_mailer_layouts`
--

DROP TABLE IF EXISTS `pyr_mailer_layouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_mailer_layouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `layout_html` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `yield_blocks` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_make_a_calls`
--

DROP TABLE IF EXISTS `pyr_make_a_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_make_a_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `phone_script` int(11) DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `interest` int(11) DEFAULT NULL,
  `follow_up` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_market_extras`
--

DROP TABLE IF EXISTS `pyr_market_extras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_market_extras` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market_id` int(11) DEFAULT NULL,
  `currency_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `currency_symbol_position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_currency` tinyint(1) DEFAULT '0',
  `no_cents_if_whole` tinyint(1) DEFAULT '1',
  `domain_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email_domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date_format` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `time_format` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_market_extras_on_market_id` (`market_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_market_language_resources`
--

DROP TABLE IF EXISTS `pyr_market_language_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_market_language_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market_language_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indx_pyr_market_language_resources_rid_rtype_mlid` (`resource_id`,`resource_type`,`market_language_id`),
  UNIQUE KEY `market_language_resources_unique_index` (`resource_type`,`market_language_id`,`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_market_languages`
--

DROP TABLE IF EXISTS `pyr_market_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_market_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market_id` int(11) NOT NULL,
  `language_id` int(11) NOT NULL,
  `default` tinyint(1) DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_market_languages_on_market_id` (`market_id`),
  KEY `index_pyr_market_languages_on_language_id` (`language_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_market_resources`
--

DROP TABLE IF EXISTS `pyr_market_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_market_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indx_pyr_market_resources_rid_rtype_mid` (`resource_id`,`resource_type`,`market_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_markets`
--

DROP TABLE IF EXISTS `pyr_markets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_markets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_message_attachment_xrefs`
--

DROP TABLE IF EXISTS `pyr_message_attachment_xrefs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_message_attachment_xrefs` (
  `message_attachment_id` int(11) DEFAULT NULL,
  `message_id` int(11) DEFAULT NULL,
  `filename` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `ix_msg_attachment_xrefs_messageable` (`message_type`,`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_message_attachments`
--

DROP TABLE IF EXISTS `pyr_message_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_message_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `storage_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `storage_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `md5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `size_in_bytes` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_unique_message_attachments` (`md5`,`content_type`,`size_in_bytes`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_message_providers`
--

DROP TABLE IF EXISTS `pyr_message_providers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_message_providers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) DEFAULT NULL,
  `messageable_id` int(11) DEFAULT NULL,
  `messageable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_message_recipients`
--

DROP TABLE IF EXISTS `pyr_message_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_message_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `recipient_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `consultant_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `delivery_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'email',
  `to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject_interpolated` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message_interpolated` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `opened_count` int(11) DEFAULT '0',
  `tag_starred` tinyint(1) DEFAULT '0',
  `tag_important` tinyint(1) DEFAULT '0',
  `tag_spam` tinyint(1) DEFAULT '0',
  `tag_trash` tinyint(1) DEFAULT '0',
  `tag_deleted` tinyint(1) DEFAULT '0',
  `from_pyr_user` tinyint(1) DEFAULT '0',
  `from_community` tinyint(1) DEFAULT '0',
  `from_downline` tinyint(1) DEFAULT '0',
  `from_upline` tinyint(1) DEFAULT '0',
  `from_team` tinyint(1) DEFAULT '0',
  `replied_to_message_id` int(11) DEFAULT NULL,
  `forwarded_message_id` int(11) DEFAULT NULL,
  `message_header_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `read` datetime DEFAULT NULL,
  `from_contact` tinyint(1) DEFAULT '0',
  `seen` datetime DEFAULT NULL,
  `undeliverable` tinyint(1) DEFAULT '0',
  `cc` tinyint(1) DEFAULT NULL,
  `bcc` tinyint(1) DEFAULT NULL,
  `spam_reported` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_message_recipients_on_message_header_id` (`message_header_id`),
  KEY `index_pyr_message_recipients_on_message_id` (`message_id`),
  KEY `index_pyr_message_recipients_on_recipient_id_and_recipient_type` (`recipient_id`,`recipient_type`),
  KEY `index_pyr_message_recipients_on_to` (`to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_messages`
--

DROP TABLE IF EXISTS `pyr_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender_id` int(11) DEFAULT NULL,
  `sender_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sent_date` datetime DEFAULT NULL,
  `to` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `from` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `short_message` varchar(140) COLLATE utf8_unicode_ci DEFAULT NULL,
  `draft` tinyint(1) DEFAULT '1',
  `delivery_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'unsent',
  `reply_to_id` int(11) DEFAULT NULL,
  `forwarded_from_id` int(11) DEFAULT NULL,
  `internal_recipient_count` int(11) DEFAULT NULL,
  `internal_open_count` int(11) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `has_attachments` tinyint(1) DEFAULT '0',
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `message_type` int(11) DEFAULT '0',
  `system_generated` tinyint(1) DEFAULT '0',
  `tag_deleted` tinyint(1) DEFAULT '0',
  `tag_trash` tinyint(1) DEFAULT '0',
  `tag_important` tinyint(1) DEFAULT '0',
  `tag_starred` tinyint(1) DEFAULT '0',
  `cc` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bcc` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `undeliverable_count` int(11) DEFAULT NULL,
  `spam_reported_count` int(11) DEFAULT NULL,
  `tag_spam` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_messages_on_sender_id_and_sender_type` (`sender_id`,`sender_type`),
  KEY `index_pyr_messages_on_message_type` (`message_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_microsite_templates`
--

DROP TABLE IF EXISTS `pyr_microsite_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_microsite_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_partition_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_microsites`
--

DROP TABLE IF EXISTS `pyr_microsites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_microsites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_partition_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `microsite_template_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `config_options` varchar(6000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_microsites_on_microsite_template_id` (`microsite_template_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_model_field_validations`
--

DROP TABLE IF EXISTS `pyr_model_field_validations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_model_field_validations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `klass_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `validation_field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_model_field_validations_on_klass_name` (`klass_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_notes`
--

DROP TABLE IF EXISTS `pyr_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `notable_id` int(11) DEFAULT NULL,
  `notable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_notes_on_notable_id_and_notable_type` (`notable_id`,`notable_type`),
  KEY `index_pyr_notes_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_notification_categories`
--

DROP TABLE IF EXISTS `pyr_notification_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_notification_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `main_category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model_regexp` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_notification_definitions`
--

DROP TABLE IF EXISTS `pyr_notification_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_notification_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notification_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_notification_preferences`
--

DROP TABLE IF EXISTS `pyr_notification_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_notification_preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `event_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event_action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preference_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_notification_settings`
--

DROP TABLE IF EXISTS `pyr_notification_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_notification_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notification_category_id` int(11) DEFAULT NULL,
  `preference_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_locked?` tinyint(1) DEFAULT '0',
  `is_switched_on?` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_notifications`
--

DROP TABLE IF EXISTS `pyr_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `item_id` int(11) DEFAULT NULL,
  `item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sub_category` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actionable_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `seen` datetime DEFAULT NULL,
  `dismissed` datetime DEFAULT NULL,
  `priority` int(11) DEFAULT '50',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `origin_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `origin_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `web_alert_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rule_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_notifications_on_user_id` (`user_id`),
  KEY `index_pyr_notifications_on_item_type_and_item_id` (`item_type`,`item_id`),
  KEY `index_pyr_notifications_on_origin_type_and_origin_id` (`origin_type`,`origin_id`),
  KEY `index_pyr_notifications_on_web_alert_id` (`web_alert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_opt_outs`
--

DROP TABLE IF EXISTS `pyr_opt_outs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_opt_outs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message_recipient_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `opted_out_from_user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_opt_outs_on_email_and_opted_out_from_user_id` (`email`,`opted_out_from_user_id`),
  KEY `index_pyr_opt_outs_on_opted_out_from_user_id` (`opted_out_from_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_parties`
--

DROP TABLE IF EXISTS `pyr_parties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `party_id` int(11) DEFAULT NULL,
  `party_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `party_description` text COLLATE utf8_unicode_ci,
  `start_date` datetime DEFAULT NULL,
  `closed_date` datetime DEFAULT NULL,
  `host_user_id` int(11) DEFAULT NULL,
  `distributor_user_id` int(11) DEFAULT NULL,
  `party_shopping_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `party_retro_box_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_payment_methods`
--

DROP TABLE IF EXISTS `pyr_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `type_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `from_date` datetime DEFAULT NULL,
  `thru_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_payout_checks`
--

DROP TABLE IF EXISTS `pyr_payout_checks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_payout_checks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_payout_direct_deposits`
--

DROP TABLE IF EXISTS `pyr_payout_direct_deposits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_payout_direct_deposits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name_on_account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `routing_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_province` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `iban` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `swift_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_payout_methods`
--

DROP TABLE IF EXISTS `pyr_payout_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_payout_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `payout_id` int(11) DEFAULT NULL,
  `payout_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_payout_payment_cards`
--

DROP TABLE IF EXISTS `pyr_payout_payment_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_payout_payment_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `ext_payment_card_id` int(11) DEFAULT NULL,
  `ext_payment_card_type_id` int(11) DEFAULT NULL,
  `card_number_display` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `primary` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `card_name_display` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `provider` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_permissions`
--

DROP TABLE IF EXISTS `pyr_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3166 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_permissions_roles`
--

DROP TABLE IF EXISTS `pyr_permissions_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_permissions_roles` (
  `role_id` int(11) DEFAULT NULL,
  `permission_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_pyr_permissions_roles_on_deleted_at` (`deleted_at`),
  KEY `index_pyr_permissions_roles_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9184 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_pg_profiles`
--

DROP TABLE IF EXISTS `pyr_pg_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_pg_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `external_profile_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `gateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_pg_transactions`
--

DROP TABLE IF EXISTS `pyr_pg_transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_pg_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction_date` datetime DEFAULT NULL,
  `payment_info` text COLLATE utf8_unicode_ci,
  `merchant_gateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currency_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transaction_result` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transaction_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transaction_history_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avs_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authorization_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `transaction_type` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` decimal(10,0) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_photo_galleries`
--

DROP TABLE IF EXISTS `pyr_photo_galleries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_photo_galleries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_photo_galleries_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_photos`
--

DROP TABLE IF EXISTS `pyr_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `photo_gallery_id` int(11) DEFAULT NULL,
  `photo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `flags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_photos_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_posts`
--

DROP TABLE IF EXISTS `pyr_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body` text COLLATE utf8_unicode_ci,
  `blog_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `published` tinyint(1) DEFAULT '0',
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `excerpt` text COLLATE utf8_unicode_ci,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `flags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_posts_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_profile_settings`
--

DROP TABLE IF EXISTS `pyr_profile_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_profile_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_profile_settings_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_profiles`
--

DROP TABLE IF EXISTS `pyr_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  `middle_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cell` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sponsor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  `relationship` int(11) DEFAULT NULL,
  `occupation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `education` int(11) DEFAULT NULL,
  `hometown` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `story` text COLLATE utf8_unicode_ci,
  `interest` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quote` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `books` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `movies` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `music` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `linkedin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `youtube` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `google_plus` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `business_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `my_why` text COLLATE utf8_unicode_ci,
  `phone_visibility` int(11) DEFAULT NULL,
  `email_visibility` int(11) DEFAULT NULL,
  `address_visibility` int(11) DEFAULT NULL,
  `story_visibility` int(11) DEFAULT NULL,
  `cover_photo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cover_photo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cover_photo_file_size` int(11) DEFAULT NULL,
  `cover_photo_updated_at` datetime DEFAULT NULL,
  `other_emails` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `cell_carrier` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cell_verification` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax_visibility` int(11) DEFAULT NULL,
  `cell_visibility` int(11) DEFAULT NULL,
  `birthday_visibility` int(11) DEFAULT NULL,
  `first_name_visibility` int(11) DEFAULT NULL,
  `last_name_visibility` int(11) DEFAULT NULL,
  `reply_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_profiles_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_promotion_templates`
--

DROP TABLE IF EXISTS `pyr_promotion_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_promotion_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `discount_price` decimal(8,2) DEFAULT NULL,
  `valid_for_days` int(11) DEFAULT NULL,
  `valid_until` datetime DEFAULT NULL,
  `security_group_id` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `first_time_subscribers` tinyint(1) DEFAULT NULL,
  `existing_subscribers` tinyint(1) DEFAULT NULL,
  `inactive_subscribers` tinyint(1) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `subscription_plan_id` int(11) DEFAULT NULL,
  `previous_promotion_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_pyr_promotion_templates_on_subscription_plan_id` (`subscription_plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_promotions`
--

DROP TABLE IF EXISTS `pyr_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_promotions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_template_id` int(11) DEFAULT NULL,
  `subscription_id` int(11) DEFAULT NULL,
  `subscription_plan_id` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_promotions_on_promotion_template_id` (`promotion_template_id`),
  KEY `index_pyr_promotions_on_subscription_id` (`subscription_id`),
  KEY `index_pyr_promotions_on_subscription_plan_id` (`subscription_plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_propay_authorizations`
--

DROP TABLE IF EXISTS `pyr_propay_authorizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_propay_authorizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resource_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transaction_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `transaction_history_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_method_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8_unicode_ci,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_propay_authorizations_on_transaction_id` (`transaction_id`),
  KEY `index_propay_authorizations_on_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rank_definition_benefits`
--

DROP TABLE IF EXISTS `pyr_rank_definition_benefits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rank_definition_benefits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `visible` tinyint(1) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `rank_definition_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `market_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rank_definition_next_steps`
--

DROP TABLE IF EXISTS `pyr_rank_definition_next_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rank_definition_next_steps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `action_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `rank_qualification_id` int(11) DEFAULT NULL,
  `rank_id` int(11) DEFAULT NULL,
  `visible` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rank_definition_resources`
--

DROP TABLE IF EXISTS `pyr_rank_definition_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rank_definition_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rank_definition_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indx_pyr_rank_definition_resources_rid_rtype_rdid` (`resource_id`,`resource_type`,`rank_definition_id`),
  UNIQUE KEY `rank_definition_resources_unique_index` (`resource_type`,`rank_definition_id`,`resource_id`),
  KEY `index_pyr_rank_definition_resources_on_start_date` (`start_date`),
  KEY `index_pyr_rank_definition_resources_on_end_date` (`end_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rank_definitions`
--

DROP TABLE IF EXISTS `pyr_rank_definitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rank_definitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `client_level` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `market_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_rank_definitions_on_level` (`level`),
  UNIQUE KEY `index_pyr_rank_definitions_on_client_level` (`client_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rank_qualifications`
--

DROP TABLE IF EXISTS `pyr_rank_qualifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rank_qualifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `required_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `weight` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank_definition_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `operand_klass` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operand_field` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operand_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `operator` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `market_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_reports`
--

DROP TABLE IF EXISTS `pyr_reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `connection_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active_start` date DEFAULT NULL,
  `active_end` date DEFAULT NULL,
  `select_tables_id` int(11) DEFAULT NULL,
  `constraint_columns_id` int(11) DEFAULT NULL,
  `output_columns_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resource_asset_comments`
--

DROP TABLE IF EXISTS `pyr_resource_asset_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resource_asset_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text COLLATE utf8_unicode_ci,
  `asset_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `abuse_reports_count` int(11) DEFAULT '0',
  `flags` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resource_assets`
--

DROP TABLE IF EXISTS `pyr_resource_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resource_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `file_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_description` text COLLATE utf8_unicode_ci,
  `language` int(11) DEFAULT NULL,
  `embed_code` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `views_count` int(11) DEFAULT '0',
  `downloads_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `icon_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_block` text COLLATE utf8_unicode_ci,
  `available_email` char(1) COLLATE utf8_unicode_ci DEFAULT '0',
  `allow_download` char(1) COLLATE utf8_unicode_ci DEFAULT '0',
  `source_thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `allow_share` char(1) COLLATE utf8_unicode_ci DEFAULT '0',
  `favorites_count` int(11) DEFAULT '0',
  `site_template_id` int(11) DEFAULT '0',
  `sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_resource_assets_resource_id` (`resource_id`),
  KEY `index_pyr_resource_assets_on_resource_id` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resource_categories`
--

DROP TABLE IF EXISTS `pyr_resource_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resource_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `parent_category_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `system` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_resource_categories_category_name` (`category_name`),
  KEY `index_pyr_resource_categories_on_parent_category_id` (`parent_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resource_files`
--

DROP TABLE IF EXISTS `pyr_resource_files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resource_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `file_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_description` text COLLATE utf8_unicode_ci,
  `language` int(11) DEFAULT NULL,
  `embed_code` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `likes_count` int(11) DEFAULT NULL,
  `shares_count` int(11) DEFAULT NULL,
  `abuse_reports_count` int(11) DEFAULT NULL,
  `views_count` int(11) DEFAULT NULL,
  `downloads_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resource_product_purchases`
--

DROP TABLE IF EXISTS `pyr_resource_product_purchases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resource_product_purchases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resource_products`
--

DROP TABLE IF EXISTS `pyr_resource_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resource_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resources`
--

DROP TABLE IF EXISTS `pyr_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `system` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `icon_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `keywords` text COLLATE utf8_unicode_ci,
  `status` int(11) DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `available_email` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_as_new` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `embed_code` text COLLATE utf8_unicode_ci,
  `allow_download` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resourceable_id` int(11) DEFAULT NULL,
  `resourceable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `linked_resource_id` int(11) DEFAULT NULL,
  `views_count` int(11) DEFAULT '0',
  `downloads_count` int(11) DEFAULT '0',
  `notification_alert` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login_interrupt` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `send_preferred_communication` char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_newest_until` date DEFAULT NULL,
  `archive_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  `microsite_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_resources_on_publish_date` (`publish_date`),
  KEY `index_pyr_resources_on_expiry_date` (`expiry_date`),
  KEY `index_pyr_resources_on_display_newest_until` (`display_newest_until`),
  KEY `index_pyr_resources_on_resourceable_id_and_resourceable_type` (`resourceable_id`,`resourceable_type`),
  KEY `index_pyr_resources_on_microsite_id` (`microsite_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resources_categories`
--

DROP TABLE IF EXISTS `pyr_resources_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resources_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `resource_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_resources_categories_on_resource_id` (`resource_id`),
  KEY `index_pyr_resources_categories_on_resource_category_id` (`resource_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resources_view_count`
--

DROP TABLE IF EXISTS `pyr_resources_view_count`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resources_view_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `view_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_resources_view_counts`
--

DROP TABLE IF EXISTS `pyr_resources_view_counts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_resources_view_counts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `resource_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `view_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_resources_view_counts_on_resource_id` (`resource_id`),
  KEY `index_pyr_resources_view_counts_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_reviews`
--

DROP TABLE IF EXISTS `pyr_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reviewable_id` int(11) DEFAULT NULL,
  `reviewable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` text COLLATE utf8_unicode_ci,
  `review` text COLLATE utf8_unicode_ci,
  `rating` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT '0',
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_roles`
--

DROP TABLE IF EXISTS `pyr_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `role_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system_flag` tinyint(1) DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rules_action_analytics`
--

DROP TABLE IF EXISTS `pyr_rules_action_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rules_action_analytics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `count` int(11) DEFAULT '0',
  `since` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_rules_event_analytics`
--

DROP TABLE IF EXISTS `pyr_rules_event_analytics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_rules_event_analytics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `count` int(11) DEFAULT '0',
  `since` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_rules_event_analytics_on_event_name` (`event_name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_s3_migrations`
--

DROP TABLE IF EXISTS `pyr_s3_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_s3_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `migratable_id` int(11) DEFAULT NULL,
  `migratable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uploader` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `upload_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `s3_path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_s3_migrations_on_migratable_type_and_migratable_id` (`migratable_type`,`migratable_id`),
  KEY `index_pyr_s3_migrations_on_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_security_groups`
--

DROP TABLE IF EXISTS `pyr_security_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_security_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `system_flag` tinyint(1) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_security_groups_roles`
--

DROP TABLE IF EXISTS `pyr_security_groups_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_security_groups_roles` (
  `security_group_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_pyr_security_groups_roles_on_deleted_at` (`deleted_at`),
  KEY `index_pyr_security_groups_roles_on_role_id` (`role_id`),
  KEY `index_pyr_security_groups_roles_security_group_id` (`security_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_security_groups_users`
--

DROP TABLE IF EXISTS `pyr_security_groups_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_security_groups_users` (
  `security_group_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `index_pyr_security_groups_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_select_tables`
--

DROP TABLE IF EXISTS `pyr_select_tables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_select_tables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `main_table` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `report_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_select_tables_on_report_id` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_share_channels`
--

DROP TABLE IF EXISTS `pyr_share_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_share_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shareable_id` int(11) DEFAULT NULL,
  `shareable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `channel_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `target` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `owner_user_id` int(11) DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_share_channels_on_shareable_type_and_shareable_id` (`shareable_type`,`shareable_id`),
  KEY `index_pyr_share_channels_on_channel_type_and_channel_id` (`channel_type`,`channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_shares`
--

DROP TABLE IF EXISTS `pyr_shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_shares` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shareable_id` int(11) DEFAULT NULL,
  `shareable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `destination` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `recipient` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_shares_on_shareable_id_and_shareable_type` (`shareable_id`,`shareable_type`),
  KEY `index_pyr_shares_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_site_template_sec_grps`
--

DROP TABLE IF EXISTS `pyr_site_template_sec_grps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_site_template_sec_grps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_template_id` int(11) DEFAULT NULL,
  `security_group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_site_template_user_editables`
--

DROP TABLE IF EXISTS `pyr_site_template_user_editables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_site_template_user_editables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_template_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_content` text COLLATE utf8_unicode_ci,
  `position` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `default_image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_image_file_size` int(11) DEFAULT NULL,
  `default_image_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_site_templates`
--

DROP TABLE IF EXISTS `pyr_site_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_site_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content_partition_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_site_user_editables`
--

DROP TABLE IF EXISTS `pyr_site_user_editables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_site_user_editables` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `site_template_user_editable_id` int(11) DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_site_visitors`
--

DROP TABLE IF EXISTS `pyr_site_visitors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_site_visitors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `visitor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_visit_date` datetime DEFAULT NULL,
  `visit_count` int(11) DEFAULT NULL,
  `ipaddress` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `browser_agent` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_site_visitors_on_site_id` (`site_id`),
  KEY `index_pyr_site_visitors_on_visitor_id` (`visitor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_sites`
--

DROP TABLE IF EXISTS `pyr_sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `site_template_id` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `owner_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `story` text COLLATE utf8_unicode_ci,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_file_size` int(11) DEFAULT NULL,
  `avatar_updated_at` datetime DEFAULT NULL,
  `show_owner_name` tinyint(1) DEFAULT NULL,
  `show_address` tinyint(1) DEFAULT NULL,
  `show_phone` tinyint(1) DEFAULT NULL,
  `show_email` tinyint(1) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_sites_on_name_and_domain` (`name`,`domain`),
  KEY `index_pyr_sites_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_sites_analytics_tracking_codes`
--

DROP TABLE IF EXISTS `pyr_sites_analytics_tracking_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_sites_analytics_tracking_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `domain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pages_being_tracked` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `third_party_tracking_company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tracking_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `access_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `refresh_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ga_profile_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_sms`
--

DROP TABLE IF EXISTS `pyr_sms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_sms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` text COLLATE utf8_unicode_ci,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `delivery_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `draft` tinyint(1) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT NULL,
  `send_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_sms_opted_lists`
--

DROP TABLE IF EXISTS `pyr_sms_opted_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_sms_opted_lists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_sms_recipients`
--

DROP TABLE IF EXISTS `pyr_sms_recipients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_sms_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sms_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `recipient_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `phone_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_social_schedules`
--

DROP TABLE IF EXISTS `pyr_social_schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_social_schedules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asset_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `photo_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `network` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `page_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `schedule_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_statuses`
--

DROP TABLE IF EXISTS `pyr_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `status` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `flags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_statuses_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscription_features`
--

DROP TABLE IF EXISTS `pyr_subscription_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscription_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_plan_feature_id` int(11) DEFAULT NULL,
  `subscription_plan_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscription_histories`
--

DROP TABLE IF EXISTS `pyr_subscription_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscription_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_id` int(11) DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `before_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `after_value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_subscription_histories_on_subscription_id` (`subscription_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscription_levels_roles`
--

DROP TABLE IF EXISTS `pyr_subscription_levels_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscription_levels_roles` (
  `subscription_level_id` int(11) DEFAULT NULL,
  `subscription_role_id` int(11) DEFAULT NULL,
  KEY `idx_subscription_levels_roles` (`subscription_level_id`,`subscription_role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscription_plan_features`
--

DROP TABLE IF EXISTS `pyr_subscription_plan_features`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscription_plan_features` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscription_plan_resources`
--

DROP TABLE IF EXISTS `pyr_subscription_plan_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscription_plan_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_plan_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `indx_pyr_subscription_plan_resources_rid_rtype_spid` (`resource_id`,`resource_type`,`subscription_plan_id`),
  UNIQUE KEY `subscription_plan_resources_unique_index` (`resource_type`,`subscription_plan_id`,`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscription_plans`
--

DROP TABLE IF EXISTS `pyr_subscription_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscription_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL,
  `billing_frequency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `setup_fee` decimal(8,2) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `first_time_subscribers` tinyint(1) DEFAULT NULL,
  `existing_subscribers` tinyint(1) DEFAULT NULL,
  `inactive_subscribers` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `security_group_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `image_file_size` int(11) DEFAULT NULL,
  `image_updated_at` datetime DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_subscriptions`
--

DROP TABLE IF EXISTS `pyr_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subscription_plan_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `last_billing_date` datetime DEFAULT NULL,
  `next_billing_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `recurring` tinyint(1) DEFAULT '1',
  `deleted_at` datetime DEFAULT NULL,
  `next_subscription_plan_id` int(11) DEFAULT NULL,
  `grace_period_end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unq_user` (`user_id`),
  KEY `index_pyr_subscriptions_on_subscription_plan_id` (`subscription_plan_id`),
  KEY `index_pyr_subscriptions_on_user_id` (`user_id`),
  KEY `index_pyr_subscriptions_on_deleted_at` (`deleted_at`),
  KEY `index_pyr_subscriptions_on_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_tasks`
--

DROP TABLE IF EXISTS `pyr_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `days_to_complete` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `share` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_tasks_languages`
--

DROP TABLE IF EXISTS `pyr_tasks_languages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_tasks_languages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_id` int(11) DEFAULT NULL,
  `market_language_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_taxon_resources`
--

DROP TABLE IF EXISTS `pyr_taxon_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_taxon_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxon_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `resource_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_theme_attachments`
--

DROP TABLE IF EXISTS `pyr_theme_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_theme_attachments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `market_language_id` int(11) DEFAULT NULL,
  `theme_id` int(11) DEFAULT NULL,
  `content_set_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo_file_size` int(11) DEFAULT NULL,
  `logo_updated_at` datetime DEFAULT NULL,
  `header_background_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `header_background_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `header_background_file_size` int(11) DEFAULT NULL,
  `header_background_updated_at` datetime DEFAULT NULL,
  `body_background_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body_background_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `body_background_file_size` int(11) DEFAULT NULL,
  `body_background_updated_at` datetime DEFAULT NULL,
  `footer_background_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `footer_background_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `footer_background_file_size` int(11) DEFAULT NULL,
  `footer_background_updated_at` datetime DEFAULT NULL,
  `nav_background_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nav_background_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nav_background_file_size` int(11) DEFAULT NULL,
  `nav_background_updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `login_logo` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `favicon_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `favicon_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `favicon_file_size` int(11) DEFAULT NULL,
  `favicon_updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_themes`
--

DROP TABLE IF EXISTS `pyr_themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_themes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_themes_on_uuid` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_categories`
--

DROP TABLE IF EXISTS `pyr_training_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subscription_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `ranks` text COLLATE utf8_unicode_ci,
  `dependency` text COLLATE utf8_unicode_ci,
  `status` int(11) DEFAULT NULL,
  `show_Market_id` text COLLATE utf8_unicode_ci,
  `dependency_select` int(11) DEFAULT NULL,
  `certification` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_series`
--

DROP TABLE IF EXISTS `pyr_training_series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_series` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `dependency` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `avatar_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avatar_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `publish_date` datetime DEFAULT NULL,
  `expiry_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_series_resources`
--

DROP TABLE IF EXISTS `pyr_training_series_resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_series_resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `training_series_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `asset_status` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_tasks`
--

DROP TABLE IF EXISTS `pyr_training_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `video_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_tasks_statuses`
--

DROP TABLE IF EXISTS `pyr_training_tasks_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_tasks_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `video_id` int(11) DEFAULT NULL,
  `training_task_id` int(11) DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_user_statuses`
--

DROP TABLE IF EXISTS `pyr_training_user_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_user_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `statusable_id` int(11) DEFAULT NULL,
  `statusable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_video_properties`
--

DROP TABLE IF EXISTS `pyr_training_video_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_video_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `training_video_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `dependency` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_video_questions`
--

DROP TABLE IF EXISTS `pyr_training_video_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_video_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `comment` text COLLATE utf8_unicode_ci,
  `video_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_training_videos`
--

DROP TABLE IF EXISTS `pyr_training_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_training_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `video_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `embed_code` text COLLATE utf8_unicode_ci,
  `upload_path` text COLLATE utf8_unicode_ci,
  `tags` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dependency` text COLLATE utf8_unicode_ci,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `series_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `thumbnail` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_trinity_credit_cards`
--

DROP TABLE IF EXISTS `pyr_trinity_credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_trinity_credit_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `card_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `card_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expire_date` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name_on_card` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cvv` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_postal_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enrollment_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_unique_rule_firings`
--

DROP TABLE IF EXISTS `pyr_unique_rule_firings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_unique_rule_firings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unique_expression` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fired_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_pyr_unique_rule_firings` (`rule_id`,`unique_expression`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_user_certifications`
--

DROP TABLE IF EXISTS `pyr_user_certifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_user_certifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `training_series_id` int(11) DEFAULT NULL,
  `percentage` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_user_chat_statuses`
--

DROP TABLE IF EXISTS `pyr_user_chat_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_user_chat_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status_user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_user_data_import_changes`
--

DROP TABLE IF EXISTS `pyr_user_data_import_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_user_data_import_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `consultant_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `klass_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `klass_id` int(11) DEFAULT NULL,
  `field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `original_value` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `new_value` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `error_message` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `failed` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_user_data_import_changes_on_consultant_id` (`consultant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_user_settings`
--

DROP TABLE IF EXISTS `pyr_user_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_user_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_user_settings_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_user_task_reminders`
--

DROP TABLE IF EXISTS `pyr_user_task_reminders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_user_task_reminders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `contact_id` int(11) DEFAULT NULL,
  `reminder_type` int(11) DEFAULT NULL,
  `has_mobile` tinyint(1) DEFAULT NULL,
  `has_email` tinyint(1) DEFAULT NULL,
  `user_task_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_user_tasks`
--

DROP TABLE IF EXISTS `pyr_user_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_user_tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `days_to_complete` int(11) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `attach_to` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `task_id` int(11) DEFAULT NULL,
  `calendar_id` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `reminders` int(11) DEFAULT NULL,
  `actionable_item_id` int(11) DEFAULT NULL,
  `actionable_item_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `actionable_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `fk_pyr_user_tasks_actionable_items` (`actionable_item_type`,`actionable_item_id`),
  KEY `index_pyr_user_tasks_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_users_chat_channels`
--

DROP TABLE IF EXISTS `pyr_users_chat_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_users_chat_channels` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `chat_channel_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_pyr_users_chat_channels_on_user_id_and_chat_channel_id` (`user_id`,`chat_channel_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_videos`
--

DROP TABLE IF EXISTS `pyr_videos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `embed` text COLLATE utf8_unicode_ci,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tags` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `source_thumbnail` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `likes_count` int(11) DEFAULT '0',
  `votes_count` int(11) DEFAULT '0',
  `shares_count` int(11) DEFAULT '0',
  `abuse_reports_count` int(11) DEFAULT '0',
  `featured_items_count` int(11) DEFAULT '0',
  `comments_count` int(11) DEFAULT '0',
  `source_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `flags` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_pyr_videos_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_visibilities`
--

DROP TABLE IF EXISTS `pyr_visibilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_visibilities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_visibilities_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_visibility_settings`
--

DROP TABLE IF EXISTS `pyr_visibility_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_visibility_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `visibility_id` int(11) DEFAULT NULL,
  `visible_id` int(11) DEFAULT NULL,
  `visible_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_visibility_settings_on_visibility_id` (`visibility_id`),
  KEY `idx_visible_id_type` (`visible_id`,`visible_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_visitor_session_details`
--

DROP TABLE IF EXISTS `pyr_visitor_session_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_visitor_session_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `site_id` int(11) DEFAULT NULL,
  `visitor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `session_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `page_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_visitor_session_details_on_site_id` (`site_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_votes`
--

DROP TABLE IF EXISTS `pyr_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` int(11) DEFAULT NULL,
  `voteable_id` int(11) DEFAULT NULL,
  `voteable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_pyr_votes_on_voteable_id_and_voteable_type` (`voteable_id`,`voteable_type`),
  KEY `index_pyr_votes_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_website_settings`
--

DROP TABLE IF EXISTS `pyr_website_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_website_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` int(11) DEFAULT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_widget_page_widgets`
--

DROP TABLE IF EXISTS `pyr_widget_page_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_widget_page_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `widget_page_id` int(11) DEFAULT NULL,
  `widget_id` int(11) DEFAULT NULL,
  `column` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `order` int(11) DEFAULT NULL,
  `locked` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_widget_pages`
--

DROP TABLE IF EXISTS `pyr_widget_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_widget_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `layout` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locked` tinyint(1) DEFAULT NULL,
  `max_rows` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `admin_default` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pyr_widgets`
--

DROP TABLE IF EXISTS `pyr_widgets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pyr_widgets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_configurable` tinyint(1) DEFAULT '0',
  `is_duplicatable` tinyint(1) DEFAULT '0',
  `extras` text COLLATE utf8_unicode_ci,
  `user_configurable` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rapidfire_answers`
--

DROP TABLE IF EXISTS `rapidfire_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rapidfire_answers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `attempt_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `answer_text` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rapidfire_answers_on_attempt_id` (`attempt_id`),
  KEY `index_rapidfire_answers_on_question_id` (`question_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rapidfire_attempts`
--

DROP TABLE IF EXISTS `rapidfire_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rapidfire_attempts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rapidfire_attempts_on_survey_id` (`survey_id`),
  KEY `index_rapidfire_attempts_on_user_id_and_user_type` (`user_id`,`user_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rapidfire_questions`
--

DROP TABLE IF EXISTS `rapidfire_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rapidfire_questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `survey_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `question_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `placeholder` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `answer_options` text COLLATE utf8_unicode_ci,
  `validation_rules` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_rapidfire_questions_on_survey_id` (`survey_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rapidfire_surveys`
--

DROP TABLE IF EXISTS `rapidfire_surveys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rapidfire_surveys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `introduction` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_class_field_mappings`
--

DROP TABLE IF EXISTS `reports_class_field_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_class_field_mappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `class_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field_names` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reports_report_snapshots`
--

DROP TABLE IF EXISTS `reports_report_snapshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reports_report_snapshots` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `report_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `results` mediumtext COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `guid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `persisted_columns` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_reports_report_snapshots_on_user_id` (`user_id`),
  KEY `index_reports_report_snapshots_on_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rules_event_history`
--

DROP TABLE IF EXISTS `rules_event_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rules_event_history` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `event_class` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `action` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `trigger_id` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_hash` text COLLATE utf8_unicode_ci,
  `changes_hash` text COLLATE utf8_unicode_ci,
  `entry_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rules_event_staging`
--

DROP TABLE IF EXISTS `rules_event_staging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rules_event_staging` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `event_class` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `action` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `trigger_id` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `data_hash` text COLLATE utf8_unicode_ci,
  `changes_hash` text COLLATE utf8_unicode_ci,
  `entry_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_addresses`
--

DROP TABLE IF EXISTS `spree_addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_addresses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `alternative_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  `address3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_addresses_on_firstname` (`firstname`),
  KEY `index_addresses_on_lastname` (`lastname`),
  KEY `index_spree_addresses_on_country_id` (`country_id`),
  KEY `index_spree_addresses_on_state_id` (`state_id`),
  KEY `index_spree_addresses_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_adjustments`
--

DROP TABLE IF EXISTS `spree_adjustments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_adjustments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adjustable_id` int(11) DEFAULT NULL,
  `adjustable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `label` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mandatory` tinyint(1) DEFAULT NULL,
  `eligible` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `order_id` int(11) NOT NULL,
  `included` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_spree_adjustments_on_order_id` (`order_id`),
  KEY `index_spree_adjustments_on_adjustable_id_and_adjustable_type` (`adjustable_id`,`adjustable_type`),
  KEY `index_spree_adjustments_on_eligible` (`eligible`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_assemblies_parts`
--

DROP TABLE IF EXISTS `spree_assemblies_parts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_assemblies_parts` (
  `assembly_id` int(11) NOT NULL,
  `part_id` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '1',
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variant_selection_deferred` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_assets`
--

DROP TABLE IF EXISTS `spree_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `viewable_id` int(11) DEFAULT NULL,
  `viewable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment_width` int(11) DEFAULT NULL,
  `attachment_height` int(11) DEFAULT NULL,
  `attachment_file_size` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `attachment_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(75) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment_updated_at` datetime DEFAULT NULL,
  `alt` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_assets_on_viewable_id` (`viewable_id`),
  KEY `index_assets_on_viewable_type_and_type` (`viewable_type`,`type`),
  KEY `index_spree_assets_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_autoship_line_items`
--

DROP TABLE IF EXISTS `spree_autoship_line_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_autoship_line_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `autoship_id` int(11) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `pv` decimal(10,2) DEFAULT '0.00',
  `bv` decimal(10,2) DEFAULT '0.00',
  `preferences` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_spree_autoship_line_items_on_autoship_id` (`autoship_id`),
  KEY `index_spree_autoship_line_items_on_variant_id` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_autoship_part_line_items`
--

DROP TABLE IF EXISTS `spree_autoship_part_line_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_autoship_part_line_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `line_item_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_spree_autoship_part_line_items_on_line_item_id` (`line_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_autoship_payments`
--

DROP TABLE IF EXISTS `spree_autoship_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_autoship_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `autoship_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_autoship_payments_on_autoship_id` (`autoship_id`),
  KEY `index_spree_autoship_payments_on_payment_method_id` (`payment_method_id`),
  KEY `index_spree_autoship_payments_on_source_type_and_source_id` (`source_type`,`source_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_autoship_shipping_rates`
--

DROP TABLE IF EXISTS `spree_autoship_shipping_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_autoship_shipping_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `autoship_id` int(11) DEFAULT NULL,
  `shipping_method_id` int(11) DEFAULT NULL,
  `selected` tinyint(1) DEFAULT '0',
  `cost` decimal(8,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `spree_autoship_shipping_rates_join_index` (`autoship_id`,`shipping_method_id`),
  KEY `index_spree_autoship_shipping_rates_on_selected` (`selected`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_autoships`
--

DROP TABLE IF EXISTS `spree_autoships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_autoships` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `frequency` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `last_run_date` datetime DEFAULT NULL,
  `next_run_date` datetime DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `price_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ship_address_id` int(11) DEFAULT NULL,
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `item_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tax_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shipping_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `pv_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guest_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `billing_address_id` int(11) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `status` int(11) DEFAULT '0',
  `weight_total` decimal(10,2) DEFAULT '0.00',
  `preferences` text COLLATE utf8_unicode_ci,
  `market_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_autoships_on_user_id` (`user_id`),
  KEY `index_spree_autoships_on_completed_at` (`completed_at`),
  KEY `index_spree_autoships_on_billing_address_id` (`billing_address_id`),
  KEY `index_spree_autoships_on_ship_address_id` (`ship_address_id`),
  KEY `index_spree_autoships_on_guest_token` (`guest_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_calculators`
--

DROP TABLE IF EXISTS `spree_calculators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_calculators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `calculable_id` int(11) DEFAULT NULL,
  `calculable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_calculators_on_id_and_type` (`id`,`type`),
  KEY `index_spree_calculators_on_calculable_id_and_calculable_type` (`calculable_id`,`calculable_type`),
  KEY `index_spree_calculators_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_countries`
--

DROP TABLE IF EXISTS `spree_countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iso_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iso` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iso3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numcode` int(11) DEFAULT NULL,
  `states_required` tinyint(1) DEFAULT '0',
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_countries_on_iso` (`iso`),
  KEY `index_spree_countries_on_iso3` (`iso3`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_credit_cards`
--

DROP TABLE IF EXISTS `spree_credit_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_credit_cards` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `month` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `year` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cc_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_digits` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `gateway_customer_profile_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gateway_payment_profile_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `default` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_spree_credit_cards_on_user_id` (`user_id`),
  KEY `index_spree_credit_cards_on_payment_method_id` (`payment_method_id`),
  KEY `index_spree_credit_cards_on_address_id` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_customer_returns`
--

DROP TABLE IF EXISTS `spree_customer_returns`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_customer_returns` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stock_location_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_direct_debits`
--

DROP TABLE IF EXISTS `spree_direct_debits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_direct_debits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `name_on_account` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `routing_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_province` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bank_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iban` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `swift_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_external_images`
--

DROP TABLE IF EXISTS `spree_external_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_external_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variant_id` int(11) DEFAULT NULL,
  `mini_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `small_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `large_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_feedback_reviews`
--

DROP TABLE IF EXISTS `spree_feedback_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_feedback_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `review_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT '0',
  `comment` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `locale` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'en',
  `helpful` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_feedback_reviews_on_review_id` (`review_id`),
  KEY `index_spree_feedback_reviews_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_gateways`
--

DROP TABLE IF EXISTS `spree_gateways`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_gateways` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `active` tinyint(1) DEFAULT '1',
  `environment` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'development',
  `server` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'test',
  `test_mode` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_spree_gateways_on_active` (`active`),
  KEY `index_spree_gateways_on_test_mode` (`test_mode`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_inventory_units`
--

DROP TABLE IF EXISTS `spree_inventory_units`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_inventory_units` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `shipment_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `pending` tinyint(1) DEFAULT '1',
  `line_item_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_inventory_units_on_order_id` (`order_id`),
  KEY `index_inventory_units_on_shipment_id` (`shipment_id`),
  KEY `index_inventory_units_on_variant_id` (`variant_id`),
  KEY `index_spree_inventory_units_on_line_item_id` (`line_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_line_items`
--

DROP TABLE IF EXISTS `spree_line_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_line_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variant_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `tax_category_id` int(11) DEFAULT NULL,
  `adjustment_total` decimal(10,2) DEFAULT '0.00',
  `additional_tax_total` decimal(10,2) DEFAULT '0.00',
  `promo_total` decimal(10,2) DEFAULT '0.00',
  `included_tax_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `pre_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `pv` decimal(10,2) DEFAULT '0.00',
  `taxable_adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `non_taxable_adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `other_volume1` decimal(10,2) DEFAULT '0.00',
  `other_volume2` decimal(10,2) DEFAULT '0.00',
  `other_volume3` decimal(10,2) DEFAULT '0.00',
  `preferences` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_spree_line_items_on_order_id` (`order_id`),
  KEY `index_spree_line_items_on_variant_id` (`variant_id`),
  KEY `index_spree_line_items_on_tax_category_id` (`tax_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_log_entries`
--

DROP TABLE IF EXISTS `spree_log_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_log_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `details` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_log_entries_on_source_id_and_source_type` (`source_id`,`source_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_option_type_prototypes`
--

DROP TABLE IF EXISTS `spree_option_type_prototypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_option_type_prototypes` (
  `prototype_id` int(11) DEFAULT NULL,
  `option_type_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_option_types_prototypes_on_prototype_and_option_type` (`prototype_id`,`option_type_id`),
  KEY `index_spree_option_type_prototypes_on_option_type_id` (`option_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_option_types`
--

DROP TABLE IF EXISTS `spree_option_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_option_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `presentation` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_option_types_on_position` (`position`),
  KEY `index_spree_option_types_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_option_value_variants`
--

DROP TABLE IF EXISTS `spree_option_value_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_option_value_variants` (
  `variant_id` int(11) DEFAULT NULL,
  `option_value_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_option_values_variants_on_variant_id_and_option_value_id` (`variant_id`,`option_value_id`),
  KEY `index_spree_option_value_variants_on_option_value_id` (`option_value_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_option_values`
--

DROP TABLE IF EXISTS `spree_option_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_option_values` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `presentation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `option_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_option_values_on_option_type_id` (`option_type_id`),
  KEY `index_spree_option_values_on_position` (`position`),
  KEY `index_spree_option_values_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_order_attributes`
--

DROP TABLE IF EXISTS `spree_order_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_order_attributes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_order_promotions`
--

DROP TABLE IF EXISTS `spree_order_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_order_promotions` (
  `order_id` int(11) DEFAULT NULL,
  `promotion_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_spree_order_promotions_on_promotion_id_and_order_id` (`promotion_id`,`order_id`),
  KEY `index_spree_order_promotions_on_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_orders`
--

DROP TABLE IF EXISTS `spree_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `user_id` int(11) DEFAULT NULL,
  `completed_at` datetime DEFAULT NULL,
  `bill_address_id` int(11) DEFAULT NULL,
  `ship_address_id` int(11) DEFAULT NULL,
  `payment_total` decimal(10,2) DEFAULT '0.00',
  `shipment_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `special_instructions` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `channel` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'spree',
  `additional_tax_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `shipment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `promo_total` decimal(10,2) DEFAULT '0.00',
  `included_tax_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `item_count` int(11) DEFAULT '0',
  `approver_id` int(11) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `confirmation_delivered` tinyint(1) DEFAULT '0',
  `considered_risky` tinyint(1) DEFAULT '0',
  `external_order_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `guest_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pv_total` decimal(10,2) DEFAULT '0.00',
  `sponsor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `canceled_at` datetime DEFAULT NULL,
  `canceler_id` int(11) DEFAULT NULL,
  `store_id` int(11) DEFAULT NULL,
  `state_lock_version` int(11) NOT NULL DEFAULT '0',
  `market_id` int(11) DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  `taxable_adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `non_taxable_adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `failed_autoship` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_spree_orders_on_number` (`number`),
  KEY `index_spree_orders_on_completed_at` (`completed_at`),
  KEY `index_spree_orders_on_approver_id` (`approver_id`),
  KEY `index_spree_orders_on_bill_address_id` (`bill_address_id`),
  KEY `index_spree_orders_on_confirmation_delivered` (`confirmation_delivered`),
  KEY `index_spree_orders_on_considered_risky` (`considered_risky`),
  KEY `index_spree_orders_on_created_by_id` (`created_by_id`),
  KEY `index_spree_orders_on_ship_address_id` (`ship_address_id`),
  KEY `index_spree_orders_on_user_id_and_created_by_id` (`user_id`,`created_by_id`),
  KEY `index_spree_orders_on_guest_token` (`guest_token`),
  KEY `index_spree_orders_on_canceler_id` (`canceler_id`),
  KEY `index_spree_orders_on_store_id` (`store_id`),
  KEY `index_spree_orders_on_external_order_id` (`external_order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_part_line_items`
--

DROP TABLE IF EXISTS `spree_part_line_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_part_line_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `line_item_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_payment_capture_events`
--

DROP TABLE IF EXISTS `spree_payment_capture_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_payment_capture_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) DEFAULT '0.00',
  `payment_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_payment_capture_events_on_payment_id` (`payment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_payment_methods`
--

DROP TABLE IF EXISTS `spree_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_payment_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `active` tinyint(1) DEFAULT '1',
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `display_on` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'both',
  `auto_capture` tinyint(1) DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  `position` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_spree_payment_methods_on_id_and_type` (`id`,`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_payments`
--

DROP TABLE IF EXISTS `spree_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `order_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `payment_method_id` int(11) DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `response_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `avs_response` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cvv_response_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cvv_response_message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_payments_on_order_id` (`order_id`),
  KEY `index_spree_payments_on_payment_method_id` (`payment_method_id`),
  KEY `index_spree_payments_on_source_id_and_source_type` (`source_id`,`source_type`),
  KEY `index_spree_payments_on_number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_pg_profiles`
--

DROP TABLE IF EXISTS `spree_pg_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_pg_profiles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `external_profile_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gateway` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_pg_profiles_on_user_id` (`user_id`),
  KEY `index_spree_pg_profiles_on_external_profile_id_and_gateway` (`external_profile_id`,`gateway`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_preferences`
--

DROP TABLE IF EXISTS `spree_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` text COLLATE utf8_unicode_ci,
  `key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_spree_preferences_on_key` (`key`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_prices`
--

DROP TABLE IF EXISTS `spree_prices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_prices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variant_id` int(11) NOT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `price_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pv` decimal(10,2) DEFAULT '0.00',
  `other_volume1` decimal(10,2) DEFAULT '0.00',
  `other_volume2` decimal(10,2) DEFAULT '0.00',
  `other_volume3` decimal(10,2) DEFAULT '0.00',
  `preferences` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_spree_prices_on_variant_id_and_currency` (`variant_id`,`currency`),
  KEY `index_spree_prices_on_deleted_at` (`deleted_at`),
  KEY `index_spree_prices_on_variant_id` (`variant_id`),
  KEY `index_spree_prices_on_deleted_at_and_variant_id` (`deleted_at`,`variant_id`),
  KEY `index_spree_prices_on_variant_id_and_currency_and_price_type` (`variant_id`,`currency`,`price_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_product_option_types`
--

DROP TABLE IF EXISTS `spree_product_option_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_product_option_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `option_type_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_product_option_types_on_option_type_id` (`option_type_id`),
  KEY `index_spree_product_option_types_on_product_id` (`product_id`),
  KEY `index_spree_product_option_types_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_product_promotion_rules`
--

DROP TABLE IF EXISTS `spree_product_promotion_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_product_promotion_rules` (
  `product_id` int(11) DEFAULT NULL,
  `promotion_rule_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_products_promotion_rules_on_product_id` (`product_id`),
  KEY `index_products_promotion_rules_on_promotion_rule_and_product` (`promotion_rule_id`,`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_product_properties`
--

DROP TABLE IF EXISTS `spree_product_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_product_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `property_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_product_properties_on_product_id` (`product_id`),
  KEY `index_spree_product_properties_on_position` (`position`),
  KEY `index_spree_product_properties_on_property_id` (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_products`
--

DROP TABLE IF EXISTS `spree_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `description` text COLLATE utf8_unicode_ci,
  `available_on` datetime DEFAULT NULL,
  `discontinue_on` datetime DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8_unicode_ci,
  `meta_keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tax_category_id` int(11) DEFAULT NULL,
  `shipping_category_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `avg_rating` decimal(7,5) NOT NULL DEFAULT '0.00000',
  `reviews_count` int(11) NOT NULL DEFAULT '0',
  `short_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `promotionable` tinyint(1) DEFAULT '1',
  `meta_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enrollment_availability` int(11) DEFAULT '3',
  `shop_availability` int(11) DEFAULT '3',
  `can_be_part` tinyint(1) NOT NULL DEFAULT '0',
  `individual_sale` tinyint(1) NOT NULL DEFAULT '1',
  `preferences` text COLLATE utf8_unicode_ci,
  `read_only` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_spree_products_on_slug` (`slug`),
  KEY `index_spree_products_on_available_on` (`available_on`),
  KEY `index_spree_products_on_deleted_at` (`deleted_at`),
  KEY `index_spree_products_on_name` (`name`),
  KEY `index_spree_products_on_shipping_category_id` (`shipping_category_id`),
  KEY `index_spree_products_on_tax_category_id` (`tax_category_id`),
  KEY `index_spree_products_on_discontinue_on` (`discontinue_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_products_taxons`
--

DROP TABLE IF EXISTS `spree_products_taxons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_products_taxons` (
  `product_id` int(11) DEFAULT NULL,
  `taxon_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_products_taxons_on_product_id` (`product_id`),
  KEY `index_spree_products_taxons_on_taxon_id` (`taxon_id`),
  KEY `index_spree_products_taxons_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotion_action_line_items`
--

DROP TABLE IF EXISTS `spree_promotion_action_line_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotion_action_line_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_action_id` int(11) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_spree_promotion_action_line_items_on_promotion_action_id` (`promotion_action_id`),
  KEY `index_spree_promotion_action_line_items_on_variant_id` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotion_actions`
--

DROP TABLE IF EXISTS `spree_promotion_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotion_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_promotion_actions_on_id_and_type` (`id`,`type`),
  KEY `index_spree_promotion_actions_on_promotion_id` (`promotion_id`),
  KEY `index_spree_promotion_actions_on_deleted_at` (`deleted_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotion_categories`
--

DROP TABLE IF EXISTS `spree_promotion_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotion_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotion_rule_taxons`
--

DROP TABLE IF EXISTS `spree_promotion_rule_taxons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotion_rule_taxons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxon_id` int(11) DEFAULT NULL,
  `promotion_rule_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_promotion_rule_taxons_on_taxon_id` (`taxon_id`),
  KEY `index_spree_promotion_rule_taxons_on_promotion_rule_id` (`promotion_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotion_rule_users`
--

DROP TABLE IF EXISTS `spree_promotion_rule_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotion_rule_users` (
  `user_id` int(11) DEFAULT NULL,
  `promotion_rule_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_promotion_rules_users_on_promotion_rule_id` (`promotion_rule_id`),
  KEY `index_promotion_rules_users_on_user_id_and_promotion_rule_id` (`user_id`,`promotion_rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotion_rules`
--

DROP TABLE IF EXISTS `spree_promotion_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotion_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `promotion_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `product_group_id` int(11) DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preferences` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_promotion_rules_on_product_group_id` (`product_group_id`),
  KEY `index_promotion_rules_on_user_id` (`user_id`),
  KEY `index_spree_promotion_rules_on_promotion_id` (`promotion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_promotions`
--

DROP TABLE IF EXISTS `spree_promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_promotions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `starts_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `usage_limit` int(11) DEFAULT NULL,
  `match_policy` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'all',
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `advertise` tinyint(1) DEFAULT '0',
  `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `promotion_category_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_promotions_on_id_and_type` (`id`,`type`),
  KEY `index_spree_promotions_on_code` (`code`),
  KEY `index_spree_promotions_on_expires_at` (`expires_at`),
  KEY `index_spree_promotions_on_starts_at` (`starts_at`),
  KEY `index_spree_promotions_on_advertise` (`advertise`),
  KEY `index_spree_promotions_on_promotion_category_id` (`promotion_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_properties`
--

DROP TABLE IF EXISTS `spree_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `presentation` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_properties_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_property_prototypes`
--

DROP TABLE IF EXISTS `spree_property_prototypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_property_prototypes` (
  `prototype_id` int(11) DEFAULT NULL,
  `property_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_properties_prototypes_on_prototype_and_property` (`prototype_id`,`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_prototype_taxons`
--

DROP TABLE IF EXISTS `spree_prototype_taxons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_prototype_taxons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxon_id` int(11) DEFAULT NULL,
  `prototype_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_prototype_taxons_on_taxon_id` (`taxon_id`),
  KEY `index_spree_prototype_taxons_on_prototype_id_and_taxon_id` (`prototype_id`,`taxon_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_prototypes`
--

DROP TABLE IF EXISTS `spree_prototypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_prototypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_refund_reasons`
--

DROP TABLE IF EXISTS `spree_refund_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_refund_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `mutable` tinyint(1) DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_refunds`
--

DROP TABLE IF EXISTS `spree_refunds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_refunds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_id` int(11) DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `transaction_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `refund_reason_id` int(11) DEFAULT NULL,
  `reimbursement_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_refunds_on_refund_reason_id` (`refund_reason_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_reimbursement_credits`
--

DROP TABLE IF EXISTS `spree_reimbursement_credits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_reimbursement_credits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00',
  `reimbursement_id` int(11) DEFAULT NULL,
  `creditable_id` int(11) DEFAULT NULL,
  `creditable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_reimbursement_types`
--

DROP TABLE IF EXISTS `spree_reimbursement_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_reimbursement_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `mutable` tinyint(1) DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_reimbursement_types_on_type` (`type`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_reimbursements`
--

DROP TABLE IF EXISTS `spree_reimbursements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_reimbursements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reimbursement_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customer_return_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_reimbursements_on_customer_return_id` (`customer_return_id`),
  KEY `index_spree_reimbursements_on_order_id` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_relation_types`
--

DROP TABLE IF EXISTS `spree_relation_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_relation_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `applies_to` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_relation_types_on_applies_to` (`applies_to`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_relations`
--

DROP TABLE IF EXISTS `spree_relations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_relations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `relation_type_id` int(11) DEFAULT NULL,
  `relatable_id` int(11) DEFAULT NULL,
  `relatable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `related_to_id` int(11) DEFAULT NULL,
  `related_to_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `discount_amount` decimal(8,2) DEFAULT '0.00',
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_relations_on_relatable_id_and_relatable_type` (`relatable_id`,`relatable_type`),
  KEY `index_spree_relations_on_relation_type_id` (`relation_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_return_authorization_reasons`
--

DROP TABLE IF EXISTS `spree_return_authorization_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_return_authorization_reasons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `mutable` tinyint(1) DEFAULT '1',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_return_authorizations`
--

DROP TABLE IF EXISTS `spree_return_authorizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_return_authorizations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `memo` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `stock_location_id` int(11) DEFAULT NULL,
  `return_authorization_reason_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_return_authorizations_on_return_authorization_reason_id` (`return_authorization_reason_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_return_items`
--

DROP TABLE IF EXISTS `spree_return_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_return_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `return_authorization_id` int(11) DEFAULT NULL,
  `inventory_unit_id` int(11) DEFAULT NULL,
  `exchange_variant_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `pre_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `included_tax_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `additional_tax_total` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `reception_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acceptance_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customer_return_id` int(11) DEFAULT NULL,
  `reimbursement_id` int(11) DEFAULT NULL,
  `exchange_inventory_unit_id` int(11) DEFAULT NULL,
  `acceptance_status_errors` text COLLATE utf8_unicode_ci,
  `preferred_reimbursement_type_id` int(11) DEFAULT NULL,
  `override_reimbursement_type_id` int(11) DEFAULT NULL,
  `resellable` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_return_items_on_customer_return_id` (`customer_return_id`),
  KEY `index_spree_return_items_on_exchange_inventory_unit_id` (`exchange_inventory_unit_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_reviews`
--

DROP TABLE IF EXISTS `spree_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_reviews` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `title` text COLLATE utf8_unicode_ci,
  `review` text COLLATE utf8_unicode_ci,
  `approved` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locale` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'en',
  `show_identifier` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `index_spree_reviews_on_show_identifier` (`show_identifier`),
  KEY `index_spree_reviews_on_product_id` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_role_users`
--

DROP TABLE IF EXISTS `spree_role_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_role_users` (
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`),
  KEY `index_spree_role_users_on_role_id` (`role_id`),
  KEY `index_spree_role_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_roles`
--

DROP TABLE IF EXISTS `spree_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_roles_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_shipments`
--

DROP TABLE IF EXISTS `spree_shipments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_shipments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracking` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT '0.00',
  `shipped_at` datetime DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `address_id` int(11) DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `stock_location_id` int(11) DEFAULT NULL,
  `adjustment_total` decimal(10,2) DEFAULT '0.00',
  `additional_tax_total` decimal(10,2) DEFAULT '0.00',
  `promo_total` decimal(10,2) DEFAULT '0.00',
  `included_tax_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `pre_tax_amount` decimal(12,4) NOT NULL DEFAULT '0.0000',
  `taxable_adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  `non_taxable_adjustment_total` decimal(10,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`id`),
  KEY `index_shipments_on_number` (`number`),
  KEY `index_spree_shipments_on_order_id` (`order_id`),
  KEY `index_spree_shipments_on_stock_location_id` (`stock_location_id`),
  KEY `index_spree_shipments_on_address_id` (`address_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_shipping_categories`
--

DROP TABLE IF EXISTS `spree_shipping_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_shipping_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_shipping_categories_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_shipping_method_categories`
--

DROP TABLE IF EXISTS `spree_shipping_method_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_shipping_method_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shipping_method_id` int(11) NOT NULL,
  `shipping_category_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_spree_shipping_method_categories` (`shipping_category_id`,`shipping_method_id`),
  KEY `index_spree_shipping_method_categories_on_shipping_method_id` (`shipping_method_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_shipping_method_zones`
--

DROP TABLE IF EXISTS `spree_shipping_method_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_shipping_method_zones` (
  `shipping_method_id` int(11) DEFAULT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_shipping_methods`
--

DROP TABLE IF EXISTS `spree_shipping_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_shipping_methods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_on` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tracking_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `admin_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tax_category_id` int(11) DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ext_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_shipping_methods_on_deleted_at` (`deleted_at`),
  KEY `index_spree_shipping_methods_on_tax_category_id` (`tax_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_shipping_rates`
--

DROP TABLE IF EXISTS `spree_shipping_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_shipping_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `shipment_id` int(11) DEFAULT NULL,
  `shipping_method_id` int(11) DEFAULT NULL,
  `selected` tinyint(1) DEFAULT '0',
  `cost` decimal(8,2) DEFAULT '0.00',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tax_rate_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `spree_shipping_rates_join_index` (`shipment_id`,`shipping_method_id`),
  KEY `index_spree_shipping_rates_on_selected` (`selected`),
  KEY `index_spree_shipping_rates_on_tax_rate_id` (`tax_rate_id`),
  KEY `index_spree_shipping_rates_on_shipment_id` (`shipment_id`),
  KEY `index_spree_shipping_rates_on_shipping_method_id` (`shipping_method_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_state_changes`
--

DROP TABLE IF EXISTS `spree_state_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_state_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `previous_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `stateful_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `stateful_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `next_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_state_changes_on_stateful_id_and_stateful_type` (`stateful_id`,`stateful_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_states`
--

DROP TABLE IF EXISTS `spree_states`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `abbr` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_states_on_country_id` (`country_id`),
  KEY `index_spree_states_on_abbr` (`abbr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_stock_items`
--

DROP TABLE IF EXISTS `spree_stock_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_stock_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_location_id` int(11) DEFAULT NULL,
  `variant_id` int(11) DEFAULT NULL,
  `count_on_hand` int(11) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `backorderable` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `stock_item_by_loc_and_var_id` (`stock_location_id`,`variant_id`),
  KEY `index_spree_stock_items_on_deleted_at` (`deleted_at`),
  KEY `index_spree_stock_items_on_backorderable` (`backorderable`),
  KEY `index_spree_stock_items_on_variant_id` (`variant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_stock_locations`
--

DROP TABLE IF EXISTS `spree_stock_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_stock_locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `default` tinyint(1) NOT NULL DEFAULT '0',
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state_id` int(11) DEFAULT NULL,
  `state_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country_id` int(11) DEFAULT NULL,
  `zipcode` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `backorderable_default` tinyint(1) DEFAULT '0',
  `propagate_all_variants` tinyint(1) DEFAULT '1',
  `admin_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_stock_locations_on_active` (`active`),
  KEY `index_spree_stock_locations_on_backorderable_default` (`backorderable_default`),
  KEY `index_spree_stock_locations_on_country_id` (`country_id`),
  KEY `index_spree_stock_locations_on_propagate_all_variants` (`propagate_all_variants`),
  KEY `index_spree_stock_locations_on_state_id` (`state_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_stock_movements`
--

DROP TABLE IF EXISTS `spree_stock_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_stock_movements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `stock_item_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT '0',
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `originator_id` int(11) DEFAULT NULL,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_stock_movements_on_stock_item_id` (`stock_item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_stock_transfers`
--

DROP TABLE IF EXISTS `spree_stock_transfers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_stock_transfers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reference` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `source_location_id` int(11) DEFAULT NULL,
  `destination_location_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_stock_transfers_on_number` (`number`),
  KEY `index_spree_stock_transfers_on_source_location_id` (`source_location_id`),
  KEY `index_spree_stock_transfers_on_destination_location_id` (`destination_location_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_store_credit_categories`
--

DROP TABLE IF EXISTS `spree_store_credit_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_store_credit_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_store_credit_events`
--

DROP TABLE IF EXISTS `spree_store_credit_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_store_credit_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `store_credit_id` int(11) NOT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `authorization_code` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_total_amount` decimal(8,2) NOT NULL DEFAULT '0.00',
  `originator_id` int(11) DEFAULT NULL,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_store_credit_events_on_store_credit_id` (`store_credit_id`),
  KEY `spree_store_credit_events_originator` (`originator_id`,`originator_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_store_credit_types`
--

DROP TABLE IF EXISTS `spree_store_credit_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_store_credit_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_store_credit_types_on_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_store_credits`
--

DROP TABLE IF EXISTS `spree_store_credits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_store_credits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `created_by_id` int(11) DEFAULT NULL,
  `amount` decimal(8,2) NOT NULL DEFAULT '0.00',
  `amount_used` decimal(8,2) NOT NULL DEFAULT '0.00',
  `memo` text COLLATE utf8_unicode_ci,
  `deleted_at` datetime DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `amount_authorized` decimal(8,2) NOT NULL DEFAULT '0.00',
  `originator_id` int(11) DEFAULT NULL,
  `originator_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_store_credits_on_deleted_at` (`deleted_at`),
  KEY `index_spree_store_credits_on_user_id` (`user_id`),
  KEY `index_spree_store_credits_on_type_id` (`type_id`),
  KEY `spree_store_credits_originator` (`originator_id`,`originator_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_stores`
--

DROP TABLE IF EXISTS `spree_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_stores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_description` text COLLATE utf8_unicode_ci,
  `meta_keywords` text COLLATE utf8_unicode_ci,
  `seo_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_from_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_stores_on_code` (`code`),
  KEY `index_spree_stores_on_default` (`default`),
  KEY `index_spree_stores_on_url` (`url`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_suggestions`
--

DROP TABLE IF EXISTS `spree_suggestions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_suggestions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `items_found` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_suggestions_on_keywords_and_count_and_items_found` (`keywords`,`count`,`items_found`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_tax_categories`
--

DROP TABLE IF EXISTS `spree_tax_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_tax_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `tax_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_tax_categories_on_deleted_at` (`deleted_at`),
  KEY `index_spree_tax_categories_on_is_default` (`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_tax_rates`
--

DROP TABLE IF EXISTS `spree_tax_rates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_tax_rates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `amount` decimal(8,5) DEFAULT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `tax_category_id` int(11) DEFAULT NULL,
  `included_in_price` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `show_rate_in_label` tinyint(1) DEFAULT '1',
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_tax_rates_on_deleted_at` (`deleted_at`),
  KEY `index_spree_tax_rates_on_included_in_price` (`included_in_price`),
  KEY `index_spree_tax_rates_on_show_rate_in_label` (`show_rate_in_label`),
  KEY `index_spree_tax_rates_on_tax_category_id` (`tax_category_id`),
  KEY `index_spree_tax_rates_on_zone_id` (`zone_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_taxon_price_types`
--

DROP TABLE IF EXISTS `spree_taxon_price_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_taxon_price_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `taxon_id` int(11) DEFAULT NULL,
  `price_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_taxonomies`
--

DROP TABLE IF EXISTS `spree_taxonomies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_taxonomies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_spree_taxonomies_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_taxons`
--

DROP TABLE IF EXISTS `spree_taxons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_taxons` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT '0',
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `permalink` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taxonomy_id` int(11) DEFAULT NULL,
  `lft` int(11) DEFAULT NULL,
  `rgt` int(11) DEFAULT NULL,
  `icon_file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon_content_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icon_file_size` int(11) DEFAULT NULL,
  `icon_updated_at` datetime DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `meta_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meta_keywords` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `depth` int(11) DEFAULT NULL,
  `user_filters` text COLLATE utf8_unicode_ci,
  `source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_taxons_on_parent_id` (`parent_id`),
  KEY `index_taxons_on_permalink` (`permalink`),
  KEY `index_taxons_on_taxonomy_id` (`taxonomy_id`),
  KEY `index_spree_taxons_on_position` (`position`),
  KEY `index_spree_taxons_on_lft` (`lft`),
  KEY `index_spree_taxons_on_rgt` (`rgt`),
  KEY `index_spree_taxons_on_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_trackers`
--

DROP TABLE IF EXISTS `spree_trackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_trackers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `analytics_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_trackers_on_active` (`active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_users`
--

DROP TABLE IF EXISTS `spree_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `encrypted_password` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password_salt` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `persistence_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `perishable_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `failed_attempts` int(11) NOT NULL DEFAULT '0',
  `last_request_at` datetime DEFAULT NULL,
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `login` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ship_address_id` int(11) DEFAULT NULL,
  `bill_address_id` int(11) DEFAULT NULL,
  `authentication_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `unlock_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_variants`
--

DROP TABLE IF EXISTS `spree_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_variants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sku` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `weight` decimal(8,2) DEFAULT '0.00',
  `height` decimal(8,2) DEFAULT NULL,
  `width` decimal(8,2) DEFAULT NULL,
  `depth` decimal(8,2) DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `discontinue_on` datetime DEFAULT NULL,
  `is_master` tinyint(1) DEFAULT '0',
  `product_id` int(11) DEFAULT NULL,
  `cost_price` decimal(10,2) DEFAULT NULL,
  `cost_currency` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  `track_inventory` tinyint(1) DEFAULT '1',
  `tax_category_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `stock_items_count` int(11) NOT NULL DEFAULT '0',
  `preferences` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `index_spree_variants_on_product_id` (`product_id`),
  KEY `index_spree_variants_on_sku` (`sku`),
  KEY `index_spree_variants_on_tax_category_id` (`tax_category_id`),
  KEY `index_spree_variants_on_deleted_at` (`deleted_at`),
  KEY `index_spree_variants_on_is_master` (`is_master`),
  KEY `index_spree_variants_on_position` (`position`),
  KEY `index_spree_variants_on_track_inventory` (`track_inventory`),
  KEY `index_spree_variants_on_discontinue_on` (`discontinue_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_wished_products`
--

DROP TABLE IF EXISTS `spree_wished_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_wished_products` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `variant_id` int(11) DEFAULT NULL,
  `wishlist_id` int(11) DEFAULT NULL,
  `remark` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_wished_products_on_wishlist_id` (`wishlist_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_wishlists`
--

DROP TABLE IF EXISTS `spree_wishlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_wishlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `access_hash` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_private` tinyint(1) NOT NULL DEFAULT '1',
  `is_default` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_wishlists_on_user_id` (`user_id`),
  KEY `index_spree_wishlists_on_user_id_and_is_default` (`user_id`,`is_default`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_zone_members`
--

DROP TABLE IF EXISTS `spree_zone_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_zone_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zoneable_id` int(11) DEFAULT NULL,
  `zoneable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zone_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_zone_members_on_zone_id` (`zone_id`),
  KEY `index_spree_zone_members_on_zoneable_id_and_zoneable_type` (`zoneable_id`,`zoneable_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `spree_zones`
--

DROP TABLE IF EXISTS `spree_zones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `spree_zones` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_tax` tinyint(1) DEFAULT '0',
  `zone_members_count` int(11) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `kind` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_spree_zones_on_default_tax` (`default_tax`),
  KEY `index_spree_zones_on_kind` (`kind`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taggings`
--

DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `context` varchar(128) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggings_idx` (`tag_id`,`taggable_id`,`taggable_type`,`context`,`tagger_id`,`tagger_type`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tags`
--

DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `taggings_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_alert_actions`
--

DROP TABLE IF EXISTS `tree_alert_actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_alert_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `report_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `count` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tree_alert_actions_on_user_id` (`user_id`),
  KEY `index_tree_alert_actions_on_report_id` (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_alert_categories`
--

DROP TABLE IF EXISTS `tree_alert_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_alert_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_alert_category_assignments`
--

DROP TABLE IF EXISTS `tree_alert_category_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_alert_category_assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alert_category_id` int(11) DEFAULT NULL,
  `display_order` int(11) DEFAULT NULL,
  `report_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tree_alert_category_assignments_on_alert_category_id` (`alert_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_auto_order_items`
--

DROP TABLE IF EXISTS `tree_auto_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_auto_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `auto_order_id` int(11) NOT NULL,
  `auto_order_item_id` int(11) NOT NULL,
  `product_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price_each` decimal(19,4) DEFAULT '0.0000',
  `price_total` decimal(19,4) DEFAULT '0.0000',
  `bv_each` decimal(19,4) DEFAULT '0.0000',
  `cv_each` decimal(19,4) DEFAULT '0.0000',
  `bv` decimal(19,4) DEFAULT '0.0000',
  `cv` decimal(19,4) DEFAULT '0.0000',
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_ao_items_orderid_itemid` (`auto_order_id`,`auto_order_item_id`),
  KEY `tree_aoi_chksm_idx` (`checksum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_auto_order_statuses`
--

DROP TABLE IF EXISTS `tree_auto_order_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_auto_order_statuses` (
  `id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_auto_orders`
--

DROP TABLE IF EXISTS `tree_auto_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_auto_orders` (
  `id` int(11) NOT NULL,
  `client_auto_order_id` int(11) NOT NULL,
  `tree_user_id` int(11) NOT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `auto_order_status_id` int(11) DEFAULT NULL,
  `period_id` int(11) DEFAULT NULL,
  `frequency_type_id` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `next_run_date` datetime DEFAULT NULL,
  `cancelled_date` datetime DEFAULT NULL,
  `currency_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total` decimal(19,4) DEFAULT '0.0000',
  `sub_total` decimal(19,4) DEFAULT '0.0000',
  `tax_total` decimal(19,4) DEFAULT '0.0000',
  `shipping_total` decimal(19,4) DEFAULT '0.0000',
  `bv_total` decimal(19,4) DEFAULT '0.0000',
  `cv_total` decimal(19,4) DEFAULT '0.0000',
  `discount_total` decimal(19,4) DEFAULT '0.0000',
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `IX_auto_orders_TreeUserID` (`tree_user_id`),
  KEY `IX_auto_orders_auto_orderStatusID` (`auto_order_status_id`),
  KEY `ao_pr_idx` (`id`),
  KEY `ao_pr_cl_idx` (`client_auto_order_id`),
  KEY `tree_ao_chksm_idx` (`checksum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_autoship_statuses`
--

DROP TABLE IF EXISTS `tree_autoship_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_autoship_statuses` (
  `id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_autoship_templates`
--

DROP TABLE IF EXISTS `tree_autoship_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_autoship_templates` (
  `id` int(11) DEFAULT NULL,
  `tree_user_id` int(11) DEFAULT NULL,
  `next_ship_date` datetime DEFAULT NULL,
  `last_ship_date` datetime DEFAULT NULL,
  `autoship_status_id` int(11) DEFAULT NULL,
  `frequency_type_id` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `cancelled_date` datetime DEFAULT NULL,
  `last_order_id` int(11) DEFAULT NULL,
  `currency_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  KEY `IX_AutoshipTemplates_UserID` (`tree_user_id`),
  KEY `IX_AutoshipTemplates_ATStatusID` (`autoship_status_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_bonuses`
--

DROP TABLE IF EXISTS `tree_bonuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_bonuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `period_type_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_commission_bonuses`
--

DROP TABLE IF EXISTS `tree_commission_bonuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_commission_bonuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commission_run_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `bonus_id` int(11) DEFAULT NULL,
  `amount` decimal(12,4) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_tree_commission_bonuses_commission_run_id` (`commission_run_id`) USING BTREE,
  KEY `ix_tree_commission_bonuses_customer_id` (`customer_id`) USING BTREE,
  KEY `ix_tree_commission_bonuses_bonus_id` (`bonus_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_commission_details`
--

DROP TABLE IF EXISTS `tree_commission_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_commission_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `commission_run_id` int(11) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `bonus_id` int(11) DEFAULT NULL,
  `from_customer_id` int(11) DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  `source_amount` decimal(12,4) DEFAULT NULL,
  `percentage` decimal(12,4) DEFAULT NULL,
  `commission_amount` decimal(12,4) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `paid_level` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ix__commission_run_id__customer_id__bonus_id` (`commission_run_id`,`customer_id`,`bonus_id`),
  KEY `ix_tree_commission_details_from_customer_id` (`from_customer_id`) USING BTREE,
  KEY `ix_tree_commission_details_order_id` (`order_id`) USING BTREE,
  KEY `ix_tree_commission_details_commission_run_id` (`commission_run_id`) USING BTREE,
  KEY `ix_tree_commission_details_bonus_id` (`bonus_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_commission_run_statuses`
--

DROP TABLE IF EXISTS `tree_commission_run_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_commission_run_statuses` (
  `id` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_commission_runs`
--

DROP TABLE IF EXISTS `tree_commission_runs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_commission_runs` (
  `id` int(11) NOT NULL,
  `client_period_type_id` int(11) NOT NULL,
  `client_period_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `run_date` datetime DEFAULT NULL,
  `accepted_date` datetime DEFAULT NULL,
  `commission_run_status_id` int(11) DEFAULT NULL,
  `plan_id` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  KEY `IX_comm_run_periodid` (`period_id`),
  KEY `IX_comm_run_client_periodids` (`client_period_id`,`client_period_type_id`),
  KEY `ix_tree_commission_runs_id` (`id`) USING BTREE,
  KEY `ix_tree_commission_runs_commission_run_status_id` (`commission_run_status_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_commissions`
--

DROP TABLE IF EXISTS `tree_commissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_commissions` (
  `tree_user_id` int(11) NOT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `commission_run_id` int(11) NOT NULL,
  `currency_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `earnings` decimal(19,4) DEFAULT '0.0000',
  `previous_balance` decimal(19,4) DEFAULT '0.0000',
  `balance_forward` decimal(19,4) DEFAULT '0.0000',
  `fee` decimal(19,4) DEFAULT '0.0000',
  `total` decimal(19,4) DEFAULT '0.0000',
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  KEY `IX_commissions_checksum` (`checksum`),
  KEY `IX_commissions_ClientUserID` (`client_user_id`),
  KEY `IX_comm_userid_runid` (`tree_user_id`,`commission_run_id`),
  KEY `ix_tree_commissions_commission_run_id` (`commission_run_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_dynamic_field_mappings`
--

DROP TABLE IF EXISTS `tree_dynamic_field_mappings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_dynamic_field_mappings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `db_column_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `app_field_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `icentris_field_helper` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `default_display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_etl_statuses`
--

DROP TABLE IF EXISTS `tree_etl_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_etl_statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tracking_id` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `run_time_seconds` int(11) DEFAULT NULL,
  `extras` varchar(3000) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tree_etl_statuses_on_tracking_id` (`tracking_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_ext_event_attendee_types`
--

DROP TABLE IF EXISTS `tree_ext_event_attendee_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_ext_event_attendee_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_ext_event_attendees`
--

DROP TABLE IF EXISTS `tree_ext_event_attendees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_ext_event_attendees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `purchaser_client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `purchaser_tree_user_id` int(11) DEFAULT NULL,
  `attendee_id` int(11) DEFAULT NULL,
  `attendee_client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attendee_tree_user_id` int(11) DEFAULT NULL,
  `attendee_type_id` int(11) DEFAULT NULL,
  `attendee_client_rank_id` int(11) DEFAULT NULL,
  `attendee_rank_id` int(11) DEFAULT NULL,
  `attendee_first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attendee_last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attendee_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attendee_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attendee_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `entry_date` date DEFAULT NULL,
  `modified_date` date DEFAULT NULL,
  `ticket_status` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ticket_price` decimal(10,0) DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `event_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `order_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_tree_ext_event_attendees_purchaser_client_user_id` (`purchaser_client_user_id`) USING BTREE,
  KEY `ix_tree_ext_event_attendees_purchaser_tree_user_id` (`purchaser_tree_user_id`) USING BTREE,
  KEY `ix_tree_ext_event_attendees_attendee_client_user_id` (`attendee_client_user_id`) USING BTREE,
  KEY `ix_tree_ext_event_attendees_attendee_tree_user_id` (`attendee_tree_user_id`) USING BTREE,
  KEY `ix_tree_ext_event_attendees_checksum` (`checksum`) USING BTREE,
  KEY `ix_tree_ext_event_attendees_event_code` (`event_code`) USING BTREE,
  KEY `ix_tree_ext_event_attendees_order_id` (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_ext_event_types`
--

DROP TABLE IF EXISTS `tree_ext_event_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_ext_event_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_ext_events`
--

DROP TABLE IF EXISTS `tree_ext_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_ext_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tee_code` (`code`),
  KEY `idx_tee_chks` (`checksum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_ext_subscriptions`
--

DROP TABLE IF EXISTS `tree_ext_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_ext_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_frequency_types`
--

DROP TABLE IF EXISTS `tree_frequency_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_frequency_types` (
  `id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_order_items`
--

DROP TABLE IF EXISTS `tree_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_order_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) DEFAULT NULL,
  `product_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `product_description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `price_each` decimal(19,4) DEFAULT '0.0000',
  `price_total` decimal(19,4) DEFAULT '0.0000',
  `weight_each` decimal(19,4) DEFAULT '0.0000',
  `weight_total` decimal(19,4) DEFAULT '0.0000',
  `tax` decimal(19,4) DEFAULT '0.0000',
  `bv` decimal(19,4) DEFAULT '0.0000',
  `bv_each` decimal(19,4) DEFAULT '0.0000',
  `cv_each` decimal(19,4) DEFAULT '0.0000',
  `cv` decimal(19,4) DEFAULT '0.0000',
  `parent_product_id` int(11) DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tracking_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carrier_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `decimal_field1` decimal(19,4) DEFAULT NULL,
  `decimal_field2` decimal(19,4) DEFAULT NULL,
  `decimal_field3` decimal(19,4) DEFAULT NULL,
  `decimal_field4` decimal(19,4) DEFAULT NULL,
  `decimal_field5` decimal(19,4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_order_items_orderid_itemid` (`order_id`,`order_item_id`),
  KEY `tree_oi_chksm_idx` (`checksum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_order_statuses`
--

DROP TABLE IF EXISTS `tree_order_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_order_statuses` (
  `id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_order_types`
--

DROP TABLE IF EXISTS `tree_order_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_order_types` (
  `id` int(11) DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_orders`
--

DROP TABLE IF EXISTS `tree_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_orders` (
  `id` int(11) NOT NULL,
  `tree_user_id` int(11) NOT NULL,
  `order_status_id` int(11) DEFAULT NULL,
  `order_type_id` int(11) DEFAULT NULL,
  `period_id` int(11) DEFAULT NULL,
  `return_order_id` int(11) DEFAULT NULL,
  `autoship_template_id` int(11) DEFAULT NULL,
  `order_date` datetime DEFAULT NULL,
  `currency_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `total` decimal(19,4) DEFAULT '0.0000',
  `sub_total` decimal(19,4) DEFAULT '0.0000',
  `tax_total` decimal(19,4) DEFAULT '0.0000',
  `shipping_total` decimal(19,4) DEFAULT '0.0000',
  `bv_total` decimal(19,4) DEFAULT '0.0000',
  `cv_total` decimal(19,4) DEFAULT '0.0000',
  `discount_total` decimal(19,4) DEFAULT '0.0000',
  `discount_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipped_date` datetime DEFAULT NULL,
  `shipping_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `shipping_county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tracking_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carrier_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `client_order_id` int(11) DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `old_order_status_id` int(11) DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `party_id` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY `IX_Orders_TreeUserID` (`tree_user_id`),
  KEY `IX_Orders_OrderStatusID` (`order_status_id`),
  KEY `to_corderid_idx` (`client_order_id`),
  KEY `to_cuserid_idx` (`client_user_id`),
  KEY `ix_treeoders_oldostatus_id` (`old_order_status_id`),
  KEY `tree_orders_chksm_idx` (`checksum`),
  KEY `treeor_id` (`id`),
  KEY `idx_to_mod_date` (`modified_date`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_parties`
--

DROP TABLE IF EXISTS `tree_parties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_parties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` int(11) NOT NULL,
  `client_user_id` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `host_id` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `party_id` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `party_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `party_type_id` int(11) DEFAULT NULL,
  `party_status_id` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `close_date` datetime DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `int_field1` int(11) DEFAULT NULL,
  `int_field2` int(11) DEFAULT NULL,
  `int_field3` int(11) DEFAULT NULL,
  `int_field4` int(11) DEFAULT NULL,
  `int_field5` int(11) DEFAULT NULL,
  `int_field6` int(11) DEFAULT NULL,
  `int_field7` int(11) DEFAULT NULL,
  `int_field8` int(11) DEFAULT NULL,
  `decimal_field1` decimal(19,4) DEFAULT NULL,
  `decimal_field2` decimal(19,4) DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `date2` datetime DEFAULT NULL,
  `date3` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `IX_Parties_TreeUserID` (`tree_user_id`),
  KEY `IX_Parties_PartyID` (`party_id`),
  KEY `IX_Parties_ClientUserID` (`client_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_party_statuses`
--

DROP TABLE IF EXISTS `tree_party_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_party_statuses` (
  `id` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_party_types`
--

DROP TABLE IF EXISTS `tree_party_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_party_types` (
  `id` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_period_data`
--

DROP TABLE IF EXISTS `tree_period_data`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_period_data` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period_id` int(11) NOT NULL,
  `tree_user_id` int(11) NOT NULL,
  `period_type_id` int(11) DEFAULT NULL,
  `rank_id` int(11) DEFAULT NULL,
  `paid_rank_id` int(11) DEFAULT NULL,
  `client_period_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_rank_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_paid_rank_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `decimal_field1` decimal(19,4) DEFAULT '0.0000',
  `decimal_field2` decimal(19,4) DEFAULT '0.0000',
  `decimal_field3` decimal(19,4) DEFAULT '0.0000',
  `decimal_field4` decimal(19,4) DEFAULT '0.0000',
  `decimal_field5` decimal(19,4) DEFAULT '0.0000',
  `decimal_field6` decimal(19,4) DEFAULT '0.0000',
  `decimal_field7` decimal(19,4) DEFAULT '0.0000',
  `decimal_field8` decimal(19,4) DEFAULT '0.0000',
  `decimal_field9` decimal(19,4) DEFAULT '0.0000',
  `decimal_field10` decimal(19,4) DEFAULT '0.0000',
  `decimal_field11` decimal(19,4) DEFAULT '0.0000',
  `decimal_field12` decimal(19,4) DEFAULT '0.0000',
  `decimal_field13` decimal(19,4) DEFAULT '0.0000',
  `decimal_field14` decimal(19,4) DEFAULT '0.0000',
  `decimal_field15` decimal(19,4) DEFAULT '0.0000',
  `decimal_field16` decimal(19,4) DEFAULT '0.0000',
  `decimal_field17` decimal(19,4) DEFAULT '0.0000',
  `decimal_field18` decimal(19,4) DEFAULT '0.0000',
  `decimal_field19` decimal(19,4) DEFAULT '0.0000',
  `decimal_field20` decimal(19,4) DEFAULT '0.0000',
  `decimal_field21` decimal(19,4) DEFAULT '0.0000',
  `decimal_field22` decimal(19,4) DEFAULT '0.0000',
  `decimal_field23` decimal(19,4) DEFAULT '0.0000',
  `decimal_field24` decimal(19,4) DEFAULT '0.0000',
  `decimal_field25` decimal(19,4) DEFAULT '0.0000',
  `decimal_field26` decimal(19,4) DEFAULT '0.0000',
  `decimal_field27` decimal(19,4) DEFAULT '0.0000',
  `decimal_field28` decimal(19,4) DEFAULT '0.0000',
  `decimal_field29` decimal(19,4) DEFAULT '0.0000',
  `decimal_field30` decimal(19,4) DEFAULT '0.0000',
  `decimal_field31` decimal(19,4) DEFAULT '0.0000',
  `decimal_field32` decimal(19,4) DEFAULT '0.0000',
  `decimal_field33` decimal(19,4) DEFAULT '0.0000',
  `decimal_field34` decimal(19,4) DEFAULT '0.0000',
  `decimal_field35` decimal(19,4) DEFAULT '0.0000',
  `decimal_field36` decimal(19,4) DEFAULT '0.0000',
  `decimal_field37` decimal(19,4) DEFAULT '0.0000',
  `decimal_field38` decimal(19,4) DEFAULT '0.0000',
  `decimal_field39` decimal(19,4) DEFAULT '0.0000',
  `decimal_field40` decimal(19,4) DEFAULT '0.0000',
  `decimal_field41` decimal(19,4) DEFAULT '0.0000',
  `decimal_field42` decimal(19,4) DEFAULT '0.0000',
  `decimal_field43` decimal(19,4) DEFAULT '0.0000',
  `decimal_field44` decimal(19,4) DEFAULT '0.0000',
  `decimal_field45` decimal(19,4) DEFAULT '0.0000',
  `decimal_field46` decimal(19,4) DEFAULT '0.0000',
  `decimal_field47` decimal(19,4) DEFAULT '0.0000',
  `decimal_field48` decimal(19,4) DEFAULT '0.0000',
  `decimal_field49` decimal(19,4) DEFAULT '0.0000',
  `decimal_field50` decimal(19,4) DEFAULT '0.0000',
  `decimal_field51` decimal(19,4) DEFAULT '0.0000',
  `decimal_field52` decimal(19,4) DEFAULT '0.0000',
  `decimal_field53` decimal(19,4) DEFAULT '0.0000',
  `decimal_field54` decimal(19,4) DEFAULT '0.0000',
  `decimal_field55` decimal(19,4) DEFAULT '0.0000',
  `decimal_field56` decimal(19,4) DEFAULT '0.0000',
  `decimal_field57` decimal(19,4) DEFAULT '0.0000',
  `decimal_field58` decimal(19,4) DEFAULT '0.0000',
  `decimal_field59` decimal(19,4) DEFAULT '0.0000',
  `decimal_field60` decimal(19,4) DEFAULT '0.0000',
  `decimal_field61` decimal(19,4) DEFAULT '0.0000',
  `decimal_field62` decimal(19,4) DEFAULT '0.0000',
  `decimal_field63` decimal(19,4) DEFAULT '0.0000',
  `decimal_field64` decimal(19,4) DEFAULT '0.0000',
  `decimal_field65` decimal(19,4) DEFAULT '0.0000',
  `decimal_field66` decimal(19,4) DEFAULT '0.0000',
  `decimal_field67` decimal(19,4) DEFAULT '0.0000',
  `decimal_field68` decimal(19,4) DEFAULT '0.0000',
  `decimal_field69` decimal(19,4) DEFAULT '0.0000',
  `decimal_field70` decimal(19,4) DEFAULT '0.0000',
  `decimal_field71` decimal(19,4) DEFAULT '0.0000',
  `decimal_field72` decimal(19,4) DEFAULT '0.0000',
  `decimal_field73` decimal(19,4) DEFAULT '0.0000',
  `decimal_field74` decimal(19,4) DEFAULT '0.0000',
  `decimal_field75` decimal(19,4) DEFAULT '0.0000',
  `decimal_field76` decimal(19,4) DEFAULT '0.0000',
  `decimal_field77` decimal(19,4) DEFAULT '0.0000',
  `decimal_field78` decimal(19,4) DEFAULT '0.0000',
  `decimal_field79` decimal(19,4) DEFAULT '0.0000',
  `decimal_field80` decimal(19,4) DEFAULT '0.0000',
  `decimal_field81` decimal(19,4) DEFAULT '0.0000',
  `decimal_field82` decimal(19,4) DEFAULT '0.0000',
  `decimal_field83` decimal(19,4) DEFAULT '0.0000',
  `decimal_field84` decimal(19,4) DEFAULT '0.0000',
  `decimal_field85` decimal(19,4) DEFAULT '0.0000',
  `decimal_field86` decimal(19,4) DEFAULT '0.0000',
  `decimal_field87` decimal(19,4) DEFAULT '0.0000',
  `decimal_field88` decimal(19,4) DEFAULT '0.0000',
  `decimal_field89` decimal(19,4) DEFAULT '0.0000',
  `decimal_field90` decimal(19,4) DEFAULT '0.0000',
  `decimal_field91` decimal(19,4) DEFAULT '0.0000',
  `decimal_field92` decimal(19,4) DEFAULT '0.0000',
  `decimal_field93` decimal(19,4) DEFAULT '0.0000',
  `decimal_field94` decimal(19,4) DEFAULT '0.0000',
  `decimal_field95` decimal(19,4) DEFAULT '0.0000',
  `decimal_field96` decimal(19,4) DEFAULT '0.0000',
  `decimal_field97` decimal(19,4) DEFAULT '0.0000',
  `decimal_field98` decimal(19,4) DEFAULT '0.0000',
  `decimal_field99` decimal(19,4) DEFAULT '0.0000',
  `decimal_field100` decimal(19,4) DEFAULT '0.0000',
  `decimal_field101` decimal(19,4) DEFAULT '0.0000',
  `decimal_field102` decimal(19,4) DEFAULT '0.0000',
  `decimal_field103` decimal(19,4) DEFAULT '0.0000',
  `decimal_field104` decimal(19,4) DEFAULT '0.0000',
  `decimal_field105` decimal(19,4) DEFAULT '0.0000',
  `decimal_field106` decimal(19,4) DEFAULT '0.0000',
  `decimal_field107` decimal(19,4) DEFAULT '0.0000',
  `decimal_field108` decimal(19,4) DEFAULT '0.0000',
  `decimal_field109` decimal(19,4) DEFAULT '0.0000',
  `decimal_field110` decimal(19,4) DEFAULT '0.0000',
  `decimal_field111` decimal(19,4) DEFAULT '0.0000',
  `decimal_field112` decimal(19,4) DEFAULT '0.0000',
  `decimal_field113` decimal(19,4) DEFAULT '0.0000',
  `decimal_field114` decimal(19,4) DEFAULT '0.0000',
  `decimal_field115` decimal(19,4) DEFAULT '0.0000',
  `decimal_field116` decimal(19,4) DEFAULT '0.0000',
  `decimal_field117` decimal(19,4) DEFAULT '0.0000',
  `decimal_field118` decimal(19,4) DEFAULT '0.0000',
  `decimal_field119` decimal(19,4) DEFAULT '0.0000',
  `decimal_field120` decimal(19,4) DEFAULT '0.0000',
  `decimal_field121` decimal(19,4) DEFAULT '0.0000',
  `decimal_field122` decimal(19,4) DEFAULT '0.0000',
  `decimal_field123` decimal(19,4) DEFAULT '0.0000',
  `decimal_field124` decimal(19,4) DEFAULT '0.0000',
  `decimal_field125` decimal(19,4) DEFAULT '0.0000',
  `decimal_field126` decimal(19,4) DEFAULT '0.0000',
  `decimal_field127` decimal(19,4) DEFAULT '0.0000',
  `decimal_field128` decimal(19,4) DEFAULT '0.0000',
  `decimal_field129` decimal(19,4) DEFAULT '0.0000',
  `decimal_field130` decimal(19,4) DEFAULT '0.0000',
  `decimal_field131` decimal(19,4) DEFAULT '0.0000',
  `decimal_field132` decimal(19,4) DEFAULT '0.0000',
  `decimal_field133` decimal(19,4) DEFAULT '0.0000',
  `decimal_field134` decimal(19,4) DEFAULT '0.0000',
  `decimal_field135` decimal(19,4) DEFAULT '0.0000',
  `decimal_field136` decimal(19,4) DEFAULT '0.0000',
  `decimal_field137` decimal(19,4) DEFAULT '0.0000',
  `decimal_field138` decimal(19,4) DEFAULT '0.0000',
  `decimal_field139` decimal(19,4) DEFAULT '0.0000',
  `decimal_field140` decimal(19,4) DEFAULT '0.0000',
  `decimal_field141` decimal(19,4) DEFAULT '0.0000',
  `decimal_field142` decimal(19,4) DEFAULT '0.0000',
  `decimal_field143` decimal(19,4) DEFAULT '0.0000',
  `decimal_field144` decimal(19,4) DEFAULT '0.0000',
  `decimal_field145` decimal(19,4) DEFAULT '0.0000',
  `decimal_field146` decimal(19,4) DEFAULT '0.0000',
  `decimal_field147` decimal(19,4) DEFAULT '0.0000',
  `decimal_field148` decimal(19,4) DEFAULT '0.0000',
  `decimal_field149` decimal(19,4) DEFAULT '0.0000',
  `decimal_field150` decimal(19,4) DEFAULT '0.0000',
  `decimal_field151` decimal(19,4) DEFAULT '0.0000',
  `decimal_field152` decimal(19,4) DEFAULT '0.0000',
  `decimal_field153` decimal(19,4) DEFAULT '0.0000',
  `decimal_field154` decimal(19,4) DEFAULT '0.0000',
  `decimal_field155` decimal(19,4) DEFAULT '0.0000',
  `decimal_field156` decimal(19,4) DEFAULT '0.0000',
  `decimal_field157` decimal(19,4) DEFAULT '0.0000',
  `decimal_field158` decimal(19,4) DEFAULT '0.0000',
  `decimal_field159` decimal(19,4) DEFAULT '0.0000',
  `decimal_field160` decimal(19,4) DEFAULT '0.0000',
  `decimal_field161` decimal(19,4) DEFAULT '0.0000',
  `decimal_field162` decimal(19,4) DEFAULT '0.0000',
  `decimal_field163` decimal(19,4) DEFAULT '0.0000',
  `decimal_field164` decimal(19,4) DEFAULT '0.0000',
  `decimal_field165` decimal(19,4) DEFAULT '0.0000',
  `decimal_field166` decimal(19,4) DEFAULT '0.0000',
  `decimal_field167` decimal(19,4) DEFAULT '0.0000',
  `decimal_field168` decimal(19,4) DEFAULT '0.0000',
  `decimal_field169` decimal(19,4) DEFAULT '0.0000',
  `decimal_field170` decimal(19,4) DEFAULT '0.0000',
  `decimal_field171` decimal(19,4) DEFAULT '0.0000',
  `decimal_field172` decimal(19,4) DEFAULT '0.0000',
  `decimal_field173` decimal(19,4) DEFAULT '0.0000',
  `decimal_field174` decimal(19,4) DEFAULT '0.0000',
  `decimal_field175` decimal(19,4) DEFAULT '0.0000',
  `decimal_field176` decimal(19,4) DEFAULT '0.0000',
  `decimal_field177` decimal(19,4) DEFAULT '0.0000',
  `decimal_field178` decimal(19,4) DEFAULT '0.0000',
  `decimal_field179` decimal(19,4) DEFAULT '0.0000',
  `decimal_field180` decimal(19,4) DEFAULT '0.0000',
  `decimal_field181` decimal(19,4) DEFAULT '0.0000',
  `decimal_field182` decimal(19,4) DEFAULT '0.0000',
  `decimal_field183` decimal(19,4) DEFAULT '0.0000',
  `decimal_field184` decimal(19,4) DEFAULT '0.0000',
  `decimal_field185` decimal(19,4) DEFAULT '0.0000',
  `decimal_field186` decimal(19,4) DEFAULT '0.0000',
  `decimal_field187` decimal(19,4) DEFAULT '0.0000',
  `decimal_field188` decimal(19,4) DEFAULT '0.0000',
  `decimal_field189` decimal(19,4) DEFAULT '0.0000',
  `decimal_field190` decimal(19,4) DEFAULT '0.0000',
  `decimal_field191` decimal(19,4) DEFAULT '0.0000',
  `decimal_field192` decimal(19,4) DEFAULT '0.0000',
  `decimal_field193` decimal(19,4) DEFAULT '0.0000',
  `decimal_field194` decimal(19,4) DEFAULT '0.0000',
  `decimal_field195` decimal(19,4) DEFAULT '0.0000',
  `decimal_field196` decimal(19,4) DEFAULT '0.0000',
  `decimal_field197` decimal(19,4) DEFAULT '0.0000',
  `decimal_field198` decimal(19,4) DEFAULT '0.0000',
  `decimal_field199` decimal(19,4) DEFAULT '0.0000',
  `decimal_field200` decimal(19,4) DEFAULT '0.0000',
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tree_pd_chksm_idx` (`checksum`),
  KEY `tree_pd_field60_idx` (`decimal_field60`),
  KEY `index_tree_period_data_on_period_id` (`period_id`),
  KEY `index_tree_period_data_on_tree_user_id` (`tree_user_id`),
  KEY `tree_period_data_cuserandcperiod` (`client_user_id`,`client_period_id`),
  KEY `tpd_df2_idx` (`decimal_field2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_period_data_plus`
--

DROP TABLE IF EXISTS `tree_period_data_plus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_period_data_plus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period_data_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `tree_user_id` int(11) NOT NULL,
  `field1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field6` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field7` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field8` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field9` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field10` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `int_field1` int(11) DEFAULT NULL,
  `int_field2` int(11) DEFAULT NULL,
  `int_field3` int(11) DEFAULT NULL,
  `int_field4` int(11) DEFAULT NULL,
  `int_field5` int(11) DEFAULT NULL,
  `int_field6` int(11) DEFAULT NULL,
  `int_field7` int(11) DEFAULT NULL,
  `int_field8` int(11) DEFAULT NULL,
  `int_field9` int(11) DEFAULT NULL,
  `int_field10` int(11) DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `period_type_id` int(11) DEFAULT NULL,
  `client_period_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `decimal_field1` decimal(19,4) DEFAULT '0.0000',
  `decimal_field2` decimal(19,4) DEFAULT '0.0000',
  `decimal_field3` decimal(19,4) DEFAULT '0.0000',
  `decimal_field4` decimal(19,4) DEFAULT '0.0000',
  `decimal_field5` decimal(19,4) DEFAULT '0.0000',
  `decimal_field6` decimal(19,4) DEFAULT '0.0000',
  `decimal_field7` decimal(19,4) DEFAULT '0.0000',
  `decimal_field8` decimal(19,4) DEFAULT '0.0000',
  `decimal_field9` decimal(19,4) DEFAULT '0.0000',
  `decimal_field10` decimal(19,4) DEFAULT '0.0000',
  `flag1` tinyint(1) DEFAULT NULL,
  `flag2` tinyint(1) DEFAULT NULL,
  `flag3` tinyint(1) DEFAULT NULL,
  `flag4` tinyint(1) DEFAULT NULL,
  `flag5` tinyint(1) DEFAULT NULL,
  `flag6` tinyint(1) DEFAULT NULL,
  `flag7` tinyint(1) DEFAULT NULL,
  `flag8` tinyint(1) DEFAULT NULL,
  `flag9` tinyint(1) DEFAULT NULL,
  `flag10` tinyint(1) DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `date2` datetime DEFAULT NULL,
  `date3` datetime DEFAULT NULL,
  `date4` datetime DEFAULT NULL,
  `date5` datetime DEFAULT NULL,
  `date6` datetime DEFAULT NULL,
  `date7` datetime DEFAULT NULL,
  `date8` datetime DEFAULT NULL,
  `date9` datetime DEFAULT NULL,
  `date10` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tree_period_data_plus_on_period_data_id` (`period_data_id`),
  UNIQUE KEY `index_tree_period_data_plus_on_period_id_and_tree_user_id` (`period_id`,`tree_user_id`),
  KEY `index_tree_period_data_plus_on_int_field1` (`int_field1`),
  KEY `ix_treeperioddataplus_cl_period_id` (`client_period_id`),
  KEY `ix_treeperioddataplus_cl_user_id` (`client_user_id`),
  KEY `ix_treeperioddataplus_cl_periodtype_id` (`period_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_period_rank_scores`
--

DROP TABLE IF EXISTS `tree_period_rank_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_period_rank_scores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_period_id` int(11) DEFAULT NULL,
  `paid_rank_id` int(11) DEFAULT NULL,
  `score` decimal(10,0) DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `close_to_flag` tinyint(4) DEFAULT NULL,
  `at_risk_flag` tinyint(4) DEFAULT NULL,
  `period_id` int(11) DEFAULT NULL,
  `period_type_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_tree_period_rank_scores_tree_user_id` (`tree_user_id`) USING BTREE,
  KEY `ix_tree_period_rank_scores_checksum` (`checksum`) USING BTREE,
  KEY `ix_tree_period_rank_scores_period_id` (`period_id`) USING BTREE,
  KEY `ix_tree_period_rank_scores_client_period_id` (`client_period_id`) USING BTREE,
  KEY `ix_tree_period_rank_scores_close_to_flag` (`close_to_flag`) USING BTREE,
  KEY `ix_tree_period_rank_scores_at_risk_flag` (`at_risk_flag`) USING BTREE,
  KEY `ix_tree_period_rank_scores_period_type_id` (`period_type_id`) USING BTREE,
  KEY `ix_tree_period_rank_scores_tprcm` (`tree_user_id`,`period_id`,`checksum`) USING BTREE,
  KEY `ix_tree_period_rank_scores_paid_rank_id` (`paid_rank_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_period_types`
--

DROP TABLE IF EXISTS `tree_period_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_period_types` (
  `id` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_periods`
--

DROP TABLE IF EXISTS `tree_periods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_periods` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `period_type_id` int(11) NOT NULL,
  `client_period_id` int(11) DEFAULT NULL,
  `period_text` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_placements`
--

DROP TABLE IF EXISTS `tree_placements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_placements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` int(11) NOT NULL,
  `upline_id` int(11) DEFAULT NULL,
  `lft` bigint(20) DEFAULT NULL,
  `rgt` bigint(20) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `PK_PlacementTree` (`tree_user_id`),
  KEY `IX_PlacementTree_Lft` (`lft`),
  KEY `IX_PlacementTree_Rgt` (`rgt`),
  KEY `IX_PlacementTree_Lvl` (`level`),
  KEY `index_tree_placements_on_upline_id` (`upline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_rank_changes`
--

DROP TABLE IF EXISTS `tree_rank_changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_rank_changes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `consultant_rank_change_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tree_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank_id` int(11) DEFAULT NULL,
  `modified_date` datetime DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_tree_rank_changes_tree_user_id` (`tree_user_id`) USING BTREE,
  KEY `ix_tree_rank_changes_client_user_id` (`client_user_id`) USING BTREE,
  KEY `ix_tree_rank_changes_checksum` (`checksum`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_sponsors`
--

DROP TABLE IF EXISTS `tree_sponsors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_sponsors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` int(11) NOT NULL,
  `upline_id` int(11) DEFAULT NULL,
  `lft` bigint(20) DEFAULT NULL,
  `rgt` bigint(20) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `position` int(11) DEFAULT NULL,
  UNIQUE KEY `PK_SponsorTree` (`tree_user_id`),
  UNIQUE KEY `id` (`id`),
  KEY `IX_SponsorTree_Lft` (`lft`),
  KEY `IX_SponsorTree_Rgt` (`rgt`),
  KEY `IX_SponsorTree_Lvl` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_subscriptions`
--

DROP TABLE IF EXISTS `tree_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_subscriptions` (
  `subscription_id` int(11) DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `expire_date` datetime DEFAULT NULL,
  KEY `idx_tree_subscriptions_cuid` (`client_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_subscriptions_staging`
--

DROP TABLE IF EXISTS `tree_subscriptions_staging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_subscriptions_staging` (
  `subscription_id` int(11) DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `expire_date` datetime DEFAULT NULL,
  KEY `idx_tree_subscriptions_stg_cuid` (`client_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_user_ext_subscriptions`
--

DROP TABLE IF EXISTS `tree_user_ext_subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_user_ext_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` int(11) DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subscription_id` int(11) DEFAULT NULL,
  `subscription_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `expiration_date` datetime DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_tues_tuid` (`tree_user_id`),
  KEY `idx_tues_sid` (`subscription_id`),
  KEY `comp_idx_tuid_sid` (`tree_user_id`,`subscription_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_user_geocodes`
--

DROP TABLE IF EXISTS `tree_user_geocodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_user_geocodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` int(11) DEFAULT NULL,
  `geocode_attempts` int(11) DEFAULT '0',
  `lat` float DEFAULT NULL,
  `lon` float DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ix_tree_user_geocodes_TreeUserId` (`tree_user_id`),
  KEY `ix_tree_user_geocodes_checksum` (`checksum`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_user_plus`
--

DROP TABLE IF EXISTS `tree_user_plus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_user_plus` (
  `tree_user_id` int(11) NOT NULL,
  `first_sponsor_id` int(11) DEFAULT NULL,
  `last_order_date` datetime DEFAULT NULL,
  `last_order_total` decimal(19,4) DEFAULT '0.0000',
  `decimal_field1` decimal(19,4) DEFAULT '0.0000',
  `decimal_field2` decimal(19,4) DEFAULT '0.0000',
  `decimal_field3` decimal(19,4) DEFAULT '0.0000',
  `decimal_field4` decimal(19,4) DEFAULT '0.0000',
  `decimal_field5` decimal(19,4) DEFAULT '0.0000',
  `decimal_field6` decimal(19,4) DEFAULT '0.0000',
  `decimal_field7` decimal(19,4) DEFAULT '0.0000',
  `decimal_field8` decimal(19,4) DEFAULT '0.0000',
  `decimal_field9` decimal(19,4) DEFAULT '0.0000',
  `decimal_field10` decimal(19,4) DEFAULT '0.0000',
  `date1` datetime DEFAULT NULL,
  `date2` datetime DEFAULT NULL,
  `date3` datetime DEFAULT NULL,
  `date4` datetime DEFAULT NULL,
  `date5` datetime DEFAULT NULL,
  `date6` datetime DEFAULT NULL,
  `date7` datetime DEFAULT NULL,
  `date8` datetime DEFAULT NULL,
  `date9` datetime DEFAULT NULL,
  `date10` datetime DEFAULT NULL,
  `int_field1` int(11) DEFAULT NULL,
  `int_field2` int(11) DEFAULT NULL,
  `int_field3` int(11) DEFAULT NULL,
  `int_field4` int(11) DEFAULT NULL,
  `int_field5` int(11) DEFAULT NULL,
  `int_field6` int(11) DEFAULT NULL,
  `int_field7` int(11) DEFAULT NULL,
  `int_field8` int(11) DEFAULT NULL,
  `int_field9` int(11) DEFAULT NULL,
  `int_field10` int(11) DEFAULT NULL,
  `last_order_id` int(11) DEFAULT NULL,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field6` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field7` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field8` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field9` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field10` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field11` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field12` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field13` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field14` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field15` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `int_field11` int(11) DEFAULT NULL,
  `int_field12` int(11) DEFAULT NULL,
  `int_field13` int(11) DEFAULT NULL,
  `int_field14` int(11) DEFAULT NULL,
  `int_field15` int(11) DEFAULT NULL,
  `int_field16` int(11) DEFAULT NULL,
  `int_field17` int(11) DEFAULT NULL,
  `int_field18` int(11) DEFAULT NULL,
  `int_field19` int(11) DEFAULT NULL,
  `int_field20` int(11) DEFAULT NULL,
  PRIMARY KEY (`tree_user_id`),
  KEY `tup_treeuserid_idx` (`tree_user_id`),
  KEY `ix_treeuserplus_cl_user_id` (`client_user_id`),
  KEY `IX_Tree_User_Plus_First_Sponsor_Id` (`first_sponsor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_user_statuses`
--

DROP TABLE IF EXISTS `tree_user_statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_user_statuses` (
  `id` int(11) NOT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_user_summary`
--

DROP TABLE IF EXISTS `tree_user_summary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_user_summary` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tree_user_id` int(11) DEFAULT NULL,
  `non_sponsor_upline` text COLLATE utf8_unicode_ci,
  `left_most_tree_user_id` int(11) DEFAULT NULL,
  `right_most_tree_user_id` int(11) DEFAULT NULL,
  `upline_access_level` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ix_tree_users_aggregators_tree_user_id` (`tree_user_id`) USING BTREE,
  KEY `ix_tree_users_aggregators_left_most_tuid` (`left_most_tree_user_id`) USING BTREE,
  KEY `ix_tree_users_aggregators_right_most_tuid` (`right_most_tree_user_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_user_types`
--

DROP TABLE IF EXISTS `tree_user_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_user_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tree_users`
--

DROP TABLE IF EXISTS `tree_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tree_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `screen_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_type_id` int(11) DEFAULT NULL,
  `user_status_id` int(11) DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mobile_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fax` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_county` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preferred_language` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `rank_id` int(11) DEFAULT NULL,
  `paid_rank_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `sponsor_id` int(11) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field5` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date1` datetime DEFAULT NULL,
  `date2` datetime DEFAULT NULL,
  `date3` datetime DEFAULT NULL,
  `date4` datetime DEFAULT NULL,
  `date5` datetime DEFAULT NULL,
  `created_date` datetime DEFAULT NULL,
  `coded_date` datetime DEFAULT NULL,
  `updated_date` datetime DEFAULT NULL,
  `birth_month_day` int(11) DEFAULT NULL,
  `anniversary_month_day` int(11) DEFAULT NULL,
  `date6` datetime DEFAULT NULL,
  `date7` datetime DEFAULT NULL,
  `date8` datetime DEFAULT NULL,
  `date9` datetime DEFAULT NULL,
  `date10` datetime DEFAULT NULL,
  `int_field1` int(11) DEFAULT NULL,
  `int_field2` int(11) DEFAULT NULL,
  `int_field3` int(11) DEFAULT NULL,
  `int_field4` int(11) DEFAULT NULL,
  `int_field5` int(11) DEFAULT NULL,
  `int_field6` int(11) DEFAULT NULL,
  `int_field7` int(11) DEFAULT NULL,
  `int_field8` int(11) DEFAULT NULL,
  `int_field9` int(11) DEFAULT NULL,
  `int_field10` int(11) DEFAULT NULL,
  `client_parent_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_sponsor_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `checksum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_rank_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field6` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field7` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field8` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field9` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field10` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field11` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field12` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field13` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field14` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `field15` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lat` decimal(10,6) DEFAULT NULL,
  `lon` decimal(10,6) DEFAULT NULL,
  `address3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_address3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_address3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `other_suburb` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `children_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tree_users_on_client_user_id` (`client_user_id`),
  KEY `IX_TreeUsers_ClientUserID` (`client_user_id`),
  KEY `IX_TreeUsers_UserStatusID` (`user_status_id`),
  KEY `IX_TreeUsers_UserTypeID` (`user_type_id`),
  KEY `IX_TreeUsers_ParentID` (`parent_id`),
  KEY `IX_TreeUsers_SponsorID` (`sponsor_id`),
  KEY `IX_TreeUsers_RankID` (`rank_id`),
  KEY `IX_TreeUsers_PaidRankID` (`paid_rank_id`),
  KEY `IX_TreeUsers_ClientParentID` (`client_parent_id`),
  KEY `IX_TreeUsers_ClientSponsorID` (`client_sponsor_id`),
  KEY `tree_users_chksm_idx` (`checksum`),
  KEY `index_tree_users_on_anniversary_month_day` (`anniversary_month_day`),
  KEY `index_tree_users_on_birth_month_day` (`birth_month_day`),
  KEY `index_tree_users_on_first_name` (`first_name`),
  KEY `index_tree_users_on_last_name` (`last_name`),
  KEY `index_tree_users_on_country` (`country`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `market_id` int(11) DEFAULT NULL,
  `profile_id` int(11) DEFAULT NULL,
  `subscription_id` int(11) DEFAULT NULL,
  `consultant_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authentication_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_activity_at` datetime DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `password_changed_at` datetime DEFAULT NULL,
  `failed_attempts` int(11) NOT NULL DEFAULT '0',
  `unlock_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  `tree_user_id` int(11) DEFAULT NULL,
  `enroll_type` int(11) DEFAULT NULL,
  `spree_api_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `extras` text COLLATE utf8_unicode_ci,
  `current_payout_method_id` int(11) DEFAULT NULL,
  `password_salt` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `system_sms_opt_in` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_authentication_token` (`authentication_token`),
  UNIQUE KEY `index_users_on_username` (`username`),
  KEY `index_users_on_tree_user_id` (`tree_user_id`),
  KEY `index_users_on_consultant_id` (`consultant_id`),
  KEY `index_users_on_remember_token` (`remember_token`),
  KEY `index_users_on_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping events for database 'pyr_nevetica_dev'
--

--
-- Dumping routines for database 'pyr_nevetica_dev'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-01-08 12:23:21
