-- MAKE A BACKUP OF YOUR DB.
-- Create a DB User redux@localhost (username is just redux) you will this user instead of root for the hive login
-- RUN AS ROOT!
SET FOREIGN_KEY_CHECKS=0;

USE REDUX; -- CHANGE THIS TO YOUR DB NAME!!!!!!

drop table `migration_schema_log`;
drop table `migration_schema_version`;
drop table `log_code`;
drop table `log_entry`;

-- Begin conversion of survivor to Character_Data
RENAME TABLE survivor TO Character_Data;

ALTER TABLE Character_Data
CHANGE ID CharacterID int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
CHANGE unique_id PlayerUID varchar(45) NOT NULL,
CHANGE pos WorldSpace varchar(128) NOT NULL DEFAULT '[]',
CHANGE start_time DateStamp datetime DEFAULT NULL,
CHANGE Last_update last_updated timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
CHANGE state CurrentState varchar(100) NOT NULL DEFAULT '[]',
CHANGE survivor_kills KillsH int(11) UNSIGNED NOT NULL DEFAULT '0',
CHANGE zombie_kills KillsZ int(11) UNSIGNED NOT NULL DEFAULT '0',
CHANGE bandit_kills KillsB int(11) UNSIGNED NOT NULL DEFAULT '0',
CHANGE headshots HeadShotsZ int(11) NOT NULL DEFAULT '0',
CHANGE survival_time Duration int(11) UNSIGNED NOT NULL DEFAULT '0',
MODIFY inventory longtext,
MODIFY backpack longtext,
MODIFY Medical varchar(200) NOT NULL DEFAULT '[]',
MODIFY Model varchar(50) NOT NULL DEFAULT '"S2_RX"';
ALTER TABLE Character_Data DROP COLUMN last_ate;
ALTER TABLE Character_Data DROP COLUMN last_drank;
ALTER TABLE Character_Data ADD COLUMN LastAte datetime NOT NULL;
ALTER TABLE Character_Data ADD COLUMN LastDrank datetime NOT NULL;
ALTER TABLE Character_Data ADD COLUMN InstanceID int(11) NOT NULL DEFAULT '1';
ALTER TABLE Character_Data ADD COLUMN DistanceFoot int(11) NOT NULL DEFAULT '0';
ALTER TABLE Character_Data ADD COLUMN Generation int(11) UNSIGNED NOT NULL DEFAULT '1';
ALTER TABLE Character_Data ADD COLUMN Humanity int(11) NOT NULL DEFAULT '2500';
ALTER TABLE Character_Data ADD COLUMN Alive tinyint(4) UNSIGNED NOT NULL DEFAULT '1';
ALTER TABLE Character_Data ADD COLUMN LastLogin datetime NOT NULL;

UPDATE Character_Data 
SET 
    Alive = '0'
WHERE
    is_dead = '1';
UPDATE Character_Data 
SET 
    Alive = '1'
WHERE
    is_dead = '0';

ALTER TABLE Character_Data DROP COLUMN is_dead;

UPDATE Character_Data t1
        INNER JOIN
    profile t2 ON t1.PlayerUID = t2.unique_id 
SET 
    t1.Humanity = t2.humanity;

ALTER TABLE Character_Data ADD KEY `CharFetch` (`PlayerUID`,`Alive`) USING BTREE;
ALTER TABLE Character_Data ADD KEY `PlayerID` (`PlayerID`);
ALTER TABLE Character_Data ADD KEY `Alive_PlayerID` (`Alive`,`LastLogin`,`PlayerID`);
ALTER TABLE Character_Data ADD KEY `Alive_PlayerUID` (`Alive`,`LastLogin`,`PlayerUID`);
-- END Character_Data
--
-- Begin conversion of profile to Player_Data
RENAME TABLE profile TO Player_Data;

ALTER TABLE Player_Data
CHANGE unique_id PlayerUID varchar(45) NOT NULL,
CHANGE id PlayerID int(11) NOT NULL,
CHANGE name PlayerName varchar(128) CHARACTER SET utf8 NOT NULL,
CHANGE humanity PlayerMorality int(11) NOT NULL DEFAULT '0',
ADD COLUMN PlayerSex int(11) UNSIGNED NOT NULL DEFAULT '0';
ALTER TABLE Player_Data DROP COLUMN survival_attempts;
ALTER TABLE Player_Data DROP COLUMN total_survival_time;
ALTER TABLE Player_Data DROP COLUMN total_survivor_kills;
ALTER TABLE Player_Data DROP COLUMN total_bandit_kills;
ALTER TABLE Player_Data DROP COLUMN total_headshots;
ALTER TABLE Player_Data DROP PRIMARY KEY;
ALTER TABLE Player_Data ADD PRIMARY KEY (`PlayerUID`);
ALTER TABLE Player_Data ADD KEY `playerID` (`playerID`);
-- END Player_Data
--
-- Begin creation of Player_Login

CREATE TABLE `Player_LOGIN` (
  `LoginID` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `PlayerUID` varchar(32) NOT NULL,
  `CharacterID` int(11) UNSIGNED NOT NULL,
  `Datestamp` datetime NOT NULL,
  `Action` tinyint(3) NOT NULL,
  PRIMARY KEY (`LoginID`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
-- END Player_Login
--
-- Begin conversion of objects to Object_Data
RENAME TABLE objects TO Object_Data;

ALTER TABLE Object_Data ADD KEY `ObjectID` (`ID`);

ALTER TABLE Object_Data

CHANGE ID ObjectID int(11) NOT NULL AUTO_INCREMENT,
CHANGE OID CharacterID int(11) NOT NULL DEFAULT '0',
CHANGE UID ObjectUID bigint(20) NOT NULL DEFAULT '0',
CHANGE pos Worldspace varchar(100) NOT NULL DEFAULT '[]',
CHANGE inventory Inventory longtext,
CHANGE otype Classname varchar(50) DEFAULT NULL,
CHANGE health Hitpoints varchar(500) NOT NULL DEFAULT '[]',
CHANGE fuel Fuel double(13,5) NOT NULL DEFAULT '1.00000',
CHANGE Damage Damage double(13,5) NOT NULL DEFAULT '0.00000',
CHANGE lastupdate last_updated timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
CHANGE created Datestamp datetime NOT NULL,
CHANGE instance Instance int(11) NOT NULL DEFAULT '1';
ALTER TABLE Object_Data ADD UNIQUE KEY `CheckUID` (`ObjectUID`,`Instance`);
ALTER TABLE Object_Data ADD KEY `Instance` (`Instance`);

RENAME TABLE rspawns TO object_spawns;

ALTER TABLE object_spawns
MODIFY type varchar(45) DEFAULT NULL,
CHANGE pos Worldspace varchar(128) DEFAULT NULL,
CHANGE uid ObjectUID bigint(20) NOT NULL DEFAULT '0';
ALTER TABLE object_spawns ADD COLUMN `Inventory` longtext;
ALTER TABLE object_spawns ADD COLUMN `Last_changed` int(10) DEFAULT NULL;
ALTER TABLE object_spawns ADD COLUMN MapID varchar(255) NOT NULL DEFAULT '';

-- ADD PROCEDURES

DELIMITER //
CREATE DEFINER=`redux`@`localhost` PROCEDURE `pCleanup`()
BEGIN


#move dead players to character_dead
#	insert
#		into character_data 
#		select * 
#		from character_data 
#		WHERE Alive = '0';
	
#remove dead players from data table
	DELETE 
		FROM character_data 
		WHERE Alive = '0';	
	
#remove vehicles with 100% damage
	DELETE
		FROM object_data 
		WHERE Damage = '1';	

#remove unused vehicles older then 14 days
	DELETE
		FROM object_data
		WHERE DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Classname != 'dummy'
			AND Classname != 'Hedgehog_DZ'
			AND Classname != 'Wire_cat1'
			AND Classname != 'Sandbag1_DZ'
			AND Classname != 'TrapBear';

#remove tents whose owner has been dead for four days
	DELETE
		FROM object_data
		USING object_data, character_data
		WHERE object_data.Classname = 'Land_Cont_RX'
			AND object_data.CharacterID = character_data.CharacterID
			AND character_data.Alive = 0
			AND DATE(character_data.last_updated) < CURDATE() - INTERVAL 7 DAY;

#remove empty tents older than seven days
	DELETE
		FROM object_data
		WHERE Classname = 'Land_Cont_RX'
			AND DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Inventory = '[[[],[]],[[],[]],[[],[]]]';
	
	DELETE
		FROM object_data
		WHERE Classname = 'Land_Cont_RX'
			AND DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Inventory = '[]';

#remove tents whose owner has been dead for four days
	DELETE
		FROM object_data
		USING object_data, character_data
		WHERE object_data.Classname = 'Land_Cont2_RX'
			AND object_data.CharacterID = character_data.CharacterID
			AND character_data.Alive = 0
			AND DATE(character_data.last_updated) < CURDATE() - INTERVAL 7 DAY;

#remove empty tents older than seven days
	DELETE
		FROM object_data
		WHERE Classname = 'Land_Cont2_RX'
			AND DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Inventory = '[[[],[]],[[],[]],[[],[]]]';
	
	DELETE
		FROM object_data
		WHERE Classname = 'Land_Cont2_RX'
			AND DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Inventory = '[]';
			
#remove boxes whose owner has been dead for four days
	DELETE
		FROM object_data
		USING object_data, character_data
		WHERE object_data.Classname = 'Land_Mag_RX'
			AND object_data.CharacterID = character_data.CharacterID
			AND character_data.Alive = 0
			AND DATE(character_data.last_updated) < CURDATE() - INTERVAL 7 DAY;

#remove empty boxes older than seven days
	DELETE
		FROM object_data
		WHERE Classname = 'Land_Mag_RX'
			AND DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Inventory = '[[[],[]],[[],[]],[[],[]]]';
	
	DELETE
		FROM object_data
		WHERE Classname = 'Land_Mag_RX'
			AND DATE(last_updated) < CURDATE() - INTERVAL 14 DAY
			AND Inventory = '[]';				

#remove barbed wire older than two days
	DELETE
		FROM object_data
		WHERE Classname = 'Wire_cat1'
			AND DATE(last_updated) < CURDATE() - INTERVAL 2 DAY;
			
#remove Tank Traps older than fifteen days
	DELETE
		FROM object_data
		WHERE Classname = 'Hedgehog_DZ'
			AND DATE(last_updated) < CURDATE() - INTERVAL 15 DAY;

#remove Sandbags older than twenty days
	DELETE
		FROM object_data
		WHERE Classname = 'Sandbag1_DZ'
			AND DATE(last_updated) < CURDATE() - INTERVAL 20 DAY;

#remove Bear Traps older than five days
	DELETE
		FROM object_data
		WHERE Classname = 'TrapBear'
			AND DATE(last_updated) < CURDATE() - INTERVAL 5 DAY;

END//
DELIMITER ;


-- Dumping structure for procedure default.pCleanupOOB
DELIMITER //
CREATE DEFINER=`redux`@`localhost` PROCEDURE `pCleanupOOB`()
BEGIN

	DECLARE intLineCount	INT DEFAULT 0;
	DECLARE intDummyCount	INT DEFAULT 0;
	DECLARE intDoLine			INT DEFAULT 0;
	DECLARE intWest				INT DEFAULT 0;
	DECLARE intNorth			INT DEFAULT 0;

	SELECT COUNT(*)
		INTO intLineCount
		FROM object_data;

	SELECT COUNT(*)
		INTO intDummyCount
		FROM object_data
		WHERE Classname = 'dummy';

	WHILE (intLineCount > intDummyCount) DO
	
		SET intDoLine = intLineCount - 1;

		SELECT ObjectUID, Worldspace
			INTO @rsObjectUID, @rsWorldspace
			FROM object_data
			LIMIT intDoLine, 1;

		SELECT REPLACE(@rsWorldspace, '[', '') INTO @rsWorldspace;
		SELECT REPLACE(@rsWorldspace, ']', '') INTO @rsWorldspace;
		SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(@rsWorldspace, ',', 2), LENGTH(SUBSTRING_INDEX(@rsWorldspace, ',', 2 -1)) + 1), ',', '') INTO @West;
		SELECT REPLACE(SUBSTRING(SUBSTRING_INDEX(@rsWorldspace, ',', 3), LENGTH(SUBSTRING_INDEX(@rsWorldspace, ',', 3 -1)) + 1), ',', '') INTO @North;

		SELECT INSTR(@West, '-') INTO intWest;
		SELECT INSTR(@North, '-') INTO intNorth;

		IF (intNorth = 0) THEN
			SELECT CONVERT(@North, DECIMAL(16,8)) INTO intNorth;
		END IF;

		IF (intWest > 0 OR intNorth > 15360) THEN
			DELETE FROM object_data
				WHERE ObjectUID = @rsObjectUID;
		END IF;
			
		SET intLineCount = intLineCount - 1;

	END WHILE;

END//
DELIMITER ;


-- Dumping structure for table default.player_data
CREATE TABLE IF NOT EXISTS `player_data` (
  `playerID` int(11) NOT NULL DEFAULT '0',
  `playerUID` varchar(45) NOT NULL DEFAULT '0',
  `playerName` varchar(50) NOT NULL DEFAULT 'Null',
  `playerMorality` int(11) NOT NULL DEFAULT '0',
  `playerSex` int(11) NOT NULL DEFAULT '0',
  KEY `playerID` (`playerID`),
  KEY `playerUID` (`playerUID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table default.player_data: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_data` ENABLE KEYS */;


-- Dumping structure for table default.player_login
CREATE TABLE IF NOT EXISTS `player_login` (
  `LoginID` int(11) NOT NULL AUTO_INCREMENT,
  `PlayerUID` varchar(45) NOT NULL,
  `CharacterID` int(11) NOT NULL DEFAULT '0',
  `datestamp` datetime NOT NULL,
  `Action` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`LoginID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table default.player_login: ~0 rows (approximately)
/*!40000 ALTER TABLE `player_login` DISABLE KEYS */;
/*!40000 ALTER TABLE `player_login` ENABLE KEYS */;


-- Dumping structure for procedure default.pMain
DELIMITER //
CREATE DEFINER=`redux`@`localhost` PROCEDURE `pMain`()
    MODIFIES SQL DATA
BEGIN

# maximum number of INSTANCE ids USED.
#-----------------------------------------------
	DECLARE sInstance VARCHAR(8) DEFAULT 391;
#-----------------------------------------------
#maximum number of vehicles allowed !!! theoretical max. amount
#-----------------------------------------------
	DECLARE iVehSpawnMax INT DEFAULT 100;
#-----------------------------------------------	

# DECLARE iVehSpawnMin				INT DEFAULT 0;		#ToDo !!!
	DECLARE iTimeoutMax 				INT DEFAULT 250;	#number of loops before timeout
	DECLARE iTimeout 						INT DEFAULT 0;		#internal counter for loops done; used to prevent infinite loops - DO NOT CHANGE
	DECLARE iNumVehExisting 		INT DEFAULT 0;		#internal counter for already existing vehicles - DO NOT CHANGE
	DECLARE iNumClassExisting 	INT DEFAULT 0;		#internal counter for already existing class types - DO NOT CHANGE
	DECLARE i INT DEFAULT 1; #internal counter for vehicles spawns - DO NOT CHANGE

#Starts Cleanup
	CALL pCleanup();
	
		SELECT COUNT(*) 				#retrieve the amount of already spawned vehicles...
			INTO iNumVehExisting
			FROM object_data 
			WHERE Instance = sInstance
			AND Classname != '-'						#exclude dummys
			AND Classname != 'Hedgehog_DZ'			#exclude hedgehog
			AND Classname != 'Wire_cat1'				#exclude wirecat
			AND Classname != 'Sandbag1_DZ'			#exclude Sanbag
			AND Classname != 'TrapBear'			#exclude trap
			AND Classname != 'Land_Cont_RX'		#exclude Land_Cont_RX
			AND Classname != 'Land_Cont2_RX'		#exclude Land_Cont2_RX
			AND Classname != 'Land_Mag_RX';		#exclude Land_Mag_RX

		WHILE (iNumVehExisting < iVehSpawnMax) DO		#loop until maximum amount of vehicles is reached

			#select a random vehicle class
			SELECT Classname, Chance, MaxNum, Damage
				INTO @rsClassname, @rsChance, @rsMaxNum, @rsDamage
				FROM object_classes ORDER BY RAND() LIMIT 1;

			#count number of same class already spawned
			SELECT COUNT(*) 
				INTO iNumClassExisting 
				FROM object_data 
				WHERE Instance = sInstance
				AND Classname = @rsClassname;

			IF (iNumClassExisting < @rsMaxNum) THEN

				IF (rndspawn(@rschance) = 1) THEN
				
					INSERT INTO object_data (ObjectUID, Instance, Classname, Damage, CharacterID, Worldspace, Inventory, Hitpoints, Fuel, Datestamp)
						SELECT ObjectUID, sInstance, Classname, RAND(@rsDamage), '0', Worldspace, Inventory, Hitpoints, RAND(1), SYSDATE() 
							FROM object_spawns 
							WHERE Classname = @rsClassname 
								AND NOT ObjectUID IN (select objectuid from object_data where instance = sInstance)
							ORDER BY RAND()
							LIMIT 0, 1;
							
					SELECT COUNT(*) 
						INTO iNumVehExisting 
						FROM object_data 
						WHERE Instance = sInstance
							AND Classname != '-'						#exclude dummys
							AND Classname != 'Hedgehog_DZ'			#exclude hedgehog
							AND Classname != 'Wire_cat1'				#exclude wirecat
							AND Classname != 'Sandbag1_DZ'			#exclude Sanbag
							AND Classname != 'TrapBear'			#exclude trap
							AND Classname != 'Land_Cont_RX'		#exclude Land_Cont_RX
							AND Classname != 'Land_Cont2_RX'		#exclude Land_Cont2_RX
							AND Classname != 'Land_Mag_RX';		#exclude Land_Mag_RX
		
					#update number of same class already spawned
					SELECT COUNT(*) 
						INTO iNumClassExisting 
						FROM object_data 
						WHERE Instance = sInstance
						AND Classname = @rsClassname;
				
				END IF;
			END IF;	
			
			SET iTimeout = iTimeout + 1; #raise timeout counter
			IF (iTimeout >= iTimeoutMax) THEN
				SET iNumVehExisting = iVehSpawnMax;
			END IF;
		END WHILE;
	SET i = i + 1;
END//
DELIMITER ;


-- Dumping structure for function default.rndspawn
DELIMITER //
CREATE DEFINER=`redux`@`localhost` FUNCTION `rndspawn`(`chance` double) RETURNS tinyint(1)
BEGIN

	DECLARE bspawn tinyint(1) DEFAULT 0;

	IF (RAND() <= chance) THEN
		SET bspawn = 1;
	END IF;

	RETURN bspawn;

END//
DELIMITER ;


-- Dumping structure for table default.version
CREATE TABLE IF NOT EXISTS `version` (
  `Version` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table default.version: ~1 rows (approximately)
/*!40000 ALTER TABLE `version` DISABLE KEYS */;
INSERT INTO `version` (`Version`) VALUES
	(2);
/*!40000 ALTER TABLE `version` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

--
-- Add old routines
--
/*!50003 DROP PROCEDURE IF EXISTS `proc_deleteObject` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_deleteObject`(in `p_uniqueId` varchar(128))
begin
  delete from object_data where ObjectUID = p_uniqueid; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_deleteObjectId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_deleteObjectId`(in `p_objectId` int(11))
begin
  delete from object_data where ObjectID = p_objectId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_getInstanceLoadout` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_getInstanceLoadout`(in `p_instanceId` int)
begin
  select loadout from instances where instance = p_instanceId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_getInstanceTime` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_getInstanceTime`(in `p_instanceId` int)
begin
  declare server_time datetime default now(); 
  select now() + interval (offset) hour into server_time from instances where instance = p_instanceid; 
  select date_format(server_time,'%d-%m-%y'), time_format(server_time, '%T'); 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_getObjectPageCount` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_getObjectPageCount`(in `p_instanceId` int)
begin
  declare itemsPerPage int default 10; -- must match proc_getobject_data
  select floor(count(*) / itemsPerPage) + if((count(*) mod itemsPerPage) > 0, 1, 0) from object_data where instance = p_instanceId; --
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_getobject_data` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_getobject_data`(in `p_instanceId` int, in `p_currentPage` int)
begin
  set @instance = p_instanceId; --
  set @page = greatest(((p_currentPage - 1) * 10), 0); -- must match proc_getObjectPageCount
  prepare stmt from 'select ObjectID,Classname,CharacterID,Worldspace,inventory,Hitpoints,fuel,damage from object_data where instance = ? limit ?, 10'; --
  execute stmt using @instance, @page; --
  deallocate prepare stmt; --
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_getSurvivorStats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_getSurvivorStats`(in `p_survivorId` int)
begin
  select
    medical, Worldspace, Kills_Z, currentState, Humanity, headshotsZ, KillsH, KillsB
  from
    character_data s
    inner join player_data p on s.PlayerUID = p.playerUID
  where
    s.playerID = p_survivorId
    and s.alive = 1; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insertObject` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_insertObject`(in `p_uniqueId` varchar(255), in `p_type` varchar(255), in `p_health` varchar(1024), in `p_damage` double, in `p_fuel` double, in `p_owner` int, in `p_position` varchar(255), in `p_instanceId` int)
begin
  insert into object_data
    (ObjectUID,Classname,Hitpoints,Damage,CharacterID,Worldspace,fuel,instance,Datestamp)
  values
    (p_uniqueId, p_type, p_health, p_damage, p_owner, p_position, p_fuel, p_instanceId, CURRENT_TIMESTAMP()); 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_insertSurvivor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_insertSurvivor`(in `p_uniqueId` varchar(128), in `p_playerName` varchar(255))
begin
  insert into player_data
    (playerUID, playerName)
  values
    (p_uniqueId, p_playerName)
  on duplicate key update playerName = p_playerName; 
  insert into character_data
    (PlayerUID, Datestamp)
  values
    (p_uniqueId, now()); 
  select last_insert_id(); 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_killSurvivor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_killSurvivor`(in `p_survivorId` int)
begin
  update character_data set alive = 0 where CharacterID = p_survivorId; 
  update
    player_data
    left join character_data on character_data.PlayerUID = player_data.PlayerUID
  set
    survival_attempts=survival_attempts+1,
    total_survivor_kills=total_survivor_kills+KillsH,
    total_bandit_kills=total_bandit_kills+KillsB,
    total_zombie_kills=total_zombie_kills+Kills_Z,
    total_headshots=total_headshots+headshotsZ,
    total_survival_time=total_survival_time+duration
  where
    character_data.CharacterID = p_survivorId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_loginSurvivor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_loginSurvivor`(in `p_uniqueId` varchar(128), in `p_playerName` varchar(128))
begin 
  update player_data set playerName = p_playerName where PlayerUID = p_uniqueId; 
  update character_data
  set currentState = '["","aidlpercmstpsnonwnondnon_player_idlesteady04",36]' 
  where 
    PlayerUID = p_uniqueId and alive = 1 and currentState rlike '.*_(driver|pilot)'; 
  select
    CharacterID, inventory, backpack, floor(time_to_sec(timediff(now(), Datestamp)) / 60), model, LastAte, LastDrank
  from character_data
  where
    character_data.PlayerUID = p_uniqueId
    and alive = 1; 
end */;;
DELIMITER ;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_updateObject`(in `p_uniqueId` varchar(128), in `p_type` varchar(255) , in `p_position` varchar(255), in `p_health` varchar(1024))
begin
  update object_data set
    Classname = if(p_type = '', Classname, p_type),
    Hitpoints = p_health,
    Worldspace = if(p_position = '[]', Worldspace, p_position)
  where
    ObjectUID = p_uniqueId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_updateObjectHealth` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_updateObjectHealth`(in `p_objectId` int, in `p_health` varchar(1024), in `p_damage` double)
begin
  update object_data set
    Hitpoints = p_health,
    damage = p_damage
  where
    ObjectID = p_objectId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_updateObjectInventory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_updateObjectInventory`(in `p_objectId` int, in `p_inventory` varchar(2048))
begin
  update object_data set
    inventory = p_inventory
  where
    ObjectID = p_objectId; --
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_updateObjectInventoryByUID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_updateObjectInventoryByUID`(in `p_uniqueId` varchar(128), in `p_inventory` varchar(8192))
begin
  update object_data set
    inventory = p_inventory
  where
    ObjectUID not like '%.%'
    and (convert(ObjectUID, unsigned integer) between (convert(p_uniqueId, unsigned integer) - 2) and (convert(p_uniqueId, unsigned integer) + 2)); 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_updateObjectPosition` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_updateObjectPosition`(in `p_objectId` int, in `p_position` varchar(255), in `p_fuel` double)
begin
  update object_data set
    Worldspace = if(p_position = '[]', Worldspace, p_position),
    fuel = p_fuel
  where
    ObjectID = p_objectId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `proc_updateSurvivor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`redux`@`localhost`*/ /*!50003 PROCEDURE `proc_updateSurvivor`(in `p_survivorId` int, in `p_position` varchar(1024), in `p_inventory` varchar(2048), in `p_backpack` varchar(2048), in `p_medical` varchar(1024), in `p_lastAte` int, in `p_lastDrank` int, in `p_survivalTime` int, in `p_model` varchar(255), in `p_humanity` int, in `p_zombieKills` int, in `p_headshots` int, in `p_murders` int, in `p_banditKills` int, in `p_state` varchar(255))
begin
  update
    player_data p
    inner join character_data s on s.PlayerUID = p.playerUID
  set
    Humanity = if(p_humanity = 0, humanity, humanity + p_humanity)
  where
    s.playerID = p_survivorId; 

  update character_data set
    Kills_Z = Kills_Z + p_zombieKills,
    headshotsZ = headshotsZ + p_headshots,
    KillsB = KillsB + p_banditKills,
    KillsH = KillsH + p_murders,
    currentState = p_state,
    model = if(p_model = 'any', model, p_model),
    LastAte = if(p_lastAte = -1, 0, LastAte + p_lastAte),
    LastDrank = if(p_lastDrank = -1, 0, LastDrank + p_lastDrank),
    duration = duration + p_survivalTime,
    Worldspace = if(p_position = '[]', Worldspace, p_position),
    medical = if(p_medical = '[]', medical, p_medical),
    backpack = if(p_backpack='[]', backpack, p_backpack),
    inventory = if(p_inventory='[]', inventory, p_inventory)
  where
    PlayerID = p_survivorId; 
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;