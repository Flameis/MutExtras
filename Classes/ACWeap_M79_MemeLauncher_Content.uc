//=============================================================================
// ROWeap_M79_GrenadeLauncher_Level2
//=============================================================================
// Level 2 Content for M79 Grenade Launcher - Secondary Buckshot Round
//=============================================================================
// Rising Storm 2 Vietnam Source
// Copyright (C) 2014 Tripwire Interactive LLC
// - Sturt "Psycho Ch!cken" Jeffery @ Antimatter Games
//=============================================================================
class ACWeap_M79_MemeLauncher_Content extends ROWeap_M79_GrenadeLauncher_Level2;

defaultproperties
{
	WeaponProjectiles(ALTERNATE_FIREMODE)=class'ACM79GrenadeProjectileWP'
	Spread(ALTERNATE_FIREMODE)=0.8
	NumProjectiles(ALTERNATE_FIREMODE)=100
	SecondaryAmmoClass=class'ROAmmo_M34_WP'
	InitialNumSecondaryMags=1	//6
	MaxNumSecondaryMags=1		//6

	FireModeCanUseClientSideHitDetection[ALTERNATE_FIREMODE]=false

	WeaponFireSnd(ALTERNATE_FIREMODE)=(DefaultCue=AkEvent'WW_WEP_M79.Play_WEP_M79_Fire_Single_3P',FirstPersonCue=AkEvent'WW_WEP_M79.Play_WEP_M79_Fire_Single')
}
