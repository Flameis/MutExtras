//=============================================================================
// RORoleInfoNorthernGuerilla
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoRiflemanARVN extends ACRoleInfoRiflemanUS
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=0

	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M1Garand_Rifle',class'ROGame.ROWeap_M16A1_AssaultRifle_Late'),
					OtherItems=(class'ROGame.ROWeap_M61_GrenadeDouble', class'ROGame.ROWeap_M8_Smoke'),
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_grunt'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_grunt'
}
