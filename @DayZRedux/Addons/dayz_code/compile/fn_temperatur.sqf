/*
Author: TeeTime

Does: Manages the body temperatur of a Player

Possible Problems:
	=>  Balancing

Missing: 
	Save Functions
	
	Should Effects Sum Up?
	
	Math Functions for Water
	
	Player Update GUI Colours need to be checked
	
	Shivering Function need improments
*/


	private ["_looptime","_model","_sun_factor","_building_factor","_vehicle_factor","_fire_factor","_water_factor","_rain_factor","_night_factor","_wind_factor","_height_mod","_difference","_hasfireffect","_isinbuilding","_isinvehicle","_raining","_sunrise","_building"];

	_looptime 			= _this;
	_model = typeOf player;
 	
	//Factors are equal to win/loss of factor*basic value
	//All Values can be seen as x of 100: 100 / x = minutes from min temperetaure to max temperature (without other effects)
	_vehicle_factor		=	4;
	_moving_factor 		=  	7;
	_fire_factor		=	15;	//Should be always:  _rain_factor + _night_factor + _wind_factor OR higher !
	_building_factor 	=  	7;
	_sun_factor			= 	4;	//max sunfactor linear over the day. highest value in the middle of the day

	if (dayz_temperatur > dayz_temperaturnormal) then {
		_vehicle_factor		=	2;
		_moving_factor 		=  	1;
		_building_factor 	=  	2;
	};

	_water_factor		= 	-8;
	_rain_factor		=	-6; // -3
	_night_factor		= 	-4; // -1.5
	_wind_factor		=	-2; // -1

//custom values for skins
	 if (_model == "S2_RX" or _model == "S3_RX" or _model == "SW2_RX" or _model == "B1_RX" or _model == "BW1_RX" or _model == "BR1_RX" or _model == "B2_RX" or _model == "S1_RX" or _model == "R_RX") then {	
 //defaults
	_water_factor		= 	-8;
	_rain_factor		=	-6;
	_night_factor		= 	-4;
	_wind_factor		=	-2;
  } else { 
    if (_model == "CB1_RX") then {
	_water_factor		= 	-7.5;
	_rain_factor		=	-6;
	_night_factor		= 	-4;
	_wind_factor		=	-1.7;
 };
    if (_model == "CS1_RX") then {
  _water_factor		= 	-7;
	_rain_factor		=	-5.5;
	_night_factor		= 	-4;
	_wind_factor		=	-2;
  //For debug
	//hintSilent format["TEMP CS1: %1",_water_factor];
  };
    if (_model == "GS1_RX" OR _model == "GB1_RX") then {
  _water_factor		= 	-6;
	_rain_factor		=	-4.5;
	_night_factor		= 	-3;
	_wind_factor		=	-1.5;
  };
    if (_model == "PS1_RX") then {
	_water_factor		= 	-7;
	_rain_factor		=	-4.5;
	_night_factor		= 	-2;
	_wind_factor		=	-1.5;
  };
    if (_model == "PB1_RX") then {
	_water_factor		= 	-8;
	_rain_factor		=	-6;
	_night_factor		= 	-4;
	_wind_factor		=	-1;  //windbreaker lol.
  };
};
	
	_difference 	= 0;
	_hasfireffect	= false;
	_isinbuilding	= false;
	_isinvehicle	= false;
	
	_raining 		= if(rain > 0) then {true} else {false};
	_sunrise		= call world_sunRise;
	
	//POSITIV EFFECTS
	
	//vehicle
	if((vehicle player) != player) then {
		_difference 	= _difference + _vehicle_factor;
		_isinvehicle 	= true;
	} else {
		//speed factor
		private["_vel","_speed"];
		_vel = 		velocity player;
		_speed = 	round((_vel distance [0,0,0]) * 3.5);
		_difference = (_moving_factor * (_speed / 20)) min 1;
	};
	
	//fire
	private ["_fireplaces"];
	_fireplaces = nearestObjects [player, ["Land_Fire","Land_Campfire"], 8];
	if(({inflamed _x} count _fireplaces) > 0 && !_isinvehicle ) then {
		//Math: factor * 1 / (0.5*(distance max 1)^2) 		0.5 = 12.5% of the factor effect in a distance o 4 meters
		_difference 	= _difference + (_fire_factor /(0.5*((player distance (_fireplaces select 0)) max 1)^2));
		_hasfireffect 	= true;
	};
	
	//building
	_building = nearestObject [player, "HouseBase"];
	if(!isNull _building) then {
		if([player,_building] call fnc_isInsideBuilding) then {
			//Make sure thate Fire and Building Effect can only appear single		Not used at the moment
			//if(!_hasfireffect && _fire_factor > _building_factor) then {
				_difference = _difference + _building_factor;
			//};
			_isinbuilding	= true;
			dayz_inside 	= true;
		} else {
			dayz_inside 	= false;
		};
	} else {
		dayz_inside 	= false;
	};
	
	
	//sun
	if(daytime > _sunrise && daytime < (24 - _sunrise) && !_raining && overcast <= 0.6 && !_isinbuilding) then {
		
		/*Mathematic Basic
		
		t = temperature effect
		
		a = calcfactor
		f = sunfactor
		s = sunrise
		d = daytime
		
		I:	a = f / (12 - s)�
		II:	t = -a * (d - 12)� + f
		
		I + II =>
		
		t = -(f / (12 - s)�) * (d - 12)� + f
		
		Parabel with highest Point( greatest Effect == _sun_factor) always at 12.00
		Zero Points are always at sunrise and sunset -> Only Positiv Values Possible
		*/
		
		_difference = _difference + (-((_sun_factor / (12 - _sunrise)^2)) * ((daytime - 12)^2) + _sun_factor);	
	};
	



	//NEGATIVE  EFFECTS
	
	//water
	if(surfaceIsWater getPosATL player || dayz_isSwimming) then {
		_difference = _difference + _water_factor;
	};
	
	//rain
	if(_raining && !_isinvehicle && !_isinbuilding) then {
		_difference = _difference + (rain * _rain_factor);
	};
	
	//night
	private ["_daytime"];
	if((daytime < _sunrise || daytime > (24 - _sunrise)) && !_isinvehicle) then {
		_daytime 	= if(daytime < 12) then {daytime + 24} else {daytime};
		if(_isinbuilding) then {
			_difference = _difference + ((((_night_factor * -1) / (_sunrise^2)) * ((_daytime - 24)^2) + _night_factor)) / 2;
		} else {
			_difference = _difference + (((_night_factor * -1) / (_sunrise^2)) * ((_daytime - 24)^2) + _night_factor);
		};
	};
	
	//wind
	if(((wind select 0) > 4 || (wind select 1) > 4) && !_isinvehicle && !_isinbuilding ) then {
		_difference = _difference + _wind_factor;
	};
	
	//height
	if (!_isinvehicle && overcast >= 0.6) then {
		_height_mod = ((getPosASL player select 2) / 100) / 2;
		_difference = _difference - _height_mod;
	};
	
	//Calculate Change Value			Basic Factor			Looptime Correction			Adjust Value to current used temperatur scala
	_difference = _difference * SleepTemperatur / (60 / _looptime)		* ((dayz_temperaturmax - dayz_temperaturmin) / 100);
	
	//Change Temperatur															 Should be moved in a own Function to allow adding of Items which increase the Temp like "hot tea"
	dayz_temperatur = (((dayz_temperatur + _difference) max dayz_temperaturmin) min dayz_temperaturmax);
	
	//Add Shivering
	//						Percent when the Shivering will start 
	if(dayz_temperatur <= (0.125 * (dayz_temperaturmax - dayz_temperaturmin) + dayz_temperaturmin)) then {
		//CamShake as linear Function Maximum reached when Temp is at temp minimum. First Entry = Max Value
		_temp = 0.6 * (dayz_temperaturmin / dayz_temperatur );
		addCamShake [_temp,(_looptime + 1),30];	//[0.5,looptime,6] -> Maximum is 25% of the Pain Effect	
	} else {
		addCamShake [0,0,0];			//Not needed at the Moment, but will be necesarry for possible Items
	};