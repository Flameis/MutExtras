
class ACRoleInfoSupportUS extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Radioman
	ClassTier=3
	ClassIndex=5
	bIsRadioman=true


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_XM177E1_Carbine', class'ROGame.ROWeap_M14_Rifle'),
					// Other items
					OtherItems=(class'MutExtras.ACItem_USAmmoCrate', class'ROGame.ROWeap_M61_Grenade', class'ROGame.ROWeap_M8_Smoke'),
					OtherItemsStartIndexForPrimary=(0, 0, 0),
					NumOtherItemsForPrimary=(0, 0, 0)
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_radioman'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_radioman'

}