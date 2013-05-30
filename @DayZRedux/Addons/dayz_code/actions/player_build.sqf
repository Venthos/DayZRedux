private ["_location","_isOk","_dir","_classname","_item","_restrictBuild","_inBuilding","_hasbuildmag","_requireItem","_buildError","_toolName"];
_location = player modeltoworld [0,1,0];
_location set [2,0];
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_isWater = 		(surfaceIsWater _location) or dayz_isSwimming;
_bypass = false;
_buildError = false;

call gear_ui_init;

if (_isWater) exitWith {cutText [localize "str_player_26", "PLAIN DOWN"];};
if (_onLadder) exitWith {cutText [localize "str_player_21", "PLAIN DOWN"];};

_item =			_this;
_classname = 	getText (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "create");
_text = 		getText (configFile >> "CfgVehicles" >> _classname >> "displayName");

_requireItems = getArray (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "require");

_hasbuildmag = _this in magazines player;

if (!_hasbuildmag) exitWith {cutText [format[(localize "str_player_31"),_text,"build"] , "PLAIN DOWN"]};

// TOOL REQUIREMENT CHECK
{
	_hasTool = _x in items player;
	_toolName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	if (!_hasTool) exitWith {
		_buildError = true;
	};
} forEach _requireItems;

if (_buildError) exitWith {
	cutText [format["You must have a %1 to build %2.", _toolName,_text], "PLAIN DOWN"];
};

_restrictBuild = (_item in ["ItemWire","ItemTankTrap"]);
_inBuilding = false;

if (_restrictBuild) then {
	_location = player modeltoworld [0,2.5,0];
	_location set [2,0];
	// fnc_isInsideBuilding only supports being passed an object, will need to
	// fix this later so we can pass where we want to place the object vs
	// where the player is.
	_building = nearestObject [(vehicle player), "HouseBase"];
	_inBuilding = [(vehicle player),_building] call fnc_isInsideBuilding;
};

if (_restrictBuild && _inBuilding) exitWith {cutText [format["You cannot place %1 within a building", _text] , "PLAIN DOWN"]};

//diag_log(format["BUILD: %1 RESTRICT: %2 INBUILD: %3 RESULT: %4", _item, _restrictBuild, _inBuilding, (!_restrictBuild || (_restrictBuild && !_inBuilding))]);
if (!_hasbuilditem) exitWith {cutText [format[(localize "str_player_31"),_text,"build"] , "PLAIN DOWN"]};
if (_text == "TrapBear") then { _bypass = true; };

if (!_restrictBuild || _bypass || (_restrictBuild && !_inBuilding)) then {
	_dir = getDir player;
	player removeMagazine _item;

	player playActionNow "Medic";
	sleep 1;
  
	_dis=50;
	_sfx = "repair";
	[player,_sfx,0,false,_dis] call dayz_zombieSpeak;  
	[player,_dis,true,(getPosATL player)] spawn player_alertZombies;
  
	sleep 5;
	
	player allowDamage false;
	_object = createVehicle [_classname, _location, [], 0, "CAN_COLLIDE"];
	_object setDir _dir;
	player reveal _object;

	cutText [format[localize "str_build_01",_text], "PLAIN DOWN"];

	dayzPublishObj = [dayz_characterID,_object,[_dir,_location],_classname];
	publicVariableServer "dayzPublishObj";

	sleep 2;
	player allowDamage true;
} else {
	cutText [format[localize "str_build_failed_01",_text], "PLAIN DOWN"];
};