private["_ent"];
_ent = _this select 3;
canAbortForce = true;

player removeAction s_player_igniteBoxNo;
s_player_igniteBoxNo = -1;
player removeAction s_player_igniteBoxYes;
s_player_igniteBoxYes = -1;
player removeAction s_player_igniteBoxSwitch;
s_player_igniteBoxSwitch = -1;

player playActionNow "Medic";
sleep 7;

_objectID 	= _ent getVariable["ObjectID","0"];
_objectUID	= _ent getVariable["ObjectUID","0"];

dayzFire = [_ent,5,time,false,true];
publicVariable "dayzFire";
_id = dayzFire spawn BIS_Effects_Burn;

_ent setDamage 2;

dayzDeleteObj = [_objectID,_objectUID];
publicVariableServer "dayzDeleteObj";
canAbortForce = false;