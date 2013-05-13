private ["_position","_box","_location","_isOk","_backpack","_tentType","_trg","_key"];

if (vehicle player != player) exitWith {cutText ["You may not place a box while in a vehicle", "PLAIN DOWN"]};//check if player can build

call gear_ui_init;
_item = _this;

_hasboxmag = _this in magazines player;

_config = configFile >> "CfgMagazines" >> _item;
_text = getText (_config >> "displayName");

if (!_hasboxmag) exitWith {cutText [format[(localize "str_player_31"),_text,"build"] , "PLAIN DOWN"]};

_location = player modeltoworld [0,2.5,0];
_location set [2,0];
//_building = nearestObject [(vehicle player), "HouseBase"];
//_isOk = [(vehicle player),_building] call fnc_isInsideBuilding;
_notInBuilding = true;
_isGoodSurface = true;

//_type = typeOf _building;
//_minDistance = (sizeOf _type)+5;
//if (_type == "Land_Cont_RX" || _type == "Land_Cont2_RX" || _type == "Land_Mag_RX") then {
//	_minDistance = 2;
//};

//_distanceFrom = _location distance _building;

//if (_distanceFrom > _minDistance) then { _notInBuilding = true; };

//allowed
//if (["forest",dayz_surfaceType] call fnc_inString) then { _isGoodSurface = true };
//if (["grass",dayz_surfaceType] call fnc_inString) then { _isGoodSurface = true };

if (_notInBuilding) then {

	if (!_isGoodSurface) exitWith {cutText [format[(localize "str_fail_box_place")] , "PLAIN DOWN"]};

	//remove storagebox
	player removeMagazine _item;
	_dir = round(direction player);
	
	//wait a bit
	player playActionNow "Medic";
	sleep 1;
	
	_id = [player,0,true,(getPosATL player)] spawn player_alertZombies;
	
	sleep 5;
	//place box
	_box = createVehicle ["Land_Mag_RX", _location, [], 0, "CAN_COLLIDE"];
	_box setdir _dir;
	_box setpos _location;
	player reveal _box;
	_location = getPosATL _box;

	_box setVariable ["characterID",dayz_characterID,true];

	dayzPublishObj = [dayz_characterID,_box,[_dir,_location],"Land_Mag_RX"];
	publicVariable "dayzPublishObj";
/*	if (isServer) then {
		dayzPublishObj call server_publishObj;
	};
*/	
	cutText [localize "str_success_box_place", "PLAIN DOWN"];
} else {
	cutText [localize "str_fail_box_place", "PLAIN DOWN"];
};

