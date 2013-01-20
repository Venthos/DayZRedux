private["_hasDel","_serial","_object","_updates","_myGroup","_nearVeh"];
_playerID = _this select 0;
_playerName = _this select 1;
_object = call compile format["player%1",_playerID];
_characterID =	_object getVariable ["characterID","0"];
_isInCombat = _object getVariable ["isincombat",0];

if (vehicle _object != _object) then {
	_object action ["eject", vehicle _object];
};

[_object, (magazines _object), true] call server_playerSync;

_id = [_playerID,_characterID,2] spawn dayz_recordLogin;

if (_isInCombat > 0) then {
	diag_log ("COMBAT LOG START (i): " + _playerName + " (" + str(_playerID) + ") Object: " + str(_object) );

	dayz_combatLog = _playerName;
	publicVariable "dayz_combatLog";

	[_object,_playerID,_characterID] spawn cLog_playerMorph;
} else {
	diag_log ("DISCONNECT START (i): " + _playerName + " (" + str(_playerID) + ") Object: " + str(_object) );

	if (!isNull _object) then {
		_charPos = getPosATL _object;
		if (alive _object) then {
			[_charPos] call server_updateNearbyObjects;
			_myGroup = group _object;
			deleteVehicle _object;
			deleteGroup _myGroup;
		};
	};
};

