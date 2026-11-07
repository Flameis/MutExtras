// A sandbag wall or a stretch of barbed wire an engineer placed with a fortification kit (ACItem_FortificationKit). Solid
// for soldiers and bullets; explosives (grenades, satchels, C4, rockets, tank shells, artillery, mines) wear it down and
// destroy it. Cleared when a new round starts. The mesh is sent by its name too, so a player's game that doesn't have its
// package loaded yet loads it.
class ACPlacedFortification extends Actor;

var repnotify string MeshPath;
var StaticMeshComponent PieceMesh;
var int Health;
var byte BuiltByTeam;
var PlayerReplicationInfo PlacedBy;

replication
{
    if (bNetDirty && Role == ROLE_Authority)
        MeshPath;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'MeshPath')
        ApplyMesh();
    else
        super.ReplicatedEvent(VarName);
}

function SetPiece(string InMeshPath, int InHealth)
{
    MeshPath = InMeshPath;
    Health = InHealth;
    ApplyMesh();
}

simulated function ApplyMesh()
{
    local StaticMesh SM;

    if (MeshPath == "")
        return;
    SM = StaticMesh(DynamicLoadObject(MeshPath, class'StaticMesh', true));
    if (SM != None && PieceMesh.StaticMesh != SM)
        PieceMesh.SetStaticMesh(SM);
}

static function bool HurtsFortifications(class<DamageType> DamageType)
{
    return ClassIsChildOf(DamageType, class'RODamageType_CannonShell') || ClassIsChildOf(DamageType, class'RODamageType_Grenades')
        || ClassIsChildOf(DamageType, class'RODamageType_Mines') || ClassIsChildOf(DamageType, class'RODmgType_Satchel')
        || ClassIsChildOf(DamageType, class'RODmgType_C4_Explosive') || ClassIsChildOf(DamageType, class'RODmgTypeArtillery');
}

event TakeDamage(int DamageAmount, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType,
    optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    if (Health <= 0 || !HurtsFortifications(DamageType))
        return;
    Health -= DamageAmount;
    if (Health <= 0)
        Destroy();
}

// Explosions reach it whether or not they hit it directly
simulated function TakeRadiusDamage(Controller InstigatedBy, float BaseDamage, float DamageRadius, class<DamageType> DamageType,
    float Momentum, vector HurtOrigin, bool bFullDamage, Actor DamageCauser, optional float DamageFalloffExponent = 1.f)
{
    if (Role == ROLE_Authority && HurtsFortifications(DamageType))
        super.TakeRadiusDamage(InstigatedBy, BaseDamage, DamageRadius, DamageType, Momentum, HurtOrigin, true, DamageCauser, DamageFalloffExponent);
}

// A new round starts without them
function Reset()
{
    Destroy();
}

// A living soldier (or vehicle) stands inside it
function bool SoldierInside()
{
    local Pawn P;
    local vector Extent;
    local float Radius, Height;

    ForceUpdateComponents(true, false);
    foreach WorldInfo.AllPawns(class'Pawn', P, PieceMesh.Bounds.Origin, PieceMesh.Bounds.SphereRadius + 200)
    {
        if (P.Health <= 0 || P.bDeleteMe)
            continue;
        P.GetBoundingCylinder(Radius, Height);
        Extent.X = Radius * 0.75;
        Extent.Y = Extent.X;
        Extent.Z = Height * 0.9;
        if (PointCheckComponent(PieceMesh, P.Location, Extent))
            return true;
    }
    return false;
}

defaultproperties
{
    Begin Object Class=DynamicLightEnvironmentComponent Name=FortLight
        bDynamic=false
    End Object
    Components.Add(FortLight)

    Begin Object Class=StaticMeshComponent Name=FortMesh
        LightEnvironment=FortLight
        CollideActors=true
        BlockActors=true
        BlockZeroExtent=true
        BlockNonZeroExtent=true
        BlockRigidBody=true
        bForceMipStreaming=true
        CastShadow=true
    End Object
    PieceMesh=FortMesh
    CollisionComponent=FortMesh
    Components.Add(FortMesh)

    Health=600
    BuiltByTeam=255
    bCollideActors=true
    bBlockActors=true
    bProjTarget=true
    bCanBeDamaged=true
    bStatic=false
    bNoDelete=false
    bMovable=true
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    NetUpdateFrequency=2
    bGameRelevant=true
}
