private["_type","_isAir","_inVehicle","_dateNow","_maxZombies","_maxWildZombies","_age","_nearbyBuildings","_radius","_locationstypes","_nearestCity","_position","_nearbytype"];
_type = _this select 0;
_Keepspawning = _this select 1;
_isAir = vehicle player iskindof "Air";
_inVehicle = (vehicle player != player);
_dateNow = (DateToNumber date);
_maxZombies = dayz_maxLocalZombies;
_maxWildZombies = 3;
_age = -1;

_nearbyBuildings = [];
_radius = 250; 
_position = getPosATL player;

if (_inVehicle) then {
	_maxZombies = _maxZombies / 2;
};
if (_isAir) then {
	_maxZombies = 5
};


//diag_log ("Type: " +str(_type));


//diag_log("SPAWN CHECKING: Starting");
	//_locationstypes = ["NameCityCapital","NameCity","NameVillage"];
	//_nearestCity = nearestLocations [getPos player, _locationstypes, _radius/2];
	//_townname = text (_nearestCity select 0);	
	//_nearbytype = type (_nearestCity select 0);
/*
switch (_nearbytype) do {
	case "NameVillage": {
		//_radius = 250; 
		_maxZombies = 30;
	};
	case "NameCity": {
		//_radius = 300; 
		_maxZombies = 40;
	};
	case "NameCityCapital": {
		//_radius = 400; 
		_maxZombies = 40;
	};
};
*/

_players = _position nearEntities ["AllPlayers",_radius+200];
dayz_maxGlobalZombies = 40;
{
	dayz_maxGlobalZombies = dayz_maxGlobalZombies + 10;
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
	_tooManyZs = {alive _x} count (_position nearEntities ["zZambie_Base",200]) > dayz_maxLocalZombies;
if (_nearbyCount < 1) exitwith 
{
	if ((dayz_spawnZombies < _maxWildZombies) and !_inVehicle)  then {
		[_position] call wild_spawnZombies;
	};
};

{
	_type = typeOf _x;
	_config = 		configFile >> "CfgBuildingLoot" >> _type;
	_canLoot = 		isClass (_config);
	_dis = _x distance player;
	
	//Loot
	if ((_dis < 120) and (_dis > 30) and _canLoot and !_inVehicle) then {
		_looted = (_x getVariable ["looted",-0.1]);
		_cleared = (_x getVariable ["cleared",true]);
		_dateNow = (DateToNumber date);
		_age = (_dateNow - _looted) * 525948;
		//diag_log ("SPAWN LOOT: " + _type + " Building is " + str(_age) + " old" );
		if ((_age > 9) and (!_cleared)) then {
			_nearByObj = nearestObjects [(getPosATL _x), ["WeaponHolder","WeaponHolderBase"],((sizeOf _type)+5)];
			{deleteVehicle _x} forEach _nearByObj;
			_x setVariable ["cleared",true,true];
			_x setVariable ["looted",_dateNow,true];
		};
		if ((_age > 9) and (_cleared)) then {
			//Register
			_x setVariable ["looted",_dateNow,true];
			//cleanup
			_handle = [_x] spawn building_spawnLoot;
			waitUntil{scriptDone _handle};
		};
	};
	//Zeds
			if ((time - dayz_spawnWait) > dayz_spawnDelay and _dis < 200) then {
				if (dayz_spawnZombies < _maxZombies) then {
					if (!_tooManyZs) then {
						private["_zombied"];
						_zombied = (_x getVariable ["zombieSpawn",-0.1]);
						_dateNow = (DateToNumber date);
						_age = (_dateNow - _zombied) * 525948;
						if (_age > 2) then {
							_bPos = getPosATL _x;
							_zombiesNum = {alive _x} count (_bPos nearEntities ["zZambie_Base",(((sizeOf _type) * 2) + 10)]);
							if (_zombiesNum == 0) then {
								//Randomize Zombies
								_x setVariable ["zombieSpawn",_dateNow,true];
								_handle = [_x] spawn building_spawnZombies;
								waitUntil{scriptDone _handle};
							};
						};
					};
				} else {
					dayz_spawnWait = time;
				};
			};

} forEach _nearby;