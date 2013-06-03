private ["_unit","_ammo","_audible","_distance","_listTalk","_weapon","_projectile","_vUp","_endPos","_dir","_height","_bolt","_hitArray","_hitObject","_hitSelection","_config","_hitMemoryPt","_variation","_val","_doLoop","_countr","_nearplayer","_playerName","_playerPos","_listNear"];
_unit = 		_this select 0;
_weapon = 		_this select 1;
_ammo = 		_this select 4;
_projectile = 	_this select 6;

//diag_log("COMBAT: Entered projectileNear logic");

// This essentially limits the amount of bullets that will end up
// being tracked for use in placing others in combat.  This should hopefully result
// in increased performance, especially when people are firing off LMGs.
_timeleft = dayz_combatTimer - time;
if (_timeleft > 43) exitWith {};

//diag_log("COMBAT: Doing projectileNear calculations");

//_projectile = nearestObject [_unit, _ammo];
_endPos = getPosATL _projectile;

_doWait = true;
while {_doWait} do {
	_vel = (velocity _projectile) distance [0,0,0];
	if (!(alive _projectile)) then {_doWait = false};	
	if (_vel < 0.1) then {_doWait = false};
	_endPos = getPosATL _projectile;
	sleep 0.02; // Bump from 0.01
};

_listNear = (_endPos) nearEntities [["CAManBase","AllVehicles"],50];
{
	_nearVehicle = _x;
	_isInCombat	= _nearVehicle getVariable["isincombat",0];
	_combatQueued	= _nearVehicle getVariable["startcombattimer",0];

	if ((alive _nearVehicle) and (isPlayer _nearVehicle) and _combatQueued == 0) then {
		if ( _isInCombat == 0 ) then {
			_nearVehicle setVariable["isincombat", 1, true];
		};
		_nearVehicle setVariable["startcombattimer", 1, true];
		diag_log("Now in Combat (Player): " + name _nearVehicle);
	};
	if (_nearVehicle isKindOf "AllVehicles") then {
		{
			_isInCombat	= _x getVariable["isincombat",0];
			_combatQueued	= _x getVariable["startcombattimer",0];
			if (isPlayer _x and _combatQueued == 0) then {
				if ( _isInCombat == 0 ) then {
					_x setVariable["isincombat", 1, true];
				};
				_x setVariable["startcombattimer", 1, true];
				diag_log("Now in Combat (Crew): " + name _x);
			};
		} forEach (crew _nearVehicle);
	};
} forEach _listNear;