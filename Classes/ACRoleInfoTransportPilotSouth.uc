//=============================================================================
// RORoleInfoSouthernTransportPilot
//=============================================================================
// Default settings for the American Pilot role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2015 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoTransportPilotSouth extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_AirCrew
	ClassTier=3
	ClassIndex=10
	bIsPilot=true
	bIsTransportPilot=true
	bBotSelectable=false

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					SecondaryWeapons=(class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol',class'ROGame.ROWeap_BHP_Pistol'),				
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_transportpilot'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_transportpilot'
}
