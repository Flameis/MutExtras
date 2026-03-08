class ACRoleInfoCommanderNorth extends RORoleInfoNorthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Commander
	ClassTier=4
	ClassIndex=12
	bIsTeamLeader=true
	bBotSelectable = false

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle',class'ROGame.ROWeap_SKS_Rifle',class'ROGame.ROWeap_M1_Carbine'),
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),
					OtherItems=(class'ROGame.ROWeap_Type67_Grenade', class'ROGame.ROWeap_RDG1_Smoke',class'ROGame.ROWeap_PunjiTrap',class'ROItem_Binoculars')
	)}
		
	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_commander'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_commander'
}
