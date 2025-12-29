//=============================================================================
// RORoleInfoNorthernSniper
//=============================================================================
// Default settings for the Vietnamese Sniper role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
//=============================================================================
class ACRoleInfoSniperNLF extends ACRoleInfoNorthernInfantry
	HideDropDown;

DefaultProperties
{
	RoleType=RORIT_Marksman
	ClassTier=2
	ClassIndex=4

	Items[RORIGM_Default]={(
					PrimaryWeapons=(class'ROGame.ROWeap_MN9130Scoped_Rifle',class'ROGame.ROWeap_MAS49Scoped_Rifle',class'ROGame.ROWeap_M1DGarand_SniperRifle'),
					OtherItems=(class'ROGame.ROWeap_TripwireTrap', class'ROGame.ROWeap_Type67_Grenade', class'ROGame.ROWeap_RDG1_SmokeSingle')
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sniper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sniper'
}
