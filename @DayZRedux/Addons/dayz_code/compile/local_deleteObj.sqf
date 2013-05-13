private ["_id","_uid","_key"];
_id 	= _this select 0;
_uid 	= _this select 1;

if (isServer) then {
//remove from database
	_idType = typeName _id;
	if (_idType == "STRING") then {
		_id = parseNumber _id;
	};

	if (_id > 0) then {
		//Send request by ID
		_key = format["CHILD:304:%1:",_id];
		_key call server_hiveWrite;
		diag_log format["DELETE: Deleted by ID: %1",_id];
	} else  {
		//Send request by UID
		_key = format["CHILD:310:%1:",_uid];
		_key call server_hiveWrite;
		diag_log format["DELETE: Deleted by UID: %1",_uid];
	};
};