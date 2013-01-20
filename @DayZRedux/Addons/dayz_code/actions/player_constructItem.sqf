private["_item","_buildError","_toolName","_itemName","_requiredName","_requiredCount"];
disableSerialization;
_item = 	_this;
_config =	configFile >> "CfgMagazines" >> _item;

_tools = 	getArray (_config >> "ItemActions" >> "Construct" >> "tools");
_consume = 	getArray (_config >> "ItemActions" >> "Construct" >> "use");
_create = 	getArray (_config >> "ItemActions" >> "Construct" >> "output");

// TOOL REQUIREMENT CHECK
{
	_hasTool = _x in items player;
	_toolName = getText(configFile >> "CfgWeapons" >> _x >> "displayName");
	if (!_hasTool) exitWith{
		_buildError = true;
	};
} forEach _tools;

if (_buildError) exitWith{
	cutText [format["You must have a %1 to perform this construction.", _toolName], "PLAIN DOWN"];
};

// BUILD MATERIALS REQUIREMENT CHECK
{
	_requiredName = _x select 0;
	_requiredCount = _x select 1;

	_playerCount = {_x == _requiredName} count magazines player;

	_itemName = getText(configFile >> "CfgMagazines" >> _requiredName >> "displayName");
	if (_playerCount < _requiredCount) exitWith{
		_buildError = true;
	};
} forEach _consume;

if (_buildError) exitWith{
	cutText [format["You do not have %1 %2, which is needed for this construction.", _requiredCount, _itemName], "PLAIN DOWN"];
};

// REMOVAL OF BUILD MATERIALS
{
	_requiredName = _x select 0;
	_requiredCount = _x select 1;

	for "_i" from 1 to _requiredCount do {
		player removeMagazine _requiredName;
	};
} forEach _consume;

// BUILD ITEMS
player playActionNow "PutDown";
{
	_itemName = _x select 0;
	_itemCount = _x select 1;

	for "_i" from 1 to _itemCount do {
		player addMagazine _itemName;
	};
} forEach _create;