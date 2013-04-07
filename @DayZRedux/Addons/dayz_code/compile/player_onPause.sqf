private["_display","_btnRespawn","_btnAbort","_timeOut","_timeMax","_isDead","_isInCombat"];

disableSerialization;

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
		dayz_lastCheckBit = time;
		_isInCombat = player getVariable["isincombat", 0];
		
		if(r_player_dead) exitWith {_btnAbort ctrlEnable true;};
		if(r_fracture_legs) exitWith {_btnRespawn ctrlEnable true; _btnAbort ctrlEnable true;};
		
		//force gear save
		if (time - dayz_lastCheckBit > 10) then {
			call dayz_forceSave;
		};			
				
		while {!isNull _display} do {
			switch true do {
				case ({isPlayer _x} count (player nearEntities ["AllVehicles", 6]) > 1) : {
					_btnAbort ctrlEnable false;
					//cutText ["You cannot abort with other players nearby!", "PLAIN DOWN"];
					cutText [format[localize "str_abort_playerclose",_text], "PLAIN DOWN"];
				};
				case (_timeOut < _timeMax && count (player nearEntities ["zZambie_Base", 25]) > 0) : {
					_btnAbort ctrlEnable false;
					cutText [format ["Can Abort in %1", (_timeMax - _timeOut)], "PLAIN DOWN"];
					//cutText [format[localize "str_abort_zedsclose",_text, "PLAIN DOWN"];
				};
				case ((dayz_combatTimer > 0) || (player getVariable["combattimeout", 0] >= time) || (_isInCombat == 1)) : {
					_btnAbort ctrlEnable false;
					//cutText ["Cannot Abort while in combat!", "PLAIN DOWN"];
					cutText [format[localize "str_abort_playerincombat",_text], "PLAIN DOWN"];					
				};
				default {
					_btnAbort ctrlEnable true;
					cutText ["", "PLAIN DOWN"];				
				};
			};
			sleep 1.0;
			_timeOut = _timeOut + 1;
		};
		cutText ["", "PLAIN DOWN"];