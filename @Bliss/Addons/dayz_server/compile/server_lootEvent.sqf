private["_playerDistance","_building","_type","_size"];

_playerDistance	= _this select 0;
_building		= _this select 1;

_type		= typeOf _building;
_size		= sizeOf _type;

if (_playerDistance > (_size + 15)) then {
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