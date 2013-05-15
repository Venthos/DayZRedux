private ["_obj", "_type", "_config", "_positions", "_itemTypes", "_lootChance", "_countPositions", "_rnd", "_iPos", "_nearBy", "_index", "_weights", "_cntWeights", "_itemType", "_qty"];

_obj = _this select 0;
_type = typeOf _obj;
_config = configFile >> "CfgBuildingLoot" >> _type;
_positions = [] + getArray (_config >> "lootPos");
_itemTypes = [] + getArray (_config >> "itemType");
_lootChance = getNumber (_config >> "lootChance");
_countPositions = count _positions;
_qty = 0; // effective quantity of spawned weaponholder 

{
	if (count _x == 3) then {
		_rnd = random 1;
		_iPos = _obj modelToWorld _x;
		_nearBy = nearestObjects [_iPos, ["ReammoBox"], 2];
        if (count _nearBy > 0) then {
          _lootChance = _lootChance + 0.05;
		    };
		if (_rnd <= _lootChance) then {
			if (count _nearBy == 0) then {
				_index = dayz_CBLBase find _type;
				_weights = dayz_CBLChances select _index;
				_cntWeights = count _weights;
				_index = floor(random _cntWeights);
				_index = _weights select _index;
				_itemType = _itemTypes select _index;
				[_itemType select 0, _itemType select 1 , _iPos, 0.0] call spawn_loot;
				_qty = _qty +1;
			};
		};
		sleep ((random 3) / 1000);
	}; /* else {
		diag_log(format["%1 Illegal loot position #%3 from %2 in building %4 -- skipped", __FILE__, configName _config, _forEachIndex+1, typeOf _obj]);
	};*/
} forEach _positions;

_qty
