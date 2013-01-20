private["_reportArray","_victim","_attacker","_damage"];

_victim = _this select 0;
_attacker = _this select 1;
_damage = _this select 2;

diag_log(format["DMGREPORT: %1 damaged by %2 for %3 damage", _victim, _attacker, _damage]);