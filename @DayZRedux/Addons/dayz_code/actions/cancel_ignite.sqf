private["_isTent","_isStorageBox"];
_isTent = ((cursorTarget isKindOf "Land_Cont_RX") or (cursorTarget isKindOf "Land_Cont2_RX"));
_isStorageBox = cursorTarget isKindOf "Land_Mag_RX";

if (!_isTent or !_isStorageBox or forceCancel) then {
	player removeAction s_player_igniteTentNo;
	s_player_igniteTentNo = -1;
	player removeAction s_player_igniteTentYes;
	s_player_igniteTentYes = -1;
	player removeAction s_player_igniteBoxNo;
	s_player_igniteBoxNo = -1;
	player removeAction s_player_igniteBoxYes;
	s_player_igniteBoxYes = -1;
	forceCancel = false;
};
/*
if (!_isStorageBox or forceCancel) then {
	player removeAction s_player_igniteBoxNo;
	s_player_igniteBoxNo = -1;
	player removeAction s_player_igniteBoxYes;
	s_player_igniteBoxYes = -1;
	forceCancel = false;
};
*/