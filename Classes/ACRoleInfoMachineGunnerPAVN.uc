//=============================================================================
// RORoleInfoNorthernMachineGunnerNLF
//=============================================================================
// Default settings for the Vietnamese Machine Gunner role, NLF specifically.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, published by Scovel
//=============================================================================
class ACRoleInfoMachineGunnerPAVN extends ACRoleInfoNorthernInfantry
	HideDropDown;

DefaultProperties
{
	RoleType=RORIT_MachineGunner
	ClassTier=2
	ClassIndex=2

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_RPD_LMG', class'ROGame.ROWeap_RP46_LMG'),
					OtherItems=(class'ROGame.ROWeap_Type67_Grenade', class'ROGame.ROWeap_PunjiTrap', class'ROGame.ROWeap_RDG1_SmokeSingle'),		
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_mg'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_mg'
}
