//=============================================================================
// ROWeap_M79_GrenadeLauncher
//=============================================================================
// M79 40mm "Thumper" Grenade Launcher
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACWeap_M79_GrenadeLauncher extends ROWeap_M79_GrenadeLauncher
	  abstract;
	  
defaultproperties
{
	WeaponContentClass(0)="MutExtras.ACWeap_M79_GrenadeLauncher_Content" // HE Only
	WeaponContentClass(1)="MutExtras.ACWeap_M79_GrenadeLauncher_Level2" // HE + Buckshot
	WeaponContentClass(2)="MutExtras.ACWeap_M79_GrenadeLauncher_Level3"	// HE + Smoke

	InitialNumPrimaryMags=13
	MaxNumPrimaryMags=13
	AmmoClass=class'ACAmmo_40x46_M79Grenade'

	SuppressionPower=25
	
	PlayerIronSightFOV=55.0//55.0
}