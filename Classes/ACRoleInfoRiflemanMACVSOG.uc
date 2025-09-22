//=============================================================================
// RORoleInfoMACVSORifleman
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
// Moddified for MACVSOG Mutator by Sgt. Capwell
//=============================================================================
class ACRoleInfoRiflemanMACVSOG extends ACRoleInfoSouthernInfantry
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Rifleman
	ClassTier=1
	ClassIndex=0


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'MutExtrasTB.ROWeap_XM177E1_Carbine_MACVSOG',class'MutExtrasTB.ACWeap_AK47_AssaultRifle_MACVSOG',class'MutExtrasTB.ACWeap_M2_Carbine_MACVSOG'),
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol',class'ROGame.ROWeap_M1911_Pistol'),
					OtherItems=(class'ROGame.ROItem_BinocularsUS',class'ROGame.ROWeap_M18_SignalSmoke',class'ROGame.ROWeap_M61_GrenadeQuad',class'ROGame.ROWeap_M8_Smoke'),					
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_grunt'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_grunt'
}
