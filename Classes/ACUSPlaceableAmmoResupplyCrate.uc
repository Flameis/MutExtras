//=============================================================================
// ROUSPlaceableAmmoResupplyCrate
//=============================================================================
// US Physical representation of the crate and it's collision (not the resupply volume)
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games
//=============================================================================
// - Every explosive damages the crate, from any angle, and a blast right next to it destroys it.
//   The VC crate uses the same rules through CrateDamage().
//=============================================================================

class ACUSPlaceableAmmoResupplyCrate extends ROUSPlaceableAmmoResupplyCrate;

// The crate's origin is on the ground. It is moved up to the middle of the crate so the blast line-of-sight check
// (which aims at the actor's location) is not blocked by the ground under it at low angles.
const CenterHeight = 20;
// Blasts within this distance of the crate's side destroy it outright (2 meters).
const CrateRadius = 30;
const CloseBlastDist = 100;

var bool bRadiusHit, bCloseBlast;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
		SetLocation(Location + (vect(0,0,1) >> Rotation) * CenterHeight);
}

/** How much of the crate's health this hit takes. Bullets, fire and gas do nothing; every other explosive counts,
    including mod explosives the base game doesn't list. Napalm and close blasts destroy it. */
static function int CrateDamage(int DamageAmount, class<DamageType> DamageType, bool bRadius, bool bClose, int HealthLeft)
{
	local class<RODamageType> RODT;

	if (ClassIsChildOf(DamageType, class'RODmgType_Napalm'))
		return HealthLeft;

	RODT = class<RODamageType>(DamageType);
	if (RODT == None || !RODT.default.bCanDamageTunnels)
	{
		if (!bRadius
			|| ClassIsChildOf(DamageType, class'RODmgType_WhitePhosphorusFumes')
			|| ClassIsChildOf(DamageType, class'RODmgType_FougasseFumes')
			|| (RODT != None && RODT.default.bFireDamage && !RODT.default.bPhosphorous))
			return 0;
	}

	if (DamageAmount <= 0)
		return 0;
	return bClose ? HealthLeft : DamageAmount;
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType,
	float Momentum, vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent=1.f)
{
	bRadiusHit = true;
	bCloseBlast = VSize(Location - HurtOrigin) - CrateRadius <= CloseBlastDist;
	Super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
	bRadiusHit = false;
	bCloseBlast = false;
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (Health <= 0)
		return;

	Health -= CrateDamage(DamageAmount, DamageType, bRadiusHit, bCloseBlast, Health);

	if (Health <= 0)
	{
		Lifespan = 60;
		if (OwningVolume != None)
			OwningVolume.CrateDestroyed();
		Shutdown();
		SetTimer(Lifespan, false, 'Destroy');
	}
}

DefaultProperties
{
	RemoteRole=ROLE_SimulatedProxy
	NetPriority = 3
	bAlwaysRelevant = true

	Begin Object Name=SkeletalMeshComp
		Translation=(X=0,Y=0,Z=-20)
	End Object

	Begin Object Name=DestroyedPFXComp
		Translation=(X=0,Y=0,Z=-18)
	End Object
}
