#define TEast 0
#define TWest 1
#define TGuerrila 2
#define TCivilian 3
#define TSideUnknown 4
#define TEnemy 5
#define TFriendly 6
#define TLogic 7
//#define EAST 0 // (Russian)

#define true 1
#define false 0

#define VSoft 0
#define VArmor 1
#define VAir 2

// type scope
#define private 0
#define protected 1
#define public 2

#define CanSeeRadar 1
#define CanSeeEye 2
#define CanSeeOptics 4
#define CanSeeEar 8
#define CanSeeCompass 16
#define CanSeeRadarC CanSeeRadar+CanSeeCompass
#define CanSeeAll 31

#define ReadAndWrite 0 //! any modifications enabled
#define ReadAndCreate 1 //! only adding new class members is allowed
#define ReadOnly 2 //! no modifications enabled
#define ReadOnlyVerified 3 //! no modifications enabled, CRC test applied

#define WeaponNoSlot		0	// dummy weapons
#define WeaponSlotPrimary	1	// primary weapons
#define WeaponSlotSecondary	4	// secondary weapons
#define WeaponSlotHandGun	2	// HandGun
#define WeaponSlotHandGunItem	16 // HandGun magazines
#define WeaponSlotItem		256	// items
#define WeaponSlotBinocular	4096	// binocular
#define WeaponHardMounted	65536
#define WeaponSlotInventory 131072 // inventory items

// The default template provided by BIS
// Control types
#define CT_STATIC           0
#define CT_BUTTON           1
#define CT_EDIT             2
#define CT_SLIDER           3
#define CT_COMBO            4
#define CT_LISTBOX          5
#define CT_TOOLBOX          6
#define CT_CHECKBOXES       7
#define CT_PROGRESS         8
#define CT_HTML             9
#define CT_STATIC_SKEW      10
#define CT_ACTIVETEXT       11
#define CT_TREE             12
#define CT_STRUCTURED_TEXT  13
#define CT_CONTEXT_MENU     14
#define CT_CONTROLS_GROUP   15
#define CT_XKEYDESC         40
#define CT_XBUTTON          41
#define CT_XLISTBOX         42
#define CT_XSLIDER          43
#define CT_XCOMBO           44
#define CT_ANIMATED_TEXTURE 45
#define CT_OBJECT           80
#define CT_OBJECT_ZOOM      81
#define CT_OBJECT_CONTAINER 82
#define CT_OBJECT_CONT_ANIM 83
#define CT_LINEBREAK        98
#define CT_USER             99
#define CT_MAP              100
#define CT_MAP_MAIN         101
// Static styles
#define ST_POS            0x0F
#define ST_HPOS           0x03
#define ST_VPOS           0x0C
#define ST_LEFT           0x00
#define ST_RIGHT          0x01
#define ST_CENTER         0x02
#define ST_DOWN           0x04
#define ST_UP             0x08
#define ST_VCENTER        0x0c
#define ST_TYPE           0xF0
#define ST_SINGLE         0
#define ST_MULTI          16
#define ST_TITLE_BAR      32
#define ST_PICTURE        48
#define ST_FRAME          64
#define ST_BACKGROUND     80
#define ST_GROUP_BOX      96
#define ST_GROUP_BOX2     112
#define ST_HUD_BACKGROUND 128
#define ST_TILE_PICTURE   144
#define ST_WITH_RECT      160
#define ST_LINE           176
#define ST_KEEP_ASPECT_RATIO	0x800

#define SPEED_STATIC 1e10

#define NEVER_DESTROY 1000	// for MP - destroying dead bodies

#define TracerEColor 0.2,0.8,0.1
#define TracerWColor 0.8,0.5,0.1
#define TracerGColor 0.7,0.7,0.5
#define TracerNColor 0,0,0 // used for sniper / silenced rifles

#define TracerEColorF {TracerEColor,0.040}
#define TracerWColorF {TracerWColor,0.040}
#define TracerGColorF {TracerGColor,0.040}
#define TracerNColorF {TracerNColor,0.005}

#define TracerSEColorF {TracerEColor,0.25}
#define TracerSWColorF {TracerWColor,0.25}

#define TRACER_W_ALWAYS tracerColor[]=TracerWColorF;tracerColorR[]=TracerWColorF
#define TRACER_W_OPTIONAL tracerColor[]=TracerWColorF;tracerColorR[]=TracerNColorF
#define TRACER_W_STRONG tracerColor[]=TracerSWColorF;tracerColorR[]=TracerSWColorF

#define TRACER_E_ALWAYS tracerColor[]=TracerEColorF;tracerColorR[]=TracerEColorF
#define TRACER_E_OPTIONAL tracerColor[]=TracerEColorF;tracerColorR[]=TracerNColorF
#define TRACER_E_STRONG tracerColor[]=TracerSEColorF;tracerColorR[]=TracerSEColorF

#define TRACER_G_ALWAYS tracerColor[]=TracerGColorF;tracerColorR[]=TracerGColorF
#define TRACER_G_OPTIONAL tracerColor[]=TracerGColorF;tracerColorR[]=TracerNColorF

#define TRACER_N_ALWAYS tracerColor[]=TracerNColorF;tracerColorR[]=TracerNColorF

#define LockNo		0
#define LockCadet	1
#define LockYes		2

enum
{
  DestructNo,
  DestructBuilding,
  DestructEngine,
  DestructTree,
  DestructTent,
  DestructMan,
  DestructDefault,
  DestructWreck
};

//#include "\ca\BasicDefines.hpp"