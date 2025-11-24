
class ACRoleInfoSupportAUS extends ACRoleInfoSupportUS;

DefaultProperties
{
	RoleType=RORIT_Radioman
	ClassTier=3
	ClassIndex=5
	bIsRadioman=true

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle',class'ROGame.ROWeap_L1A1_Rifle'),
					// Other items
					OtherItems=(class'ROGame.ROWeap_M8_Smoke',class'MutExtras.ACItem_USAmmoCrate',class'ROGame.ROItem_BinocularsUS'),
					OtherItemsStartIndexForPrimary=(0, 0),
					NumOtherItemsForPrimary=(0, 0)
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_radioman'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_radioman'
}