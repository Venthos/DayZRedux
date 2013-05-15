private ["_body","_isMan","_isAlive","_inVehicle","_animState","_isDoing","_grave","_canDo","_isZombie","_cross","_dir","_location","_sfx","_dis","_isAnimal","_bodyPos","_bodyHeight","_bodyATL","_pos","_flies"];

_body = cursorTarget;
_isMan = cursorTarget isKindOf "Man";
_isAlive = alive cursorTarget;
_inVehicle = (vehicle player != player);
_grave = nearestObject [cursorTarget,"Fort_EnvelopeSmall"];
_isZombie = cursorTarget isKindOf "zZambie_Base";
_location = position _grave;
_dir = round(direction _grave);
_isAnimal = cursorTarget isKindOf "Animal";
_bodyPos = getPosATL cursorTarget;
_bodyHeight = _bodyPos select 2;
_bodyATL = _bodyHeight >= -0.2;
_canDo = (!r_drag_sqf and !r_player_unconscious);
_animState = animationState player;
_isDoing = ["medic",_animState] call fnc_inString;

	if (_isDoing) exitWith {cutText ["You cannot bury a body while performing another action!","PLAIN DOWN"];};
	if (!_canDo) exitWith {cutText ["You cannot dig a grave while dragging a body!","PLAIN DOWN"];};
	if (!_bodyATL) exitWith {cutText ["This body has already been hidden!","PLAIN DOWN"];};
	
	//For animals
	if (_isAnimal and !_inVehicle and !_isMan and !_isZombie) then {
		player playActionNow "Medic";
		sleep 2;
		dayzHideBody = _body;
		hideBody _body;
		publicVariable "dayzHideBody";
	};

	//Zeds and players
	if (_isMan and !_isAlive and !_inVehicle) then {

		player playActionNow "Medic";
		sleep 1;
		_dis=10;
		_sfx = "repair";
		[player,_sfx,0,false,_dis] call dayz_zombieSpeak;  
		[player,_dis,true,(getPosATL player)] spawn player_alertZombies;
		sleep 3;
		dayzHideBody = _body;
		hideBody _body;
		publicVariable "dayzHideBody";
		sleep 2;
		deleteVehicle _grave;

		//Create cross at grave site for burried players
		if (_isMan and !_isZombie and !_isAnimal) then {
			_cross = createVehicle ["GraveCrossHelmet_EP1", _location, [], 0, "CAN_COLLIDE"];
			_cross setdir _dir;
			_cross setpos _location;

			//Delete flies
				_pos = getPosATL _body;
				_flies = nearestObject [_pos,"Sound_Flies"];
				if (!(isNull _flies)) then {
				deleteVehicle _flies;
				};
			player reveal _cross;
		};

		sleep 2;
		deleteVehicle _body;
	} else {
		cutText ["You cannot bury a player while in a vehicle!","PLAIN DOWN"];
	};