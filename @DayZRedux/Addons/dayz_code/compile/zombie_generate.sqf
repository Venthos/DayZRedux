private ["_position","_doLoiter","_unitTypes","_isNoone","_loot","_array","_agent","_type","_radius","_method","_isAlive","_myDest","_newDest","_rnd","_lootType","_index","_weights","_loot_count"];
_position = 	_this select 0;
_doLoiter = 	_this select 1;
_unitTypes = 	_this select 2;

if (dayz_CurrentZombies > dayz_maxGlobalZombies) exitwith {}; 
if (dayz_spawnZombies > dayz_maxLocalZombies) exitwith {}; 

_isNoone = 	{isPlayer _x} count (_position nearEntities [["AllVehicles","CAManBase"],30]) == 0;
_loot = 	"";
_array = 	[];
_agent = 	objNull;

//Exit if no one is nearby
if (!_isNoone) exitWith {};

if (count _unitTypes == 0) then {
	_unitTypes = 	[]+ getArray (configFile >> "CfgBuildingLoot" >> "Default" >> "zombieClass");
};
 
_unitTypes = _unitTypes + _unitTypes + _unitTypes + _unitTypes;
 
_type = _unitTypes call BIS_fnc_selectRandom;

//Create the Group and populate it
//diag_log ("Spawned: " + _type);
_radius = 0;
_method = "CAN_COLLIDE";
if (_doLoiter) then {
	_radius = 40;
	_method = "NONE";
};

//Make sure position is on the ground
//_position = [_position select 0,_position select 1,0];

//diag_log ("Spawned: " + str([_type, _position, [], _radius, _method]));
_agent = createAgent [_type, _position, [], _radius, _method];

_agent setPosATL _position;
_agent setDir round(random 360);
_agent setvelocity [0,0,1];

if (_doLoiter) then {
	_agent setPosATL _position;
} else {
	_agent setVariable ["doLoiter",false,true];
};

dayz_spawnZombies = dayz_spawnZombies + 1;

//diag_log ("CREATE INFECTED: " + str(_this));

_position = getPosATL _agent;

//_position = getPosATL _agent;
if (random 1 > 0.7) then {
	_agent setUnitPos "Middle";
};

//diag_log ("CREATED: "  + str(_agent));

//_agent setPosATL _position;

if (isNull _agent) exitWith {
	dayz_spawnZombies = dayz_spawnZombies - 1;
};

_isAlive = alive _agent;

_myDest = getPosATL _agent;
_newDest = getPosATL _agent;
_agent setVariable ["myDest",_myDest];
_agent setVariable ["newDest",_newDest];

//Add some loot
_rnd = random 1;
if (_rnd > 0.3) then {
	_lootType = 		configFile >> "CfgVehicles" >> _type >> "zombieLoot";
	if (isText _lootType) then {
		_array = []+ getArray (configFile >> "cfgLoot" >> getText(_lootType));
		if (count _array > 0) then {
			_loot = _array call BIS_fnc_selectRandomWeighted;
			if (!isNil "_array") then {
				_agent addMagazine _loot;
			};
		};
	};
};

//Start behavior
_id = [_position,_agent] execFSM "\z\AddOns\dayz_code\system\zombie_agent.fsm";