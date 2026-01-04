//=============================================================================
// ACItem_CTFFlag
//=============================================================================
// Capture The Flag item that can be picked up by either team, drops on death
// (including teamkills), and never despawns.
//=============================================================================
// Created for the 29th Infantry Division Realism Unit
//=============================================================================

class ACItem_CTFFlag extends ROWeapon;

var bool bIsCarried;
var Actor FlagBase;  // The original spawn location or flag stand

// Visibility components for flag carrier
var StaticMeshComponent CarrierBeam;      // Beam above carrier (like commander mark)
var StaticMeshComponent CarrierBeamBase;  // Base of beam on ground
var SkeletalMeshComponent BackAttachment; // Flag mesh on carrier's back
var bool bShowCarrierBeam;
var bool bShowBackAttachment;

replication
{
	if (bNetDirty)
		bIsCarried;
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
}

// Called when weapon is attached to pawn - use this instead of GiveTo (which is final)
simulated function AttachWeaponTo(SkeletalMeshComponent MeshCpnt, optional Name SocketName)
{
	local ROPlayerController ROPC;
	
	Super.AttachWeaponTo(MeshCpnt, SocketName);
	
	if (Instigator != None && Instigator.Controller != None)
	{
		ROPC = ROPlayerController(Instigator.Controller);
		
		if (ROPC != None)
		{
			// Log pickup event
			`log("CTF Flag picked up by: " @ ROPC.PlayerReplicationInfo.PlayerName @ " Team:" @ ROPC.GetTeamNum());
		}
		
		bIsCarried = true;
		
		// Show carrier indicators
		ShowCarrierIndicators();
	}
}

// Show visual indicators on the flag carrier
simulated function ShowCarrierIndicators()
{
	if (Instigator == None)
		return;
		
	// Attach beam above carrier
	if (bShowCarrierBeam && CarrierBeam != None)
	{
		Instigator.AttachComponent(CarrierBeam);
		if (CarrierBeamBase != None)
			Instigator.AttachComponent(CarrierBeamBase);
	}
	
	// Attach flag to carrier's back
	if (bShowBackAttachment && BackAttachment != None)
	{
		Instigator.Mesh.AttachComponentToSocket(BackAttachment, 'Spine2');
	}
}

// Hide visual indicators
simulated function HideCarrierIndicators()
{
	if (Instigator == None)
		return;
		
	if (CarrierBeam != None)
		Instigator.DetachComponent(CarrierBeam);
		
	if (CarrierBeamBase != None)
		Instigator.DetachComponent(CarrierBeamBase);
		
	if (BackAttachment != None && Instigator.Mesh != None)
		Instigator.Mesh.DetachComponent(BackAttachment);
}

// Called when the weapon is added to inventory
function ItemRemovedFromInvManager()
{
	HideCarrierIndicators();
	Super.ItemRemovedFromInvManager();
	bIsCarried = false;
}

// Override to drop on death
function DropFrom(vector StartLocation, vector StartVelocity)
{
	local DroppedPickup P;
	local ROPlayerController ROPC;
	
	if (Instigator != None && Instigator.Controller != None)
	{
		ROPC = ROPlayerController(Instigator.Controller);
		if (ROPC != None)
		{
			`log("CTF Flag dropped by: " @ ROPC.PlayerReplicationInfo.PlayerName);
		}
	}
	
	// Hide indicators before dropping
	HideCarrierIndicators();
	
	bIsCarried = false;
	
	// Create a dropped pickup that won't despawn
	P = Spawn(DroppedPickupClass,,, StartLocation);
	if (P != None)
	{
		P.SetPhysics(PHYS_Falling);
		P.Inventory = Self;
		P.InventoryClass = Class;
		P.Velocity = StartVelocity;
		P.Instigator = Instigator;
		P.SetPickupMesh(DroppedPickupMesh);
		P.SetPickupParticles(DroppedPickupParticles);
		
		// Make sure it never despawns
		P.LifeSpan = 0.0;
	}
	
	Instigator = None;
	GotoState('');
}

// Ensure flag drops on any death, including teamkills
simulated function DetachWeapon()
{
	local vector X, Y, Z, TossVel;
	
	// Hide indicators before detaching
	HideCarrierIndicators();
	
	if (Instigator != None)
	{
		GetAxes(Instigator.Rotation, X, Y, Z);
		TossVel = Vector(Instigator.GetViewRotation());
		TossVel = TossVel * ((Instigator.Velocity Dot TossVel) * 0.5 + 150.0) + Vect(0, 0, 200);
		
		DropFrom(Instigator.Location + 0.8 * Instigator.GetCollisionHeight() * Z, TossVel);
	}
	
	Super.DetachWeapon();
}

// Can be picked up by either team
simulated function bool DenyPickupQuery(class<Inventory> ItemClass, Actor Pickup)
{
	// Allow anyone to pick up the flag
	return false;
}

defaultproperties
{
    WeaponContentClass(0)=class'ACItem_CTFFlag_Content'

	bIsCarried=false
	bCanThrow=true  // Can't manually throw it
	
	// Set very high inventory category limit so it doesn't get auto-dropped
	InventoryGroup=99
	
	// Never despawn when dropped
	MaxDesireability=2.0
	
	// Item settings
	Weight=2.0
	
	// Use custom dropped pickup class that won't despawn
	DroppedPickupClass=class'ACDroppedCTFFlag'
	
	// Visibility options - enable one or both
	bShowCarrierBeam=true       // Show beam above carrier (very visible from distance)
	bShowBackAttachment=true    // Show flag on carrier's back (realistic but less visible)
	
	// Define base component templates (content added in Content class)
	Begin Object Class=StaticMeshComponent Name=CarrierBeamComponent
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		RBChannel=RBCC_Nothing
		DepthPriorityGroup=SDPG_World
		AbsoluteTranslation=true
		AbsoluteRotation=true
		AbsoluteScale=true
		TranslucencySortPriority=9999
		Translation=(X=0,Y=0,Z=150)
	End Object
	CarrierBeam=CarrierBeamComponent
	
	Begin Object Class=StaticMeshComponent Name=CarrierBeamBaseComponent
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		RBChannel=RBCC_Nothing
		DepthPriorityGroup=SDPG_World
		AbsoluteTranslation=true
		AbsoluteRotation=true
		AbsoluteScale=true
		TranslucencySortPriority=9999
	End Object
	CarrierBeamBase=CarrierBeamBaseComponent
	
	Begin Object Class=SkeletalMeshComponent Name=BackAttachmentComponent
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		RBChannel=RBCC_Nothing
		DepthPriorityGroup=SDPG_World
		Scale=0.5
	End Object
	BackAttachment=BackAttachmentComponent
	
	Begin Object Class=SkeletalMeshComponent Name=FlagMesh
		bOwnerNoSee=true
		CollideActors=false
		BlockActors=false
		BlockZeroExtent=false
		BlockNonZeroExtent=false
		BlockRigidBody=false
		CastShadow=false
		bAcceptsDynamicDecals=false
		bUseAsOccluder=false
	End Object
	Mesh=FlagMesh
	
	Begin Object Class=SkeletalMeshComponent Name=FlagPickupMesh
		CollideActors=true
		BlockActors=true
		BlockZeroExtent=true
		BlockNonZeroExtent=false
		BlockRigidBody=true
		RBChannel=RBCC_GameplayPhysics
		RBCollideWithChannels=(Default=TRUE,GameplayPhysics=TRUE,EffectPhysics=TRUE)
	End Object
	DroppedPickupMesh=FlagPickupMesh
	PickupFactoryMesh=FlagPickupMesh
}
