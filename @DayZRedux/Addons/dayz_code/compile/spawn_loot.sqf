private ["_iItem","_iClass","_iPos","_radius","_iPosZ","_item","_itemTypes","_qty","_max","_index","_weights","_cntWeights","_tQty","_canType","_mags","_magQty","_uniq"];

_iItem = 	_this select 0;
_iClass = 	_this select 1;
_iPos =	_this select 2;
_radius =	_this select 3;
_uniq = ["ItemWaterbottle", "ItemWaterbottleUnfilled"];

_iPosZ = _iPos select 2;
if ((isNil "_iPosZ") OR {( _iPosZ < 0)}) then { _iPos = [_iPos select 0,_iPos select 1,0]; };

switch (_iClass) do {
	default {
		//Item is food, add random quantity of cans along with an item (if exists)
		_item = createVehicle ["WeaponHolder", _iPos, [], _radius, "CAN_COLLIDE"];
		/*
		_itemTypes = [];
		{
			_itemTypes set [count _itemTypes, _x select 0]
		} foreach getArray (configFile >> "cfgLoot" >> _iClass);
		*/
		_arrayLootSpawn = [] + getArray (configFile >> "cfgLoot" >> _iClass);
		_itemTypes = _arrayLootSpawn select 0;
		_qty = 0;
		_max = ceil(random 2) + 1;
		while {_qty < _max} do {
			_index = dayz_CLBase find _iClass;
			_weights = dayz_CLChances select _index;
			_cntWeights = count _weights;
			_index = floor(random _cntWeights);
			_index = _weights select _index;
			_canType = _itemTypes select _index;
			_tQty = round(random 1) + 1;
			if (_canType in _uniq) then {
				_tQty = if (({_x in _uniq} count magazines _item) == 0) then {1} else {0};
				if (_tQty == 0) then {diag_log(format["%1 Prevent any duplicate member %2 from family %3",__FILE__, _canType, _uniq]);};
				//diag_log(format["%1 %2 DUP? type:%3 mag:%4 _this:%5",__FILE__, __LINE__, _canType, magazines _item, _this]);
			};
			if (_tQty > 0) then {
				_item addMagazineCargoGlobal [_canType,_tQty];
				_qty = _qty + _tQty;
			};
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
if ((count _iPos) > 2) then {
	_item setPosATL _iPos;
};