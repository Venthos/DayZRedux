private["_refObj","_size","_vel","_speed","_hunger","_thirst","_array","_unsaved","_timeOut","_result","_lastSave"];
disableSerialization;
_timeOut = 	0;
_messTimer = 0;
_lastSave = 0;
_lastTemp = dayz_temperatur;
_debug = getMarkerpos "respawn_west";
_isBandit = false;
_isHero = false;

player setVariable ["temperature",dayz_temperatur,true];

dayz_myLoad = (((count dayz_myBackpackMags) * 0.2) + (count dayz_myBackpackWpns)) +  (((count dayz_myMagazines) * 0.1) + (count dayz_myWeapons * 0.5));

	//player addMagazine "Hatchet_swing";
	//player addWeapon "MeleeHatchet";

while {true} do {
	//Initialize
	_refObj = 	vehicle player;
	_size = 	(sizeOf typeOf _refObj) * 0.6;
	_vel = 		velocity player;
	_speed = 	round((_vel distance [0,0,0]) * 3.5);
	_saveTime = (playersNumber west * 2) + 10;
		
	//reset position
	_randomSpot = true;
	_tempPos = getPosATL player;
	_distance = _debug distance _tempPos;
	if (_distance < 2000) then {
		_randomSpot = false;
	};	
	_distance = [0,0,0] distance _tempPos;
	if (_distance < 500) then {
		_randomSpot = false;
	};
	_distance = _mylastPos distance _tempPos;
	if (_distance > 400) then {
		_randomSpot = false;
	};
	
	if (_randomSpot) then {
		_mylastPos = _tempPos;
	};
	
	dayz_mylastPos = _mylastPos;
	dayz_areaAffect = _size;
	
	//CheckVehicle
	/*
	if (_refObj != player) then {
		_isSync =_refObj getVariable ["ObjectID",0] > 0;
		if (!_isSync) then {
			_veh allowDamage true;
			_veh setDamage 1;
			player setDamage 1;			
		};
	};
	*/
	
	if (_speed > 0.1) then {
		_timeOut = _timeOut + 1;
	};
	
	_humanity = player getVariable ["humanity",0];
	if (_timeOut > 150) then {
		_timeOut = 0;
		if (_humanity < 2500) then {
			_humanity = _humanity + 150;
			_humanity = _humanity min 2500;
			player setVariable ["humanity",_humanity,true];
		};
	};
	
	if (_humanity < -2000 and !_isBandit) then {
		_isBandit = true;
		_model = typeOf player;
		if (_model == "S2_RX" or _model == "S3_RX") then {
			[dayz_playerUID,dayz_characterID,"B1_RX"] spawn player_humanityMorph;
		};
		if (_model == "SW2_RX") then {
			[dayz_playerUID,dayz_characterID,"BW1_RX"] spawn player_humanityMorph;
		};
	};
	
	if (_humanity > 0 and _isBandit) then {
		_isBandit = false;
		_model = typeOf player;
		if (_model == "B1_RX") then {
			[dayz_playerUID,dayz_characterID,"S2_RX"] spawn player_humanityMorph;
		};
		if (_model == "BW1_RX") then {
			[dayz_playerUID,dayz_characterID,"SW2_RX"] spawn player_humanityMorph;
		};
	};
	
	if (_humanity > 5000 and !_isHero) then {
		_isBandit = false;
		_model = typeOf player;
		if (_model == "S2_RX") then {
			[dayz_playerUID,dayz_characterID,"S3_RX"] spawn player_humanityMorph;
		};
	};
	
	//Has infection?
	if (r_player_infected) then {
		[player,"cough",8,false] call dayz_zombieSpeak;
	};

	//Record Check
	_lastUpdate = 	time - dayZ_lastPlayerUpdate;
	if (_lastUpdate > 8) then {
		//POSITION?
		_distance = dayz_myPosition distance player;
		if (_distance > 10) then {
			//Player has moved
			dayz_myPosition = getPosATL player;
			player setVariable["posForceUpdate",true,true];
			dayz_unsaved = true;
			dayZ_lastPlayerUpdate = time;
		};
	};

	//Hunger
	_hunger = +((((r_player_bloodTotal - r_player_blood) / r_player_bloodTotal) * 5) + _speed + dayz_myLoad) * 3;
	if (time - dayz_panicCooldown < 120) then {
		_hunger = _hunger * 2;
	};
	dayz_hunger = dayz_hunger + (_hunger / 60);

	//Thirst
	_thirst = 2;
	if (_refObj == player) then {
		_thirst = (_speed + 4) * 3;
	};
	dayz_thirst = dayz_thirst + (_thirst / 60) * (dayz_temperatur / dayz_temperaturnormal);	//TeeChange Temperatur effects added Max Effects: -25% and + 16.6% waterloss

	//Temperatur
	2 call player_temp_calculation; //2 = sleep time of this loop		//TeeChange
	if ((_lastTemp - dayz_temperatur) > 0.75 or (_lastTemp - dayz_temperatur) < -0.75 ) then {
		player setVariable ["temperature",dayz_temperatur,true];
		_lastTemp = dayz_temperatur;
	};
	
	//can get nearby infection
	if (!r_player_infected) then {
		//					Infectionriskstart
		if (dayz_temperatur < ((80 / 100) * (dayz_temperaturnormal - dayz_temperaturmin) + dayz_temperaturmin)) then {	//TeeChange
			_listTalk = _mylastPos nearEntities ["CAManBase",8];
			{
				if (_x getVariable["USEC_infected",false]) then {
					_rnd = (random 1) * (((dayz_temperaturnormal - dayz_temperatur) * (100 /(dayz_temperaturnormal - dayz_temperaturmin)))/ 50);	//TeeChange
					if (_rnd < 0.1) then {
						_rnd = random 1;
						if (_rnd > 0.7) then {
							r_player_infected = true;
							player setVariable["USEC_infected",true];
						};
					};
				};
			} forEach _listTalk;
			if (dayz_temperatur < ((50 / 100) * (dayz_temperaturnormal - dayz_temperaturmin) + dayz_temperaturmin)) then {	//TeeChange
				_rnd = (random 1) * (((dayz_temperaturnormal - dayz_temperatur) * (100 /(dayz_temperaturnormal - dayz_temperaturmin)))/ 25);	//TeeChange
				if (_rnd < 0.05) then {
					_rnd = random 1;
					if (_rnd > 0.95) then {
						r_player_infected = true;
						player setVariable["USEC_infected",true];
					};
				};
			};
		};
	};

	//If has infection reduce blood cough and add shake
	if (r_player_infected) then {
		if !(player getVariable["USEC_infected",false]) then { 
			player setVariable["USEC_infected",true,true];  
		};
		
		_rnd = ceil (random 8);
		[player,"cough",_rnd,false,9] call dayz_zombieSpeak;
		
		if (_rnd < 3) then {
			addCamShake [2, 1, 25];
		};
		if (r_player_blood > 3000) then {
			r_player_blood = r_player_blood - 3;
			player setVariable["USEC_BloodQty",r_player_blood];
		};
	};
	
	//Pain Shake Effects
	if (r_player_inpain and !r_player_unconscious) then {
		playSound "breath_1";
		addCamShake [2, 1, 25];
	};
	
	//Hunger Effect
	_foodVal = 		dayz_statusArray select 0;
	_thirstVal = 	dayz_statusArray select 1;
	if (_thirstVal <= 0) then {
		_result = r_player_blood - 10;
		if (_result < 0) then {
			_id = [player,"dehyd"] spawn player_death;
		} else {
			r_player_blood = _result;
		};
	};
	if (_foodVal <= 0) then {
		_result = r_player_blood - 10;
		if (_result < 0) then {
			_id = [player,"starve"] spawn player_death;
		} else {
			r_player_blood = _result;
		};
	};
	
	//Record low bloow
	_lowBlood = player getVariable ["USEC_lowBlood", false];
	if ((r_player_blood < r_player_bloodTotal) and !_lowBlood) then {
		player setVariable["USEC_lowBlood",true,true];
	};
	
	//Broadcast Hunger/Thirst
	_messTimer = _messTimer + 1;
	if (_messTimer > 15) then {
		_messTimer = 0;
		player setVariable ["messing",[dayz_hunger,dayz_thirst],true];
	};

	//check if can disconnect
	if (!dayz_canDisconnect) then {
		if ((time - dayz_damageCounter) > 180) then {
			if (!r_player_unconscious) then {
				dayz_canDisconnect = true;
				//["dayzDiscoRem",getPlayerUID player] call callRpcProcedure;
				dayzDiscoRem = getPlayerUID player;
				publicVariable "dayzDiscoRem";
				
				//Ensure Control is hidden
				_display = uiNamespace getVariable 'DAYZ_GUI_display';
				_control = 	_display displayCtrl 1204;
				_control ctrlShow false;
			};
		};
	};

	//Save Checker
	if (dayz_unsaved) then {
		if ((time - dayz_lastSave) > _saveTime) then {
			dayzPlayerSave = [player,dayz_Magazines,false];
			publicVariableServer "dayzPlayerSave";
			if (isServer) then {
				dayzPlayerSave call server_playerSync;
			};
			dayz_lastSave = time;
			dayz_Magazines = [];
		};
		_lastSave = _lastSave + 2;
	} else {
		dayz_lastSave = time;
		_lastSave = 0;
	};

	if (!dayz_unsaved) then {
		dayz_lastSave = time;
	};

	//Attach Trigger Current Object
	//dayz_playerTrigger attachTo [_refObj,[0,0,0]];
	//dayz_playerTrigger setTriggerArea [_size,_size,0,false];

	// This is true if someone else set is into combat (projectile impact)
	_remoteCombatStart = player getVariable["startcombattimer", 0];
	if (_remoteCombatStart == 1) then {
		dayz_combatStart = true;
		diag_log("COMBAT: In combat from projectileNear");
	};

	// If in combat, display counter and restrict logout
	if (dayz_combatStart) then {
		dayz_combatStart = false;
		dayz_combatTimer = time + 45;
		dayz_combat = 1;

		_isInCombat = player getVariable["isincombat", 0];
		if (_isInCombat != 1) then {
			player setVariable["isincombat", 1, true];
		};
		if (_remoteCombatStart != 0) then {
			player setVariable["startcombattimer", 0, true];
		};
	};

	if (dayz_combatTimer > 0) then {
		_timeleft = dayz_combatTimer - time;

		if (_timeleft > 0) then {
			//hintSilent format["In Combat: %1",round(_timeleft)];
		} else {
			//hintSilent "Not in Combat";
			dayz_combatTimer = 0;
			dayz_combat = 0;
			_combatdisplay = uiNamespace getVariable 'DAYZ_GUI_display';
			_combatcontrol = 	_combatdisplay displayCtrl 1307;
			_combatcontrol ctrlShow true;
			player setVariable["isincombat", 0, true];
		};
	} else {
		//hintSilent "Not in Combat";
		dayz_combat = 0;
		_combatdisplay = uiNamespace getVariable 'DAYZ_GUI_display';
		_combatcontrol = 	_combatdisplay displayCtrl 1307;
		_combatcontrol ctrlShow true;
		_isInCombat = player getVariable["isincombat", 0];
		if (_isInCombat != 0) then {
			player setVariable["isincombat", 0, true];
		};
	};

	// Tmp Debug
	//_zombies = 	{alive _x} count entities "zZombie_Base";
	//hintSilent format["Zoms: %1",_zombies];

	// Loot Placement Helper (only enable for debug)
	/*
	_vehicle = vehicle player;
	_inVehicle = (_vehicle != player);
	if (!isNull cursorTarget and !_inVehicle and (player distance cursorTarget < 40)) then {
		_lootPile = cursorTarget;
		_lootPos = getPosATL _lootPile;
		_plyrPos = getPosATL player;
		_nearObject = nearestObject [_plyrPos, "HouseBase"];
		_modelPos = _nearObject worldToModel _lootPos;

		hintSilent format["LOOT HELPER:\n\nTargeted: %1\nWithin Object: %2\nUse Loot Coord: %3", typeOf _lootPile, typeOf _nearObject, str(_modelPos)];
	} else {
		hintSilent format["LOOT HELPER:\n\nAim at a loot pile to get its position\nThe loot pile coords given are relative to the building/object YOU are personally closest to."];
	};
	*/

	// Nearest Object
	//_nearestZam = nearestObject [player, "zZombie_Base"];
	//_zamDistance = player distance _nearestZam;
	//_intersecting = {_x isKindOf "All"} count lineIntersectsWith [(eyePos player), (eyePos _nearestZam)] > 0;
	//hintSilent format["INTERSECTION BETWEEN: %1\n\nCantSee: %2\nDistance: %3", typeOf(_nearestZam), str(_intersecting), _zamDistance];

	/*
	setGroupIconsVisible [false,false];
	clearGroupIcons group player;
	*/
	"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, (r_player_blood/r_player_bloodTotal)],  [1, 1, 1, 0.0]];
	"colorCorrections" ppEffectCommit 0;
	sleep 2;
	
	_myPos = player getVariable["lastPos",[]];
	if (count _myPos > 0) then {
		player setVariable["lastPos",_mylastPos, true];
		player setVariable["lastPos",[]];
	};
	
	_lastPos = getPosATL player;	
	if (player == vehicle player) then {
		if (_mylastPos distance _lastPos > 200) then {
			if (alive player) then {
				player setPosATL _mylastPos;
			};
		};
	} else {
		if (_mylastPos distance _lastPos > 800) then {
			if (alive player) then {
				player setPosATL _mylastPos;
			};
		};
	};
	//Hatchet ammo fix	
	//"MeleeHatchet" call dayz_meleeMagazineCheck;
	
	//Crowbar ammo fix	
	//"MeleeCrowbar" call dayz_meleeMagazineCheck;
};