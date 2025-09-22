//=============================================================================
// RORoleInfoSouthernMarksman
//=============================================================================
// Default settings for the American Marksman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Modified for MACVSOG Mutator by Sgt. Capwell [29ID]
//=============================================================================
class ACRoleInfoMarksmanMACVSOG extends ACRoleInfoSouthernInfantry;


DefaultProperties
{
	RoleType=RORIT_Marksman
	ClassTier=2
	ClassIndex=4


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'MutExtrasTB.ACWeap_M40Scoped_Rifle_MACVSOG', class'MutExtrasTB.ROWeap_XM21Scoped_Rifle_MACVSOG'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol', class'ROGame.ROWeap_M1911_Pistol'),
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeDouble',class'ROGame.ROWeap_M18_Claymore',class'ROGame.ROItem_BinocularsUS', class'ROGame.ROWeap_M18_SignalSmoke')
	)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sniper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sniper'
}
