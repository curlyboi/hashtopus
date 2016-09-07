-- MySQL dump 10.13  Distrib 5.6.16, for Win64 (x86_64)
--
-- Host: localhost    Database: hashtopus
-- ------------------------------------------------------
-- Server version	5.6.16-log

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
-- Table structure for table `agents`
--

DROP TABLE IF EXISTS `agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE latin1_bin NOT NULL COMMENT 'Friendly machine name',
  `uid` varchar(36) COLLATE latin1_bin NOT NULL COMMENT 'HDD serial number',
  `os` tinyint(4) NOT NULL COMMENT '0=Win, 1=Unix',
  `cputype` tinyint(4) NOT NULL COMMENT '32/64',
  `gpus` text COLLATE latin1_bin NOT NULL COMMENT 'List of GPUs',
  `hcversion` varchar(10) COLLATE latin1_bin DEFAULT '' COMMENT 'Version of oclHashcat delivered to agent',
  `cmdpars` varchar(128) COLLATE latin1_bin DEFAULT NULL COMMENT 'Agent specific command line',
  `wait` int(11) NOT NULL DEFAULT '0' COMMENT 'Idle wait before cracking',
  `ignoreerrors` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Don''t pause agent on errors',
  `active` bit(1) NOT NULL DEFAULT b'1' COMMENT 'Flag if agent is active',
  `trusted` bit(1) NOT NULL DEFAULT b'1' COMMENT 'Is agent trusted for secret data?',
  `token` varchar(10) COLLATE latin1_bin NOT NULL COMMENT 'Generated access token',
  `lastact` varchar(10) COLLATE latin1_bin NOT NULL DEFAULT '' COMMENT 'Last action',
  `lasttime` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Last action time',
  `lastip` varchar(15) COLLATE latin1_bin NOT NULL DEFAULT '' COMMENT 'Last action IP',
  PRIMARY KEY (`id`),
  KEY `assignment_verify` (`token`,`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='List of Hashtopus agents';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `assignments`
--

DROP TABLE IF EXISTS `assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `assignments` (
  `task` int(11) NOT NULL COMMENT 'Task ID',
  `agent` int(11) NOT NULL COMMENT 'Agent ID',
  `benchmark` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Agent''s benchmark for this task',
  `autoadjust` tinyint(4) NOT NULL COMMENT 'Autoadjust override',
  `speed` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Current cracking speed',
  UNIQUE KEY `assigned_all` (`agent`),
  KEY `assigned_active` (`task`,`agent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Information about agents assignments';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `chunks`
--

DROP TABLE IF EXISTS `chunks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chunks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `task` int(11) DEFAULT NULL COMMENT 'Task ID',
  `skip` bigint(20) NOT NULL COMMENT 'Keyspace skip',
  `length` bigint(20) NOT NULL COMMENT 'Keyspace length',
  `agent` int(11) DEFAULT NULL COMMENT 'Agent ID',
  `dispatchtime` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Time of dispatching',
  `progress` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Confirmed progress in chunk (0 to length)',
  `rprogress` smallint(20) NOT NULL DEFAULT '0' COMMENT 'Real progress within chunk',
  `state` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Actual state of the chunk',
  `cracked` int(11) NOT NULL DEFAULT '0' COMMENT 'Number of cracked hashes',
  `solvetime` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Time of last activity',
  PRIMARY KEY (`id`),
  KEY `solve_verify` (`id`,`task`,`agent`),
  KEY `chunk_redispatch` (`task`,`agent`,`progress`,`length`,`dispatchtime`,`solvetime`,`skip`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Dispatched chunks of work';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `config`
--

DROP TABLE IF EXISTS `config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `config` (
  `item` varchar(16) COLLATE latin1_bin NOT NULL,
  `value` varchar(64) COLLATE latin1_bin NOT NULL,
  PRIMARY KEY (`item`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Global configuration values';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `errors`
--

DROP TABLE IF EXISTS `errors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `errors` (
  `agent` int(11) NOT NULL COMMENT 'Agent ID',
  `task` int(11) DEFAULT NULL COMMENT 'Task ID',
  `time` bigint(20) NOT NULL COMMENT 'Error time',
  `error` text COLLATE latin1_bin NOT NULL COMMENT 'Error message'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Error output received from agents';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'File id',
  `filename` varchar(64) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Filename',
  `size` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Size of the file',
  `secret` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Is file secret?',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Files that can be added to tasks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashcats`
--

DROP TABLE IF EXISTS `hashcats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashcats` (
  `version` varchar(10) COLLATE latin1_bin NOT NULL,
  `time` bigint(20) NOT NULL,
  `file` int(11) NOT NULL COMMENT 'File id',
  PRIMARY KEY (`version`),
  KEY `newest_search` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='oclHashcat releases';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashes`
--

DROP TABLE IF EXISTS `hashes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashes` (
  `hashlist` int(11) NOT NULL COMMENT 'Hashlist ID',
  `hash` varchar(512) CHARACTER SET latin1 COLLATE latin1_general_ci NOT NULL COMMENT 'Hash',
  `salt` varchar(64) COLLATE latin1_bin NOT NULL DEFAULT '' COMMENT 'Optional salt',
  `plaintext` varchar(128) COLLATE latin1_bin DEFAULT NULL COMMENT 'Cracked plaintext',
  `time` bigint(20) DEFAULT NULL COMMENT 'Time of crack',
  `chunk` int(11) DEFAULT NULL COMMENT 'Chunk in which the hash was cracked',
  PRIMARY KEY (`hashlist`,`hash`,`salt`),
  KEY `download` (`hashlist`,`plaintext`),
  KEY `adm_chunk` (`chunk`),
  KEY `download_zaps` (`hashlist`,`time`,`chunk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Hashes for specific hashlists';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashes_binary`
--

DROP TABLE IF EXISTS `hashes_binary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashes_binary` (
  `hashlist` int(11) NOT NULL COMMENT 'hashlist ID',
  `essid` varchar(36) COLLATE latin1_bin NOT NULL DEFAULT '' COMMENT 'AP name',
  `MAC1` char(12) COLLATE latin1_bin DEFAULT NULL COMMENT 'First MAC address',
  `MAC2` char(12) COLLATE latin1_bin DEFAULT NULL COMMENT 'Second MAC address',
  `hash` longblob NOT NULL COMMENT 'Raw binary hash',
  `plaintext` varchar(128) COLLATE latin1_bin DEFAULT NULL COMMENT 'Cracked plaintext',
  `time` bigint(20) DEFAULT NULL COMMENT 'Time of crack',
  `chunk` int(11) DEFAULT NULL COMMENT 'Chunk in which the hash was cracked',
  PRIMARY KEY (`hashlist`,`essid`),
  UNIQUE KEY `download` (`hashlist`,`plaintext`),
  KEY `adm_chunk` (`chunk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Hashes for specific WPA hashlist';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashlists`
--

DROP TABLE IF EXISTS `hashlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashlists` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE latin1_bin NOT NULL COMMENT 'Name of the hashlist',
  `format` int(11) NOT NULL DEFAULT '0' COMMENT '0 = text, 1 = wpa, 2 = bin',
  `hashtype` int(11) NOT NULL COMMENT 'Hashtype',
  `hashcount` int(11) NOT NULL DEFAULT '0' COMMENT 'Total count of hashes',
  `cracked` int(11) NOT NULL DEFAULT '0' COMMENT 'Total count of cracked hashes',
  `secret` bit(1) NOT NULL DEFAULT b'0' COMMENT 'Is hashlist secret?',
  PRIMARY KEY (`id`,`format`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='List of hashlists';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashlistusers`
--

DROP TABLE IF EXISTS `hashlistusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashlistusers` (
  `hashlist` int(11) NOT NULL COMMENT 'Used hashlist',
  `agent` int(11) NOT NULL COMMENT 'Using agent',
  PRIMARY KEY (`hashlist`,`agent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Marks if an agent is using a hashlist';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hashtypes`
--

DROP TABLE IF EXISTS `hashtypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hashtypes` (
  `id` int(11) NOT NULL COMMENT 'Hashtype',
  `description` varchar(64) COLLATE latin1_bin NOT NULL COMMENT 'Hash description',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `regvouchers`
--

DROP TABLE IF EXISTS `regvouchers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `regvouchers` (
  `voucher` varchar(10) COLLATE latin1_bin NOT NULL COMMENT 'Registration vouchers',
  `time` bigint(20) NOT NULL COMMENT 'Timestamp of creation',
  PRIMARY KEY (`voucher`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Tokens allowing agent registration';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `superhashlists`
--

DROP TABLE IF EXISTS `superhashlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `superhashlists` (
  `id` int(11) NOT NULL,
  `hashlist` int(11) NOT NULL COMMENT 'Included hashlist',
  KEY `hashlists` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `taskfiles`
--

DROP TABLE IF EXISTS `taskfiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taskfiles` (
  `task` int(11) NOT NULL COMMENT 'Task ID',
  `file` int(11) NOT NULL COMMENT 'Attached file ID',
  KEY `task` (`task`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Files associated to tasks (wordlist, rulesets, etc)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tasks`
--

DROP TABLE IF EXISTS `tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) COLLATE latin1_bin NOT NULL COMMENT 'Task name',
  `attackcmd` varchar(256) COLLATE latin1_bin NOT NULL COMMENT 'Hashcat command line',
  `hashlist` int(11) DEFAULT NULL COMMENT 'Hashlist ID',
  `chunktime` int(11) NOT NULL COMMENT 'Chunk size in seconds',
  `statustimer` int(11) NOT NULL COMMENT 'Interval for sending status',
  `autoadjust` tinyint(4) NOT NULL COMMENT 'Indicator if agents benchmarks are automaticaly adjusted',
  `keyspace` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Keyspace size (calculated by Hashcat)',
  `progress` bigint(20) NOT NULL DEFAULT '0' COMMENT 'How far have chunks been dispatched',
  `priority` int(11) NOT NULL DEFAULT '0' COMMENT 'Assignment priority',
  `color` varchar(6) COLLATE latin1_bin DEFAULT NULL COMMENT 'Color of task shown in admin',
  PRIMARY KEY (`id`),
  KEY `adm_usage` (`hashlist`),
  KEY `autoassign` (`progress`,`keyspace`,`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='List of tasks';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `zapqueue`
--

DROP TABLE IF EXISTS `zapqueue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `zapqueue` (
  `hashlist` int(11) NOT NULL COMMENT 'Hashlist to zap',
  `agent` int(11) NOT NULL COMMENT 'For which agent',
  `time` bigint(20) NOT NULL COMMENT 'When were the hashes cracked',
  `chunk` int(11) NOT NULL COMMENT 'Chunk where the hashes were cracked',
  PRIMARY KEY (`hashlist`,`agent`,`time`,`chunk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_bin COMMENT='Contains zapping instruction for all involved agents';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-07 17:09:09


INSERT INTO `config` (`item`,`value`) VALUES
('agenttimeout','30'),
('benchtime','10'),
('chunktime','1200'),
('chunktimeout','30'),
('emailaddr','changeme@domain.com'),
('emailerror','0'),
('emailhldone','0'),
('emailtaskdone','0'),
('fieldseparator',':'),
('statustimer','5'),
('timefmt','d.m.Y, H:i:s');

INSERT INTO `hashtypes` (`id`, `description`) VALUES
(900, 'MD4'),
(0, 'MD5'),
(5100, 'Half MD5'),
(100, 'SHA1'),
(10800, 'SHA-384'),
(1400, 'SHA-256'),
(1700, 'SHA-512'),
(5000, 'SHA-3(Keccak)'),
(10100, 'SipHash'),
(6000, 'RipeMD160'),
(6100, 'Whirlpool'),
(6900, 'GOST R 34.11-94'),
(11700, 'GOST R 34.11-2012 (Streebog) 256-bit'),
(11800, 'GOST R 34.11-2012 (Streebog) 512-bit'),
(10, 'md5($pass.$salt)'),
(20, 'md5($salt.$pass)'),
(30, 'md5(unicode($pass).$salt)'),
(40, 'md5($salt.unicode($pass))'),
(3800, 'md5($salt.$pass.$salt)'),
(3710, 'md5($salt.md5($pass))'),
(2600, 'md5(md5($pass))'),
(4300, 'md5(strtoupper(md5($pass)))'),
(4400, 'md5(sha1($pass))'),
(110, 'sha1($pass.$salt)'),
(120, 'sha1($salt.$pass)'),
(130, 'sha1(unicode($pass).$salt)'),
(140, 'sha1($salt.unicode($pass))'),
(4500, 'sha1(sha1($pass))'),
(4700, 'sha1(md5($pass))'),
(4900, 'sha1($salt.$pass.$salt)'),
(1410, 'sha256($pass.$salt)'),
(1420, 'sha256($salt.$pass)'),
(1430, 'sha256(unicode($pass).$salt)'),
(1440, 'sha256($salt.unicode($pass))'),
(1710, 'sha512($pass.$salt)'),
(1720, 'sha512($salt.$pass)'),
(1730, 'sha512(unicode($pass).$salt)'),
(1740, 'sha512($salt.unicode($pass))'),
(50, 'HMAC-MD5 (key = $pass)'),
(60, 'HMAC-MD5 (key = $salt)'),
(150, 'HMAC-SHA1 (key = $pass)'),
(160, 'HMAC-SHA1 (key = $salt)'),
(1450, 'HMAC-SHA256 (key = $pass)'),
(1460, 'HMAC-SHA256 (key = $salt)'),
(1750, 'HMAC-SHA512 (key = $pass)'),
(1760, 'HMAC-SHA512 (key = $salt)'),
(400, 'phpass, phpBB3, Joomla > 2.5.18, Wordpress'),
(8900, 'scrypt'),
(11900, 'PBKDF2-HMAC-MD5'),
(12000, 'PBKDF2-HMAC-SHA1'),
(10900, 'PBKDF2-HMAC-SHA256'),
(12100, 'PBKDF2-HMAC-SHA512'),
(23, 'Skype'),
(2500, 'WPA/WPA2'),
(4800, 'iSCSI CHAP authentication, MD5(Chap)'),
(5300, 'IKE-PSK MD5'),
(5400, 'IKE-PSK SHA1'),
(5500, 'NetNTLMv1, NetNTLMv1 + ESS'),
(5600, 'NetNTLMv2'),
(7300, 'IPMI2 RAKP HMAC-SHA1'),
(7500, 'Kerberos 5 AS-REQ Pre-Auth etype 23'),
(8300, 'DNSSEC (NSEC3)'),
(10200, 'Cram MD5'),
(11100, 'PostgreSQL CRAM (MD5)'),
(11200, 'MySQL CRAM (SHA1)'),
(11400, 'SIP digest authentication (MD5)'),
(13100, 'Kerberos 5 TGS-REP etype 23'),
(121, 'SMF (Simple Machines Forum)'),
(2611, 'vBulletin < v3.8.5'),
(2711, 'vBulletin > v3.8.5'),
(2811, 'MyBB, IPB (Invison Power Board)'),
(8400, 'WBB3 (Woltlab Burning Board)'),
(11, 'Joomla < 2.5.18'),
(2612, 'PHPS'),
(7900, 'Drupal7'),
(21, 'osCommerce, xt:Commerce'),
(11000, 'PrestaShop'),
(124, 'Django (SHA-1)'),
(10000, 'Django (PBKDF2-SHA256)'),
(3711, 'Mediawiki B type'),
(7600, 'Redmine'),
(13900, 'OpenCart'),
(12, 'PostgreSQL'),
(131, 'MSSQL(2000)'),
(132, 'MSSQL(2005)'),
(1731, 'MSSQL(2012), MSSQL(2014)'),
(200, 'MySQL323'),
(300, 'MySQL4.1/MySQL5'),
(3100, 'Oracle H: Type (Oracle 7+)'),
(112, 'Oracle S: Type (Oracle 11+)'),
(12300, 'Oracle T: Type (Oracle 12+)'),
(8000, 'Sybase ASE'),
(141, 'EPiServer 6.x < v4'),
(1441, 'EPiServer 6.x > v4'),
(1600, 'Apache $apr1$'),
(12600, 'ColdFusion 10+'),
(1421, 'hMailServer'),
(101, 'nsldap, SHA-1(Base64), Netscape LDAP SHA'),
(111, 'nsldaps, SSHA-1(Base64), Netscape LDAP SSHA'),
(1711, 'SSHA-512(Base64), LDAP {SSHA512}'),
(11500, 'CRC32'),
(3000, 'LM'),
(1000, 'NTLM'),
(1100, 'Domain Cached Credentials (DCC), MS Cache'),
(2100, 'Domain Cached Credentials 2 (DCC2), MS Cache 2'),
(12800, 'MS-AzureSync PBKDF2-HMAC-SHA256'),
(1500, 'descrypt, DES(Unix), Traditional DES'),
(12400, 'BSDiCrypt, Extended DES'),
(500, 'md5crypt $1$, MD5(Unix), Cisco-IOS $1$'),
(3200, 'bcrypt $2*$, Blowfish(Unix)'),
(7400, 'sha256crypt $5$, SHA256(Unix)'),
(1800, 'sha512crypt $6$, SHA512(Unix)'),
(122, 'OSX v10.4, OSX v10.5, OSX v10.6'),
(1722, 'OSX v10.7'),
(7100, 'OSX v10.8, OSX v10.9, OSX v10.10'),
(6300, 'AIX {smd5}'),
(6700, 'AIX {ssha1}'),
(6400, 'AIX {ssha256}'),
(6500, 'AIX {ssha512}'),
(2400, 'Cisco-PIX'),
(2410, 'Cisco-ASA'),
(5700, 'Cisco-IOS $4$'),
(9200, 'Cisco-IOS $8$'),
(9300, 'Cisco-IOS $9$'),
(22, 'Juniper Netscreen/SSG (ScreenOS)'),
(501, 'Juniper IVE'),
(5800, 'Android PIN'),
(13800, 'Windows 8+ phone PIN/Password'),
(8100, 'Citrix Netscaler'),
(8500, 'RACF'),
(7200, 'GRUB 2'),
(9900, 'Radmin2'),
(125, 'ArubaOS'),
(7700, 'SAP CODVN B (BCODE)'),
(7800, 'SAP CODVN F/G (PASSCODE)'),
(10300, 'SAP CODVN H (PWDSALTEDHASH) iSSHA-1'),
(8600, 'Lotus Notes/Domino 5'),
(8700, 'Lotus Notes/Domino 6'),
(9100, 'Lotus Notes/Domino 8'),
(133, 'PeopleSoft'),
(13500, 'PeopleSoft Token'),
(11600, '7-Zip'),
(12500, 'RAR3-hp'),
(13000, 'RAR5'),
(13200, 'AxCrypt'),
(13300, 'AxCrypt in memory SHA1'),
(13600, 'WinZip'),
(8800, 'Android FDE < v4.3'),
(12900, 'Android FDE (Samsung DEK)'),
(12200, 'eCryptfs'),
(9700, 'MS Office <= 2003 $0'),
(9710, 'MS Office <= 2003 $0'),
(9720, 'MS Office <= 2003 $0'),
(9800, 'MS Office <= 2003 $3'),
(9810, 'MS Office <= 2003 $3'),
(9820, 'MS Office <= 2003 $3'),
(9400, 'MS Office 2007'),
(9500, 'MS Office 2010'),
(9600, 'MS Office 2013'),
(10400, 'PDF 1.1 - 1.3 (Acrobat 2 - 4)'),
(10410, 'PDF 1.1 - 1.3 (Acrobat 2 - 4), collider #1'),
(10420, 'PDF 1.1 - 1.3 (Acrobat 2 - 4), collider #2'),
(10500, 'PDF 1.4 - 1.6 (Acrobat 5 - 8)'),
(10600, 'PDF 1.7 Level 3 (Acrobat 9)'),
(10700, 'PDF 1.7 Level 8 (Acrobat 10 - 11)'),
(9000, 'Password Safe v2'),
(5200, 'Password Safe v3'),
(6800, 'Lastpass + Lastpass sniffed'),
(6600, '1Password, agilekeychain'),
(8200, '1Password, cloudkeychain'),
(11300, 'Bitcoin/Litecoin wallet.dat'),
(12700, 'Blockchain, My Wallet'),
(13400, 'Keepass 1 (AES/Twofish) and Keepass 2 (AES)');
