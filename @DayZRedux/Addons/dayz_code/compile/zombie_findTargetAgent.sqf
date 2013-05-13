private ["_agent","_target","_targets","_targetDis","_c","_man","_manDis","_targets","_agent","_agentheight","_nearEnts","_rnd","_assigned","_range","_objects"];
_agent = _this;
_target = objNull;
_targets = [];
_targetDis = [];
_range = 300;
_manDis = 0;
_refobj = vehicle player;

_targets = _agent getVariable ["targets",[]];

if (isNil "_targets") exitWith {};
//Search for objects
if (count _targets == 0) then {
	_objects = nearestObjects [_agent,["ThrownObjects","GrenadeHandTimedWest","SmokeShell"],50];
	{
		private ["_dis"];
		if (!(_x in _targets)) then {
			_targets set [count _targets,_x];
			_targetDis set [count _targetDis,_dis];
		};
	} forEach _objects;
};

//Find best target
if (count _targets > 0) then
{
	_man = _targets select 0;
	_manDis = _man distance _agent;
	{
		private ["_dis"];
		_dis =  _x distance _agent;
		if (_dis < _manDis) then
		{
			_man = _x;
			_manDis = _dis;
		};
		if (_x isKindOf "SmokeShell") then
		{
			_man = _x;
			_manDis = _dis;
		};
	} forEach _targets;

	_target = _man;
};

//Check if too far
if (_manDis > _range) then {
	_targets = _targets - [_target];
	_target = objNull;
};
_target;