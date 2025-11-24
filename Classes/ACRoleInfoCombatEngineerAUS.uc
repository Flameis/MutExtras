//=============================================================================
// RORoleInfoSouthernEngineer
//=============================================================================
// Default settings for the American Engineer role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, edited by Scovel
//=============================================================================
class ACRoleInfoCombatEngineerAUS extends ACRoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=2
	ClassIndex=3
	//bCanCompleteMiniObjectives=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle',class'ROGame.ROWeap_F1_SMG',class'ROGame.ROWeap_M9_Flamethrower',class'MutExtras.ACWeap_M79_GrenadeLauncher'),
					// Secondary Weapons
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_M8_SmokeSingle',class'ROGame.ROWeap_M61_Grenade',class'ROGame.ROWeap_C4_Explosive'),
					OtherItemsStartIndexForPrimary=( 0, 0, 0, 1),
					NumOtherItemsForPrimary=( 0, 0, 255, 1)
		)}

	bAllowPistolsInRealism=true
	bUseRootSecondaryWeapsForSL=true
	
	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
