//=============================================================================
// RORoleInfoNorthernInfantry
//=============================================================================
// Base role info for all Northern infantry
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACRoleInfoNorthernInfantry extends RORoleInfoNorthernInfantry
	abstract;

DefaultProperties
{
	Items[RORIGM_Default]={(
					// SECONDARY : DEFAULTS
					SecondaryWeapons=(class'ROGame.ROWeap_TT33_Pistol',class'ROGame.ROWeap_PM_Pistol'),
					// Squad Leader Items
					SquadLeaderItems=(class'ROGame.ROItem_Binoculars',class'ROGame.ROItem_TunnelTool')
		)}
}
