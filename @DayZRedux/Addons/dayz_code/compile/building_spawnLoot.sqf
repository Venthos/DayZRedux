private ["_obj", "_type", "_config", "_positions", "_itemTypes", "_lootChance", "_countPositions", "_rnd", "_iPos", "_nearBy", "_index", "_weights", "_cntWeights", "_itemType"];

_obj = _this;_type = typeOf _obj;
_config = configFile >> "CfgBuildingLoot" >> _type;
_positions = [] + getArray (_config >> "lootPos");
_itemTypes = [] + getArray (_config >> "itemType");
_lootChance = getNumber (_config >> "lootChance");
_countPositions = count _positions;
//_qty = 0; // effective quantity of spawned weaponholder 

{
	//if (count _x == 3) then {
		_rnd = random 1;
		_iPos = _obj modelToWorld _x;
		_nearBy = _iPos nearObjects ["ReammoBox",2];
		{deleteVehicle _x} forEach _nearBy;

        if (count _nearBy > 0) then {
          _lootChance = _lootChance + 0.05;
		};

		if (_rnd <= _lootChance) then {
			//if (count _nearBy == 0) then {
				_index = dayz_CBLBase find _type;
				_weights = dayz_CBLChances select _index;
				_cntWeights = count _weights;
				_index = floor(random _cntWeights);
				_index = _weights select _index;
				_itemType = _itemTypes select _index;
				[_itemType select 0, _itemType select 1 , _iPos, 0.0] call spawn_loot;
				//_qty = _qty +1;
			//};
			_obj setVariable ["created",(DateToNumber date),true];
		};
		sleep ((random 3) / 1000);
	//};
} forEach _positions;

//_qty
