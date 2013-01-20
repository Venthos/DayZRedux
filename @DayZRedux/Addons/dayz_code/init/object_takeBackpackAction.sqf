private["_holder","_type","_classname","_name","_actionSet"];
_holder = _this;

_actionSet = _holder getVariable["actionSet", false];

if (!_actionSet) then {
	_classname = typeOf _holder;
	_name = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
	null = _holder addAction [format["Take %1",_name], "\z\addons\dayz_code\actions\object_takeBag.sqf", _holder, 1, true, true];
	player reveal _holder;
	_holder setVariable["actionSet", true];
};