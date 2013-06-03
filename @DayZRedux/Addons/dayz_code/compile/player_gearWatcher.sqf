private ["_dialog","_staticName","_ctrlGearOfUnit","_ctrlAvailItems","_numItems","_object"];

// There doesn't seem to be a way to determine what object's gear you're
// accessing through the Gear UI display.  This is likely something only
// held onto by the engine.  Therefore, we have to make a wild guess
// that the last known cursorTarget is the vehicle in question.

_object = cursorTarget;

disableSerialization;

_dialog = 	_this select 0;

_ctrlGearOfUnit = _display displayCtrl 1101;
_ctrlAvailItems = _display displayCtrl 105;

_staticName = "Gear of unit:";

private ["_curWep","_maxWep","_curMag","_maxMag","_curPck","_maxPck"];

_curWep = count (getWeaponCargo _object);
_curMag = count (getMagazineCargo _object);
_curPck = count (getBackpackCargo _object);

_maxWep = getNumber(configfile >> "cfgVehicles" >> typeOf(_object) >> "transportMaxWeapons");
_maxMag = getNumber(configfile >> "cfgVehicles" >> typeOf(_object) >> "transportMaxMagazines");
_maxPck = getNumber(configfile >> "cfgVehicles" >> typeOf(_object) >> "transportMaxBackpacks");

ctrlSetText _ctrlGearOfUnit format["%1 %2/%3 %4/%5 %6/%7", _staticName, _curWep, _maxWep, _curMag, _maxMag, _curPack, _maxPck];

/*
// This was the original goal until it seemed impossible to determine
// the "max" of each item, since we have no way to find out what object
// we're accessing (and therefores its limits).
_numItems = (lnbSize _ctrlAvailItems) select 0;  

private ["_curWep","_curMag","_curVeh"];
_curWep = 0;
_curMag = 0;
_curVeh = 0;

for "_i" from 0 to (_numItems - 1) do {
	private ["_itemType"];
	_item = lnbData [_ctrlAvailItems,[_i,1]];
	

	if (str(configfile >> "cfgWeapons" >> _item) != "") {
		_curWep = _curWep + 1;
	} else {
		if (str(configfile >> "cfgMagazines" >> _item) != "") {
			_curMag = _curMag + 1;
		} else {
			// cfgVehicles
			_curVeh = _curVeh + 1;
		};
	};
		

};

_itemSlot = {
  private ["_item", "_return"];
  _item = _this select 0;
  _return = 0;
  if ([_item] call _isWeapon) then {
  //_return = getNumber(configfile >> "cfgMagazines" >> _item >> "type");
    _return = getNumber(configfile >> "cfgWeapons" >> _item >> "type");
  };
  if ([_item] call _isMagazine) then {
  //_return = getNumber(configfile >> "cfgWeapons" >> _item >> "type");
    _return = getNumber(configfile >> "cfgMagazines" >> _item >> "type");
  };  
_return;
};
*/