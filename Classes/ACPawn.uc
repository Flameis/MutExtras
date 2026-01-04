class ACpawn extends ROPawn;

var string 	PlayerRank, PlayerUnit;
var bool bNeedsIdle, bSaluting, bUBSalute;

var MaterialInstanceConstant 		HeadgearMIC2;
var MaterialInstanceConstant 		HeadgearMIC3;

var MaterialInstanceConstant HeadgearTemplateMIC2;
var MaterialInstanceConstant HeadgearTemplateMIC3;

var DecalComponent MyLDecal, MyRDecal;

simulated event PreBeginPlay()
{
	PawnHandlerClass = class'ACPawnHandler';

	SetTimer(0.2, true, 'CheckIdle');
	SetTimer(3.5, true, 'SetIdle');
	
	super.PreBeginPlay();
}

simulated event PostBeginPlay()
{
	MyLDecal = PlayerWoundDecalManager.SpawnDecal(
					MaterialInstanceConstant'MutExtrasTBPkg.Materials.TestMat',			// Decal material
					Location,  // Decal location
					Rotation,	// Decal orientation
					10,				// Decal width
					10,				// Decal height
					100,				// Decal thickness
					false,				// bNoClip
					,					// Decal rotation
					ThirdPersonHeadAndArmsMeshComponent, 				// HitComponent
					FALSE,				// bProjectOnTerrain
					TRUE,				// bProjectOnSkeletalMeshes
					,					// bone name
					,					// Hit node index (for BSP)
					,					// Hit level index (for BSP)
					,					// lifespan
					,					// InFracturedStaticMeshComponentIndex
					,					// InDepthBias
					,					// InBlendRange
					self				// LifeTimeParent
					);
	mesh.AttachComponent( MyLDecal, 'CHR_LArmshoulder');

	MyRDecal = PlayerWoundDecalManager.SpawnDecal(
					MaterialInstanceConstant'MutExtrasTBPkg.Materials.TestMat',			// Decal material
					Location,  // Decal location
					Rotation,	// Decal orientation
					10 * 20.0f,				// Decal width
					10 * 20.0f,				// Decal height
					50.0f,				// Decal thickness
					false,				// bNoClip
					,					// Decal rotation
					ThirdPersonHeadAndArmsMeshComponent, 				// HitComponent
					FALSE,				// bProjectOnTerrain
					TRUE,				// bProjectOnSkeletalMeshes
					,					// bone name
					,					// Hit node index (for BSP)
					,					// Hit level index (for BSP)
					,					// lifespan
					,					// InFracturedStaticMeshComponentIndex
					,					// InDepthBias
					,					// InBlendRange
					self				// LifeTimeParent
					);
	mesh.AttachComponent( MyRDecal, 'CHR_LArmshoulder');

	`log(MyLDecal.Orientation);
	`log(MyLDecal.Location);
	`log(MyLDecal.HitLocation);
	`log(MyLDecal.HitComponent);

	`log(MyRDecal.Orientation);
	`log(MyRDecal.Location);
	`log(MyRDecal.HitLocation);
	`log(MyRDecal.HitComponent);

	`log(Location);
			
	super.PostBeginPlay();
}

function CheckInvSizeOverride(ROPlayerReplicationInfo ROPRI)
{
	local ROInventoryManager MyInvManager;
	MyInvManager = ROInventoryManager(InvManager);

	// `log("Checking inventory size override for pawn of roleinfo: " $ ROPRI.RoleInfo);
	
	if (ROPRI != none && ROPRI.RoleInfo != none && MyInvManager != none)
	{
		if (ROPRI.RoleInfo.default.Items[ROGameReplicationInfo(WorldInfo.GRI).RoleInfoItemsIdx].SecondaryWeapons[0].default.Category == ROIC_Primary)
		{
			MyInvManager.CategoryLimits[ROIC_Primary] = 2.0;
		}
	}
}

simulated function CheckIdle()
{
	if (Weapon.IsA('ACHolster') && IsZero(Velocity) && !bIsCrouched && !bIsProning)
	{
    	bNeedsIdle = true;
	}
	else if (!bUBSalute)
	{
		StopIdleAnim();
	}
}

function SetIdle()
{
	if (bNeedsIdle && !bSaluting && !bUBSalute)
	{
    	PlayIdleAnim();
	}
}

function PostSalute()
{
	bSaluting = false;
	bUBSalute = false;
	if (Weapon.IsA('ACHolster') && IsZero(Velocity) && !bIsCrouched && !bIsProning)
	{
    	PlayIdleAnim();
	}
}

function Salute()
{
	PlayerController(Controller).ServerSay("*Salute*");

	if (IsZero(Velocity) && !bIsCrouched && !bIsProning && Weapon.IsInState('Active'))
	{
		PlayFullBodyAnimation('SaluteAnimV2', 0.5f, false, 0.8, 0);
	}
	else if (!bIsProning && Weapon.IsInState('Active'))
	{
		PlayUpperBodyAnimation('SaluteAnimV2',, 0.8);
		bUBSalute = true;
	}
	bSaluting = true;
	SetTimer(1.6, false, 'PostSalute');
	ResetSBool();
}

function PlayIdleAnim()
{
	ACPawn(Instigator).PlayFullBodyAnimation('AttentionIdleAnimV2', 0.5f, false, 1, 0);
}

function StopIdleAnim()
{
	ACPawn(Instigator).CleanupActiveAnimation();
}

reliable server function ResetSBool()
{
	ACPlayerReplicationInfo(PlayerReplicationInfo).bNeedsSalute = false;
}


//Overridden to set the unit and rank of the player before the mesh is created and after the controller is set
function PossessedBy(Controller C, bool bVehicleTransition)
{
	super(Pawn).PossessedBy(C, bVehicleTransition);

	SetUnitAndRank();//29th Helmet

	ClientPossessed();

	if( Role == ROLE_Authority )
	{
		if( AIController(C) != none )
		{
			FriendlyPlayerCollisionType = 0;
		}
		else if( ROGameInfo(WorldInfo.Game) != none )
		{
			FriendlyPlayerCollisionType = ROGameInfo(WorldInfo.Game).FriendlyInfantryCollisionType;
		}
	}

	// Check if we need guys to follow us in single player
	if( ROGameInfoSinglePlayer(WorldInfo.Game) != none && ROPlayerController(Controller) != none )
	{
	   SetTimer( 3.0, true, 'EvaluateFollowFormation' );
	}

	if ( PlayerReplicationInfo != None )
	{
		MyOldPRI = PlayerReplicationInfo;
	}

	if( !bVehicleTransition && ROPlayerReplicationInfo(PlayerReplicationInfo) != none && !bSetFinalMesh )
	{
		if( WorldInfo.NetMode == NM_Standalone || IsLocallyControlled() )
			SetPawnElementsByConfig(false);
		else if( WorldInfo.NetMode != NM_DedicatedServer )
			SetPawnElementsByConfig(true);

		CreatePawnMesh();
		bSetFinalMesh = true;
	}
}

function SetUnitAndRank()
{
	PlayerRank = ACPlayerReplicationInfo(Controller.PlayerReplicationInfo).PlayerRank;
	PlayerUnit = ACPlayerReplicationInfo(Controller.PlayerReplicationInfo).PlayerUnit;
	ServerSetUnitAndRank();
}

reliable server function ServerSetUnitAndRank()
{
	PlayerRank = ACPlayerReplicationInfo(Controller.PlayerReplicationInfo).PlayerRank;
	PlayerUnit = ACPlayerReplicationInfo(Controller.PlayerReplicationInfo).PlayerUnit;
}

simulated function CreatePawnMesh()
{
	SetUnitAndRank();

	super.CreatePawnMesh();
}

//Took me soooooooooo long to get this to work
//Overridden to check if the headgear is the 29th helmet and if so set up the rank on the front and the unit on the side
simulated function AttachNewHeadgear(SkeletalMesh NewHeadgearMesh)
{
	local SkeletalMeshSocket 	HeadSocket;
	
	if( ThirdPersonHeadgearMeshComponent.AttachedToSkelComponent != none )
		mesh.DetachComponent(ThirdPersonHeadgearMeshComponent);

	ThirdPersonHeadgearMeshComponent.SetSkeletalMesh(NewHeadgearMesh);
	ThirdPersonHeadgearMeshComponent.SetMaterial(0, HeadgearMIC);

	if( ThirdPersonHeadgearMeshComponent.GetNumElements() > 1 )
	{
		if( !bIsPilot && HairMIC != none )
			ThirdPersonHeadgearMeshComponent.SetMaterial(1, HairMIC);
		if(NewHeadgearMesh.name != '29thHelmet') //Set to default to avoid overwriting stuff like visors for pilots
		{
			ThirdPersonHeadgearMeshComponent.SetMaterial(2, NewHeadgearMesh.Materials[2]);
			ThirdPersonHeadgearMeshComponent.SetMaterial(3, NewHeadgearMesh.Materials[3]);
		}
	}

	// Set up the MICS for the 29th helmet
	// `log ("[MutExtras Debug] NewHeadgearMesh.name "$NewHeadgearMesh.name);
	if(NewHeadgearMesh.name == '29thHelmet')
	{
		HeadgearTemplateMIC2 = MaterialInstanceConstant(DynamicLoadObject("MutExtrasTBPkg.Materials." $PlayerRank,class'MaterialInstanceConstant',true));
		HeadgearTemplateMIC3 = MaterialInstanceConstant(DynamicLoadObject("MutExtrasTBPkg.Materials." $PlayerUnit,class'MaterialInstanceConstant',true));

		// `log (PlayerRank);
		// `log (PlayerUnit);

		if( HeadgearTemplateMIC2 != none )
			HeadgearMIC2 = new class'MaterialInstanceConstant';
		if( HeadgearTemplateMIC3 != none )
			HeadgearMIC3 = new class'MaterialInstanceConstant';

		HeadgearMIC2.SetParent(HeadgearTemplateMIC2);
		HeadgearMIC3.SetParent(HeadgearTemplateMIC3);
		MeshMICs.AddItem(HeadgearMIC2);
		MeshMICs.AddItem(HeadgearMIC3);
		ThirdPersonHeadgearMeshComponent.SetMaterial(2, HeadgearMIC2);
		ThirdPersonHeadgearMeshComponent.SetMaterial(3, HeadgearMIC3);
	}

	HeadSocket = ThirdPersonHeadAndArmsMeshComponent.GetSocketByName(HeadgearAttachSocket);
	if( HeadSocket!=none )
	{
	   if( mesh.MatchRefBone(HeadSocket.BoneName) != INDEX_NONE )
	   {
	       	ThirdPersonHeadgearMeshComponent.SetShadowParent(mesh);
	       	ThirdPersonHeadgearMeshComponent.SetLODParent(mesh);
	       	mesh.AttachComponent( ThirdPersonHeadgearMeshComponent, HeadSocket.BoneName, HeadSocket.RelativeLocation, HeadSocket.RelativeRotation, HeadSocket.RelativeScale);
	   }
	   else
	   {
			`warn("Bone name specified in socket not found in parent anim component. Headgear component will not be attached");
	   }
	}
}

/* function HandleSuppressionEvent(float SuppressionPower, ESuppressionEventType SuppressionType, optional class<DamageType> DamageType, optional Actor Suppressor)
{
	SuppressionPower = int(SuppressionPower * 5);

	super.HandleSuppressionEvent(SuppressionPower, SuppressionType, DamageType, Suppressor);
} */

defaultproperties
{
	PlayerRank="pvt"
	PlayerUnit="pvt"

	Begin Object Class=DecalComponent Name=Decal
		bIgnoreOwnerHidden=TRUE
		bProjectOnBackfaces=TRUE
		DecalMaterial=MaterialInstanceConstant'MutExtrasTBPkg.Materials.TestMat'
	End Object
	Components.Add(Decal)
	// MyDecal=Decal
}