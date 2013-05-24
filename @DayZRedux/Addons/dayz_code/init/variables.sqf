disableSerialization;

//Model Variables
B1_RX = 	"B1_RX";
B2_RX =		"B2_RX";
BW1_RX =	"BW1_RX";
S1_RX = 	"S2_RX";
S2_RX = 	"S2_RX";
SW2_RX = 	"SW2_RX";
GS1_RX = 	"GS1_RX";
GB1_RX = 	"GB1_RX ";
PS1_RX = 	"PS1_RX ";
PB1_RX = 	"PB1_RX ";
CS1_RX = 	"CS1_RX";
CB1_RX = 	"CB1_RX";
BR1_RX = 	"BR1_RX";
R_RX = 		"R_RX";
G1_RX = 	"GS1_RX";
C1_RX = 	"CS1_RX";

AllPlayers = ["Soldier_Crew_PMC","GS1_RX","GB1_RX","CS1_RX","CB1_RX","BR1_RX","PS1_RX","PB1_RX","R_RX"];
AllPlayersVehicles = ["Soldier_Crew_PMC","GS1_RX","GB1_RX","CS1_RX","CB1_RX","BR1_RX","PS1_RX","PB1_RX","R_RX","AllVehicles"];

MeleeWeapons = ["MeleeHatchet","MeleeCrowbar","MeleeMachete"];
MeleeMagazines = ["hatchet_swing","crowbar_swing","Machete_swing"];

SafeObjects = ["Land_Fire_DZ", "TentStorage", "Wire_cat1", "Sandbag1_DZ", "Hedgehog_DZ", "Land_Mag_RX", "Land_Cont_RX", "Land_Cont2_RX"];


//Cooking
meatraw = [
    "FoodSteakRaw",
    "FoodmeatRaw",
    "FoodbeefRaw",
    "FoodmuttonRaw",
    "FoodchickenRaw",
    "FoodrabbitRaw",
    "FoodbaconRaw",
    "FoodgoatRaw"
];
meatcooked = [
    "FoodSteakCooked",
    "FoodmeatCooked",
    "FoodbeefCooked",
    "FoodmuttonCooked",
    "FoodchickenCooked",
    "FoodrabbitCooked",
    "FoodbaconCooked",
    "FoodgoatCooked"
];
//Eating
no_output_food = [
	"FoodMRE", 
	"FoodPistachio", 
	"FoodNutmix",
	"FoodCandyAnders",
	"FoodCandyLegacys",
	"FoodCandyMintception"
]+meatcooked+meatraw;

food_with_output=[
    "FoodCanBakedBeans",
    "FoodCanSardines",
    "FoodCanFrankBeans",
    "FoodCanPasta",
	"FoodCanGriff",
	"FoodCanBadguy",
	"FoodCanBoneboy",
	"FoodCanCorn",
	"FoodCanCurgon",
	"FoodCanDemon",
	"FoodCanFraggleos",
	"FoodCanHerpy",
	"FoodCanOrlok",
	"FoodCanPowell",
	"FoodCanTylers",
	"FoodCanUnlabeled"
];

food_output = [
    "TrashTinCan",
    "TrashTinCan",
    "TrashTinCan",
    "TrashTinCan",
	"FoodCanGriffEmpty",
	"FoodCanBadguyEmpty",
	"FoodCanBoneboyEmpty",
	"FoodCanCornEmpty",
	"FoodCanCurgonEmpty",
	"FoodCanDemonEmpty",
	"FoodCanFraggleosEmpty",
	"FoodCanHerpyEmpty",
	"FoodCanOrlokEmpty",
	"FoodCanPowellEmpty",
	"FoodCanTylersEmpty",
	"FoodCanUnlabeledEmpty"
];
//Drinking
no_output_drink = ["ItemWaterbottle", "ItemWaterbottleBoiled"];
drink_with_output = [
    "ItemSoda",  //just to define item for ItemSodaEmpty
    "ItemSodaCoke",
    "ItemSodaPepsi",
    "ItemSodaMdew",
    "ItemSodaMtngreen",
    "ItemSodaR4z0r",
    "ItemSodaClays",
    "ItemSodaSmasht", 
    "ItemSodaDrwaste", 
    "ItemSodaLemonade", 
    "ItemSodaLvg", 
    "ItemSodaMzly", 
    "ItemSodaRabbit"
];
drink_output = [
    "ItemSodaEmpty", 
    "ItemSodaCokeEmpty",
    "ItemSodaPepsiEmpty",
    "ItemSodaMdewEmpty",
    "ItemSodaMtngreenEmpty",
    "ItemSodaR4z0rEmpty",
    "ItemSodaClaysEmpty",
    "ItemSodaSmashtEmpty", 
    "ItemSodaDrwasteEmpty", 
    "ItemSodaLemonadeEmpty", 
    "ItemSodaLvgEmpty", 
    "ItemSodaMzlyEmpty", 
    "ItemSodaRabbitEmpty"
];
boil_tin_cans = [
    "TrashTinCan",
	"FoodCanGriffEmpty",
	"FoodCanBadguyEmpty",
	"FoodCanBoneboyEmpty",
	"FoodCanCornEmpty",
	"FoodCanCurgonEmpty",
	"FoodCanDemonEmpty",
	"FoodCanFraggleosEmpty",
	"FoodCanHerpyEmpty",
	"FoodCanOrlokEmpty",
	"FoodCanPowellEmpty",
	"FoodCanTylersEmpty",
	"FoodCanUnlabeledEmpty",
    "ItemSodaEmpty", 
    "ItemSodaCokeEmpty",
    "ItemSodaPepsiEmpty",
    "ItemSodaMdewEmpty",
    "ItemSodaMtngreenEmpty",
    "ItemSodaR4z0rEmpty",
    "ItemSodaClaysEmpty",
    "ItemSodaSmashtEmpty", 
    "ItemSodaDrwasteEmpty", 
    "ItemSodaLemonadeEmpty", 
    "ItemSodaLvgEmpty", 
    "ItemSodaMzlyEmpty", 
    "ItemSodaRabbitEmpty"
];

dayz_combatLog = "";
canRoll = true;
dayz_combatStart = false;
dayz_combatTimer = 0;
dayz_chloroform = [];
dayz_logDamage = [];
dayz_myKiller = ['None', 'None', 'None'];
dayzFire = [];
//dayz_serverSpawnLoot = [];

//Hunting Variables
dayZ_partClasses = [
	"PartFueltank",
	"PartWheel",
	//"PartGeneric",	//No need to add, it is default for everything
	"PartEngine"
];
dayZ_explosiveParts = [
	"palivo",
	"motor"
];
//Survival Variables
SleepFood =				2160; //minutes (48 hours)
SleepWater =			1440; //minutes (24 hours)
SleepTemperatur	= 		90 / 100;	//Firs Value = Minutes untill Player reaches the coldest Point at night (without other effects! night factor expected to be -1)			//TeeChange

//Server Variables
allowConnection = 		false;
isSinglePlayer =		false;
dayz_serverObjectMonitor = [];
dayz_serverCrashMonitor = []; //define for crash spawner

//Streaming Variables (player only)
dayz_Locations = [];
dayz_locationsActive = [];

//GUI
Dayz_GUI_R = 0.38; // 0.7
Dayz_GUI_G = 0.63; // -0.63
Dayz_GUI_B = 0.26; // -0.26

//Player self-action handles
dayz_resetSelfActions = {
	s_player_fire =			-1;
	s_player_cook =			-1;
	s_player_boil =			-1;
	s_player_fireout =		-1;
	s_player_butcher =		-1;
	s_player_packtent = 	-1;
	s_player_fillwater =	-1;
	s_player_fillwater2 = 	-1;
	s_player_fillfuel = 	-1;
	s_player_grabflare = 	-1;
	s_player_removeflare = 	-1;
	s_player_painkiller =	-1;
	s_player_studybody = 	-1;
	s_player_chloroform = -1;
	s_build_Sandbag1_DZ = 	-1;
	s_build_Hedgehog_DZ =	-1;
	s_build_Wire_cat1 =		-1;
	s_player_deleteBuild =	-1;
	s_player_forceSave = 	-1;
	s_player_igniteTentSwitch = -1;
	s_player_igniteBoxSwitch = -1;
	s_player_igniteBoxYes = -1;
	s_player_igniteBoxNo = -1;
	s_player_igniteTentYes = -1;
	s_player_igniteTentNo = -1;
	s_player_retrievebox = -1;
	s_player_diggrave =     -1;
	s_player_burybody =    -1;
	s_player_dragbody = 	-1;
	s_player_flipveh = 		-1;
	s_player_stats =		-1;
	s_player_sleep =		-1;
	s_player_movedog =		-1;
	s_player_speeddog =		-1;
	s_player_calldog = 		-1;
	s_player_feeddog = 		-1;
	s_player_waterdog = 	-1;
	s_player_staydog = 		-1;
	s_player_trackdog = 	-1;
	s_player_barkdog = 		-1;
	s_player_warndog = 		-1;
	s_player_followdog = 	-1;
	s_player_tamedog =		-1;
	diggingGrave = 			false;
};
call dayz_resetSelfActions;

//ANTI DUPE
canPickup = false;
pickupInit = false;

//Allow player to leave by default -- Disallow forced leaving
canAbort = true;
canAbortForce = false;

//Engineering variables
s_player_lastTarget =	objNull;
s_player_repairActions = [];
s_player_removeactions = [];

//Initialize Medical Variables
forceDrag =         	false;
r_interrupt = 			false;
r_doLoop = 				false;
r_self = 				false;
r_self_actions = 		[];
r_drag_sqf = 			false;
r_action = 				false;
r_action_unload = 		false;
r_player_handler = 		false;
r_player_handler1 = 	false;
r_player_dead = 		false;
r_player_unconscious = 	false;
r_player_infected =		false;
r_player_injured = 		false;
r_player_inpain = 		false;
r_player_loaded = 		false;
r_player_cardiac = 		false;
r_fracture_legs =		false;
r_fracture_arms =		false;
r_player_vehicle =		player;
r_player_blood = 		12000;
r_player_lowblood = 	false;
r_player_timeout =		0;
r_player_bloodTotal = 	r_player_blood;
r_public_blood =		r_player_blood;
r_player_bloodDanger =	r_player_bloodTotal * 0.2;
r_player_actions = 		[];
r_handlerCount = 		0;
r_action_repair = 		false;
r_action_targets = 		[];
r_pitchWhine = 			false;
r_isBandit =			false;

//ammo routine
r_player_actions2 = [];
r_action2 = false;
r_player_lastVehicle = objNull;
r_player_lastSeat = [];
r_player_removeActions2 = {
	if (!isNull r_player_lastVehicle) then {
		{
			r_player_lastVehicle removeAction _x;
		} forEach r_player_actions2;
		r_player_actions2 = [];
		r_action2 = false;
	};
};

USEC_woundHit 	= [
	"",
	"body",
	"hands",
	"legs",
	"head_hit"
];
DAYZ_woundHit 	= [
	[
		"body",
		"hands",
		"legs",
		"head_hit"
	],
	[ 0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,3]
];
DAYZ_woundHit_ok = [
	[
		"body",
		"hands",
		"legs"
	],
	[0,0,0,0,0,1,1,1,2,2]
];
DAYZ_woundHit_dog = [
	[
		"body",
		"hands",
		"legs"
	],
	[0,0,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2]
];
USEC_MinorWounds 	= [
	"hands",
	"legs"
];
USEC_woundPoint	= [
	["Pelvis","aimpoint"],
	["aimpoint"], //,"RightShoulder","LeftShoulder"
	["lelbow","relbow"],
	["RightFoot","LeftFoot"],
	["neck","pilot"]
];
USEC_typeOfWounds = [
	"Pelvis",
	"aimpoint",
	"lelbow","relbow",
	"RightFoot","LeftFoot",
	"neck","pilot"
];

//Initialize Zombie Variables
dayz_zombieTargetList = [
	["SoldierWB",50],
	["Air",500],
	["LandVehicle",200]
];
dayzHit = [];
dayzPublishObj = [];		//used for eventhandler to spawn a mirror of players tent
dayzHideBody = objNull;

//DayZ settings
dayz_dawn = 6;
dayz_dusk = 18;
dayz_maxAnimals = 5;
DAYZ_agentnumber = 0;
dayz_animalDistance = 800;
dayz_zSpawnDistance = 1400;
dayz_maxLocalZombies = 40;
dayz_maxGlobalZombies = 30;
dayz_maxZeds = 500;
dayz_spawnPos = getPosATL player;

//init global arrays for Loot Chances
call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\loot_init.sqf";

if (isServer) then {
	dayz_players = [];
	dead_bodyCleanup = [];
	needUpdate_objects = [];
};

if (!isDedicated) then {
	//Establish Location Streaming
	_funcGetLocation = 
	{
		for "_i" from 0 to ((count _this) - 1) do 
		{
			private ["_location","_config","_locHdr","_position","_size","_type"];
			//Get Location Data from config
			_config = 	(_this select _i);
			_locHdr = 	configName _config;
			_position = getArray	(_config >> "position");
			_size = 	getNumber	(_config >> "size");
			_type = 	getText		(_config >> "type");
			
			//Find the Location
			_location = nearestLocation [_position, _type];
			
			//Record details
			dayz_Locations set [count dayz_Locations, [_location,_locHdr,_size]]; 
		};
	};
	_cfgLocation = configFile >> "CfgTownGenerator";
	_cfgLocation call _funcGetLocation;
	
	dayz_buildingMonitor = [];	//Buildings to check
	dayz_bodyMonitor = [];
	dayz_flyMonitor = [];		//used for monitor flies
	
	dayz_baseTypes = 		getArray (configFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
	
	//temperature variables
	dayz_temperatur 		= 	36;		//TeeChange
	dayz_temperaturnormal 	= 	36;		//TeeChange
	dayz_temperaturmax 		= 	42;		//TeeChange
	dayz_temperaturmin 		= 	27;		//TeeChange
	
	//player special variables
	dayZ_lastPlayerUpdate = 0;
	dayZ_everyonesTents =	[];
	dayz_hunger	=			0;
	dayz_thirst = 			0;
	dayz_combat =			0;
	dayz_preloadFinished = 	false;
	dayz_statusArray =		[1,1];
	dayz_disAudial =		0;
	dayz_disVisual =		0;
	dayz_firedCooldown = 	0;
	dayz_DeathActioned =	false;
	dayz_canDisconnect = 	true;
	dayz_damageCounter =	time;
	dayz_lastSave =			time;
	dayz_isSwimming	=		true;
	dayz_currentDay = 		0;
	dayz_hasLight = 		false;
	dayz_surfaceNoise =		0;
	dayz_surfaceType =		"None";
	dayz_noPenalty = 		[];
	dayz_heavenCooldown =	0;
	deathHandled = 			false;
	dayz_lastHumanity =		0;
	dayz_guiHumanity =		-90000;
	dayz_firstGroup = 		group player;
	dayz_originalPlayer = 	player;
	dayz_playerName =		"Unknown";
	dayz_sourceBleeding =	objNull;
	dayz_clientPreload = 	false;
	dayz_authed = 			false;
	dayz_panicCooldown = 	0;
	dayz_areaAffect =		2;
	dayz_heartBeat = 		false;
	dayzClickTime =			0;
	dayz_spawnDelay =		120; // was 300
	dayz_spawnWait =		-120;
	dayz_lootDelay =		3; // was 300
	dayz_lootWait =			-300;
	dayz_spawnZombies =		0;
	//used to count global zeds around players
	dayz_CurrentZombies = 0;
	//Used to limit overall zed counts
	dayz_maxCurrentZeds = 0;
	dayz_inVehicle =		false;
	dayz_Magazines = 		[];
	dayzGearSave = 			false;
	dayz_unsaved =			false;
	dayz_scaleLight = 		0;
	dayzDebug = false;
	dayzState = -1;
	//uiNamespace setVariable ['DAYZ_GUI_display',displayNull];
	//if (uiNamespace getVariable ['DZ_displayUI', 0] == 2) then {
	//	dayzDebug = true;
	//};
};