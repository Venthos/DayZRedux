private["_pos"];
_pos = _this select 0;

{
	[_x, "gear"] call server_updateObject;
} forEach nearestObjects [_pos, ["Car", "Helicopter", "Motorcycle", "Ship", "Animals", "Land_Cont_RX", "Land_Cont2_RX", "Land_Mag_RX"], 10];
