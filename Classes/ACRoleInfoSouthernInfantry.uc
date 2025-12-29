//=============================================================================
// RORoleInfoSouthernInfantry
//=============================================================================
// Base role info for all Southern infantry
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoSouthernInfantry extends RORoleInfoSouthernInfantry
	abstract;

DefaultProperties
{
	Items[RORIGM_Default]={(
					// SECONDARY : DEFAULTS
					SecondaryWeapons=(class'ROGame.ROWeap_M1911_Pistol',class'ROGame.ROWeap_M1917_Pistol'),
					// Squad Leader Items
					SquadLeaderItems=(class'ROGame.ROItem_BinocularsUS',class'ROGame.ROWeap_M18_SignalSmoke')
		)}
}
