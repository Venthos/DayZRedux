waitUntil{!isnil "bis_fnc_init"};

#define PREFIX asff

dayz_versionNo = getText(configFile >> "CfgMods" >> "DayZ" >> "version");
dayz_hiveVersionNo = 1;
diag_log("SERVER VERSION: Bliss v3.5");

if ((count playableUnits == 0) and !isDedicated) then {
	isSinglePlayer = true;
	diag_log("SERVER: SINGLEPLAYER DETECTED!");
};
waitUntil{initialized};

//Get initial loadout
_result = "blisshive" callExtension format ["Q:%1:call proc_getInstanceLoadout(%2)", (call fnc_instanceName), dayz_instance];
_result = call compile _result;
initialLoadout = call compile ((_result select 0) select 0);
diag_log("SERVER: Got initial loadout of " + str(initialLoadout));

//Get object page count
_result = "blisshive" callExtension format ["Q:%1:call proc_getObjectPageCount(%2)", (call fnc_instanceName), dayz_instance];
_result = call compile _result;
_pageCount = call compile ((_result select 0) select 0);
diag_log("SERVER: Got " + str(_pageCount + 1) + " pages of objects...");

//Load objects
_objList = [];
_objCount = 0;
for "_page" from 1 to _pageCount do {
	_result = "blisshive" callExtension format ["Q:%1:call proc_getObjects(%2, %3)", (call fnc_instanceName), dayz_instance, _page];
	_result = call compile _result;
	_end = ((count _result) - 1);
	for "_i" from 0 to _end do {
		_item = _result select _i;
		if (count _item > 0) then {
			_objList set [count _objList, _item];
			_objCount = _objCount + 1;
			//diag_log("DEBUG: Added object " + _item);
		};
	};
};
diag_log ("SERVER: Fetched " + str(_objCount) + " objects!");

//Spawn objects
_countr = 0;
{
	//Parse individual vehicle row
	_countr = _countr + 1;

	_idKey = call compile (_x select 0);
	_type = _x select 1;
	_ownerID = _x select 2;
	_pos = call compile (_x select 3);
	_dir = (_pos) select 0;
	_pos = (_pos) select 1;
	_intentory = call compile (_x select 4);
	_hitPoints = call compile (_x select 5);
	_fuel = call compile (_x select 6);
	_damage = call compile (_x select 7);

	if (_damage < 1) then {
		diag_log("Spawned: " + str(_idKey) + " " + _type);

		//Create it
		_object = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
		_object setVariable ["lastUpdate",time];
		_object setVariable ["ObjectID", _idKey, true];
		_object setVariable ["CharacterID", _ownerID, true];

		if (_object isKindOf "AllVehicles") then {
			_object addEventHandler ["HandleDamage", { _this call vehicle_handleDamage }];
			_object addEventHandler ["GetOut", { _this call vehicle_handleInteract }];
			_object addEventHandler ["GetIn", { _this call vehicle_handleInteract }];
			_object addEventHandler ["Killed", { _this call vehicle_handleKilled }];
		};

		clearWeaponCargoGlobal  _object;
		clearMagazineCargoGlobal  _object;

		_object setdir _dir;
		_object setDamage _damage;
		if ((_object isKindOf "Land_Cont_RX") or (_object isKindOf "Land_Cont2_RX")) then {
			_pos set [2,0];
			_object setpos _pos;
		};

		if (count _intentory > 0) then {
			//Add weapons
			_objWpnTypes = (_intentory select 0) select 0;
			_objWpnQty = (_intentory select 0) select 1;
			_countr = 0;					
			{
				_isOK = 	isClass(configFile >> "CfgWeapons" >> _x);
				if (_isOK) then {
					_block = 	getNumber(configFile >> "CfgWeapons" >> _x >> "stopThis") == 1;
					if (!_block) then {
						_object addWeaponCargoGlobal [_x,(_objWpnQty select _countr)];
					};
				};
				_countr = _countr + 1;
			} forEach _objWpnTypes; 

			//Add Magazines
			_objWpnTypes = (_intentory select 1) select 0;
			_objWpnQty = (_intentory select 1) select 1;
			_countr = 0;
			{
				_isOK = 	isClass(configFile >> "CfgMagazines" >> _x);
				if (_isOK) then {
					_block = 	getNumber(configFile >> "CfgMagazines" >> _x >> "stopThis") == 1;
					if (!_block) then {
						_object addMagazineCargoGlobal [_x,(_objWpnQty select _countr)];
					};
				};
				_countr = _countr + 1;
			} forEach _objWpnTypes;

			//Add Backpacks
			_objWpnTypes = (_intentory select 2) select 0;
			_objWpnQty = (_intentory select 2) select 1;
			_countr = 0;
			{
				_isOK = 	isClass(configFile >> "CfgVehicles" >> _x);
				if (_isOK) then {
					_block = 	getNumber(configFile >> "CfgVehicles" >> _x >> "stopThis") == 1;
					if (!_block) then {
						_object addBackpackCargoGlobal [_x,(_objWpnQty select _countr)];
					};
				};
				_countr = _countr + 1;
			} forEach _objWpnTypes;
		};	

		if (_object isKindOf "AllVehicles") then {
			{
				_selection = _x select 0;
				_dam = _x select 1;
				if (_selection in dayZ_explosiveParts and _dam > 0.8) then {_dam = 0.8};
				[_object,_selection,_dam] call object_setFixServer;
			} forEach _hitpoints;
			_object setvelocity [0,0,1];
			_object setFuel _fuel;
			if (getDammage _object == 1) then {
				_position = ([(getPosATL _object),0,100,10,0,500,0] call BIS_fnc_findSafePos);
				_object setPosATL _position;
			};

			//[_object, "damage", true] call server_updateObject;
		};

		// Everything needs the "Killed" handler so tents/etc. can be destroyed by players.
		//_object addEventHandler ["Killed", { _this call vehicle_handleKilled }];

		//Monitor the object
		//_object enableSimulation false;
		dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];
	};
} forEach _objList;


// Spawn custom buildings
_cfgLocations = configFile >> "CfgChernarusRedux";

diag_log(format["ChernarusRedux Loading (%1)...", count _cfgLocations]);
for "_i" from 0 to ((count _cfgLocations) - 1) do 
{
	_config = _cfgLocations select _i;
	_locName = configName _config;

	_buildingList = configFile >> "CfgChernarusRedux" >> _locName;
	diag_log(format["Generating ChernarusRedux Buildings for: %1 (%2)", _locName, count _buildingList]);

	for "_j" from 0 to ((count _buildingList) - 1) do 
	{
		_config	= _buildingList select _j;
		if (isClass(_config)) then {
			_type		= getText(_config >> "type");
			_position	= [] + getArray	(_config >> "position");
			_dir		= getNumber	(_config >> "direction");
			_noTilt		= getNumber	(_config >> "noTilt");
		
			_object =  createVehicle [_type, _position, [], 0, "CAN_COLLIDE"];

			// noTilt means the building/object will not be tilted to match the terrain incline
			// However, you generally don't want this other than for proper cement buildings,
			// as doing a setDir after a setPos risks misplacement of the building
			if (_noTilt == 1) then {
				_object setDir _dir;
				_object setPos _position;
				_object setDir _dir;
			} else {
				_object setDir _dir;
				_object setPos _position;
			};

			_object allowDamage false;

			//Monitor the object
			//dayz_serverObjectMonitor set [count dayz_serverObjectMonitor,_object];

			diag_log(format["Added: %1", _type]);
		};
	};
};

//TIME
_key = "CHILD:307:";
_result = [_key] call server_hiveReadWrite;
_outcome = _result select 0;
if (_outcome == "PASS") then {
	_date = _result select 1; 
	if (isDedicated) then {
		setDate _date;
		dayzSetDate = _date;
		publicVariable "dayzSetDate";
	};

	diag_log("SERVER: Set local time to " + str(_date));
};

createCenter civilian;
if (isDedicated) then {
	endLoadingScreen;
};	
hiveInUse = false;

if (isDedicated) then {
	_id = [] execFSM "\z\addons\dayz_server\system\server_cleanup.fsm";
	_id = [] execFSM "\z\addons\dayz_server\system\server_timewarp.fsm";
};

allowConnection = true;

//Spawn crashed helos
nul = ['HooeyC_RX',	'HeliCrash',	3, 1, (70 * 60), (20 * 60), 0.5, 'center', 4000, false, true] spawn server_spawnCrashSite;
nul = ['BHC_RX',	'BHCrash',	4, 2, (60 * 60), (20 * 60), 0.5, 'center', 4000, true, true] spawn server_spawnCrashSite;
nul = ['MyAteC_RX',	'MyAteCrash',	5, 2, (60 * 60), (15 * 60), 0.33, 'center', 4000, true, true] spawn server_spawnCrashSite;
nul = ['BlimpTooC_RX',	'BlimpTooCrash', 3, 1, (60 * 60), (15 * 60), 0.33, 'center', 4000, true, false] spawn server_spawnCrashSite;
nul = ['HumC_RX',	'HumCrash',	3, 1, (45 * 60), (10 * 60), 0.2, 'center', 4000, true, false] spawn server_spawnCrashSite;
nul = ['LilBC_RX',	'LilBCrash',	3, 1, (30 * 60), (10 * 60), 0.2, 'center', 4000, true, false] spawn server_spawnCrashSite;

/*
nul = ['HooeyC_RX', 'HeliCrash', 3, 1, (3 * 60), (1 * 60), 0.9, 'kamenka', 400, false, true] spawn server_spawnCrashSite;
nul = ['LilBC_RX', 'LilBCrash', 4, 2, (3 * 60), (1 * 60), 0.9, 'kamenka', 400, true, false] spawn server_spawnCrashSite;
nul = ['BHC_RX', 'BHCrash', 4, 2, (3 * 60), (1 * 60), 0.9, 'kamenka', 400, true, true] spawn server_spawnCrashSite;
nul = ['MyAteC_RX', 'MyAteCrash', 6, 3, (3 * 60), (1 * 60), 0.9, 'kamenka', 400, true, true] spawn server_spawnCrashSite;
nul = ['BlimpTooC_RX', 'BlimpTooCrash', 5, 3, (3 * 60), (1 * 60), 0.9, 'kamenka', 400, true, false] spawn server_spawnCrashSite;
nul = ['HumC_RX', 'HumCrash', 5, 3, (3 * 60), (1 * 60), 0.9, 'kamenka', 400, true, false] spawn server_spawnCrashSite;
*/

//for "_x" from 1 to 3 do {
	//_id = [] spawn spawn_heliCrash;
	//_id = [] spawn spawn_heliCrashKamenka;
	//_id = [] spawn spawn_heliCrashKomarovo;
	//waitUntil{scriptDone _id};
//};

// Start loot cycle
//_id = [] spawn server_lootCheck;