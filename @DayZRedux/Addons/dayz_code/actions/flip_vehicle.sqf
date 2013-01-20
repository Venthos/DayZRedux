private["_obj","_bag","_pos"];
_veh = _this select 3;

player playActionNow "Medic";
[player,"repair",0,false] call dayz_zombieSpeak;
sleep 6;

// If the player isn't invulnerable, then "teleporting" the vehicle right side up
// will instantly and severely damage the flipper.
player allowDamage false;
_veh setpos [getpos _veh select 0, getpos _veh select 1, 0];
// _veh setvectorup [0,0,1];

_text = getText (configFile >> "CfgVehicles" >> typeOf _veh >> "displayName");
cutText [format[(localize  "str_player_flippedveh"),_text], "PLAIN DOWN"];

sleep 2;
player allowDamage true;