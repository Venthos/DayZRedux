private["_victim","_attacker","_ammo"];

_victim = _this select 0;
_attacker = _this select 1;
_ammo = _this select 2;

diag_log(format["DEATHREPORT: %1 was last hurt by %2 with %3", _victim, _attacker, _ammo]);