//=============================================================================
// ROVCPlaceableAmmoResupplyCrate
//=============================================================================
// VC Physical representation of the crate and it's collision (not the resupply volume)
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Nate Steger @ Antimatter Games
//=============================================================================
// - Same damage rules as the US crate (see ACUSPlaceableAmmoResupplyCrate).
//=============================================================================

class ACVCPlaceableAmmoResupplyCrate extends ROVCPlaceableAmmoResupplyCrate;

var bool bRadiusHit, bCloseBlast;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	if (Role == ROLE_Authority)
		SetLocation(Location + (vect(0,0,1) >> Rotation) * class'ACUSPlaceableAmmoResupplyCrate'.const.CenterHeight);
}

simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType,
	float Momentum, vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent=1.f)
{
	bRadiusHit = true;
	bCloseBlast = VSize(Location - HurtOrigin) - class'ACUSPlaceableAmmoResupplyCrate'.const.CrateRadius
		<= class'ACUSPlaceableAmmoResupplyCrate'.const.CloseBlastDist;
	Super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, bFullDamage, DamageCauser, DamageFalloffExponent);
	bRadiusHit = false;
	bCloseBlast = false;
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	if (Health <= 0)
		return;

	Health -= class'ACUSPlaceableAmmoResupplyCrate'.static.CrateDamage(DamageAmount, DamageType, bRadiusHit, bCloseBlast, Health);

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

	// The VC mesh sat 2 units up; the crate's location is now 20 units up (see the US crate).
	Begin Object Name=SkeletalMeshComp
		Translation=(X=0,Y=0,Z=-18)
	End Object

	Begin Object Name=DestroyedPFXComp
		Translation=(X=0,Y=0,Z=-18)
	End Object
}
