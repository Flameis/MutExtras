
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
					OtherItems=(class'ROGame.ROWeap_M61_Grenade', class'ROGame.ROWeap_M8_Smoke',class'MutExtras.ACItem_USAmmoCrate'),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_radioman'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_radioman'
}