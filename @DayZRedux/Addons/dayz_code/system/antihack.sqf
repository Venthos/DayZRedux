/*
	Anti-Teleport
	Created By Razor
	Refactored By Alby
*/

private["_debug","_curpos","_lastpos","_curheight","_lastheight","_terrainHeight","_curtime","_lasttime","_distance","_difftime","_speed","_topSpeed"];

waitUntil {vehicle player == player};

[] spawn {
	private ["_playerName","_playerUID"];
	_playerName = name player;
	_playerUID = getPlayerUID player;
	while {true} do {
		if (typeName player != "OBJECT") then {
			atp = format["WARNING! TYPENAME ERROR ON %1 (%2)", _playerName, _playerUID];
			publicVariableServer "atp";
			//forceEnd;
			endMission "CONTINUE";
			sleep 10; //Bypass spam
		};
	};
};

_debug = getMarkerPos "respawn_west";
_lastpos = getPosATL (vehicle player);
_lastheight = (ATLtoASL _lastpos) select 2;
_lasttime = time;

while {alive player} do
{
	//[-18697.58,379.53012,25815.256]
	if ([getMarkerPos "respawn_west", [0,0,0]] call BIS_fnc_areEqual  || !([getMarkerPos "respawn_west", _debug] call BIS_fnc_areEqual)) then {
		createMarkerLocal ["respawn_west", _debug];
		"respawn_west" setMarkerType "EMPTY";
	};
	
	_curpos = getPosATL (vehicle player);
	_curheight = (ATLtoASL _curpos) select 2;
	_curtime = time;
	_distance = _lastpos distance _curpos;
	_difftime = (_curtime - _lasttime) max 0.001;
	_speed = _distance / _difftime;
	_topSpeed = 10;
	
	if (vehicle player != player) then {
		_topSpeed = (getNumber (configFile >> "CfgVehicles" >> typeOf (vehicle player) >> "maxSpeed")) min 500;
	};
	
	_terrainHeight = getTerrainHeightASL [_curpos select 0, _curpos select 1];
	
	/*
	_differenceCheck = false;
	_lastPosVar = player getVariable ["lastPos", []];
	if (count _lastPosVar > 0) then {
		_differenceCheck = (_lastPosVar distance _lastpos) > _topSpeed;
	} else {
		diag_log "LASTPOS RESET";
	};
	*/

	if ((_speed > _topSpeed) && (alive player) && ((driver (vehicle player) == player) or (isNull (driver (vehicle player)))) && (_debug distance _lastpos > 3000) && !((vehicle player == player) && (_curheight < _lastheight) && ((_curheight - _terrainHeight) > 1))) then {
		(vehicle player) setpos _lastpos;
		atp = format["TELEPORT REVERT: %1 (%2) from %3 to %4 (%5 meters) now at %6", name player, dayz_characterID, _lastpos, _curPos, _lastpos distance _curpos, getPosATL player];
		publicVariableServer "atp";
	} else {
		_lastpos = _curpos;
		_lastheight = _curheight;		
	};
	
	_lasttime = _curtime;
	sleep 0.5;
};