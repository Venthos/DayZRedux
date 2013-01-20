private["_holder","_type","_classname","_name"];
_holder = _this;
null = _holder addAction [format["Gear"], "\z\addons\dayz_code\actions\object_gear.sqf", _holder, 1, true, true];
player reveal _holder;