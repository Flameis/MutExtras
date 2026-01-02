//=============================================================================
// RORoleInfoSouthernMarksman
//=============================================================================
// Default settings for the American Marksman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoSniperUS extends ACRoleInfoSouthernInfantry
	HideDropDown;

DefaultProperties
{
	RoleType=RORIT_Marksman
	ClassTier=2
	ClassIndex=4


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M40Scoped_Rifle', class'ROGame.ROWeap_XM21Scoped_Rifle'),
					OtherItems=(class'ROGame.ROWeap_M61_Grenade', class'ROGame.ROWeap_M18_ClaymoreSingle', class'ROGame.ROWeap_M8_SmokeSingle')
	)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sniper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sniper'
}
