private["_item"];
_item = _this;
call gear_ui_init;
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

_hasclothesmag = _this in magazines player;

_config = configFile >> "CfgMagazines" >> _item;
_text = getText (_config >> "displayName");

if (!_hasclothesmag) exitWith {cutText [format[(localize "str_player_31"),_text,"wear"] , "PLAIN DOWN"]};

if (vehicle player != player) exitWith {cutText ["You may not change clothes while in a vehicle", "PLAIN DOWN"]};

if (typeOf player == "SW2_DZ") exitWith {cutText ["Currently Female Characters cannot change skins. This will change in a future update.", "PLAIN DOWN"]};
if (typeOf player == "BW1_DZ") exitWith {cutText ["Currently Female Characters cannot change skins. This will change in a future update.", "PLAIN DOWN"]};

player removeMagazine _item;
_humanity = player getVariable ["humanity",0];

switch (_item) do {
	case "Skin_Sniper1_DZ": {
		[dayz_playerUID,dayz_characterID,"G1_RX"] spawn player_humanityMorph;
	};
	case "Skin_Camo1_DZ": {
		[dayz_playerUID,dayz_characterID,"C1_RX"] spawn player_humanityMorph;
	};
	case "Skin_Survivor2_DZ": {
		_model = "S2_RX";
		if (_humanity < -2000) then {
			_model = "B1_RX";
		};
		if (_humanity > 5000) then {
			_model = "S3_RX";
		};
		[dayz_playerUID,dayz_characterID,_model] spawn player_humanityMorph;
	};
	case "Skin_Soldier1_DZ": {
		[dayz_playerUID,dayz_characterID,"A1_RX"] spawn player_humanityMorph;
	};
};

_myModel = (typeOf player);

if (_myModel == "B1_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "S2_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "S3_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "A1_RX") then {
	_myModel = "Soldier1_DZ";
};
if (_myModel == "G1_RX") then {
	_myModel = "Sniper1_DZ";
};
if (_myModel == "C1_RX") then {
	_myModel = "Camo1_DZ";
};


_itemNew = "Skin_" + _myModel;

_config = 		configFile >> "CfgMagazines" >> _itemNew;
_isClass = 		isClass (_config);

if (_isClass) then {
	player addMagazine _itemNew;
};
player setVariable ["humanity",_humanity,true];