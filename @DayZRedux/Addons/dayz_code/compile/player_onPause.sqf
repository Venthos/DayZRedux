private["_display","_btnRespawn","_btnAbort","_timeOut","_timeMax","_isDead","_isInCombat"];
	disableSerialization;
		canAbort = false;
		waitUntil {
			_display = findDisplay 49;
			!isNull _display;
		};
		_btnRespawn = _display displayCtrl 1010;
		_btnAbort = _display displayCtrl 104;
		_btnRespawn ctrlEnable false;
		_btnAbort ctrlEnable false;
		_timeOut = 0;
		_timeMax = 30;
		
		dayz_lastCheckSave = time;
		_isInCombat = player getVariable["isincombat", 0];
		
		if(r_player_dead) exitWith {_btnAbort ctrlEnable true; canAbort = true;};
		
		if(r_fracture_legs) exitWith {_btnRespawn ctrlEnable true; 
			if (!((dayz_combatTimer > 0) || (player getVariable["combattimeout", 0] >= time) || (_isInCombat == 1))) then {
				_btnAbort ctrlEnable true; canAbort = true;
			};
		};
		
		//force gear save
		if (time - dayz_lastCheckSave > 10) then {
			call dayz_forceSave;
		};			
				
		while {!isNull _display} do {
			switch true do {
				case (canAbortForce) : {
					canAbort = true;
					_btnAbort ctrlEnable true;
					cutText ["", "PLAIN DOWN"];
				};
				case ((dayz_combatTimer > 0) || (player getVariable["combattimeout", 0] >= time) || (_isInCombat == 1)) : {
				canAbort = false;
				_btnAbort ctrlEnable false;
					cutText [localize "str_abort_playerincombat", "PLAIN DOWN"];
				};
				case ({isPlayer _x} count (player nearEntities ["AllVehicles", 6]) > 1) : {
					canAbort = false;
					_btnAbort ctrlEnable false;
					cutText [localize "str_abort_playerclose", "PLAIN DOWN"];
				};
				case (_timeOut < _timeMax && count (player nearEntities ["zZambie_Base", 25]) > 0) : {
					canAbort = false;
					_btnAbort ctrlEnable false;
					cutText [format ["Can Abort in %1", (_timeMax - _timeOut)], "PLAIN DOWN"];
				};
				default {
					_btnAbort ctrlEnable true;
					cutText ["", "PLAIN DOWN"];
					canAbort = true;
				};
			};
			sleep 1;
			_timeOut = _timeOut + 1;
		};
		cutText ["", "PLAIN DOWN"];