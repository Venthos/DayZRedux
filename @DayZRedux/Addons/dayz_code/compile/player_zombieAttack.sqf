private["_unit","_targets","_move","_openVehicles","_damage","_wound","_index","_cnt","_sound","_local","_dir","_hpList","_hp","_strH","_dam","_total","_vehicle","_tPos","_zPos","_cantSee","_inAngle"];
_unit = _this select 0;
_type = _this select 1;
_vehicle = (vehicle player);

_targets = _unit getVariable ["targets",[]];
//if (!(_vehicle in _targets)) exitWith {};

//Do the attack
if (r_player_unconscious && _vehicle == player && _type == "zombie") then {
	_rnd = round(random 4) + 1;
	_move = "ZombieFeed" + str(_rnd);
} else {
	if (_type == "zombie") then {
		_rnd = round(random 9) + 1;
		_move = "ZombieStandingAttack" + str(_rnd);
	} else {
		_move = "Dog_Attack";
	};
};
_dir = [_unit,player] call BIS_Fnc_dirTo;
_unit setDir _dir;
_unit playMove _move;

//Wait
sleep 0.3;

if (_vehicle != player) then {
	_hpList = 	_vehicle call vehicle_getHitpoints;
	_hp = 		_hpList call BIS_fnc_selectRandom;
	_wound = 	getText(configFile >> "cfgVehicles" >> (typeOf _vehicle) >> "HitPoints" >> _hp >> "name");
	_damage = 	random 0.08;
	_chance =	round(random 12);
  
if (_vehicle isKindOf "Helicopter") exitWith {};
//Remove getting hit in helicopters since the zombies stand at the edge of the blades, not at the body
	       
	if ((_chance % 4) == 0) then {
		_openVehicles = ["ATV_Base_EP1", "Motorcycle", "Bicycle"];
		{
			if (_vehicle isKindOf _x) exitWith {
				player action ["eject", _vehicle];
			};
		} forEach _openVehicles;
	};
  
  //Remove vehicles that are moving faster than 10KPH
  if (!(_vehicle isKindOf _x)) then {
  _lastpos = getPosATL (vehicle player);
  _lasttime = time;
  _curpos = getPosATL (vehicle player);
	_curtime = time;
	_distance = _lastpos distance _curpos;
	_difftime = (_curtime - _lasttime) max 0.001;
	_speed = _distance / _difftime;
	_threshold = 10;
      if (_speed > _threshold) exitWith {};
		} forEach _openVehicles;

	if ((_wound == "Glass1") or (_wound == "Glass2") or (_wound == "Glass3") or (_wound == "Glass4") or (_wound == "Glass5") or (_wound == "Glass6")) then {
		[_unit,"hit",4,false] call dayz_zombieSpeak;
		_strH = "hit_" + (_wound);
		_dam = _vehicle getVariable [_strH,0];
		_total = (_dam + _damage);

		//diag_log ("Hitpoints " +str(_wound) +str(_total));

		//["dayzHitV",[_vehicle, _wound,_total, _unit,"zombie"]] call broadcastRpcCallAll;
		if (_total >= 1) then {
			if (r_player_blood < (r_player_bloodTotal * 0.8)) then {
				_cnt = count (DAYZ_woundHit select 1);
				_index = floor (random _cnt);
				_index = (DAYZ_woundHit select 1) select _index;
				_wound = (DAYZ_woundHit select 0) select _index; 
			} else {
				_cnt = count (DAYZ_woundHit_ok select 1);
				_index = floor (random _cnt);
				_index = (DAYZ_woundHit_ok select 1) select _index;
				_wound = (DAYZ_woundHit_ok select 0) select _index; 
			};
			_damage = 0.1 + random (1.2);
			//diag_log ("START DAM: Player Hit on " + _wound + " for " + str(_damage));
			[player, _wound, _damage, _unit,"zombie"] call fnc_usec_damageHandler;
			//dayzHit =	[player,_wound, _damage, _unit,"zombie"];
			//publicVariable "dayzHit";
			[_unit,"hit",2,false] call dayz_zombieSpeak;	
		} else {
			//["dayzHitV",[_vehicle, _wound, _total, _unit,"zombie"]] call broadcastRpcCallAll;
			dayzHitV =	[_vehicle, _wound, _total, _unit,"zombie"];
			publicVariable "dayzHitV";
		};
	};
} else {
	//Did he hit?
	//_currentAnim = animationState _unit;
	//diag_log ("Animation state: " +(_currentAnim));
	//"amovpercmstpsnonwnondnon",
	_attackanimations = ["zombiestandingattack1","zombiestandingattack2","zombiestandingattack3","zombiestandingattack4","zombiestandingattack5","zombiestandingattack6","zombiestandingattack7","zombiestandingattack8","zombiestandingattack9","zombiestandingattack10","zombiefeed1","zombiefeed2","zombiefeed3","zombiefeed4","zombiefeed5"];
	if (((_unit distance player) <= 3) and ((animationState _unit) in _attackanimations)) then {
		//check LOS
		private[];
		_tPos = (getPosASL _vehicle);
		_zPos = (getPosASL _unit);
		_inAngle = [_zPos,(getdir _unit),50,_tPos] call fnc_inAngleSector;
		if (_inAngle) then {
			//LOS check
			_cantSee = [_unit,_vehicle] call dayz_losCheck;
			if (!_cantSee) then {
				if (r_player_blood < (r_player_bloodTotal * 0.8)) then {
					_cnt = count (DAYZ_woundHit select 1);
					_index = floor (random _cnt);
					_index = (DAYZ_woundHit select 1) select _index;
					_wound = (DAYZ_woundHit select 0) select _index; 
				} else {
					_cnt = count (DAYZ_woundHit_ok select 1);
					_index = floor (random _cnt);
					_index = (DAYZ_woundHit_ok select 1) select _index;
					_wound = (DAYZ_woundHit_ok select 0) select _index; 
				};
				_damage = 0.1 + random (1.2);
					
				//diag_log ("START DAM: Player Hit on " + _wound + " for " + str(_damage));
				[player, _wound, _damage, _unit,"zombie"] call fnc_usec_damageHandler;
				//dayzHit =	[player,_wound, _damage, _unit,"zombie"];
				//publicVariable "dayzHit";
				[_unit,"hit",2,false] call dayz_zombieSpeak;
			} else {
				/*
				_isZombieInside = [_unit,_building] call fnc_isInsideBuilding;
				if (_isPlayerInside) then {
					_damage = 0.1 + random (1.2);
					//diag_log ("START DAM: Player Hit on " + _wound + " for " + str(_damage));
					[player, _wound, _damage, _unit,"zombie"] call fnc_usec_damageHandler;
					//dayzHit =	[player,_wound, _damage, _unit,"zombie"];
					//publicVariable "dayzHit";
					[_unit,"hit",2,false] call dayz_zombieSpeak;	
				};
				*/
			};
		};
	};
};