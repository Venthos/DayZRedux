private ["_array","_type","_classname","_holder","_config","_isOk","_muzzles","_playerID","_claimedBy","_text"];
_holder = _this select 3;
_classname = typeOf _holder;
_text = getText (configFile >> "CfgVehicles" >> _classname >> "displayName");

_otherPlayerNear =	{isPlayer _x} count (_holder nearEntities ["CAManBase", 10]) > 1;

if (_otherPlayerNear) exitWith {cutText [format["[Anti-Dupe] You must be the only player within 10 meters of the bag to pick it up"] , "PLAIN DOWN"]};

player action ["TakeBag", _holder];