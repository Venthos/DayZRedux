private["_body","_duration"];
_body = _this select 0;
_duration = _this select 1;

diag_log("Chloroform attempt on:" + str(_body) + " and I am: " + str(player) );

if (_body == player) then {
	diag_log("Chloroformed");
	[player, _duration] call fnc_usec_damageUnconscious;

	cutText [format["You've been chloroformed!",_playerName], "PLAIN DOWN"];
};