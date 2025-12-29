//=============================================================================
// RORoleInfoSouthernInfantryAus
//=============================================================================
// Base role info for all Australian infantry
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2017 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoSouthernInfantryAus extends ACRoleInfoSouthernInfantry
	abstract;

DefaultProperties
{
	Items[RORIGM_Default]={(
					// SECONDARY : DEFAULTS
					SecondaryWeapons=(class'ROGame.ROWeap_BHP_Pistol'),
		)}

	RoleRootClass=class'RORoleInfoSouthernInfantryAus'
}
