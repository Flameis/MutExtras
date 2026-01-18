//=============================================================================
// RORoleInfoNorthernGuerilla
//=============================================================================
// Default settings for the Vietnamese Guerilla (Rifleman) role.
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2016 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
// Edited for the 29th by Reimer, Published by Scovel
//=============================================================================
class ACRoleInfoLineup extends ACRoleInfoSouthernInfantry
	HideDropDown;

defaultproperties
{
	RoleType=RORIT_Support
	ClassTier=4
	ClassIndex=7


	Items[RORIGM_Default]={(
					// Primary : DEFAULTS
					PrimaryWeapons=(class'ROGame.ROWeap_M1Garand_Rifle'),
					SecondaryWeapons=(class'ROGame.ROWeap_M1911_Pistol', class'MutExtras.ACHolster'),
					SquadLeaderItems=()
		)}

	ClassIcon=Texture2D'VN_UI_Textures.menu.class_icon_None'
	ClassIconLarge=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_None'
}
