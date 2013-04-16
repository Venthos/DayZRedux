private["_isTent","_isStorageBox"];
_isTent = ((cursorTarget isKindOf "Land_Cont_RX") or (cursorTarget isKindOf "Land_Cont2_RX"));
_isStorageBox = cursorTarget isKindOf "Land_Mag_RX";

if (_isTent and (s_player_igniteTentSwitch != -1)) then {
	s_player_igniteTentNo = player addAction ["No, spare this tent!", "\z\addons\dayz_code\actions\cancel_ignite.sqf",cursorTarget, 2, true, true, "", ""];
	s_player_igniteTentYes = player addAction ['<t color="#FF0000">' + "YES I AM SURE -- BURN THE TENT TO THE GROUND!!!" + '</t>', "\z\addons\dayz_code\actions\tent_ignite.sqf",cursorTarget, -1, true, true, "", ""];
    player removeAction s_player_igniteTentSwitch;
	} else {
		player removeAction s_player_igniteTentNo;
		player removeAction s_player_igniteTentYes;
};

if (_isStorageBox and (s_player_igniteBoxSwitch != -1)) then {
	s_player_igniteBoxNo = player addAction ["No, spare this box!", "\z\addons\dayz_code\actions\cancel_ignite.sqf",cursorTarget, 2, true, true, "", ""];
	s_player_igniteBoxYes = player addAction ['<t color="#FF0000">' + "YES I AM SURE -- BURN THE BOX TO THE GROUND!!!" + '</t>', "\z\addons\dayz_code\actions\box_ignite.sqf",cursorTarget, -1, true, true, "", ""];
    player removeAction s_player_igniteBoxSwitch;
	} else {
		player removeAction s_player_igniteBoxNo;
		player removeAction s_player_igniteBoxYes;
};
/*
    if (_burnTent) then {
		player removeAction s_player_igniteTentNo;
		player removeAction s_player_igniteTentYes;
		s_player_igniteTent = player addAction ['<t color="#FF0000">' + "YES I AM SURE -- BURN THE TENT TO THE GROUND!!!" + '</t>', "\z\addons\dayz_code\actions\tent_ignite.sqf",cursorTarget, 1, true, true, "", ""];
};
	if (_cancelburnTent) exitWith {
		player removeAction s_player_igniteTentNo;
		player removeAction s_player_igniteTentYes;
		cutText ["Ignition of tent aborted!","PLAIN DOWN"]
	};
	if (_burnBox) then {
		player removeAction s_player_igniteBoxNo;
		player removeAction s_player_igniteBoxYes;
		s_player_igniteBox = player addAction ['<t color="#FF0000">' + "YES I AM SURE -- BURN THE BOX TO THE GROUND!!!" + '</t>', "\z\addons\dayz_code\actions\box_ignite.sqf",cursorTarget, 1, true, true, "", ""];
    };
    if (_cancelburnBox) exitWith {
		player removeAction s_player_igniteBoxYes;
		player removeAction s_player_igniteBoxNo;
		cutText ["Ignition of box aborted!","PLAIN DOWN"]
	};
*/