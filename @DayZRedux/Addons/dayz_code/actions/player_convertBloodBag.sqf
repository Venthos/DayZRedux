private["_hasBag","_item","_text","_key","_inBuilding","_isHospital","_giveBag"];
disableserialization;
call gear_ui_init;
_onLadder =	(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

if (vehicle player != player) exitWith {cutText ["You may not convert blood bags while in a vehicle", "PLAIN DOWN"]};

_item = _this;
_hasBag = _this in magazines player;

_config =	configFile >> "CfgMagazines" >> _item;
_text = 	getText (_config >> "displayName");

if (!_hasBag) exitWith {cutText [format[(localize "str_player_31"),_text,"convert"] , "PLAIN DOWN"]};

_building = nearestObject [player, "HouseBase"];

_inHospital = false;

_buildConfig = configFile >> "CfgBuildingLoot" >> typeOf(_building) >> "isHospital";
if (isNumber(_buildConfig)) then {
	if ([player,_building] call fnc_isInsideBuilding) then {
		_inHospital = true;
	};
};

if (!_inHospital) exitWith {cutText ["You must be inside of a hospital building to convert a blood bag.", "PLAIN DOWN"]};

if (_inHospital) then {
	player playActionNow "PutDown";
	player removeMagazine _item;
	sleep 1;

	if (_item == "ItemBloodbag") then {
		_giveBag = "ItemSelfBloodbag";
	} else {
		_giveBag = "ItemBloodbag";
	};

	_config =	configFile >> "CfgMagazines" >> _giveBag;
	_newText =	getText (_config >> "displayName");

	player addMagazine _giveBag;

	cutText [format["You have converted your %1 into a %2",_text,_newText], "PLAIN DOWN"];
};