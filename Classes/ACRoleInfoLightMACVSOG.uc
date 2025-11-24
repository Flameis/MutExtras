//=============================================================================
// RORoleInfoMACVSOGLight
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games// 
// Edited for the 29th by Reimer, Published by Scovel
// Moddified for MACVSOG Mutator by Sgt. Capwell
//=============================================================================
class ACRoleInfoLightMACVSOG extends ACRoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Scout
	ClassTier=2
	ClassIndex=1

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'MutExtras.ACWeap_AK47_AssaultRifle_MACVSOG',class'MutExtras.ACWeap_M3A1_SMG_MACVSOG',class'MutExtras.ACWeap_M1A1_SMG_MACVSOG'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol',class'ROGame.ROWeap_M1911_Pistol'),
					// Other items
					OtherItems=(class'ROGame.ROItem_BinocularsUS',class'MutExtras.ACWeap_M8_Smoke_Quad_MACVSOG',class'ROGame.ROWeap_M61_GrenadeDouble',class'ROGame.ROWeap_M18_Claymore',class'ROGame.ROWeap_MD82_Mine'),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_scout'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_scout'
}
