//=============================================================================
// RORoleInfoSouthernPointman
//=============================================================================
// Default settings for the American Pointman role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
//=============================================================================
class ACRoleInfoLightUSMC extends ACRoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Scout
	ClassTier=2
	ClassIndex=1

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_M1A1_SMG'),
					SecondaryWeapons=(class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M8_Smoke',class'MutExtras.ACWeap_M18_Claymore_Quad',class'ROGame.ROWeap_M61_GrenadeSingle'),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_scout'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_scout'
}
