private ["_notInBuilding","_isWater","_isGoodSurface","_animState","_isDoing","_canDo","_distanceFrom","_location","_building","_isMan","_isAlive","_inVehicle","_type","_minDistance","_dir","_dis","_sfx","_body","_bodyPos","_bodyHeight","_bodyATL"];

_notInBuilding = false;
_isGoodSurface = true;
_building = nearestObject [cursorTarget, "HouseBase"];
_type = typeOf _building;
  if (_type != "Fort_EnvelopeSmall") then {
    _minDistance = (sizeOf _type) + 1;
  } else {
    _minDistance = 0;
  };
_location = position cursorTarget;
_distanceFrom = _location distance _building;
_isMan = cursorTarget isKindOf "Man";
_isAlive = alive cursorTarget;
_inVehicle = (vehicle player != player);
_isWater = (surfaceIsWater (position cursorTarget)) or dayz_isSwimming;
_bodyPos = getPosATL cursorTarget;
_bodyHeight = _bodyPos select 2;
_bodyATL = _bodyHeight >= -0.2;
_canDo = (!r_drag_sqf and !r_player_unconscious);
_animState = animationState player;
_isDoing = ["medic",_animState] call fnc_inString;

	if (_isDoing or diggingGrave) exitWith {cutText ["You cannot dig a grave while performing another action!","PLAIN DOWN"];};
	diggingGrave = true;
	if (!_canDo) exitWith {cutText ["You cannot dig a grave while dragging a body!","PLAIN DOWN"]; diggingGrave = false;};
	if (!_bodyATL) exitWith {cutText ["You cannot dig a grave for a body that has already been burried!","PLAIN DOWN"]; diggingGrave = false;};
	if (_distanceFrom > _minDistance) then { _notInBuilding = true; };
	if (isOnRoad _bodyPos) exitWith {cutText ["You cannot dig a grave on a road!","PLAIN DOWN"]; diggingGrave = false;};
	if ((["Concrete",dayz_surfaceType] call fnc_inString) or (["Tarmac",dayz_surfaceType] call fnc_inString) or (["Rock",dayz_surfaceType] call fnc_inString) or (["BetonNew",dayz_surfaceType] call fnc_inString) or (["Beton",dayz_surfaceType] call fnc_inString) or (["BetonIN",dayz_surfaceType] call fnc_inString) or (["Roadway",dayz_surfaceType] call fnc_inString) or (["Asfalt",dayz_surfaceType] call fnc_inString) or (["CubeRoad",dayz_surfaceType] call fnc_inString) or (["Sil_new",dayz_surfaceType] call fnc_inString) or (["Asfalt_New",dayz_surfaceType] call fnc_inString) or (["DlazbaIN",dayz_surfaceType] call fnc_inString) or (["Road",dayz_surfaceType] call fnc_inString) or (["CRConcrete",dayz_surfaceType] call fnc_inString)) then { _isGoodSurface = false };
	if (_isWater) exitWith {cutText ["You cannot dig a grave in water","PLAIN DOWN"]; diggingGrave = false;};
	if (!_notInBuilding) exitWith {cutText ["You cannot dig a grave so close to a building!","PLAIN DOWN"]; diggingGrave = false;};
	if (!_isGoodSurface) exitWith {cutText ["You cannot dig a grave on this terrain!","PLAIN DOWN"]; diggingGrave = false;};

if (_isMan and !_isAlive and !_inVehicle) then {
	_dir = round(direction cursorTarget);
	player playActionNow "Medic";
	sleep 1;
	_dis=15;
	_sfx = "repair";
	[player,_sfx,0,false,_dis] call dayz_zombieSpeak;  
	[player,_dis,true,(getPosATL player)] spawn player_alertZombies;
	sleep 5;
	
	_body = createVehicle ["Fort_EnvelopeSmall", _location, [], 0, "CAN_COLLIDE"];
	_body setdir _dir;
	_body setpos _location;
	player reveal _body;
	_location = getPosATL _body;
	diggingGrave = false;
} else {
	cutText ["You cannot dig a grave right now!","PLAIN DOWN"];
		diggingGrave = false;
};