private["_serial","_positions","_lootGroup","_iArray","_iItem","_iClass","_iPos","_item","_mags","_qty","_max","_tQty","_canType","_obj","_type","_nearBy","_allItems","_items","_itemType","_itemChance","_lootChance","_weights","_index"];
_obj = 			_this select 0;
_fastRun = 		_this select 1;

_type = 		typeOf _obj;
_config = 		configFile >> "CfgBuildingLoot" >> _type;

_positions =	 [] + getArray (_config >> "lootPos");
//diag_log ("LOOTSPAWN: READ:" + str(_type));
_lootChance =	getNumber (_config >> "lootChance");
_itemType =		 [] + getArray (_config >> "itemType");
//diag_log ("LOOTSPAWN: READ:" + str(_itemType));
_itemChance =	 [] + getArray (_config >> "itemChance");	

//diag_log ("LOOTSPAWN: Type " + str(count _itemType) + " / Chance " + str(count _itemChance));

//diag_log ("I want to spawn loot at: " + str(_type));

{
	private["_iPos2"];
	_iPos2 = _obj modelToWorld _x;



	//Place something at each position
	//if (player distance _iPos2 > 5) then {
	//_nearByPlayer = ({isPlayer _x} count (_iPos2 nearEntities ["CAManBase",20])) > 0;
	//if (!_nearByPlayer) then {
		//diag_log("No players nearby");
		_rnd = random 1;
		if (_rnd < _lootChance) then {
		//if (true) then {
			//diag_log("Rolled to SPAWN");
			//_nearBy = nearestObjects [_iPos2, ["WeaponHolder","WeaponHolderBase"],1];
			// If we're told to spawn loot and there is none, spawn it
				_nearBy = _iPos2 nearObjects ["ReammoBox",1];
				{deleteVehicle _x} forEach _nearBy;

				//diag_log("No loot here, spawning!");
				private["_index","_iArray"];
				_weights = [_itemType,_itemChance] call fnc_buildWeightedArray;
				_index = _weights call BIS_fnc_selectRandom;
				//diag_log ("LOOTSPAWN: _itemType:" + str(_itemType));
				//diag_log ("LOOTSPAWN: _index:" + str(_index));
				if (_index >= 0) then {
					_iArray = +(_itemType select _index);
					//diag_log ("LOOTSPAWN: _iArray" + str(_iArray));
					_iArray set [2,_iPos2];
					_iArray set [3,0];
					_iArray set [4,_type];
					_handle = _iArray spawn spawn_loot;
					waitUntil{scriptDone _handle};
					_iArray = [];
				};
				//_item setVariable ["created",(DateToNumber date),true];

			if (!_fastRun) then {
				sleep 0.1;
			};
		} else {
			if (_rnd > 0.5) then {
				_nearBy = _iPos2 nearObjects ["ReammoBox",1];
				{deleteVehicle _x} forEach _nearBy;
			};
			//diag_log("Failed to roll loot");
		};
	//} else {
		//diag_log("Players near, bailing...");
	//};
} forEach _positions;