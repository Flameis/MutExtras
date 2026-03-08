//=============================================================================
// RORoleInfoSouthernPilot
//=============================================================================
// Default settings for the American Pilot role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoPilotSouth extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_AirCrew
	ClassTier=3
	ClassIndex=9
	bIsPilot=true
	bBotSelectable=false


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					SecondaryWeapons=(class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol',class'ROGame.ROWeap_BHP_Pistol'),				
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_combatpilot'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_combatpilot'
}
