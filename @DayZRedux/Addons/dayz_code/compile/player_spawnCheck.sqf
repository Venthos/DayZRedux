private ["_type","_isAir","_inVehicle","_zombied","_dateNow","_maxZombies","_maxWildZombies","_age","_nearbyBuildings","_radius","_locationstypes","_nearestCity","_position","_nearbytype"];
_type = _this select 0;
_Keepspawning = _this select 1;
_isAir = vehicle player iskindof "Air";
_inVehicle = (vehicle player != player);
_dateNow = (DateToNumber date);
_maxZombies = dayz_maxLocalZombies;
_maxWildZombies = 5;
_age = -1;
_force = false;

_nearbyBuildings = [];
_radius = 250;
_position = getPosATL player;

if (_inVehicle) then {
	_maxZombies = 10;
};
if (_isAir) then {
	_maxZombies = 10;
};

_players = _position nearEntities ["CAManBase",_radius+200];
dayz_maxGlobalZombies = 40;
{
	if (isPlayer _x) then {
		dayz_maxGlobalZombies = dayz_maxGlobalZombies + 10;
	};
} foreach _players;

_spawnZombies = _position nearEntities ["zZambie_Base",_radius+100];
dayz_spawnZombies = 0;
{
	if (local _x) then 
	{
		//diag_log ("Local");
		dayz_spawnZombies = dayz_spawnZombies + 1;
	};
} foreach _spawnZombies;

dayz_CurrentZombies = count (_position nearEntities ["zZambie_Base",_radius+200]);

if ("ItemMap_Debug" in items player) then {
	deleteMarkerLocal "MaxZeds";
	deleteMarkerLocal "Counter";
	deleteMarkerLocal "Loot30";
	deleteMarkerLocal "Loot120";
	deleteMarkerLocal "Agro80";
	
	_markerstr = createMarkerLocal ["MaxZeds", _position];
	_markerstr setMarkerColorLocal "ColorYellow";
	_markerstr setMarkerShapeLocal "ELLIPSE";
	_markerstr setMarkerBrushLocal "Border";
	_markerstr setMarkerSizeLocal [_radius, _radius];

	_markerstr1 = createMarkerLocal ["Counter", _position];
	_markerstr1 setMarkerColorLocal "ColorRed";
	_markerstr1 setMarkerShapeLocal "ELLIPSE";
	_markerstr1 setMarkerBrushLocal "Border";
	_markerstr1 setMarkerSizeLocal [_radius+100, _radius+100];
	
	_markerstr2 = createMarkerLocal ["Agro80", _position];
	_markerstr2 setMarkerColorLocal "ColorRed";
	_markerstr2 setMarkerShapeLocal "ELLIPSE";
	_markerstr2 setMarkerBrushLocal "Border";
	_markerstr2 setMarkerSizeLocal [80, 80];

	_markerstr2 = createMarkerLocal ["Loot30", _position];
	_markerstr2 setMarkerColorLocal "ColorRed";
	_markerstr2 setMarkerShapeLocal "ELLIPSE";
	_markerstr2 setMarkerBrushLocal "Border";
	_markerstr2 setMarkerSizeLocal [30, 30];

	_markerstr3 = createMarkerLocal ["Loot120", _position];
	_markerstr3 setMarkerColorLocal "ColorBlue";
	_markerstr3 setMarkerShapeLocal "ELLIPSE";
	_markerstr3 setMarkerBrushLocal "Border";
	_markerstr3 setMarkerSizeLocal [120, 120];

diag_log ("SpawnWait: " +str(time - dayz_spawnWait));
diag_log ("LocalZombies: " +str(dayz_spawnZombies) + "/" +str(dayz_maxLocalZombies));
diag_log ("GlobalZombies: " +str(dayz_CurrentZombies) + "/" +str(dayz_maxGlobalZombies));
diag_log ("dayz_maxCurrentZeds: " +str(dayz_maxCurrentZeds) + "/" +str(dayz_maxZeds));

};
	
_nearby = _position nearObjects ["building",_radius];
_nearbyCount = count _nearby;

if (_nearbyCount < 1) exitwith 
{
//	if ((dayz_spawnZombies < _maxWildZombies) and !_inVehicle)  then {
//		[_position] call wild_spawnZombies;
//	};
};

//Make sure zeds always spawn no matter the timeout
if (dayz_spawnZombies == 0) then {
	_force = true;
};
{
	_type = typeOf _x;
	_config = 		configFile >> "CfgBuildingLoot" >> _type;
	_canLoot = 		isClass (_config);
	_dis = _x distance player;
	_checkLoot = ((count (getArray (_config >> "lootPos"))) > 0);
	//_canLoot = ((count (getArray (_config >> "lootPos"))) > 0);
	_x setVariable ["cleared",false,true];
		if (_canLoot) then {
			_keepAwayDist = ((sizeOf _type)+5);
			_isNoone =	{isPlayer _x} count (_x nearEntities ["CAManBase",_keepAwayDist]) == 0;

			if (_isNoone) then {
				_looted = (_x getVariable ["looted",-0.1]);
				_cleared = (_x getVariable ["cleared",true]);
				_dateNow = (DateToNumber date);
				_age = (_dateNow - _looted) * 525948;
			if (_age < -0.1) then {
					_x setVariable ["looted",(DateToNumber date),true];
			} else {
				if (_age > 9) then {
					_x setVariable ["looted",_dateNow,true];
					dayz_lootWait = time;
					_qty = _x call building_spawnLoot;
					//_currentWeaponHolders = _currentWeaponHolders + _qty;
					//_handle = [_x] spawn building_spawnLoot;
					//waitUntil{scriptDone _handle};
					};
				};
			};
		};
	//Zeds
	if ((((time - dayz_spawnWait) > dayz_spawnDelay) or _force)) then {
		if (dayz_CurrentZombies < dayz_maxGlobalZombies) then {
			if (dayz_spawnZombies < _maxZombies) then {
					//[_radius, _position, _inVehicle, _dateNow, _age, _locationstypes, _nearestCity, _maxZombies] call player_spawnzedCheck;
					_zombied = (_x getVariable ["zombieSpawn",-0.1]);
					_dateNow = (DateToNumber date);
					if (isNil "_zombied") then {_x setVariable ["zombieSpawn",_dateNow,true];}; //Lazy fix for possible errors
					_age = (_dateNow - _zombied) * 525948;
					if (_age > 3) then {
						_x setVariable ["zombieSpawn",_dateNow,true];
						_handle = [_x] spawn building_spawnZombies;
						waitUntil{scriptDone _handle};
					};
			} else {
				dayz_spawnWait = time;
			};
		};
	};
} forEach _nearby;