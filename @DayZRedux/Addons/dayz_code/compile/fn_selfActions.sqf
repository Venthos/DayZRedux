scriptName "Functions\misc\fn_selfActions.sqf";
/***********************************************************
	ADD ACTIONS FOR SELF
	- Function
	- [] call fnc_usec_selfActions;
************************************************************/
private ["_vehicle","_hasChloroform","_inVehicle","_bag","_classbag","_isWater","_hasAntiB","_hasFuelE","_hasFuel5","_hasbottleitem","_hastinitem","_hasKnife","_hasToolbox","_onLadder","_nearLight","_canPickLight","_canDo","_text","_isHarvested","_isVehicle","_isVehicletype","_isMan","_ownerID","_isAnimal","_isDog","_isZombie","_isDestructable","_isTent","_isFuel","_isAlive","_canmove","_rawmeat","_hasRawMeat","_allFixed","_hitpoints","_damage","_part","_cmpt","_damagePercent","_color","_string","_handle","_dogHandle","_lieDown","_warn","_dog","_speed","_array","_newArray","_toStr","_fullPartName","_glassName","_isStorageBox","_hasMatches"];

_vehicle = vehicle player;
_inVehicle = (_vehicle != player);
_bag = unitBackpack player;
_classbag = typeOf _bag;
_isWater = 		(surfaceIsWater (position player)) or dayz_isSwimming;
_hasAntiB = 	"ItemAntibiotic" in magazines player;
_hasFuelE = 	"ItemJerrycanEmpty" in magazines player;
_hasFuel5 = 	"ItemFuelcanEmpty" in magazines player;
//boiled Water
_hasbottleitem = "ItemWaterbottle" in magazines player;
_hastinitem = false;
{
    if (_x in magazines player) then {
        _hastinitem = true;
    };

} forEach boil_tin_cans;


_hasKnife = 	"ItemKnife" in items player;
_hasToolbox = 	"ItemToolbox" in items player;
//_hasTent = 		"ItemTent" in items player;
_hasChloroform = "ItemChloroform" in magazines player;
_hasMatches = 	"ItemMatchbox" in items player;
_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
_nearLight = 	nearestObject [player,"LitObject"];
_canPickLight = false;

if (!isNull _nearLight) then {
	if (_nearLight distance player < 4) then {
		_canPickLight = isNull (_nearLight getVariable ["owner",objNull]);
	};
};
_canDo = (!r_drag_sqf and !r_player_unconscious and !_onLadder);

//Grab Flare
if (_canPickLight and !dayz_hasLight) then {
	if (s_player_grabflare < 0) then {
		_text = getText (configFile >> "CfgAmmo" >> (typeOf _nearLight) >> "displayName");
		s_player_grabflare = player addAction [format[localize "str_actions_medical_15",_text], "\z\addons\dayz_code\actions\flare_pickup.sqf",_nearLight, 1, false, true, "", ""];
		s_player_removeflare = player addAction [format[localize "str_actions_medical_17",_text], "\z\addons\dayz_code\actions\flare_remove.sqf",_nearLight, 1, false, true, "", ""];
	};
} else {
	player removeAction s_player_grabflare;
	player removeAction s_player_removeflare;
	s_player_grabflare = -1;
	s_player_removeflare = -1;
};

if (!isNull cursorTarget and !_inVehicle and (player distance cursorTarget < 4)) then {	//Has some kind of target
	_isHarvested = cursorTarget getVariable["meatHarvested",false];
	_isVehicle = cursorTarget isKindOf "AllVehicles";
	_isVehicletype = typeOf cursorTarget in ["ATV_US_EP1","ATV_CZ_EP1"];
	_isMan = cursorTarget isKindOf "Man";
	_ownerID = cursorTarget getVariable ["characterID","0"];
	_isAnimal = cursorTarget isKindOf "Animal";
	_isDog =  (cursorTarget isKindOf "DZ_Pastor" || cursorTarget isKindOf "DZ_Fin");
	_isZombie = cursorTarget isKindOf "zZambie_Base";
	_isDestructable = cursorTarget isKindOf "BuiltItems";
	_isTent = ((cursorTarget isKindOf "Land_Cont_RX") or (cursorTarget isKindOf "Land_Cont2_RX"));
	_isStorageBox = (cursorTarget isKindOf "Land_Mag_RX");
	_isFuel = false;
	_isAlive = alive cursorTarget;
	_canmove = canmove cursorTarget;
	_text = getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName");
	
	
	_rawmeat = meatraw;
	_hasRawMeat = false;
		{
			if (_x in magazines player) then {
				_hasRawMeat = true;
			};
		} forEach _rawmeat; 
	
	
	if (_hasFuelE or _hasFuel5) then {
		_isFuel = (cursorTarget isKindOf "Land_Ind_TankSmall") or (cursorTarget isKindOf "Land_fuel_tank_big") or (cursorTarget isKindOf "Land_fuel_tank_stairs") or (cursorTarget isKindOf "Land_wagon_tanker");
	};
	//diag_log ("OWNERID = " + _ownerID + " CHARID = " + dayz_characterID + " " + str(_ownerID == dayz_characterID));
	
	//Allow player to delete objects
	if(_isDestructable and _hasToolbox and _canDo) then {
		if (s_player_deleteBuild < 0) then {
			s_player_deleteBuild = player addAction [format[localize "str_actions_delete",_text], "\z\addons\dayz_code\actions\remove.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_deleteBuild;
		s_player_deleteBuild = -1;
	};
	
	/*
	//Allow player to force save
	if((_isVehicle or _isTent) and _canDo and !_isMan) then {
		if (s_player_forceSave < 0) then {
			s_player_forceSave = player addAction [format[localize "str_actions_save",_text], "\z\addons\dayz_code\actions\forcesave.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_forceSave;
		s_player_forceSave = -1;
	};
	*/
	//flip vehicle
	if ((_isVehicle) and !_canmove and _isAlive and (player distance cursorTarget >= 2) and (count (crew cursorTarget))== 0 and ((vectorUp cursorTarget) select 2) < 0.5) then {
		if (s_player_flipveh  < 0) then {
			s_player_flipveh = player addAction [format[localize "str_actions_flipveh",_text], "\z\addons\dayz_code\actions\player_flipvehicle.sqf",cursorTarget, 1, true, true, "", ""];		
		};	
	} else {
		player removeAction s_player_flipveh;
		s_player_flipveh = -1;
	};

	//Allow player to set tent ablaze
	if(_isTent and _hasMatches and _canDo and !_isMan) then {
		if (s_player_igniteTent < 0) then {
			s_player_igniteTent = player addAction [format[localize "str_actions_ignite_tent"], "\z\addons\dayz_code\actions\tent_ignite.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_igniteTent;
		s_player_igniteTent = -1;
	};

	//Allow player to set storage box ablaze
	if(_isStorageBox and _hasMatches and _canDo and !_isMan and _isAlive) then {
		if (s_player_igniteBox < 0) then {
			s_player_igniteBox = player addAction [format[localize "str_actions_ignite_box"], "\z\addons\dayz_code\actions\box_ignite.sqf",cursorTarget, 1, true, true, "", ""];
		};
	} else {
		player removeAction s_player_igniteBox;
		s_player_igniteBox = -1;
	};
	
	//Allow player to fill jerrycan
	if((_hasFuelE or _hasFuel5) and _isFuel and _canDo) then {
		if (s_player_fillfuel < 0) then {
			s_player_fillfuel = player addAction [localize "str_actions_self_10", "\z\addons\dayz_code\actions\jerry_fill.sqf",[], 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_fillfuel;
		s_player_fillfuel = -1;
	};
	
	if (!alive cursorTarget and _isAnimal and _hasKnife and !_isHarvested and _canDo) then {
		if (s_player_butcher < 0) then {
			s_player_butcher = player addAction [localize "str_actions_self_04", "\z\addons\dayz_code\actions\gather_meat.sqf",cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_butcher;
		s_player_butcher = -1;
	};
	
	//Fireplace Actions check
	if (inflamed cursorTarget and _hasRawMeat and _canDo) then {
		if (s_player_cook < 0) then {
			s_player_cook = player addAction [localize "str_actions_self_05", "\z\addons\dayz_code\actions\cook.sqf",cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_cook;
		s_player_cook = -1;
	};
	if (inflamed cursorTarget and (_hasbottleitem and _hastinitem) and _canDo) then {
		if (s_player_boil < 0) then {
			s_player_boil = player addAction [localize "str_actions_boilwater", "\z\addons\dayz_code\actions\boil.sqf",cursorTarget, 3, true, true, "", ""];
		};
	} else {
		player removeAction s_player_boil;
		s_player_boil = -1;
	};
	
	if(cursorTarget == dayz_hasFire and _canDo) then {
		if ((s_player_fireout < 0) and !(inflamed cursorTarget) and (player distance cursorTarget < 3)) then {
			s_player_fireout = player addAction [localize "str_actions_self_06", "\z\addons\dayz_code\actions\fire_pack.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_fireout;
		s_player_fireout = -1;
	};
	
	//Packing my tent
	if(((cursorTarget isKindOf "Land_Cont_RX") or (cursorTarget isKindOf "Land_Cont2_RX")) and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_packtent < 0) and (player distance cursorTarget < 3)) then {
			s_player_packtent = player addAction [localize "str_actions_self_07", "\z\addons\dayz_code\actions\tent_pack.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_packtent;
		s_player_packtent = -1;
		};
	
	//Sleep -- USELESS
/*
	if(cursorTarget isKindOf "TentStorage" and _canDo and _ownerID == dayz_characterID) then {
		if ((s_player_sleep < 0) and (player distance cursorTarget < 3)) then {
			s_player_sleep = player addAction [localize "str_actions_self_sleep", "\z\addons\dayz_code\actions\player_sleep.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_sleep;
		s_player_sleep = -1;
	};
*/
	//Retrieving my box
	if((cursorTarget isKindOf "Land_Mag_RX") and _canDo and _ownerID == dayz_characterID and _isAlive) then {
		if ((s_player_retrievebox < 0) and (player distance cursorTarget < 3)) then {
			s_player_retrievebox = player addAction [localize "str_actions_self_11", "\z\addons\dayz_code\actions\box_retrieve.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_retrievebox;
		s_player_retrievebox = -1;
	};

	// Remove Parts from Vehicles - By SilverShot.
	if( !_isMan and _canDo and _hasToolbox and (silver_myCursorTarget != cursorTarget) and cursorTarget isKindOf "AllVehicles" and (getDammage cursorTarget < 0.95) ) then {
		_vehicle = cursorTarget;
<<<<<<< HEAD
		_invalidVehicle = (_vehicle isKindOf "Motorcycle") or (_vehicle isKindOf "Tractor") or (_vehicle isKindOf "Ship") or (_vehicle isKindOf "ATV_Base_EP1"); //or (_vehicle isKindOf "ATV_US_EP1") or (_vehicle isKindOf "ATV_CZ_EP1");
=======
		_invalidVehicle = (_vehicle isKindOf "Motorcycle") or (_vehicle isKindOf "Tractor") or (_vehicle isKindOf "Ship") or (_vehicle isKindOf "ATV_Base_EP1"); //or (_vehicle isKindOf "ATV_US_EP1") or (_vehicle isKindOf "ATV_CZ_EP1");
>>>>>>> a413987f5de0a4ace7f5aca9450b3642c4298b56
		if( !_invalidVehicle ) then {
		{silver_myCursorTarget removeAction _x} forEach s_player_removeActions;
		
		s_player_removeActions = [];
		silver_myCursorTarget = _vehicle;
		 
		_hitpoints = _vehicle call vehicle_getHitpoints;
		 
		{
		_damage = [_vehicle,_x] call object_getHit;
		 
		if( _damage < 0.15 ) then {
		 
		//change "HitPart" to " - Part" rather than complicated string replace
		_cmpt = toArray (_x);
		_cmpt set [0,20];
		_cmpt set [1,toArray ("-") select 0];
		_cmpt set [2,20];
		_cmpt = toString _cmpt;
		 
		_skip = true;
		if((_damage < 10) and _skip and _x == "HitFuel" ) then { _skip = false; _part = "PartFueltank"; _cmpt = _cmpt + "tank"};
		if((_damage < 10) and _skip and _x == "HitEngine" ) then { _skip = false; _part = "PartEngine"; };
		if((_damage < 10) and _skip and _x == "HitLFWheel" ) then { _skip = false; _part = "PartWheel"; };
		if((_damage < 10) and _skip and _x == "HitRFWheel" ) then { _skip = false; _part = "PartWheel"; };
		if((_damage < 10) and _skip and _x == "HitLBWheel" ) then { _skip = false; _part = "PartWheel"; };
		if((_damage < 10) and _skip and _x == "HitRBWheel" ) then { _skip = false; _part = "PartWheel"; };
		if((_damage < 10) and _skip and _x == "HitGlass1" ) then { _skip = false; _part = "PartGlass"; };
		if((_damage < 10) and _skip and _x == "HitGlass2" ) then { _skip = false; _part = "PartGlass"; };
		if((_damage < 10) and _skip and _x == "HitGlass3" ) then { _skip = false; _part = "PartGlass"; };
		if((_damage < 10) and _skip and _x == "HitGlass4" ) then { _skip = false; _part = "PartGlass"; };
		if((_damage < 10) and _skip and _x == "HitGlass5" ) then { _skip = false; _part = "PartGlass"; };
		if((_damage < 10) and _skip and _x == "HitGlass6" ) then { _skip = false; _part = "PartGlass"; };
		if((_damage < 10) and _skip and _x == "HitHRotor" ) then { _skip = false; _part = "PartVRotor"; };
		 
		if (!_skip ) then {
			_string = format["<t color='#0096ff'>Remove%1</t>",_cmpt,_color]; //Remove - Part
			_handle = silver_myCursorTarget addAction [_string, "\z\addons\dayz_code\actions\remove_parts.sqf",[_vehicle,_part,_x], 0, false, true, "",""];
			s_player_removeActions set [count s_player_removeActions,_handle];
		};
		};
		 
		} forEach _hitpoints;
		};
	};

	//Repairing Vehicles
	if ((dayz_myCursorTarget != cursorTarget) and _isVehicle and !_isMan and _hasToolbox and (damage cursorTarget < 1)) then {
		_vehicle = cursorTarget;
		{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
		dayz_myCursorTarget = _vehicle;
		_hitpoints = _vehicle call vehicle_getHitpoints;

		_handle = dayz_myCursorTarget addAction ["Inspect Vehicle", "\z\addons\dayz_code\actions\inspectvehicle.sqf",[_vehicle,_hitpoints], 0, false, true, "",""];
		s_player_repairActions set [count s_player_repairActions,_handle];

		_allFixed = true;
		{
			_damage = [_vehicle,_x] call object_getHit;
			//if (_damage > 0) then {
				_color = "";
				_part = "PartGeneric";
				_cmpt = _x;
				_damagePercent = round((1 - _damage) * 100);
				if(["Body",_x,false] call fnc_inString) then {
					_part = "PartGeneric";
					_cmpt = "Body";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Engine",_x,false] call fnc_inString) then {
					_part = "PartEngine";
					_cmpt = "Engine";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["HRotor",_x,false] call fnc_inString) then {
					_part = "PartVRotor";
					_cmpt = "Main Rotor Assembly";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Avionics",_x,false] call fnc_inString) then {
					_part = "PartGeneric";
					_cmpt = "Avionics";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Missiles",_x,false] call fnc_inString) then {
					_part = "PartGeneric";
					_cmpt = "Missiles";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["VRotor",_x,false] call fnc_inString) then {
					_part = "PartGeneric";
					_cmpt = "Rear Rotor Assembly";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Hull",_x,false] call fnc_inString) then {
					_part = "PartGeneric";
					_cmpt = "Hull";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Fuel",_x,false] call fnc_inString) then {
					_part = "PartFueltank";
					_cmpt = "Fuel Tank";
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Wheel",_x,false] call fnc_inString) then {
					_part = "PartWheel";
					_cmpt = "Wheel";
					_array = toArray _x;
					_newArray = [];
					for "_i" from 3 to ((count _array) - 1) do {_newArray set [count _newArray,(_array select _i)]};
					_array = _newArray;
					_newArray = [];
					for "_i" from 0 to ((count _array) - 6) do {_newArray set [count _newArray,(_array select _i)]};
					_toStr = toString _newArray;
					_toStr = switch (_toStr) do {
						default {_toStr};
						case "LF": {"Left Front"};
						case "RF": {"Right Front"};
						case "LF2": {"Left Front 2nd"};
						case "RF2": {"Right Front 2nd"};
						case "LB": {"Left Back"};
						case "RB": {"Right Back"};
						case "LM": {"Left Middle"};
						case "RM": {"Right Middle"};
						case "F": {"Front"};
						case "B": {"Back"};
					};
					_cmpt = _cmpt + " " + _toStr;
					if (_damagePercent < 95) then {_allFixed = false};
				};
				if(["Glass",_x,false] call fnc_inString) then {
					_part = "PartGlass";

					_fullPartName = toArray _x;
					_glassName = [];
					for "_i" from 3 to ((count _fullPartName) - 1) do {_glassName set [count _glassName ,(_fullPartName select _i)]};
					_cmpt = toString _glassName;

					if (_damagePercent < 95) then {_allFixed = false};
				};
				if (_part in magazines player and _damage > 0) then {
					if (_damage > 0.3) then {_color = "color='#ffff00'"};
					if (_damage > 0.6) then {_color = "color='#ff0000'";};
					_string = format[localize "str_actions_medical_09",_cmpt,_color];
					_handle = dayz_myCursorTarget addAction [_string, "\z\addons\dayz_code\actions\repair.sqf",[_vehicle,_part,_x], 0, false, true, "",""];
					s_player_repairActions set [count s_player_repairActions,_handle];
				};
			//};
			//diag_log(format["Checking Part X[%1] part[%2] cmpt[%3] damage[%3] -- State: %4",_x,_part,_cmpt,_damage,_allFixed]);
		} forEach _hitpoints;
		if (_allFixed) then {
			_vehicle setDamage 0;
		};
	};

	if (_isMan and _isAlive and !_isZombie and _hasChloroform and _canDo) then {
		if (s_player_chloroform < 0) then {
			s_player_chloroform = player addAction [localize "str_action_chloroform", "\z\addons\dayz_code\actions\chloroform.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_chloroform;
		s_player_chloroform = -1;
	};
	
	if (_isMan and !_isAlive and !_isZombie) then {
		if (s_player_studybody < 0) then {
			s_player_studybody = player addAction [localize "str_action_studybody", "\z\addons\dayz_code\actions\study_body.sqf",cursorTarget, 0, false, true, "",""];
		};
	} else {
		player removeAction s_player_studybody;
		s_player_studybody = -1;
	};

	//Dog
	if (_isDog and _isAlive and (_hasRawMeat) and _canDo and _ownerID == "0" and player getVariable ["dogID", 0] == 0) then {
		if (s_player_tamedog < 0) then {
			s_player_tamedog = player addAction [localize "str_actions_tamedog", "\z\addons\dayz_code\actions\tame_dog.sqf", cursorTarget, 1, false, true, "", ""];
		};
	} else {
		player removeAction s_player_tamedog;
		s_player_tamedog = -1;
	};
	
	if (_isDog and _ownerID == dayz_characterID and _isAlive and _canDo) then {
		_dogHandle = player getVariable ["dogID", 0];
		if (s_player_feeddog < 0 and _hasRawMeat) then {
			s_player_feeddog = player addAction [localize "str_actions_feeddog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,0], 0, false, true,"",""];
		};
		if (s_player_waterdog < 0 and "ItemWaterbottle" in magazines player) then {
			s_player_waterdog = player addAction [localize "str_actions_waterdog","\z\addons\dayz_code\actions\dog\feed.sqf",[_dogHandle,1], 0, false, true,"",""];
		};
		if (s_player_staydog < 0) then {
			_lieDown = _dogHandle getFSMVariable "_actionLieDown";
			if (_lieDown) then { _text = "str_actions_liedog"; } else { _text = "str_actions_sitdog"; };
			s_player_staydog = player addAction [localize _text,"\z\addons\dayz_code\actions\dog\stay.sqf", _dogHandle, 5, false, true,"",""];
		};
		if (s_player_trackdog < 0) then {
			s_player_trackdog = player addAction [localize "str_actions_trackdog","\z\addons\dayz_code\actions\dog\track.sqf", _dogHandle, 4, false, true,"",""];
		};
		if (s_player_barkdog < 0) then {
			s_player_barkdog = player addAction [localize "str_actions_barkdog","\z\addons\dayz_code\actions\dog\speak.sqf", cursorTarget, 3, false, true,"",""];
		};
		if (s_player_warndog < 0) then {
			_warn = _dogHandle getFSMVariable "_watchDog";
			if (_warn) then { _text = "Quiet"; _warn = false; } else { _text = "Alert"; _warn = true; };
			s_player_warndog = player addAction [format[localize "str_actions_warndog",_text],"\z\addons\dayz_code\actions\dog\warn.sqf",[_dogHandle, _warn], 2, false, true,"",""];		
		};
		if (s_player_followdog < 0) then {
			s_player_followdog = player addAction [localize "str_actions_followdog","\z\addons\dayz_code\actions\dog\follow.sqf",[_dogHandle,true], 6, false, true,"",""];
		};
	} else {
		player removeAction s_player_feeddog;
		s_player_feeddog = -1;
		player removeAction s_player_waterdog;
		s_player_waterdog = -1;
		player removeAction s_player_staydog;
		s_player_staydog = -1;
		player removeAction s_player_trackdog;
		s_player_trackdog = -1;
		player removeAction s_player_barkdog;
		s_player_barkdog = -1;
		player removeAction s_player_warndog;
		s_player_warndog = -1;
		player removeAction s_player_followdog;
		s_player_followdog = -1;
	};
} else {
  //remove vehicle parts
	{silver_myCursorTarget removeAction _x} forEach s_player_removeActions;s_player_removeActions = [];
	silver_myCursorTarget = objNull;
	//Engineering
	{dayz_myCursorTarget removeAction _x} forEach s_player_repairActions;s_player_repairActions = [];
	dayz_myCursorTarget = objNull;
	//Others
	player removeAction s_player_forceSave;
	s_player_forceSave = -1;
	player removeAction s_player_flipveh;
	s_player_flipveh = -1;
	player removeAction s_player_sleep;
	s_player_sleep = -1;
	player removeAction s_player_igniteTent;
	s_player_igniteTent = -1;
	player removeAction s_player_igniteBox;
	s_player_igniteBox = -1;
	player removeAction s_player_deleteBuild;
	s_player_deleteBuild = -1;
	player removeAction s_player_butcher;
	s_player_butcher = -1;
	player removeAction s_player_cook;
	s_player_cook = -1;
	player removeAction s_player_boil;
	s_player_boil = -1;
	player removeAction s_player_fireout;
	s_player_fireout = -1;
	player removeAction s_player_packtent;
	s_player_packtent = -1;
	player removeAction s_player_retrievebox;
  s_player_retrievebox = -1;
	player removeAction s_player_fillfuel;
	s_player_fillfuel = -1;
	player removeAction s_player_studybody;
	s_player_studybody = -1;
	player removeAction s_player_flipveh;
	s_player_flipveh = -1;
	player removeAction s_player_chloroform;
	s_player_chloroform = -1;
	//Dog
	player removeAction s_player_tamedog;
	s_player_tamedog = -1;
	player removeAction s_player_feeddog;
	s_player_feeddog = -1;
	player removeAction s_player_waterdog;
	s_player_waterdog = -1;
	player removeAction s_player_staydog;
	s_player_staydog = -1;
	player removeAction s_player_trackdog;
	s_player_trackdog = -1;
	player removeAction s_player_barkdog;
	s_player_barkdog = -1;
	player removeAction s_player_warndog;
	s_player_warndog = -1;
	player removeAction s_player_followdog;
	s_player_followdog = -1;
};

//Dog actions on player self
_dogHandle = player getVariable ["dogID", 0];
if (_dogHandle > 0) then {
	_dog = _dogHandle getFSMVariable "_dog";
	_ownerID = "0";
	if (!isNull cursorTarget) then { _ownerID = cursorTarget getVariable ["characterID","0"]; };
	if (_canDo and !_inVehicle and alive _dog and _ownerID != dayz_characterID) then {
		if (s_player_movedog < 0) then {
			s_player_movedog = player addAction [localize "str_actions_movedog", "\z\addons\dayz_code\actions\dog\move.sqf", player getVariable ["dogID", 0], 1, false, true, "", ""];
		};
		if (s_player_speeddog < 0) then {
			_text = "Walk";
			_speed = 0;
			if (_dog getVariable ["currentSpeed",1] == 0) then { _speed = 1; _text = "Run"; };
			s_player_speeddog = player addAction [format[localize "str_actions_speeddog", _text], "\z\addons\dayz_code\actions\dog\speed.sqf",[player getVariable ["dogID", 0],_speed], 0, false, true, "", ""];
		};
		if (s_player_calldog < 0) then {
			s_player_calldog = player addAction [localize "str_actions_calldog", "\z\addons\dayz_code\actions\dog\follow.sqf", [player getVariable ["dogID", 0], true], 2, false, true, "", ""];
		};
	};
} else {
	player removeAction s_player_movedog;		
	s_player_movedog =		-1;
	player removeAction s_player_speeddog;
	s_player_speeddog =		-1;
	player removeAction s_player_calldog;
	s_player_calldog = 		-1;
};