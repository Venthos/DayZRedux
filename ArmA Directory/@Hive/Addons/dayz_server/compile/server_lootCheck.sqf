private["_mapCenter","_allBuildings","_lootBuildings","_canLoot","_badTypes"];

_badTypes	= [];
_goodTypes	= [];

canHaveLoot = {
	_canLoot = false;

	_building	= _this select 0;
	_type		= typeOf _building;

	if (_type in _badTypes) then {
		//diag_log(_type + " is false (cached)");
	} else {
		if (_type in _goodTypes) then {
			_canLoot = true;
			//diag_log(_type + " is true (cached)");
		} else {
			_config	= configFile >> "CfgBuildingLoot" >> _type;

			if (isClass (_config) ) then {
				_canLoot = (count (getArray (_config >> "lootPos"))) > 0;
			};

			if (!_canLoot) then {
				_badTypes set [count _badTypes, _type];
			} else {
				_goodTypes set [count _goodTypes, _type];
			};
			//diag_log(_type + " is " + str(_canLoot));
		};
	};
	_canLoot
};

diag_log("Finding all static buildings...");
// Nab a list of all buildings on the map
_mapCenter = getMarkerPos "absolutecenter";
_allBuildings = _mapCenter nearObjects ["building",14000];

// Build an array of only those buildings in which have configs in CfgBuildingLoot
_lootBuildings = [];
{
	_canLoot = [_x] call canHaveLoot;
	if (_canLoot) then {
		_lootBuildings set [count _lootBuildings, _x];
	};
} forEach _allBuildings;

// Since the above doesn't include post-mission spawned items (army tents, etc.)
// we need to manually chuck those in.
diag_log("Starting Dynamic Building logic");
_cfgLocations = configFile >> "CfgTownGenerator";

for "_i" from 0 to ((count _cfgLocations) - 1) do 
{
	_config = _cfgLocations select _i;
	_locName = configName _config;
	//diag_log(format["Checking Dynamic Town: %1", _locName]);
	_buildingList = configFile >> "CfgTownGenerator" >> _locName;

	for "_j" from 0 to ((count _buildingList) - 1) do 
	{
		_config	= _buildingList select _j;
		if (isClass(_config)) then {
			_type		= getText(_config >> "type");
			_position	= [] + getArray	(_config >> "position");
			_dir		= getNumber	(_config >> "direction");
		
			_object =  _type createVehicleLocal _position;
			_object setPos _position;
			_object setDir _dir;
			_object allowDamage false;

			//diag_log("Added Local Dynamic Building: " + str(_type));

			_canLoot = [_object] call canHaveLoot;
			if (_canLoot) then {
				_lootBuildings set [count _lootBuildings, _object];
				//diag_log("Lootable Dynamic Building: " + str(_type));
			};
		};
	};
};

while {true} do {
	_tmptime = time;
	diag_log("Cycling Loot..." + str(_tmptime));
	{


		_type		= typeOf _x;
		_buildPos	= getPosATL _x;
		_size		= sizeOf _type;
		//_config	= configFile >> "CfgBuildingLoot" >> _type;
		//_canLoot	= isClass (_config);

		diag_log("Building: " + str(_type));

//		if (_canLoot) then {
//			diag_log(str(_type) + " can have loot");
//			nearByObj = nearestObjects [(getPosATL _x), ["WeaponHolder","WeaponHolderBase"],((sizeOf _type)+5)];
//			{deleteVehicle _x} forEach _nearByObj;

		_nearByPlayer = ({isPlayer _x} count (_buildPos nearEntities ["CAManBase",(_size + 15)])) > 0;
		if (!_nearByPlayer) then {

/*
			_rnd = random 1;
			if (_rnd > 0.25) then {
				diag_log("Clearing building");
				_nearByObj = _buildPos nearObjects ["ReammoBox",(_size + 1)];
				{deleteVehicle _x} forEach _nearByObj;
			} else {
				diag_log("Leaving building alone");
			};
*/

			_handle = [_x,true] spawn building_spawnLoot;
			waitUntil{scriptDone _handle};
			sleep 0.1;
		};
	} forEach _lootBuildings;

	_donetime = time - _tmptime;
	diag_log("Loot Cycled... took " + str(_donetime));

	while {(time - _tmptime) < 360} do {
		diag_log("Waiting to cycle...");
		sleep 10;
	};
};