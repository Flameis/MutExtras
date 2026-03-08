class ACRoleInfoCommanderSouth extends RORoleInfoSouthernInfantry;

DefaultProperties
{
	RoleType=RORIT_Commander
	ClassTier=4
	ClassIndex=12
	bIsTeamLeader=true
	bBotSelectable = false

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M16A1_AssaultRifle',class'ROGame.ROWeap_XM177E1_Carbine',class'ROGame.ROWeap_M2_Carbine'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol',class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol'),
					OtherItems=(class'ROGame.ROWeap_M61_Grenade', class'ROGame.ROWeap_M8_Smoke', class'ROGame.ROWeap_M18_SignalSmoke',class'ROGame.ROItem_BinocularsUS'),					
		)}
		
	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_commander'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_commander'
}
