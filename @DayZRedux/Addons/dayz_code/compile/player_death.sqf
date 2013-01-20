private["_array","_source","_kills","_killsV","_humanity","_wait","_myKills"];
if (deathHandled) exitWith {};
deathHandled = true;
//Death

_body =		player;
_playerID =	getPlayerUID player;

//Send Death Notice
dayzDeath = [dayz_characterID,0,_body,_playerID,dayz_playerName];
publicVariableServer "dayzDeath";
if (isServer) then {
	_id = dayzDeath spawn server_playerDied; 
};

//Send Killer Information
dayzKiller = dayz_myKiller;
publicVariableServer "dayzKiller";

_id = [player,50,true,getPosATL player] spawn player_alertZombies;

sleep 0.5;

player setDamage 1;
0.1 fadeSound 0;

player setVariable ["NORRN_unconscious", false, true];
player setVariable ["unconsciousTime", 0, true];
player setVariable ["USEC_isCardiac",false,true];
player setVariable ["medForceUpdate",true,true];
r_player_unconscious = false;
r_player_cardiac = false;

_id = player spawn spawn_flies;

_humanity =		0;
_wait = 		0;

_array = _this;
if (count _array > 0) then {
	_source = _array select 0;
	_method = _array select 1;
	if (!isNull _source) then {
		if (_source != player) then {
			_canHitFree = 	player getVariable ["freeTarget",false];
			_isBandit = 	((typeOf player) == "B1_RX" or (typeOf player) == "B2_RX" or (typeOf player) == "BW1_RX");
			_myKills = 		((player getVariable ["humanKills",0]) / 30) * 1000;
			if (!_canHitFree and !_isBandit) then {
				//Process Morality Hit
				_humanity = -(2000 - _myKills);
				_kills = 		_source getVariable ["humanKills",0];
				_source setVariable ["humanKills",(_kills + 1),true];
				_wait = 300;
			} else {
				//Process Morality Hit
				//_humanity = _myKills * 100;
				_killsV = 		_source getVariable ["banditKills",0];
				_source setVariable ["banditKills",(_killsV + 1),true];
				_wait = 0;
			};
			if (_humanity < 0) then {
				_wait = 0;
			};
			if (!_canHitFree and !_isBandit) then {
				dayzHumanity = [_source,_humanity,_wait];
				publicVariable "dayzHumanity";
			};
		};
	};
	_body setVariable ["deathType",_method,true];
};

terminate dayz_musicH;
terminate dayz_lootCheck;
terminate dayz_slowCheck;
terminate dayz_animalCheck;
terminate dayz_monitor1;
terminate dayz_medicalH;
terminate dayz_gui;
//terminate dayz_vehicleCamCheck;

//Reset (just in case)
//deleteVehicle dayz_playerTrigger;
disableUserInput false;
r_player_dead = true;

"dynamicBlur" ppEffectEnable true;"dynamicBlur" ppEffectAdjust [4]; "dynamicBlur" ppEffectCommit 0.2;

"colorCorrections" ppEffectEnable true;
"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 0.01],  [1, 1, 1, 0.0]];
"colorCorrections" ppEffectCommit 1;

//Player is Dead!
3 fadeSound 0;
0 cutText ["", "BLACK",10];
dayz_DeathActioned = true;
sleep 1;

TitleText[localize "str_player_12","PLAIN DOWN",5];

dayz_originalPlayer enableSimulation true;

addSwitchableUnit dayz_originalPlayer;
setPlayable dayz_originalPlayer;
selectPlayer dayz_originalPlayer;

_myGroup = group _body;
[_body] joinSilent dayz_firstGroup;
deleteGroup _myGroup;

3 cutRsc ["default", "PLAIN",3];
4 cutRsc ["default", "PLAIN",3];

if (count _array > 0) then {
	_body setVariable ["deathType",_method,true];
};

_body setVariable["isincombat", 0, true];
dayz_combatTimer = 0;

/*
dayzFlies = player;
publicVariable "dayzFlies";
*/
sleep 1;


1 cutRsc ["DeathScreenBG","BLACK OUT",1];
2 cutRsc ["DeathScreen1","BLACK OUT",1];
sleep 0.1;
3 cutRsc ["DeathScreen2","BLACK OUT",1];
sleep 0.1;
4 cutRsc ["DeathScreen3","BLACK OUT",1];
sleep 0.1;
5 cutRsc ["DeathScreen4","BLACK OUT",1];
sleep 0.1;
6 cutRsc ["DeathScreen5","BLACK OUT",1];
sleep 0.1;
7 cutRsc ["DeathScreen6","BLACK OUT",1];
sleep 1;
8 cutRsc ["DeathScreen7","BLACK OUT",3];

playMusic "dayz_track_death_1";

"dynamicBlur" ppEffectAdjust [0]; "dynamicBlur" ppEffectCommit 5;
"colorCorrections" ppEffectAdjust [1, 1, 0, [1, 1, 1, 0.0], [1, 1, 1, 1],  [1, 1, 1, 1]];"colorCorrections" ppEffectCommit 5;