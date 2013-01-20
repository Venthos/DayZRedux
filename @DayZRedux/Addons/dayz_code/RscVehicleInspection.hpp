class RscDisplayInspectVehicle {
	idd = 9763;
	enableDisplay = 1;
	onLoad="uiNamespace setVariable ['redux_vehicleInspect', _this select 0]";

	class controls {
		class RscText_1000: RscText
		{
			idc = 1000;
			x = 0.334375 * safezoneW + safezoneX;
			y = 0.310417 * safezoneH + safezoneY;
			w = 0.343984 * safezoneW;
			h = 0.351528 * safezoneH;
			colorBackground[] = {0,0,0,0.9};
		};

		class RscText_1001: RscText
		{
			style = ST_CENTER;

			idc = 1001;
			text = "Vehicle Inspection";
			x = 0.334375 * safezoneW + safezoneX;
			y = 0.281944 * safezoneH + safezoneY;
			w = 0.343984 * safezoneW;
			h = 0.0286111 * safezoneH;
			colorBackground[] = {0,0.2,0,0.9};
		};

		class RscShortcutButton_1700: RscShortcutButton
		{
			idc = 1700;
			text = "Close";
			x = 0.472264 * safezoneW + safezoneX;
			y = 0.614583 * safezoneH + safezoneY;
			w = 0.063125 * safezoneW;
			h = 0.0591667 * safezoneH;
			colorBackground[] = {0,0.4,0,1};
			colorBackgroundActive[] = {0,0,0,1};
			onButtonClick = "closeDialog 0;";
		};

		class RscText_1002: RscText
		{
			style = ST_MULTI;
			lineSpacing = 1;
			idc = 1002;
			sizeEx = 0.0275;
			text = "Loading...";
			x = 0.348046 * safezoneW + safezoneX;
			y = 0.334306 * safezoneH + safezoneY;
			w = 0.317812 * safezoneW;
			h = 0.282778 * safezoneH;
		};

		class RscText_1003: RscPictureKeepAspect
		{
			idc = 1003;
			sizeEx = 0.0275;
			text = "";
			x = 0.438046 * safezoneW + safezoneX;
			y = 0.334306 * safezoneH + safezoneY;
			w = 0.227812 * safezoneW;
			h = 0.282778 * safezoneH;
		};

		class RscText_1004: RscPictureKeepAspect
		{
			idc = 1004;
			sizeEx = 0.0275;
			text = "";
			x = 0.438046 * safezoneW + safezoneX;
			y = 0.334306 * safezoneH + safezoneY;
			w = 0.227812 * safezoneW;
			h = 0.282778 * safezoneH;
		};

		class RscText_1005: RscText
		{
			style = ST_CENTER;
			
			idc = 1005;
			sizeEx = 0.0275;
			text = "";
			x = 0.438046 * safezoneW + safezoneX;
			y = 0.580000 * safezoneH + safezoneY;
			w = 0.227812 * safezoneW;
			h = 0.0591667 * safezoneH;
		};
	};
};