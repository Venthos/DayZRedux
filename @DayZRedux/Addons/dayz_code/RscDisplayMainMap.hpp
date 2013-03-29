// Generated by unRap v1.06 by Kegetys

class RscDisplayMainMap {
	saveParams = 1;
	
	class controlsBackground {
		class Map {};
		
		class CA_Black : CA_Black_Back {};
		
		class CA_Map : RscMapControl {
			x = "SafeZoneXAbs";
			y = "SafeZoneY";
			w = "SafeZoneWAbs";
			h = "SafeZoneH";
		};
	};
	
	class controls {
		class DiaryIndex {};
		class DiaryAdd {};
		class DiarySort {};
		class DiaryFilter {};
		class Diary {};
		
		class CA_MainBackground : IGUIBack {
			idc = 1020;
			x = "SafeZoneX + 0.010 * SafeZoneW";
			y = "SafeZoneY + 0.031";
			w = "0.98*SafeZoneW";
			h = 0.082;
			colorbackground[] = {0.1961, 0.1451, 0.0941, 0.85};
		};
		
		class CA_TopicsBackground : IGUIBack {
			idc = 1021;
			x = "0.010*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.117";
			w = "0.146*SafeZoneW";
			h = 0.53;
			colorbackground[] = {0.1961, 0.1451, 0.0941, 0.85};
		};
		
		class CA_SubTopicsBackground : IGUIBack {
			idc = 1022;
			x = "0.16*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.117";
			w = "0.283*SafeZoneW";
			h = 0.53;
			colorbackground[] = {0.1961, 0.1451, 0.0941, 0.85};
		};
		
		class CA_ContentBackground : IGUIBack {
			idc = 1023;
			x = "0.446*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.117";
			w = "SafeZoneW * 0.544";
			h = 0.832;
			colorbackground[] = {0.1961, 0.1451, 0.0941, 0.85};
		};
		
		class CA_PlayerName : RscIGUIText {
			idc = 111;
			style = 1;
			x = "0.02*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.07";
			w = "SafeZoneW * 0.96";
			h = 0.041;
			sizeEx = 0.034;
			colorText[] = {0.95, 0.95, 0.95, 1};
			text = $STR_DIARY_PLAYER_NAME;
		};
		
		class CA_PlayerRank : RscIGUIText {
			idc = 116;
			style = 2;
			x = "0.02*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.07";
			w = "SafeZoneW * 0.96";
			h = 0.041;
			sizeEx = 0.034;
			colorText[] = {0.95, 0.95, 0.95, 1};
			text = "";
		};
		
		class CA_MissionName : RscText {
			idc = 112;
			style = 1;
			x = "0.02*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.033";
			w = "0.96 * SafeZoneW";
			h = 0.041;
			sizeEx = 0.034;
			colorText[] = {0.95, 0.95, 0.95, 1};
			text = $STR_DIARY_MISSION_NAME;
		};
		
		class CA_CurrentTaskLabel : RscText {
			style = 0;
			x = "0.02*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.033";
			w = "0.96 * SafeZoneW";
			h = 0.041;
			sizeEx = 0.034;
			text = $STR_DIARY_CURRENT_TASK;
		};
		
		class CA_CurrentTask : RscText {
			idc = 113;
			style = 0;
			x = "0.02*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.07";
			w = "0.96*SafeZoneW";
			h = 0.041;
			colorText[] = {0.95, 0.95, 0.95, 1};
			text = "";
		};
		
		class DiaryList : RscIGUIListBox {
			idc = 1001;
			onLBSelChanged = " [ _this select 0 , _this select 1 , 'List' ] call compile preprocessFileLineNumbers 'ca\Warfare2\Scripts\Client\GUI\GUI_logEH.sqf'; ";
			default = 1;
			x = "0.010*SafeZoneW + SafeZoneX";
			y = "SafeZoneY + 0.137";
			w = "0.146*SafeZoneW";
			h = 0.6;
		};
		
		class CA_DiaryIndex : RscIGUIListBox {
			idc = 1002;
			onLBSelChanged = "[_this select 0, _this select 1, 'Index'] call compile preprocessFileLineNumbers 'ca\Warfare2\Scripts\Client\GUI\GUI_logEH.sqf';";
			default = 0;
			x = "0.16*SafeZoneW  + SafeZoneX";
			y = "SafeZoneY + 0.137";
			w = "0.283*SafeZoneW";
			h = 0.6;
			sizeEx = 0.034;
		};
		
		class CA_DiaryGroup : RscControlsGroup {
			idc = 1013;
			x = "0.446*SafeZoneW  + SafeZoneX";
			y = "SafeZoneY + 0.137";
			w = "0.534*SafeZoneW";
			h = 0.718;
			
			class VScrollbar {
				autoScrollSpeed = -1;
				autoScrollDelay = 5;
				autoScrollRewind = 0;
				color[] = {1, 1, 1, 1};
				width = 0.01;
			};
			
			class HScrollbar {
				color[] = {1, 1, 1, 0};
				height = 0.001;
			};
			
			class Controls {
				class CA_Diary : RscHTML {
					idc = 1003;
					cycleLinks = 0;
					cycleAllLinks = 0;
					default = 0;
					x = "0.01*SafeZoneW";
					y = 0.0;
					w = "0.514*SafeZoneW";
					h = 1.807;
					colorText[] = {0.95, 0.95, 0.95, 1};
					
					class H1 {
						font = "Zeppelin32";
						fontBold = "Zeppelin32";
						sizeEx = 0.034;
					};
					
					class P {
						font = "Zeppelin32";
						fontBold = "Zeppelin32";
						sizeEx = 0.034;
					};
				};
			};
		};
		
		class HC_tooltip_back : IGUIBack {
			idc = 1124;
			x = 0.0;
			y = 0.0;
			w = 0.0;
			h = 0.0;
			colorBackground[] = {0.2, 0.15, 0.1, 0.8};
		};
		
		class HC_tooltip_text : RscStructuredText {
			idc = 1125;
			x = 0.0;
			y = 0.0;
			w = 0.0;
			h = 0.0;
			size = 0.035;
			
			class Attributes {
				font = "Zeppelin32";
				color = "#B6F862";
				align = "left";
				shadow = true;
			};
		};
	};
	
	class objects {
		class Watch : RscObject {
			model = "\ca\ui\Watch.p3d";
			x = 0.08;
			xBack = 0.4;
			y = 0.925;
			yBack = 0.5;
			z = 0.21;
			zBack = 0.11;
			enableZoom = 1;
			direction[] = {0, 1, 7.2};
			up[] = {0, 0, -1};
			scale = 0.4;
		};
		
		class Compass : RscObject {
			model = "\ca\ui\Compass.p3d";
			selectionArrow = "";
			x = 0.16;
			xBack = 0.6;
			y = 0.925;
			yBack = 0.5;
			z = 0.2;
			zBack = 0.1;
			enableZoom = 1;
			direction[] = {1, 0, 0};
			up[] = {0, 1, 0};
			scale = 0.35;
		};
		
		class GPS : RscObject {
			model = "\ca\ui\gps.p3d";
			x = 0.36;
			xBack = 0.7;
			y = 0.925;
			yBack = 0.5;
			z = 0.22;
			zBack = 0.12;
			scale = 0.3;
			
			class Areas {
				class Display {
					class controls {
						class GPSSquare : RscText {
							idc = 75;
							x = 0;
							y = 0.56;
							w = 1;
							h = 0.5;
							colorText[] = {0.2314, 0.2588, 0.1373, 1.0};
							sizeEx = 0.4;
						};
						
						class GPS_ALT : RscText {
							idc = 77;
							x = 0.25;
							y = 0.31;
							w = 1;
							h = 0.3;
							colorText[] = {0.2314, 0.2588, 0.1373, 1.0};
							sizeEx = 0.23;
						};
						
						class GPS_Heading : RscText {
							idc = 78;
							x = 0.25;
							y = 0.073;
							w = 1;
							h = 0.3;
							colorText[] = {0.2314, 0.2588, 0.1373, 1.0};
							sizeEx = 0.23;
						};
					};
				};
			};
		};
		
		class WalkieTalkie : RscObject {
			model = "\ca\ui\radio.p3d";
			x = 0.56;
			xBack = 0.8;
			y = 0.925;
			yBack = 0.5;
			z = 0.22;
			zBack = 0.12;
			scale = 0.15;
			
			class Areas {
				class Papir {
					class controls {
						class RscRadioText : RscActiveText {
							sizeEx = 0.17;
							x = 0.005;
							y = 0.02;
							h = 0.1;
						};
						
						class RadioAlpha : RscRadioText {
							y = 0.05;
						};
						
						class RadioBravo : RscRadioText {
							y = 0.17;
						};
						
						class RadioCharlie : RscRadioText {
							y = 0.29;
						};
						
						class RadioDelta : RscRadioText {
							y = 0.41;
						};
						
						class RadioEcho : RscRadioText {
							y = 0.53;
						};
						
						class RadioFoxtrot : RscRadioText {
							y = 0.65;
						};
						
						class RadioGolf : RscRadioText {
							y = 0.77;
						};
						
						class RadioHotel : RscRadioText {
							y = 0.89;
						};
						
						class RadioIndia : RscRadioText {
							y = 1.01;
						};
						
						class RadioJuliet : RscRadioText {
							y = 1.13;
						};
					};
				};
			};
		};
	};
};
