/*

 DRAG BODY SCRIPT

 Allows players to drag unconscious bodies 

 JULY 2010 - norrin
*****************************************************************************************************************************
Start drag.sqf
*/

private ["_unit","_dragee","_pos","_dir","_bodyPos","_bodyHeight","_bodyATL","_canDo","_onLadder","_animState","_isDoing","_addAction"];
_dragee				= _this select 3;
_unit  				= player;
_unconscious = 		_dragee getVariable ["NORRN_unconscious", false];
_animState = animationState player;
_isDoing = ["medic",_animState] call fnc_inString;
_addAction = false;

	if (isNull _dragee) exitWith {};

	if (!forceDrag) then {
		if (!_unconscious) exitWith {};
	};

	if (_isDoing) exitWith {cutText ["You cannot drag a body while performing another action!","PLAIN DOWN"];};

_bodyPos = getPosATL _dragee;
_bodyHeight = _bodyPos select 2;
_bodyATL = _bodyHeight >= -0.2;
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);

if (!_canDo) exitWith { if (r_drag_sqf) then { [cursorTarget, _unit, _unconscious, _dragee] execVM "\z\addons\dayz_code\medical\drop_body.sqf"; }; }; //prevent duplicate drags
if (!_bodyATL) exitWith { cutText ["You cannot drag a body that has been burried!","PLAIN DOWN"]; };
//player assumes dragging posture
r_drag_sqf 	= true;
while {r_drag_sqf} do {
if (!_addAction) then {
_dragee setVariable ["NORRN_unit_dragged", true, true];

_unit playActionNow "grabDrag";
sleep 2;

//unconscious unit assumes dragging posture
//public EH 
//norrnRaDrag = _dragee;
norrnRaDrag = [_dragee];
publicVariable "norrnRaDrag";
//_dragee switchmove "ainjppnemstpsnonwrfldb_still";
_dragee attachto [_unit,[0.1, 1.01, 0]];
sleep 0.02;

//rotate wounded units so that it is facing the correct direction
norrnR180 = _dragee;
publicVariable "norrnR180";
_dragee  setDir 180;

//Uneccesary actions removed & drop body added 
call fnc_usec_medic_removeActions;

NORRN_dropAction = player addAction ["Drop body", "\z\addons\dayz_code\medical\drop_body.sqf",_dragee, 0, false, true];
//NORRN_carryAction = player addAction ["Carry body", "\z\addons\dayz_code\medical\carry.sqf",_dragee, 0, false, true];
sleep 1;
_addAction = true;
};
	if (force_dropBody) then {
		[cursorTarget, _unit, _unconscious, _dragee] execVM "\z\addons\dayz_code\medical\drop_body.sqf";
	};

	if (vehicle player != player) then {
		player action ["eject", vehicle player];
		cutText ["You cannot enter a vehicle while dragging a body!","PLAIN DOWN"];
		[cursorTarget, _unit, _unconscious, _dragee] execVM "\z\addons\dayz_code\medical\drop_body.sqf";
	};
if (!r_drag_sqf) exitWith {};
};