private["_hasKit","_item","_text","_key"];
disableserialization;
call gear_ui_init;
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

if (vehicle player != player) exitWith {cutText ["You may not give yourself a transfusion while in a vehicle", "PLAIN DOWN"]};

if (dayz_combat == 1) exitWith {cutText ["You can't attempt a self transfusion while in combat!", "PLAIN DOWN"]};

_item = _this;
_hasKit = _this in magazines player;

_config =	configFile >> "CfgMagazines" >> _item;
_text = 	getText (_config >> "displayName");

if (!_hasKit) exitWith {cutText [format[(localize "str_player_31"),_text,"use"] , "PLAIN DOWN"]};

if (r_player_blood >= r_player_bloodTotal) exitWith {cutText [format["You are already in perfect health."], "PLAIN DOWN"]};

_failureChance = random 1;

if (_failureChance < 0.33) then {
	closeDialog 0;
	player removeMagazine _item;
	cutText [format["You nicked an artery and tore the blood bag!"], "PLAIN DOWN"];

	r_player_blood = (r_player_blood - 1000) max 2000;

	[player,"scream",0,false] call dayz_zombieSpeak;

	dayz_combat = 1;
	dayz_combatStart = true;

	[player, 0.3] call fnc_usec_damageUnconscious;

	r_player_inpain = true;
	player setVariable["USEC_inPain",true,true];

	_wound = "hands" call fnc_usec_damageGetWound;
	//Create Wound
	player setVariable[_wound,true,true];
	[player,_wound,_hit] spawn fnc_usec_damageBleed;
	usecBleed = [player,_wound,_hit];
	publicVariable "usecBleed";

	//Set Injured if not already
	_isInjured = player getVariable["USEC_injured",false];
	if (!_isInjured) then {
		player setVariable["USEC_injured",true,true];
		dayz_sourceBleeding = _source;
	};
	//Set ability to give blood
	_lowBlood = player getVariable["USEC_lowBlood",false];
	if (!_lowBlood) then {
		player setVariable["USEC_lowBlood",true,true];
	};
		r_player_injured = true;
} else {
	closeDialog 0;
	player playActionNow "Medic";
	[player,"hurting",0,false] call dayz_zombieSpeak;

	r_interrupt = false;
	_animState = animationState player;
	r_doLoop = true;
	_started = false;
	_finished = false;
	while {r_doLoop} do {
		_animState = animationState player;
		_isMedic = ["medic",_animState] call fnc_inString;
		if (_isMedic) then {
			_started = true;
		};
		if (_started and !_isMedic) then {
			r_doLoop = false;
			_finished = true;
		};
		if (r_interrupt) then {
			r_doLoop = false;
		};
		sleep 0.1;
	};
	r_doLoop = false;

	if (_finished) then {
		player removeMagazine _item;
		r_player_blood = r_player_bloodTotal;

		r_player_lowblood = 	false;	
		10 fadeSound 1;
		"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;
		"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 1]];"colorCorrections" ppEffectCommit 5;

		player setVariable["USEC_BloodQty",r_player_blood,true];
		player setVariable["medForceUpdate",true];
		dayzPlayerSave = player;
		publicVariableServer "dayzPlayerSave";
		if (isServer) then {
			dayzPlayerSave call server_updatePlayer;
		};

		//Ensure Control is visible
		_display = uiNamespace getVariable 'DAYZ_GUI_display';
		_control = 	_display displayCtrl 1300;
		_control ctrlShow true;

	} else {
		r_interrupt = false;
		[objNull, player, rSwitchMove,""] call RE;
		player playActionNow "stop";
		cutText [format["You moved and interrupted the transfusion!"], "PLAIN DOWN"];
	};
};