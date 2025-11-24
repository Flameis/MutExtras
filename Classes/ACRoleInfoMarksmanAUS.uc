//=============================================================================
// RORoleInfoSouthernMarksman
//=============================================================================
// Default settings for the American Marksman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoMarksmanAUS extends ACRoleInfoSouthernInfantry
	HideDropDown;

DefaultProperties
{
	RoleType=RORIT_Marksman
	ClassTier=2
	ClassIndex=4


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M40Scoped_Rifle', class'ROGame.ROWeap_M1DGarand_SniperRifle', class'MutExtras.ACWeap_XM21Scoped_Rifle'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol',class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol'),
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeSingle',class'ROGame.ROWeap_M18_ClaymoreSingle',class'ROGame.ROItem_BinocularsUS')
	)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sniper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sniper'
}
