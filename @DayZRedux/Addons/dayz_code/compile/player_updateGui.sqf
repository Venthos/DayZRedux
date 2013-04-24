private["_debug","_charPos","_nearDebug","_nearSpawnPos","_gycolorS","_gycolorB","_gxcolorS","_gxcolorB","_ycolorS","_ycolorB","_xcolorS","_xcolorB","_xCoord","_yCoord","_display","_ctrlBlood","_bloodVal","_ctrlFood","_ctrlThirst","_foodVal","_ctrlTemp","_tempVal","_combatVal","_array"];
disableSerialization;

_foodVal = 		1 - (dayz_hunger / SleepFood);
_thirstVal = 	1 - (dayz_thirst / SleepWater);
//_tempVal 	= 	(dayz_temperatur / dayz_temperaturnormal);	//TeeChange
_tempVal 	= 	1 - ((dayz_temperatur - dayz_temperaturmin)/(dayz_temperaturmax - dayz_temperaturmin));	// Normalise to [0,1]
_combatVal =	1 - dayz_combat; // May change later to be a range of red/green to loosely indicate 'time left in combat'

if (uiNamespace getVariable ['DZ_displayUI', 0] == 1) exitWith {
	_array = [_foodVal,_thirstVal];
	_array
};

_display = uiNamespace getVariable 'DAYZ_GUI_display';

_ctrlBlood = 	_display displayCtrl 1300;
_ctrlBleed = 	_display displayCtrl 1303;
_bloodVal =		r_player_blood / r_player_bloodTotal;
_ctrlFood = 	_display displayCtrl 1301;
_ctrlThirst = 	_display displayCtrl 1302;
_ctrlTemp 	= 	_display displayCtrl 1306;					//TeeChange
//_ctrlEar = 		_display displayCtrl 1304;
//_ctrlEye = 		_display displayCtrl 1305;
//_ctrlHumanity = _display displayCtrl 1207;
_ctrlCombat = _display displayCtrl 1307;
_ctrlFracture = 	_display displayCtrl 1203;
_ctrlInfection = 	_display displayCtrl 1204;
_ctrlPain = 	_display displayCtrl 1209;
_ctrlDebug = _display displayCtrl 1210;

_ctrlBloodBorder  = _display displayCtrl 1200;
_ctrlFoodBorder   = _display displayCtrl 1201;
_ctrlThirstBorder = _display displayCtrl 1202;
_ctrlTempBorder   = _display displayCtrl 1208;

/*
//Food/Water/Blood
_bloodColor = [(Dayz_GUI_R + (0.3 * (1-_bloodVal))),(Dayz_GUI_G * _bloodVal),(Dayz_GUI_B * _bloodVal), 0.6];
_ctrlBlood ctrlSetTextColor _bloodColor;

_foodColor = [(Dayz_GUI_R + (0.3 * (1-_foodVal))),(Dayz_GUI_G * _foodVal),(Dayz_GUI_B * _foodVal), 0.6];
_ctrlFood ctrlSetTextColor _foodColor;

_thirstColor = [(Dayz_GUI_R + (0.3 * (1-_thirstVal))),(Dayz_GUI_G * _thirstVal),(Dayz_GUI_B * _thirstVal), 0.6];
_ctrlThirst ctrlSetTextColor _thirstColor;

//_tempColor = [(Dayz_GUI_R + (0.3 * _tempVal)),(Dayz_GUI_G * _tempVal),(Dayz_GUI_B + (0.25 * (1/_tempVal))), 0.6];	//TeeChange Coulor should change into red if value is higher as normale temp and into blue if coulor is lower as normal temp
_tempColor = [(Dayz_GUI_R + (0.2 * (1-_tempVal))), (Dayz_GUI_G * _tempVal), _tempVal, 0.5];
_ctrlTemp ctrlSetTextColor _tempColor;

_ctrlCombat ctrlSetTextColor[(Dayz_GUI_R + (0.3 * (1-_combatVal))),(Dayz_GUI_G * _combatVal),(Dayz_GUI_B * _combatVal), 0.6];
*/

//Food/Water/Blood
_bloodColor = [(Dayz_GUI_R + (0.2 * (1-_bloodVal))),(Dayz_GUI_G * _bloodVal),(Dayz_GUI_B * _bloodVal), 0.6];
_ctrlBlood ctrlSetTextColor _bloodColor;

_foodColor = [(Dayz_GUI_R + (0.2 * (1-_foodVal))),(Dayz_GUI_G * _foodVal),(Dayz_GUI_B * _foodVal), 0.6];
_ctrlFood ctrlSetTextColor _foodColor;

_thirstColor = [(Dayz_GUI_R + (0.2 * (1-_thirstVal))),(Dayz_GUI_G * _thirstVal),(Dayz_GUI_B * _thirstVal), 0.6];
_ctrlThirst ctrlSetTextColor _thirstColor;

_tempColor = [(Dayz_GUI_R + (0.2 * _tempVal)),(Dayz_GUI_G * (1-_tempVal)),(Dayz_GUI_B * (1-_tempVal)), 0.6];
_ctrlTemp ctrlSetTextColor _tempColor;

_ctrlCombat ctrlSetTextColor[(Dayz_GUI_R + (0.2 * (1-_combatVal))),(Dayz_GUI_G * _combatVal),(Dayz_GUI_B * _combatVal), 0.6];

//hintSilent format["Temp Readout:\n\ndayz_temperatur: %1\n_tempVal: %2", dayz_temperatur, _tempVal];

// Temperature Colors
//_shiverTemp =		((0.125 * (dayz_temperaturmax    - dayz_temperaturmin) + dayz_temperaturmin)); // taken from dayz_code/compiles/fn_temperature.sqf
//_infectionRiskTemp =	((0.48  * (dayz_temperaturmax    - dayz_temperaturmin) + dayz_temperaturmin)); // taken from dayz_code/system/player_spawn2.sqf

/*
_humanity = player getVariable["humanity",0];
_guiHumanity = 0;
if(_humanity != dayz_lastHumanity) then {
	if (_humanity > 0) then {
		_humanity = _humanity min 5000;
		_guiHumanity = (round((_humanity / 5000) * 5) + 5);
	} else {
		_humanity = _humanity max -20000;
		_guiHumanity = 5 - (round(-(_humanity / 20000) * 4));
	};
	dayz_lastHumanity = _humanity;
	dayz_guiHumanity = _guiHumanity;
	_humanityText = "\z\addons\dayz_code\gui\humanity_" + str(_guiHumanity) + "_ca.paa";
	_ctrlHumanity ctrlSetText _humanityText;
};
*/

_bloodText = "";
_bloodLevel = round(_bloodVal * 10);
if (_bloodLevel > 0) then {_bloodText = "\z\addons\dayz_code\gui\bloodlevel_" + str(_bloodLevel) + "_ca.paa"};
_ctrlBlood ctrlSetText _bloodText;

_foodLevel = round((_foodVal max 0) * 10);
_foodText = "\z\addons\dayz_code\gui\foodlevel_" + str(_foodLevel) + "_ca.paa";
_ctrlFood ctrlSetText _foodText;

_thirstText = "";
_thirstLevel = round((_thirstVal max 0) * 10);
if (_thirstLevel > 0) then {_thirstText = "\z\addons\dayz_code\gui\thirstlevel_" + str(_thirstLevel) + "_ca.paa"};
_ctrlThirst ctrlSetText _thirstText;

/*
_visualtext = "";
_visual = round((dayz_disVisual / 100) * 4) min 5;
if (_visual > 0) then {_visualtext = "\z\addons\dayz_code\gui\val_" + str(_visual) + "_ca.paa"};

_audibletext = "";
_audible = round((dayz_disAudial / 50) * 4) min 5;
if (_audible > 0) then {_audibletext = "\z\addons\dayz_code\gui\val_" + str(_audible) + "_ca.paa"};

_ctrlEye ctrlSetText _visualtext;
_ctrlEar ctrlSetText _audibletext;
*/

if (_combatVal == 0) then {
	_ctrlCombat call player_guiControlFlash;
};

if (_bloodVal < 0.2) then {
	_ctrlBlood call player_guiControlFlash;
	//_ctrlBloodBorder ctrlSetTextColor _bloodColor;
} else {
	//_ctrlBloodBorder ctrlSetTextColor [1, 1, 1, 0.2];
};

if (_thirstVal < 0.2) then {
	_ctrlThirst call player_guiControlFlash;
	//_ctrlThirstBorder ctrlSetTextColor _thirstColor;
} else {
	//_ctrlThirstBorder ctrlSetTextColor [1, 1, 1, 0.2];
};

if (_foodVal < 0.2) then {
	_ctrlFood call player_guiControlFlash;
	//_ctrlFoodBorder ctrlSetTextColor _foodColor;
} else {
	//_ctrlFoodBorder ctrlSetTextColor [1, 1, 1, 0.2];
};

if (_tempVal > 0.8 ) then {
	_ctrlTemp call player_guiControlFlash;
} else {
	_ctrlTemp ctrlShow true;
};

if (r_player_injured) then {
	_ctrlBleed call player_guiControlFlash;
};

if (r_player_infected) then {
	_ctrlInfection ctrlShow true;
} else {
	_ctrlInfection ctrlShow false;

};

if (r_player_inpain) then {
	_ctrlPain ctrlShow true;
} else {
	_ctrlPain ctrlShow false;

};

//private["_debug","_charPos","_nearDebug","_nearSpawnPos","_xCoord","_yCoord"];
//Debug Warning

_debug = getMarkerpos "respawn_west";
_charPos = 		getPosATL (vehicle player);
_nearDebug = ((_debug distance _charPos) < 1500);
_nearSpawnPos = ((dayz_spawnPos distance _charPos) < 100);
_xCoord = _charPos select 0;
_yCoord = _charPos select 1;
if (_xCoord > 14360 or _xCoord < 1000 or _yCoord > 14360 or _yCoord < 1000) then {
	_ctrlDebug ctrlShow true;
if (_xCoord > 14360) then {
  _xcolorB = ((_xCoord - 14360) / 1000); //(15360 - 14360) / 1000 = 1.00
  _gxcolorB = abs (_xcolorB - 1);
  _ctrlDebug ctrlSetTextColor [_xcolorB, _gxcolorB, 0, 0.8];
};
if (_xCoord < 1000) then {
  _xcolorS = _xCoord / 1000;
  _gxcolorS = abs (_xcolorS - 1);
  _ctrlDebug ctrlSetTextColor [_gxcolorS, _xcolorS, 0, 0.8];
};
if (_yCoord > 14360) then { 
  _ycolorB = ((_yCoord - 14360) / 1000);
  _gycolorB = abs (_ycolorB - 1);
  _ctrlDebug ctrlSetTextColor [_ycolorB, _gycolorB, 0, 0.8];};
if (_yCoord < 1000) then {
  _ycolorS = _yCoord / 1000;
  _gycolorS = abs (_ycolorS - 1);
  _ctrlDebug ctrlSetTextColor [_gycolorS, _ycolorS, 0, 0.8];
};
} else {
	_ctrlDebug ctrlShow false;
};

if (!canStand player) then {
	if (!(ctrlShown _ctrlFracture)) then {
		r_fracture_legs = true;
		_ctrlFracture ctrlShow true;
		//_id = true spawn dayz_disableRespawn;
	};
};

_array = [_foodVal,_thirstVal];
_array