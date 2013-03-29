/***********************************************************
	PROCESS DAMAGE TO A UNIT
	- Function
	- [unit, selectionName, damage, source, projectile] call cLog_damageHandler;
************************************************************/
private["_unit","_hit","_damage","_unconscious","_source","_ammo","_type","_isMinor","_isHeadHit","_inVehicle","_isPlayer",
	"_humanityHit","_myKills","_characterID","_player_blood"];
_unit = _this select 0;
_hit = _this select 1;
_damage = _this select 2;
_unconscious = _unit getVariable ["NORRN_unconscious", false];
_source = _this select 3;
_ammo = _this select 4;
_type = [_damage,_ammo] call fnc_usec_damageType;
_isMinor = (_hit in USEC_MinorWounds);
_isHeadHit = (_hit == "head_hit");
_inVehicle = (vehicle _unit != _unit);
_isPlayer = (isPlayer _source);
_humanityHit = 0;
_myKills = 0;
_characterID = _unit getVariable["CharacterID","0"];
_player_blood = _unit getVariable["USEC_BloodQty",12000];

private["_strH","_dam","_total","_totalDmg"];
_strH = "hit_" + (_hit);
_dam = _unit getVariable [_strH,0];
if ( _dam > 1 ) then { _dam = 1 };
_total = _dam + _damage;
_unit setVariable [_strH,_total,true];

_totalDmg = 0;
{
	_strH = "hit_" + _x;
	_dam = _unit getVariable[_strH,0];
	_totalDmg = _totalDmg + _dam;
} forEach USEC_woundHit;

private["_scale"];
//PVP Damage
_scale = 200;
if (_total > 0) then {
	_scale = _scale + 50;
	if (_isHeadHit) then {
		_scale = _scale + 500;
	};
	switch (_type) do {
		case 1: {_scale = _scale + 200};
		case 2: {_scale = _scale + 200};
	};
	//Cause blood loss
	_player_blood = _player_blood - (_total * _scale);
};

//Record Damage to Minor parts (legs, arms)
if ( (_hit == "legs") && (_total == 1) ) then { _unit setVariable ["hit_legs",1,true]; };
if ( (_hit == "hands") && (_total == 1) ) then { _unit setVariable ["hit_hands",1,true]; };

if (_total > 0.1) then {
		_unit setVariable["medForceUpdate",true,true];
};

private["_wound","_isHit","_rndPain","_isInjured","_rndInfection","_rndPain","_hitPain","_inPain","_hitInfection"];
if (_type == 1) then {
	/*
		BALISTIC DAMAGE
	*/
	if (_totalDmg > 4) then {
		//serious ballistic damage
		//no message for this when study
		[_unit,_source,"explosion"] spawn cLog_playerDeath;
	};
};
if (_type == 2) then {
	/*
		HIGH CALIBRE
	*/
	if (_totalDmg > 4) then {
		//serious ballistic damage
		[_unit,_source,"shotheavy"] spawn cLog_playerDeath;
	}
};
if (_total > 0.4) then {	//0.25
	/*
		BLEEDING
	*/		
	_wound = _hit call fnc_usec_damageGetWound;
	_isHit = _unit getVariable[_wound,false];
	diag_log format["DEBUG: wound:%1 [%2]",_wound,_isHit];
	_rndPain = 		(random 10);
	_rndInfection = (random 1000);
	_hitPain = 		(_rndPain < _total);
	if (_isHeadHit or _hitPain) then {
		_hitPain = true;
	};
	_hitInfection = (_rndInfection < 1);
	if (_isHit) then {
		//Make hit worse
		_player_blood = _player_blood - 50;
	};
	if (_hitInfection) then {
		//Set Infection if not already
		_unit setVariable["USEC_infected",true,true];
		
	};
	if (_hitPain) then {
		//Set Pain if not already
 			_unit setVariable["USEC_inPain",true,true];
	};
	if ((_total > 1) and _isHeadHit) then {
		[_unit,_source,"shothead"] spawn cLog_playerDeath;
	};
};
private["_isInjured"];
if(!_isHit) then {
	//Create Wound
	diag_log format["DEBUG: spawn bleed %1",_wound];
	_unit setVariable[_wound,true,true];
	[_unit,_wound,_hit] spawn fnc_usec_damageBleed;
	usecBleed = [_unit,_wound,_hit];
	publicVariable "usecBleed";
	//Set Injured if not already
	_isInjured = _unit getVariable["USEC_injured",false];
	if (!_isInjured) then {
		_unit setVariable["USEC_injured",true,true];
	};
};

_unit setVariable["USEC_BloodQty",_player_blood,true];
if ( (_totalDmg >= 4) || (_player_blood <= 0) ) then {
	[_unit,_source,"bled"] spawn cLog_playerDeath;
};
