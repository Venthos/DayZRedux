private["_hasChloroform","_item","_text","_body","_name"];
_body = 	_this select 3;

_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
if (_onLadder) exitWith {cutText [(localize "str_player_21") , "PLAIN DOWN"]};

_item = "ItemChloroform";

_config =	configFile >> "CfgMagazines" >> _item;
_text = 	getText (_config >> "displayName");

_hasChloroform = _item in magazines player;

if (!_hasChloroform) exitWith {cutText [format[(localize "str_player_31"),_text,"use it"] , "PLAIN DOWN"]};

dayz_chloroform = [_body,3.5];
publicVariable "dayz_chloroform";

player playActionNow "PutDown";
player removeMagazine _item;
sleep 1;