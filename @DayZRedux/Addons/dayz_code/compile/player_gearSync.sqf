private ["_objects"];

_objects = nearestObjects [getPosATL player, ["Car", "Helicopter", "Motorcycle", "Ship", "Land_Cont_RX", "Land_Cont2_RX", "Land_Mag_RX"], 10];
{
	if ((_x isKindOf "Land_Cont_RX") or (_x isKindOf "Land_Cont2_RX") or (_x isKindOf "Land_Mag_RX")) then {
		dayzUpdateVehicle = [_x,"gear"];
	} else {
		dayzUpdateVehicle = [_x,"all"];
	};
	//["dayzUpdateVehicle",[_x,"gear"]] call callRpcProcedure;
	//dayzUpdateVehicle = [_x,"gear"];
	publicVariable "dayzUpdateVehicle";
	
} foreach _objects;

private["_dialog","_magazineArray","_control","_item","_val","_max"];

disableSerialization;
_dialog = 			_this select 0;
_magazineArray = 	[];

//Primary Mags
for "_i" from 109 to 120 do 
{
	_control = 	_dialog displayCtrl _i;
	_item = 	gearSlotData _control;
	_val =		gearSlotAmmoCount _control;
	_max = 		getNumber (configFile >> "CfgMagazines" >> _item >> "count");
	if (_item != "") then {
		if (_item == "BoltSteel") then { _item = "WoodenArrow" };
		if (_val != _max) then {
			_magazineArray set [count _magazineArray,[_item,_val]];
		} else {
			_magazineArray set [count _magazineArray,_item];
		};
	};
};

//Secondary Mags
for "_i" from 122 to 129 do 
{
	_control = 	_dialog displayCtrl _i;
	_item = 	gearSlotData _control;
	_val =		gearSlotAmmoCount _control;
	_max = 		getNumber (configFile >> "CfgMagazines" >> _item >> "count");
	if (_item != "") then {
		if (_val != _max) then {
			_magazineArray set [count _magazineArray,[_item,_val]];
		} else {
			_magazineArray set [count _magazineArray,_item];
		};
	};
};
dayz_unsaved = true;
dayz_Magazines = _magazineArray;	