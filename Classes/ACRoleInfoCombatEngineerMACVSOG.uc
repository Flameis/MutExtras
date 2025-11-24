// Edited for the 29th by Reimer, edited by Scovel
// Modified for MACVSOG Mutator by Sgt. Capwell [29ID]
//=============================================================================
class ACRoleInfoCombatEngineerMACVSOG extends ACRoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=2
	ClassIndex=3
	//bCanCompleteMiniObjectives=true


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'MutExtras.ROWeap_XM177E1_Carbine_MACVSOG', class'MutExtras.ACWeap_M79_GrenadeLauncher'),
					// Secondary Weapons
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol', class'ROGame.ROWeap_M1911_Pistol'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_C4_Explosive', class'ROGame.ROWeap_M34_WP', class'ROGame.ROItem_BinocularsUS', class'ROGame.ROWeap_M18_SignalSmoke'),
					OtherItemsStartIndexForPrimary=( 0, 1),
					NumOtherItemsForPrimary=( 0, 1)
		)}

	bAllowPistolsInRealism=true
	bUseRootSecondaryWeapsForSL=true

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
