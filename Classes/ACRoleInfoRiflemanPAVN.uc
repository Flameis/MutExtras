//=============================================================================
// RORoleInfoNorthernGuerilla
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer. Published by Scovel. 
//=============================================================================
class ACRoleInfoRiflemanPAVN extends ACRoleInfoRiflemanNLF
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=0
	
	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_AK47_AssaultRifle', class'ROGame.ROWeap_SKS_Rifle', class'ROGame.ROWeap_MAS49_Rifle'),
					OtherItems=(class'ROGame.ROWeap_Type67_Grenade', class'ROGame.ROWeap_RDG1_Smoke', class'ROGame.ROWeap_PunjiTrap')
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_guerilla'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_guerilla'
}
