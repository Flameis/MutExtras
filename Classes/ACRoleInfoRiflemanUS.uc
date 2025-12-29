//=============================================================================
// RORoleInfoNorthernGuerilla
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
//=============================================================================
class ACRoleInfoRiflemanUS extends ACRoleInfoSouthernInfantry
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=0

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M14_Rifle', class'ROGame.ROWeap_M16A1_AssaultRifle'),
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeDouble', class'ROGame.ROWeap_M8_Smoke'),					
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_grunt'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_grunt'
}
