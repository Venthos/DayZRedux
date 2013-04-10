// Remove Parts from Vehicles - By SilverShot.

private["_vehicle","_part","_hitpoint","_type","_selection","_array"];
_id = _this select 2;
_array = 	_this select 3;
_vehicle = 	_array select 0;
_part =		_array select 1;
_hitpoint = _array select 2;
_type = typeOf _vehicle;

_hasToolbox = 	"ItemToolbox" in items player;

_nameType = 		getText(configFile >> "cfgVehicles" >> _type >> "displayName");
_namePart = 		getText(configFile >> "cfgMagazines" >> _part >> "displayName");

if (_hasToolbox) then {
    if (getDammage _vehicle < 2) then {

        _damage = [_vehicle,_hitpoint] call object_getHit;

        if( _damage < 0.20 ) then {
            _result = [player,_part] call BIS_fnc_invAdd;
            if (_result) then {

                {silver_myCursorTarget removeAction _x} forEach s_player_removeActions;
                s_player_removeActions = [];
                silver_myCursorTarget = objNull;

                _selection = getText(configFile >> "cfgVehicles" >> _type >> "HitPoints" >> _hitpoint >> "name");
                if( _hitpoint == "HitEngine" or _hitpoint == "HitFuel" ) then {
                    dayzSetFix = [_vehicle,_selection,0.89];
                } else {
                    dayzSetFix = [_vehicle,_selection,1];
                };
				
                if (local _vehicle) then {
                    dayzSetFix call object_setFixServer;
                }else{
                    publicVariable "dayzSetFix";
                };

                player playActionNow "Medic";
                sleep 1;

                [player,"repair",0,false] call dayz_zombieSpeak;
                null = [player,10,true,(getPosATL player)] spawn player_alertZombies;
                sleep 5;
                _vehicle setvelocity [0,0,1];

                cutText [format["You have successfully taken %1 from the %2",_namePart,_nameType], "PLAIN DOWN"];
            } else {
                cutText [localize "str_player_24", "PLAIN DOWN"];
            };
        } else {
            cutText [format["Cannot remove %1 from %2, the part has been damaged.",_namePart,_nameType], "PLAIN DOWN"];
        };
    } else {
        {silver_myCursorTarget removeAction _x} forEach s_player_removeActions;
        s_player_removeActions = [];
        silver_myCursorTarget = objNull;
    };
};

if( silver_myCursorTarget != objNull ) then {
    {silver_myCursorTarget removeAction _x} forEach s_player_removeActions;
    s_player_removeActions = [];
    silver_myCursorTarget = objNull;
};