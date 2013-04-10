private["_vehicle","_qty"];

_vehicle = _this select 0;
_qty = _this select 1;

_vehicle setFuel _qty;