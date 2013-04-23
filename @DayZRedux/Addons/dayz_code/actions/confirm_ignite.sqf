private["_isTent","_isStorageBox"];
_isTent = (cursorTarget isKindOf "Land_Cont_RX") or (cursorTarget isKindOf "Land_Cont2_RX");
_isStorageBox = cursorTarget isKindOf "Land_Mag_RX";

//Here I use a very convoluted method of doing this...

if (_isTent and (s_player_igniteTentSwitch != -1)) then {
	forceCancel = true;
	s_player_igniteTentNo = player addAction ["No, spare this tent!", "\z\addons\dayz_code\actions\cancel_ignite.sqf", "cursorTarget", 2, true, true, "", ""];
	s_player_igniteTentYes = player addAction ['<t color="#FF0000">' + "YES I AM SURE -- BURN THE TENT TO THE GROUND!!!" + '</t>', "\z\addons\dayz_code\actions\tent_ignite.sqf", "cursorTarget", -1, true, true, "", ""];
    player removeAction s_player_igniteTentSwitch;
	s_player_igniteTentSwitch = -1;
};

if (_isStorageBox and (s_player_igniteBoxSwitch != -1)) then {
	forceCancel = true;
	s_player_igniteBoxNo = player addAction ["No, spare this box!", "\z\addons\dayz_code\actions\cancel_ignite.sqf", "cursorTarget", 2, true, true, "", ""];
	s_player_igniteBoxYes = player addAction ['<t color="#FF0000">' + "YES I AM SURE -- BURN THE BOX TO THE GROUND!!!" + '</t>', "\z\addons\dayz_code\actions\box_ignite.sqf", "cursorTarget", -1, true, true, "", ""];
    player removeAction s_player_igniteBoxSwitch;
	s_player_igniteBoxSwitch = -1;
};