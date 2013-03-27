private["_position","_tent","_location","_isOk","_backpack","_tentType","_trg","_key"];
//check if can pitch here
call gear_ui_init;
_item = _this;

_hastentmag = _this in magazines player;

_config = configFile >> "CfgMagazines" >> _item;
_text = getText (_config >> "displayName");

if (!_hastentmag) exitWith {cutText [format[(localize "str_player_31"),_text,"pitch"] , "PLAIN DOWN"]};

_location = player modeltoworld [0,2.5,0];
_location set [2,0];
_building = nearestObject [(vehicle player), "HouseBase"];
//_isOk = [(vehicle player),_building] call fnc_isInsideBuilding;
_notInBuilding = false;
_isGoodSurface = false;

_type = typeOf _building;
_minDistance = (sizeOf _type)+5;
if (_type == "Land_Cont_RX" || _type == "Land_Cont2_RX" || _type == "Land_Mag_RX") then {
	_minDistance = 2;
};

_distanceFrom = _location distance _building;

if (_distanceFrom > _minDistance) then { _notInBuilding = true; };

//allowed
if (["forest",dayz_surfaceType] call fnc_inString) then { _isGoodSurface = true };
if (["grass",dayz_surfaceType] call fnc_inString) then { _isGoodSurface = true };

if (_notInBuilding) then {

	if (!_isGoodSurface) exitWith {cutText [format[(localize "str_fail_tent_pitch")] , "PLAIN DOWN"]};

	//remove tentbag
	player removeMagazine _item;
	_dir = round(direction player);	
	
	//wait a bit
	player playActionNow "Medic";
	sleep 1;

	_dis=50;
	_sfx = "tentunpack";
	[player,_sfx,0,false,_dis] call dayz_zombieSpeak;  
	[player,_dis,true,(getPosATL player)] spawn player_alertZombies;
	
	sleep 5;
	//place tent (local)
	_tent = createVehicle ["Land_Cont2_RX", _location, [], 0, "CAN_COLLIDE"];
	_tent setdir _dir;
	_tent setpos _location;
	player reveal _tent;
	_location = getPosATL _tent;

	_tent setVariable ["characterID",dayz_characterID,true];

	//player setVariable ["tentUpdate",["Land_A_tent",_dir,_location,[dayz_tentWeapons,dayz_tentMagazines,dayz_tentBackpacks]],true];

	dayzPublishObj = [dayz_characterID,_tent,[_dir,_location],"Land_Cont2_RX"];
	publicVariable "dayzPublishObj";
	
	cutText [localize "str_success_tent_pitch", "PLAIN DOWN"];
} else {
	cutText [localize "str_fail_tent_pitch", "PLAIN DOWN"];
};
