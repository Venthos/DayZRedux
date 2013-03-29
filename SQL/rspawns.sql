-- YOU MUST HAVE FIRST IMPORTED YOUR OLD rspawns TABLE!!
USE redux;
SET FOREIGN_KEY_CHECKS=0;

-- rspawns = object_spawns
-- convert rspawns to object_spawns
RENAME TABLE rspawns TO object_spawns;

ALTER TABLE object_spawns
--  id int(11) NOT NULL AUTO_INCREMENT,
CHANGE type Classname varchar(45) DEFAULT NULL,
CHANGE pos Worldspace varchar(128) DEFAULT NULL,
-- CHANGE description MapID varchar(255) NOT NULL DEFAULT '',
CHANGE uid ObjectUID bigint(20) NOT NULL DEFAULT '0';
-- ALTER TABLE object_spawns ADD UNIQUE KEY `uid_UNIQUE` (`ObjectUID`);
ALTER TABLE object_spawns ADD COLUMN `Inventory` longtext;
ALTER TABLE object_spawns ADD COLUMN `Last_changed` int(10) DEFAULT NULL;
ALTER TABLE object_spawns ADD COLUMN MapID varchar(255) NOT NULL DEFAULT '';