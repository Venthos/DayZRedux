private["_itemType","_iPos","_indexLootSpawn","_iArray","_iItem","_iClass","_item","_qty","_max","_tQty","_arrayLootSpawn","_canType"];
// [_itemType,_weights]
_iItem = 	_this select 0;
_iClass = 	_this select 1;
_iPos =		_this select 2;
_radius =	_this select 3;
_type   =	_this select 4;

_iPosZ = _iPos select 2;
if( _iPosZ < 0 ) then { _iPos = [_iPos select 0,_iPos select 1,0]; };

switch (_iClass) do {
	default {
		//Item is food, add random quantity of cans along with an item (if exists)
		_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
		_arrayLootSpawn = [] + getArray (configFile >> "cfgLoot" >> _iClass);
		_itemType = _arrayLootSpawn select 0;
		_weights = _arrayLootSpawn call fnc_buildWeightedArray;
		_qty = 0;
		_max = ceil(random 2) + 1;
		//diag_log ("LOOTSPAWN: QTY: " + str(_max) + " ARRAY: " + str(_arrayLootSpawn));
		while {_qty < _max} do {
			private["_tQty","_indexLootSpawn","_canType"];
			_tQty = floor(random 1) + 1;
			//diag_log ("LOOTSPAWN: ITEM QTY: " + str(_tQty));
			
			_indexLootSpawn = _weights call BIS_fnc_selectRandom;
			_canType = _itemType select _indexLootSpawn;
			
			//diag_log ("LOOTSPAWN: ITEM: " + str(_canType));
			_item addMagazineCargoGlobal [_canType,_tQty];
			_qty = _qty + _tQty;
		};
		if (_iItem != "") then {
			_conf = configFile >> "cfgWeapons" >> _iItem;
			if (isClass _conf) then {
				_item addWeaponCargoGlobal [_iItem,1];
			} else {
				_item addMagazineCargoGlobal [_iItem,1];
			};
		};
	};
	case "weapon": {
		//Item is a weapon, add it and a random quantity of magazines
		_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
		_item addWeaponCargoGlobal [_iItem,1];
		_mags = [] + getArray (configFile >> "cfgWeapons" >> _iItem >> "magazines");
		if (count _mags > 0) then {
			if (_type == "CrashSiteLoot") then {
				_item addMagazineCargoGlobal [(_mags select 0),(round(random 1) + 2)];
			} else {
			if (_mags select 0 == "Quiver") then { _mags set [0, "WoodenArrow"] }; // Prevent spawning a Quiver
				_item addMagazineCargoGlobal [(_mags select 0),(round(random 2) + 1)];
			};
		};
	};
	case "magazine": {
		//Item is one magazine
		_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
		_item addMagazineCargoGlobal [_iItem,1];
	};
	case "object": {
		//Item is one magazine
		_item = createVehicle [_iItem, _iPos, [], _radius, "CAN_COLLIDE"];
	};
};

//diag_log(format["Spawned: %1 (%2) - %3 ",_iItem,_iClass,_type]);
_dateNow = (DateToNumber date);
_item setVariable ["looted",_dateNow,true];

if ((count _iPos) > 2) then {
	_item setPosATL _ipos;
};