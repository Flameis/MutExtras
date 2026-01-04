//=============================================================================
// ACDroppedCTFFlag
//=============================================================================
// Dropped pickup for CTF flag that never despawns
//=============================================================================
// Created for the 29th Infantry Division Realism Unit
//=============================================================================

class ACDroppedCTFFlag extends RODroppedPickup;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	// Never despawn
	LifeSpan = 0.0;
}

// Override to prevent despawning
function StartSleeping()
{
	// Don't call super - prevents the despawn timer
	SetPhysics(PHYS_None);
	SetCollision(true, false);
}

defaultproperties
{
	LifeSpan=0.0
	bUpdateSimulatedPosition=true
	bAlwaysRelevant=true
}
