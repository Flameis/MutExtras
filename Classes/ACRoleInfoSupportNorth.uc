
class ACRoleInfoSupportNorth extends RORoleInfoNorthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Radioman
	ClassTier=3
	ClassIndex=5
	bIsRadioman=true


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_SKS_Rifle', class'ROGame.ROWeap_AK47_AssaultRifle'),
					OtherItems=(class'MutExtras.ACItem_VCAmmoCrate', class'ROGame.ROWeap_Type67_Grenade', class'ROGame.ROWeap_RDG1_Smoke'),
					OtherItemsStartIndexForPrimary=(0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 0)
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_radioman'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_radioman'
}