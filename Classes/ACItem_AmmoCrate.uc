
// ROItem_PlaceableAmmoCrate
// Placeable Ammo Crate, used to place a ammo resupply volume placed by players
//=============================================================================
// Rising Storm 2: Vietnam Source
// Copyright (C) 2018 Tripwire Interactive LLC
// - Callum Coombes @ Antimatter Games LTD
//=============================================================================
// - Many modifications to use faction-based menshes, animations, etc. -Nate
//============================================================================

class ACItem_AmmoCrate extends ROItem_PlaceableAmmoCrate
	abstract;

simulated function BeginFire(Byte FireModeNum)
{
	// Only default fire mode, please.
	if(FireModeNum > DEFAULT_FIREMODE)
		return;

	TeamIdx = Instigator.Controller.GetTeamNum();

	// Set our arms animation set to our team's one.
	ArmsAnimSet = ArmsAnimSets[TeamIdx];

	Super.BeginFire(FireModeNum);
}


// @TODO: Move this up to the parent class?
simulated function bool CanPlace(optional bool bIsInitialCheck = true)
{
	local ROPlayerController ROPC;
	local ROTeamInfo ROTI;
	// local byte MySquad;
	local int i;
	local Actor	HitActor;
	local vector	HitNormal, HitLocation, ViewDirection, TraceEnd, TraceStart;
	local TraceHitInfo HitInfo;
	local ROPlaceableAmmoResupply ROAC;
	local float TraceBuff, TraceLength, VerticalAngle, LimitedVerticalAngle;

	ROPC = ROPlayerController(Instigator.Controller);

	// If this material physically doesn't support it or we've already got one in the world, bail.
	if(!Super(ROItemPlaceable).CanPlace() || ROPC.NumPlacedAmmoCrates > 0)
	{
		return false;
	}

	// Finally, make sure we're not within a certain range (30m by default) of another ammo resupply crate.
	VerticalAngle = acos(-ViewDirection.Z);
	ViewDirection = Vector(Instigator.GetViewRotation());
	TraceBuff = (Role == Role_Authority || IsInState('PlacingItem')) ? 1.15f : 1.0f; // I'm giving the server a buff as it often seems to have about 10UU differencein height

	if( Instigator.bIsCrouched )
	{
		TraceLength = PlaceCrouchDist;
		LimitedVerticalAngle = FMin(VerticalAngle, 45 * DegToRad);
	}
	else
	{
		TraceLength = PlaceStandingDist;
		LimitedVerticalAngle = FMin(VerticalAngle, 46 * DegToRad);
	}

	if (LimitedVerticalAngle < VerticalAngle && VerticalAngle < 120 * DegToRad) // Limit vertical angle to 120º
	{
		TraceStart = Instigator.GetPawnViewLocation();
		TraceEnd = TraceStart + ViewDirection * (TraceLength * TraceBuff * 1.2f);

		HitActor = Trace(HitLocation, HitNormal, TraceEnd, TraceStart, false,, HitInfo, TRACEFLAG_Bullet/**TRACEFLAG_NeedsTerrainMaterial*/); // TRACEFLAG_Bullet |
		if( HitActor != none && HitActor.bWorldGeometry && TraceStart.Z - HitLocation.Z <= 80 )
		{
			ROTI = ROTeamInfo(Instigator.PlayerReplicationInfo.Team);
			// MySquad = ROPlayerReplicationInfo(Instigator.PlayerReplicationInfo).SquadIndex;

			if(ROTI != None)
			{
				for(i = 0; i < `MAX_SQUADS; i++)
				{
					// Bypassing the "Squad" check for now because potentially we could have a couple combat engineers/sappers in our squad. -Nate
					if(/*i != MySquad
						&&*/ ROTI.PlaceableAmmoCrates[i] != None
						&& VSizeSq(HitLocation - ROTI.PlaceableAmmoCrates[i].Location) <  MinDistFromOtherAmmoCratesSq
						)
					{
						if(ROPC != None)
						{
							ROPC.ReceiveLocalizedMessage(class'ROLocalMessagePlantedItem', ROTMSG_PlaceAmmoTooCloseToOtherCrate);

							HidePreviewMesh();
							return false;
						}
					}
				}

				// Or too close to other placeable ammo crates being placed.
				if( !IsInState('PlacingItem') )
				{
					foreach CollidingActors(class'ROPlaceableAmmoResupply', ROAC, MinDistFromOtherAmmoCrates * 2, HitLocation)
					{
						if( ROAC != none )
						{
							if (ROPC != none)
							{
								ROPC.ReceiveLocalizedMessage(class'ROLocalMessagePlantedItem', ROTMSG_PlaceAmmoTooCloseToOtherCrate);
							}

							HidePreviewMesh();
							return false;
						}
					}
				}
			}
			else // If we can't get our team info, bail.
			{
				HidePreviewMesh();
				return false;
			}

			return true;
		}
	}

	// Failsafe.
	return false;
}


DefaultProperties
{
	WeaponContentClass(0)="MutExtras.ACItem_AmmoCrate_Content"
	RoleSelectionImage(0)=Texture2D'VN_UI_Textures.menu.ProfileStats.class_icon_large_mg'

	Category=ROIC_PlaceableEquipment

	Weight=8 //KG

	MinDistFromOtherAmmoCrates=50 // 30m = 30 * 50. 30m sq. = 30 * 50 ^ 2

	bCanThrow=true
	DroppedPickupMesh=None
	PickupFactoryMesh=None
}