
class ACRoleInfoSupportNorth extends ACRoleInfoNorthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Radioman
	ClassTier=3
	ClassIndex=5
	bIsRadioman=true


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_SKS_Rifle',class'ROGame.ROWeap_MAS49_Rifle'),
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),
					OtherItems=(class'ROGame.ROWeap_RDG1_Smoke',class'MutExtras.ACItem_VCAmmoCrate',class'ROGame.ROItem_Binoculars'),
					OtherItemsStartIndexForPrimary=(0, 0),
					NumOtherItemsForPrimary=(0, 0)
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_radioman'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_radioman'
}