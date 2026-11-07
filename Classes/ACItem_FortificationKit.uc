// An engineer's fortification kit (bEngineerFortifications): selected like the ammo crate, it shows where the piece will
// go, and a click places it (ACPlacedFortification), across your view and centred where you aim. It holds a few pieces
// (KitsLeft); the last one used, the kit is gone. The arms and animations are the ammo crate item's. Subclasses say which
// piece (a sandbag wall, barbed wire).
class ACItem_FortificationKit extends ACItem_AmmoCrate_Content
    abstract;

var string PieceMeshPath;       // the piece placed
var vector PieceCentreOffset;   // from the mesh's origin to its middle, so the piece is centred on where you aim
var int PieceYawOffset;         // turned across the view (the long side faces you)
var int PieceHealth;
var repnotify int KitsLeft;     // pieces still in the kit
var string PieceName;           // "sandbag wall", for messages

replication
{
    if (bNetDirty && bNetOwner)
        KitsLeft;
}

simulated event ReplicatedEvent(name VarName)
{
    super.ReplicatedEvent(VarName);
}

// A static preview of the piece, not the crate's skeletal mesh
simulated function PostBeginPlay()
{
    ReferenceSkeletalMesh = None;
    ReferenceStaticMesh = StaticMesh(DynamicLoadObject(PieceMeshPath, class'StaticMesh', true));
    MinDistFromOtherAmmoCratesSq = 0;
    super(ROItemPlaceable).PostBeginPlay();
}

// Where the piece goes and how it is turned, from where the item would be placed
simulated function rotator PieceRotation()
{
    local rotator R;

    R = PlaceRot;
    R.Yaw += PieceYawOffset;
    return R;
}

simulated function vector PieceLocation()
{
    return PlaceLoc + (PieceCentreOffset >> PieceRotation());
}

simulated function UpdatePreviewMesh()
{
    if (Instigator == None || PreviewStaticMesh == None)
        return;
    PreviewStaticMesh.SetTranslation(PieceLocation());
    PreviewStaticMesh.SetRotation(PieceRotation());
    if (PreviewMeshMIC != None)
        PreviewMeshMIC.SetVectorParameterValue('color', bLastCheckSuccessful ? GoodPlacementColour : BadPlacementColour);
}

// Only the game's own placing checks (ground, slope, room); none of the ammo crate's (one each, 30 m apart)
simulated function bool CanPlace(optional bool bIsInitialCheck = true)
{
    return KitsLeft > 0 && super(ROItemPlaceable).CanPlace(bIsInitialCheck);
}

// No crate opening in the world while placing
simulated function StartPlacingItem()
{
    GotoState('PlacingItem');
}

function bool DoActualSpawn()
{
    local ACPlacedFortification F;

    F = Spawn(class'ACPlacedFortification', Instigator != None ? Instigator.Controller : None,, PieceLocation(), PieceRotation(),, true);
    if (F == None)
        return false;
    F.SetPiece(PieceMeshPath, PieceHealth);
    if (F.SoldierInside())
    {
        F.Destroy();
        if (Instigator != None && PlayerController(Instigator.Controller) != None)
            PlayerController(Instigator.Controller).ClientMessage("A soldier is in the way of the " $ PieceName $ ".");
        return false;
    }
    if (Instigator != None && Instigator.PlayerReplicationInfo != None)
    {
        F.PlacedBy = Instigator.PlayerReplicationInfo;
        if (Instigator.PlayerReplicationInfo.Team != None)
            F.BuiltByTeam = Instigator.PlayerReplicationInfo.Team.TeamIndex;
    }
    return true;
}

// The kit is kept until its last piece is used
simulated function SpawnPlaceable()
{
    HidePreviewMesh();
    if (Role < ROLE_Authority)
        return;

    if (DoActualSpawn())
    {
        KitsLeft--;
        if (KitsLeft <= 0)
        {
            if (Instigator != None && Instigator.InvManager != None)
                Instigator.InvManager.RemoveFromInventory(self);
            ForceEndFire();
            DetachWeapon();
            ClientWeaponThrown();
            Destroy();
            return;
        }
        if (Instigator != None && PlayerController(Instigator.Controller) != None)
            PlayerController(Instigator.Controller).ClientMessage(KitsLeft $ " more " $ PieceName $ (KitsLeft == 1 ? "" : "s") $ " in the kit.");
    }
    GotoActiveState();
}

defaultproperties
{
    ClassConstructorProxy=None
    KitsLeft=3
    PieceHealth=600
    bCanThrow=false
    DroppedPickupClass=None
}
