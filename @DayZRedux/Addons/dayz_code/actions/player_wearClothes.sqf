/*
_item spawn player_wearClothes;
TODO: female
*/
private ["_item","_isFemale","_itemNew","_item","_onLadder","_model","_hasclothesitem","_config","_text"];
_item = _this;
call gear_ui_init;
_onLadder = (getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

_hasclothesitem = _this in magazines player;
_config = configFile >> "CfgMagazines";
_text = getText (_config >> _item >> "displayName");

if (!_hasclothesitem) exitWith {cutText [format[(localize "str_player_31"),_text,"wear"] , "PLAIN DOWN"]};

if (vehicle player != player) exitWith {cutText ["You may not change clothes while in a vehicle", "PLAIN DOWN"]};

_isFemale = ((typeOf player == "SW2_RX")||(typeOf player == "BW1_RX"));
if (_isFemale) exitWith {cutText ["Currently Female Characters cannot change to this skin. This will change in a future update.", "PLAIN DOWN"]};

private ["_itemNew","_myModel","_humanity","_isBandit","_isHero"];
_myModel = (typeOf player);
	//diag_log("DIAG: wearClothes allowdamage false");
	player allowDamage false;

if (_myModel == "B1_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "BW1_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "S2_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "SW2_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "S3_RX") then {
	_myModel = "Survivor2_DZ";
};
if (_myModel == "S1_RX") then {
	_myModel = "Soldier1_DZ";
};
if (_myModel == "GS1_RX") then {
	_myModel = "Sniper1_DZ";
};
if (_myModel == "GB1_RX") then {
	_myModel = "Sniper1_DZ";
};
if (_myModel == "CS1_RX") then {
	_myModel = "Camo1_DZ";
};
if (_myModel == "CB1_RX") then {
	_myModel = "Camo1_DZ";
};
if (_myModel == "PS1_RX") then {
	_myModel = "Uniform1_DZ";
};
if (_myModel == "PB1_RX") then {
	_myModel = "Uniform1_DZ";
};
if (_myModel == "BR1_RX") then {
	_myModel = "Bait1_DZ";
};

_humanity = player getVariable ["humanity",0];
_isBandit = _humanity < -2000;
_isHero = _humanity > 5000;
_itemNew = "Skin_" + _myModel;

if ( !(isClass(_config >> _itemNew)) ) then {
	_itemNew = if (!_isFemale) then {"Skin_Survivor2_DZ"} else {"Skin_SurvivorW2_DZ"}; 
};

switch (_item) do {
	case "Skin_Sniper1_DZ": {
			_model = "GS1_RX";
		if (_humanity <= -2000) then {
			_model = "GB1_RX";
		};
		if (_humanity > 0) then {
			_model = "GS1_RX";
		};
	};
	case "Skin_Camo1_DZ": {
		_model = "CS1_RX";
		if (_humanity <= -2000) then {
			_model = "CB1_RX";
		};
		if (_humanity > 0) then {
			_model = "CS1_RX";
		};
	};
	case "Skin_Soldier1_DZ": {
		_model = "S1_RX";
	};
	case "Skin_Survivor2_DZ": {
		_model = "S2_RX";
		if (_isBandit) then {
			_model = "B1_RX";
		};
		if (_isHero) then {
			_model = "S3_RX";
		};
	};
	case "Skin_Uniform1_DZ": {
		_model = "PB1_RX";
		if (_isBandit) then {
			_model = "PB1_RX";
		};
		if (_isHero) then {
			_model = "PS1_RX";
		};
	};
	case "Skin_Bait1_DZ": {
		_model = "BR1_RX";
	};
};
	//diag_log("DIAG: wearClothes allowdamage true");
	player allowDamage true;
if (_model != _myModel) then {
	player removeMagazine _item;
	player addMagazine _itemNew;
	[dayz_playerUID,dayz_characterID,_model] spawn player_humanityMorph;
};
