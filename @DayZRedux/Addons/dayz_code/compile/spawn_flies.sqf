private ["_body","_id","_position"];
_body = _this;
_position = getPosATL _body;
_id = [_position,0.1,1.5] call bis_fnc_flies;
//_flies = nearestObject [_position,"Sound_Flies"];
//_flies attachTo [_body];
//_id setVariable ["body",_body];
//dayz_flyMonitor set[count dayz_flyMonitor, _id];