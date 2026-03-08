// Edited for the 29th by Reimer, published by Scovel
//=============================================================================
class ACRoleInfoCombatEngineerPAVN extends RORoleInfoNorthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Engineer
	ClassTier=2
	ClassIndex=3
	//bCanCompleteMiniObjectives=true
	
	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_IZH43_Shotgun',class'ROGame.ROWeap_SKS_Rifle',class'ROGame.ROWeap_MAS49_Rifle_Grenade'),
					OtherItems=(class'MutExtras.ACWeap_RPG7_RocketLauncher',class'MutExtras.ACWeap_VietSatchel'),
					OtherItemsStartIndexForPrimary=(0, 0, 1),
					NumOtherItemsForPrimary=(0, 0, 1),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_sapper'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_sapper'
}