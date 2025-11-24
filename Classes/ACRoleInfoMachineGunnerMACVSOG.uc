//=============================================================================
// RORoleInfoSouthernMachineGunnerMACVSOG
//=============================================================================
// Default settings for the ARVN Machine Gunner role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
// Modified for MACVSOG Mutator by Sgt. Capwell [29ID]
//=============================================================================
class ACRoleInfoMachineGunnerMACVSOG extends ACRoleInfoSouthernInfantry;


DefaultProperties
{
	RoleType=RORIT_MachineGunner
	ClassTier=2
	ClassIndex=2


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'MutExtras.ROWeap_M60_GPMG_MACVSOG', class'MutExtras.ROWeap_RPD_LMG_MACVSOG'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol', class'ROGame.ROWeap_M1911_Pistol'),
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeDouble',class'ROGame.ROItem_BinocularsUS',class'ROGame.ROWeap_M18_SignalSmoke'),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_mg'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_mg'
}
