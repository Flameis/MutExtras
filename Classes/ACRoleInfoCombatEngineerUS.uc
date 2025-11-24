// Edited for the 29th by Reimer, edited by Scovel
//=============================================================================
class ACRoleInfoCombatEngineerUS extends ACRoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=2
	ClassIndex=3
	//bCanCompleteMiniObjectives=true


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M3A1_SMG',class'ROGame.ROWeap_M37_Shotgun',class'ROGame.ROWeap_M2_Carbine',class'ROGame.ROWeap_M9_Flamethrower',class'MutExtras.ACWeap_M79_GrenadeLauncher'),
					// Secondary Weapons
					SecondaryWeapons=(class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol'),
					// Other Items
					OtherItems=(class'ROGame.ROWeap_C4_Explosive',class'ROGame.ROWeap_M34_WP',class'ROGame.ROWeap_M61_GrenadeQuad'),
					OtherItemsStartIndexForPrimary=( 0, 0, 2, 0, 1),
					NumOtherItemsForPrimary=( 0, 0, 0, 255, 1)
		)}

	bAllowPistolsInRealism=true
	bUseRootSecondaryWeapsForSL=true

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}
