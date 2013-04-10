private["_ent"];
_ent = _this select 3;
canAbort = true;

player removeAction s_player_igniteBox;
s_player_igniteBox = -1;

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
canAbort = false;