waituntil {!isnil "bis_fnc_init"};

BIS_Effects_Burn =			{};
object_spawnDamVehicle =	compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\object_spawnDamVehicle.sqf";
server_playerLogin =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerLogin.sqf";
server_playerSetup =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSetup.sqf";
server_onPlayerDisconnect = compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_onPlayerDisconnect.sqf";
server_routinePlayerCheck =	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_routinePlayerCheck.sqf";
server_updateObject =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateObject.sqf";
server_playerDied =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerDied.sqf";
server_updatePlayer	=		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updatePlayer.sqf";
server_playerStat =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerStat.sqf";
server_publishObj = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_publishObject.sqf";
local_publishObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\local_publishObj.sqf";		//Creates the object in DB
local_deleteObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\local_deleteObj.sqf";		//Creates the object in DB
local_createObj = 			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\local_createObj.sqf";		//Creates the object in DB
server_playerSync =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_playerSync.sqf";
//zombie_initialize =			compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\zombie_initialize.sqf";
zombie_findOwner =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\zombie_findOwner.sqf";

server_hiveWrite =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_hiveWrite.sqf";
server_hiveReadWrite =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_hiveReadWrite.sqf";

server_updateNearbyObjects =	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_updateNearbyObjects.sqf";

fnc_join =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fnc_join.sqf";
fnc_split = 			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fnc_split.sqf";
fnc_replace =			compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\fnc_replace.sqf";

//combat log functions
cLog_playerMorph = 		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\cLog_playerMorph.sqf";
cLog_damageHandler =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\cLog_damageHandler.sqf";
cLog_playerDeath  =		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\cLog_playerDeath.sqf";
server_logDamage		= compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_logDamage.sqf";
server_killerReport = 	compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_killerReport.sqf";
server_spawnCrashSite	=		compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_spawnCrashSite.sqf";

//loot
//server_lootCheck	= compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\server_lootCheck.sqf";
//building_spawnLoot	= compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\building_spawnLoot.sqf";
//spawn_loot			= compile preprocessFileLineNumbers "\z\addons\dayz_server\compile\spawn_loot.sqf";

//Get instance name (e.g. dayz_1.chernarus)
fnc_instanceName = {
	"dayz_" + str(dayz_instance) + "." + worldName
};

vehicle_handleInteract = {
	private["_object"];
	_object = _this select 0;
	[_object, "all"] call server_updateObject;
	[_object, "damage", true] call server_updateObject;
};

//event Handlers
eh_localCleanup =			{
	_object = _this select 0;
	_object addEventHandler ["local", {
		if(_this select 1) then {
			private["_type","_unit"];
			_unit = _this select 0;
			_type = typeOf _unit;
			deleteVehicle _unit;
			diag_log ("CLEANUP: DELETED A " + str(_type) );
		};
	}];
};

server_characterSync = {
	//dayzCharDisco = [_characterID,_playerPos,[_weapons,_magazines],[typeOf _backpack,getWeaponCargo _backpack,getMagazineCargo _backpack],_medical,_currentState,_currentModel];
	_characterID = 	_this select 0;	
	_playerPos =	_this select 1;
	_playerGear =	_this select 2;
	_playerBackp =	_this select 3;
	_medical = 		_this select 4;
	_currentState =	_this select 5;
	_currentModel = _this select 6;
	_isAlive      = _this select 7;
	_playerName   = _this select 8;

	_charPos = _playerPos select 1;
	_debugPos = getMarkerpos "respawn_west";
	_nearDebug = ((_debugPos distance _charPos) < 1500);

	if (_nearDebug) exitWith {
		diag_log format["ERROR: Refusing characterSync %1 since they're near debug (%2)", _playerName, _charPos];
	};
	if (!_isAlive) exitWith {
		diag_log format["ERROR: Refusing characterSync %1 since they're dead (%2)", _playerName, _charPos];
	};
	
	_key = format["CHILD:201:%1:%2:%3:%4:%5:%6:%7:%8:%9:%10:%11:%12:%13:%14:%15:%16:",_characterID,_playerPos,_playerGear,_playerBackp,_medical,false,false,0,0,0,0,_currentState,0,0,_currentModel,0];
	//diag_log ("HIVE: WRITE: "+ str(_key) + " / " + _characterID);
	_key call server_hiveWrite;
};

//was missing for server
fnc_buildWeightedArray = 	compile preprocessFileLineNumbers "\z\addons\dayz_code\compile\fn_buildWeightedArray.sqf";		//Checks which actions for nearby casualty

//onPlayerConnected 		"[_uid,_name] spawn server_onPlayerConnect;";
onPlayerDisconnected 		"[_uid,_name] call server_onPlayerDisconnect;";

spawn_heliCrash = {
	private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray","_startTime","_maxDelay","_minFrequency","_helis"];
	
	waitUntil{!isNil "BIS_fnc_selectRandom"};
	if (isDedicated) then {

	_maxHelis		= round(random 1) + 1;
	_spawnedHelis	= 0;
	_startTime		= time;
	_maxDelay		= 3 * 60 * 60;
	_minFrequency	= 35 * 60;
 
	diag_log("HELI: Starting Heli Logic");
	while {_spawnedHelis < _maxHelis} do {

		diag_log(format["HELI: %1 of %2 helis spawned",_spawnedHelis,_maxHelis]);
		// The time left before our max delay (anticipated server restart)
		_timeLeft	= _maxDelay - _startTime;
		// The minimum buffer to make sure we leave to spawn all _maxHelis
		_minBuffer	= _minFrequency * (_maxHelis - _spawnedHelis);
		// The resulting window of time this chopper can spawn
		_timeWindow = _timeLeft - _minBuffer;
		// The scheduled time for the next heli to spawn, assuring it's at least _minFrequency out
		_nextHeli	= round(random _timeWindow) max (time + _minFrequency);

		diag_log(format["HELI: Will spawn one at: %1",_nextHeli]);
		while {time < _nextHeli} do {
			sleep 5;
		};
		diag_log(format["HELI: Spawning now: %1",time]);
		_spawnedHelis = _spawnedHelis + 1;

		//_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
		_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;
		diag_log("DEBUG: Spawning a crashed helicopter at " + str(_position));
		_veh = createVehicle ["HHC_RX",_position, [], 0, "CAN_COLLIDE"];
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
		_veh setVariable ["ObjectID",1,true];
		//dayzFire = [_veh,2,time,false,false];
		//publicVariable "dayzFire";
		//if (isServer) then {
		//	nul=dayzFire spawn BIS_Effects_Burn;
		//};
		_num = round(random 1) + 3;
		_config = 		configFile >> "CfgBuildingLoot" >> "HeliCrash";
		_itemType =		[] + getArray (_config >> "itemType");
		//diag_log ("DW_DEBUG: _itemType: " + str(_itemType));	
		_itemChance =	[] + getArray (_config >> "itemChance");
		//diag_log ("DW_DEBUG: _itemChance: " + str(_itemChance));	
		//diag_log ("DW_DEBUG: (isnil fnc_buildWeightedArray): " + str(isnil "fnc_buildWeightedArray"));	
	
		waituntil {!isnil "fnc_buildWeightedArray"};
	
		_weights = [];
		_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
		//diag_log ("DW_DEBUG: _weights: " + str(_weights));	
		for "_x" from 1 to _num do {
			//create loot
			_index = _weights call BIS_fnc_selectRandom;
			sleep 1;
			if (count _itemType > _index) then {
				//diag_log ("DW_DEBUG: " + str(count (_itemType)) + " select " + str(_index));
				_iArray = _itemType select _index;
				_iArray set [2,_position];
				_iArray set [3,5];
				_iArray set [4,"HeliCrash"];
				_iArray call spawn_loot;
				_nearby = _position nearObjects ["WeaponHolder",20];
				{
					_x setVariable ["permaLoot",true];
				} forEach _nearBy;
			};
		};
	};
	};
};

spawn_heliCrashKamenka = {
	private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray","_startTime","_maxDelay","_minFrequency","_helis"];
	
	waitUntil{!isNil "BIS_fnc_selectRandom"};
	if (isDedicated) then {

	_maxHelis		= 2;
	_spawnedHelis	= 0;
	_startTime		= time;
	_maxDelay		= 5 * 60; //10.5 * 60 * 60;
	_minFrequency	= 5; //1 * 60 * 60;
 
	diag_log("KaHELI: Starting KaHeli Logic");
	while {_spawnedHelis < _maxHelis} do {

		diag_log(format["KaHELI: %1 of %2 helis spawned",_spawnedHelis,_maxHelis]);
		// The time left before our max delay (anticipated server restart)
		_timeLeft	= _maxDelay - _startTime;
		// The minimum buffer to make sure we leave to spawn all _maxHelis
		_minBuffer	= _minFrequency * (_maxHelis - _spawnedHelis);
		// The resulting window of time this chopper can spawn
		_timeWindow = _timeLeft - _minBuffer;
		// The scheduled time for the next heli to spawn, assuring it's at least _minFrequency out
		_nextHeli	= round(random _timeWindow) max (time + _minFrequency);

		diag_log(format["KaHELI: Will spawn one at: %1",_nextHeli]);
		while {time < _nextHeli} do {
			sleep 5;
		};
		diag_log(format["KaHELI: Spawning now: %1",time]);
		_spawnedHelis = _spawnedHelis + 1;

		//_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;

		// Should spawn 1.45 above ground for AH6 crash
		_position = [getMarkerPos "kamenka",0,400,10,0,2000,0] call BIS_fnc_findSafePos;

		diag_log("DEBUG: Spawning a crashed helicopter at " + str(_position));
		_veh = createVehicle ["AH6Wreck_DZ",_position, [], 0, "CAN_COLLIDE"];
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
		_veh setVariable ["ObjectID",1,true];
		//dayzFire = [_veh,2,time,false,false];
		//publicVariable "dayzFire";
		//if (isServer) then {
		//	nul=dayzFire spawn BIS_Effects_Burn;
		//};
		_num = round(random 1) + 3;
		_config = 		configFile >> "CfgBuildingLoot" >> "NoobHeliCrash";
		_itemType =		[] + getArray (_config >> "itemType");
		//diag_log ("DW_DEBUG: _itemType: " + str(_itemType));	
		_itemChance =	[] + getArray (_config >> "itemChance");
		//diag_log ("DW_DEBUG: _itemChance: " + str(_itemChance));	
		//diag_log ("DW_DEBUG: (isnil fnc_buildWeightedArray): " + str(isnil "fnc_buildWeightedArray"));	
	
		waituntil {!isnil "fnc_buildWeightedArray"};
	
		_weights = [];
		_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
		//diag_log ("DW_DEBUG: _weights: " + str(_weights));	
		for "_x" from 1 to _num do {
			//create loot
			_index = _weights call BIS_fnc_selectRandom;
			sleep 1;
			if (count _itemType > _index) then {
				//diag_log ("DW_DEBUG: " + str(count (_itemType)) + " select " + str(_index));
				_iArray = _itemType select _index;
				_iArray set [2,_position];
				_iArray set [3,5];
				_iArray call spawn_loot;
				_nearby = _position nearObjects ["WeaponHolder",20];
				{
					_x setVariable ["permaLoot",true];
				} forEach _nearBy;
			};
		};
	};
	};
};


spawn_heliCrashKomarovo = {
	private["_position","_veh","_num","_config","_itemType","_itemChance","_weights","_index","_iArray","_startTime","_maxDelay","_minFrequency","_helis"];
	
	waitUntil{!isNil "BIS_fnc_selectRandom"};
	if (isDedicated) then {

	_maxHelis		= 2;
	_spawnedHelis	= 0;
	_startTime		= time;
	_maxDelay		= 5 * 60; //10.5 * 60 * 60;
	_minFrequency	= 5; //1 * 60 * 60;
 
	diag_log("HELI: Starting Heli Logic");
	while {_spawnedHelis < _maxHelis} do {

		diag_log(format["KoHELI: %1 of %2 helis spawned",_spawnedHelis,_maxHelis]);
		// The time left before our max delay (anticipated server restart)
		_timeLeft	= _maxDelay - _startTime;
		// The minimum buffer to make sure we leave to spawn all _maxHelis
		_minBuffer	= _minFrequency * (_maxHelis - _spawnedHelis);
		// The resulting window of time this chopper can spawn
		_timeWindow = _timeLeft - _minBuffer;
		// The scheduled time for the next heli to spawn, assuring it's at least _minFrequency out
		_nextHeli	= round(random _timeWindow) max (time + _minFrequency);

		diag_log(format["KoHELI: Will spawn one at: %1",_nextHeli]);
		while {time < _nextHeli} do {
			sleep 5;
		};
		diag_log(format["KoHELI: Spawning now: %1",time]);
		_spawnedHelis = _spawnedHelis + 1;

		//_position = [getMarkerPos "center",0,4000,10,0,2000,0] call BIS_fnc_findSafePos;

		// Should spawn 1.45 above ground for AH6 crash
		_position = [getMarkerPos "komarovo",0,400,10,0,2000,0] call BIS_fnc_findSafePos;

		diag_log("DEBUG: Spawning a crashed helicopter at " + str(_position));
		_veh = createVehicle ["AH6Wreck_DZ",_position, [], 0, "CAN_COLLIDE"];
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_veh];
		_veh setVariable ["ObjectID",1,true];
		//dayzFire = [_veh,2,time,false,false];
		//publicVariable "dayzFire";
		//if (isServer) then {
		//	nul=dayzFire spawn BIS_Effects_Burn;
		//};
		_num = round(random 1) + 3;
		_config = 		configFile >> "CfgBuildingLoot" >> "NoobHeliCrash";
		_itemType =		[] + getArray (_config >> "itemType");
		//diag_log ("DW_DEBUG: _itemType: " + str(_itemType));	
		_itemChance =	[] + getArray (_config >> "itemChance");
		//diag_log ("DW_DEBUG: _itemChance: " + str(_itemChance));	
		//diag_log ("DW_DEBUG: (isnil fnc_buildWeightedArray): " + str(isnil "fnc_buildWeightedArray"));	
	
		waituntil {!isnil "fnc_buildWeightedArray"};
	
		_weights = [];
		_weights = 		[_itemType,_itemChance] call fnc_buildWeightedArray;
		//diag_log ("DW_DEBUG: _weights: " + str(_weights));	
		for "_x" from 1 to _num do {
			//create loot
			_index = _weights call BIS_fnc_selectRandom;
			sleep 1;
			if (count _itemType > _index) then {
				//diag_log ("DW_DEBUG: " + str(count (_itemType)) + " select " + str(_index));
				_iArray = _itemType select _index;
				_iArray set [2,_position];
				_iArray set [3,5];
				_iArray call spawn_loot;
				_nearby = _position nearObjects ["WeaponHolder",20];
				{
					_x setVariable ["permaLoot",true];
				} forEach _nearBy;
			};
		};
	};
	};
};

server_getDiff =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = 	0;
	if (_vNew < _vOld) then {
		//JIP issues
		_vNew = _vNew + _vOld;
		_object getVariable[(_variable + "_CHK"),_vNew];
	} else {
		_result = _vNew - _vOld;
		_object setVariable[(_variable + "_CHK"),_vNew];
	};
	_result
};

server_getDiff2 =	{
	private["_variable","_object","_vNew","_vOld","_result"];
	_variable = _this select 0;
	_object = 	_this select 1;
	_vNew = 	_object getVariable[_variable,0];
	_vOld = 	_object getVariable[(_variable + "_CHK"),_vNew];
	_result = _vNew - _vOld;
	_object setVariable[(_variable + "_CHK"),_vNew];
	_result
};

dayz_objectUID2 = {
	private["_position","_dir","_key"];
	_dir = _this select 0;
	_key = "";
	_position = _this select 1;
	{
		_x = _x * 10;
		if ( _x < 0 ) then { _x = _x * -10 };
		_key = _key + str(round(_x));
	} forEach _position;
	_key = _key + str(round(_dir));
	_key
};

dayz_objectUID = {
	private["_position","_dir","_key","_object"];
	_object = _this;
	_position = getPosATL _object;
	_dir = direction _object;
	_key = [_dir,_position] call dayz_objectUID2;
    	_key
};

dayz_recordLogin = {
	private["_key"];
	_key = format["CHILD:103:%1:%2:%3:",_this select 0,_this select 1,_this select 2];
	diag_log ("DISCONNECT: "+ str(_key));
	_key call server_hiveWrite;
};