private["_item","_config","_onLadder","_consume","_meleeNum","_bag","_i"];

_item = 	_this;
_config =	configFile >> "CfgWeapons" >> _item;
_droppedtype =  (gettext (_config >> "droppeditem"));

_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

call gear_ui_init;

_consume = 	([] + getArray (_config >> "magazines")) select 0;
player removeMagazines _consume;

player removeWeapon _item;

if (_droppedtype == "") then { _item = _this; } else { _item = _droppedtype; };

/*
if (_item == "MeleeHatchet") then {_item = "ItemHatchet";};
if (_item == "MeleeCrowbar") then {_item = "ItemCrowbar";};
if (_item == "MeleeMachete") then {_item = "ItemMachete";};
*/

_bag = createVehicle [format["WeaponHolder_%1",_item],getPosATL player,[], 1, "CAN_COLLIDE"];
_bag modelToWorld getPosATL player;
_bag setdir (getDir player);
player reveal _bag;
