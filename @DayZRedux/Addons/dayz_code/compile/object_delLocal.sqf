private["_type","_pos","_tent"];

_type = _this select 0;
_pos = _this select 1;

_tent = nearestObject [_type,_pos];

if (!isNull _tent) then {
	if (local _tent) then {deleteVehicle _tent};
};