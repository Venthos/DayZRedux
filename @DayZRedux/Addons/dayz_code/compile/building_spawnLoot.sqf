private["_serial","_positions","_lootGroup","_iArray","_iItem","_iClass","_iPos","_item","_mags","_qty","_max","_tQty","_canType","_obj","_type","_nearBy","_allItems","_items","_itemType","_itemChance","_lootChance","_weights","_index"];

_obj = 			_this select 0;
_type = 		typeOf _obj;
_config = 		configFile >> "CfgBuildingLoot" >> _type;
_positions =	 [] + getArray (_config >> "lootPos");
_lootChance =	getNumber (_config >> "lootChance");
_itemType =		 [] + getArray (_config >> "itemType");
_itemChance =	 [] + getArray (_config >> "itemChance");	

{
	private["_iPos2"];
	_iPos2 = _obj modelToWorld _x;
	_rnd = random 1;
  
	//Place something at each position
		_nearBy = _iPos2 nearObjects ["ReammoBox",2];
		{deleteVehicle _x} forEach _nearBy;

		if (count _nearBy > 0) then {
			_lootChance = _lootChance + 0.05;
		};

		if (_rnd < _lootChance) then {

			private["_index","_iArray"];
			_weights = [_itemType,_itemChance] call fnc_buildWeightedArray;
			_index = _weights call BIS_fnc_selectRandom;
			if (_index >= 0) then {
				_iArray = +(_itemType select _index);
				_iArray set [2,_iPos2];
				_iArray set [3,0];
				_iArray set [4,_type];
				_iArray call spawn_loot;
				_iArray = [];
			};
			_obj setVariable ["created",(DateToNumber date),true];
		};
/* we don't need this, plus I don't feel like perfecting it..
  //add wait for player to leave
  _playerNear = ({isPlayer _x} count (player nearEntities ["AllVehicles", 10]) >= 1);
  if (_playerNear) then {
  _slowRun = true;
  hint "_slowRun was set to true";
  } else {
  _slowRun = false;
  };
  if (_slowRun) then {
    hint "wait started";
  waitUntil {!_playerNear};
	diag_log ("Wait: DONE!");	
  };
*/
} forEach _positions;