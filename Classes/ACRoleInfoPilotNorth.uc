//=============================================================================
// RORoleInfoSouthernPilot
//=============================================================================
// Default settings for the American Pilot role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoPilotNorth extends ACRoleInfoNorthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Tank
	ClassTier=4
	ClassIndex=9
	bIsPilot=false
	bBotSelectable=true


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle'),
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),					
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_combatpilot'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_combatpilot'
}
