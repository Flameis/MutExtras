// Free look, as in Arma or Squad: while the free look key is held the mouse turns the player's head, not their aim. The
// weapon, the arms and where a shot goes stay as they were, and when the key is let go the view springs back to the aim
// with a little bounce, like the game's helicopter pilot free look. Nothing in the game is replaced, so it works with WW2,
// Winter War and GOM: one of these is made for each player by MutExtras and reaches only that player's game, where it
// - takes the mouse while the key is held (ACFreeLookInput, ahead of the game's own input, so the aim gets no movement),
// - turns only the view: it ticks after the camera has been worked out for the frame (TG_PostUpdateWork, where the game
//   updates its rain so it follows the camera) and turns the camera's result before the frame is drawn. The camera's
//   own modifiers can't do it: the game leaves them out for a soldier in first person.
// - shows the soldier's own body in first person (ACFirstPersonBody), while free looking or always (bFirstPersonBodyAlways).
// The aim never changes, so the server's idea of where the player shoots is untouched. The only thing sent is how far the
// head is turned, a few times a second while it changes: every other player's game turns that soldier's head to match,
// with the look-at node in the game's own soldier animation (VNTurretLookAtNode, which the game finds but never uses on
// foot). Only the head turns, not the chest, so the weapon stays where it points.
class ACFreeLook extends Info;

// The angles are in the engine's units: 65536 is a full turn, so 182 is one degree
const YAW_LIMIT = 18204;          // 100 degrees left and right
const PITCH_DOWN_LIMIT = 12743;   // 70 degrees down from the aim
const PITCH_UP_LIMIT = 10923;     // 60 degrees up from the aim
const EDGE_GIVE = 1820;           // the view can be pushed 10 degrees past an edge, and eases back to it
const EDGE_RETURN = 10.0;         // how quickly it eases back to the edge (the part past it, per second)
const RETURN_STIFFNESS = 180.0;   // the spring that brings the view back to the aim when the key is let go
const RETURN_DAMPING = 0.55;      // under 1 it swings a little past the aim and back before it settles: the bounce
const SETTLE = 30.0;              // close enough to the aim (a sixth of a degree) to stop
const MAX_STEP = 0.05;            // seconds; a longer frame is taken in this size, so the spring never jumps

// The head others see
const HEAD_NODE = 'VNTurretLookAtNode';
const HEAD_STEP = 256;            // the head turn is sent in steps of this (1.4 degrees)
const HEAD_SEND_TIME = 0.1;       // seconds between sends at most
const HEAD_FOLLOW = 10.0;         // how quickly a watched head follows the sent turn
const HEAD_BLEND = 6.0;           // how quickly the look-at comes in and goes again
const HEAD_LOOK_DIST = 1000.0;    // the point the head is pointed at, this far out along the look

// How far behind the camera the body stands (unreal units), so the camera isn't inside the chest
const BODY_BACK_STAND = 10.0;
const BODY_BACK_CROUCH = 14.0;
const BODY_BACK_PRONE = 24.0;

var bool bAllowed; // the server has free look on (bDisableFreeLook off)
var PlayerReplicationInfo OwnerPRI; // whose it is, so every game can find that player's soldier
var int HeadYaw, HeadPitch;         // how far their head is turned, in HEAD_STEPs (0 when not free looking)

// Client-side
var PlayerController LocalPC;
var ACFreeLookInput LookInput;
var bool bLooking;                // the key is held (or switched on) and nothing stops free looking
var float OffYaw, OffPitch;       // how far the view is turned from the aim
var float VelYaw, VelPitch;       // and how fast it is turning back
var ACFirstPersonBody Body;
var Pawn BodyPawn;
var int InstallTries;
var int SentYaw, SentPitch;       // the owner: the turn last sent
var float SentAt;

// Everyone else's game: the soldier whose head is turned
var Pawn HeadPawn;
var AnimNodeHumanIKLookAt HeadNode;
var float HeadNodeWeight;         // the node's own weight, put back when the look is over
var float CurHeadYaw, CurHeadPitch, HeadWeight;
var float PawnSearchAt;

replication
{
    if (bNetInitial && Role == ROLE_Authority)
        bAllowed, OwnerPRI;
    if (bNetDirty && !bNetOwner && Role == ROLE_Authority)
        HeadYaw, HeadPitch;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (WorldInfo.NetMode != NM_DedicatedServer)
        SetTimer(0.5, true, 'InstallInput');
}

// The local player's input for it, on its owner's game. Every game gets every player's, for their heads; only the owner's
// game knows the owner (a player's controller only reaches that player), so the others stop looking after a while. A
// demo being played back gets none: the viewer isn't the soldier.
simulated function InstallInput()
{
    local PlayerController PC;

    if (WorldInfo.IsPlayingDemo())
    {
        ClearTimer('InstallInput');
        return;
    }
    PC = PlayerController(Owner);
    if (PC == None)
    {
        if (++InstallTries >= 20)
            ClearTimer('InstallInput');
        return;
    }

    ClearTimer('InstallInput');
    if (LocalPlayer(PC.Player) == None)
        return;

    LocalPC = PC;
    LookInput = new(PC) class'ACFreeLookInput';
    LookInput.Look = self;
    PC.Interactions.AddItem(LookInput);
    KeepInputFirst();
    SetTimer(1.0, true, 'KeepInputFirst');
}

// The mouse has to reach it before the game's own input turns the aim, so it stays in front of PlayerInput
simulated function KeepInputFirst()
{
    local int LookIndex, InputIndex;

    if (LocalPC == None || LookInput == None)
        return;
    LookIndex = LocalPC.Interactions.Find(LookInput);
    InputIndex = LocalPC.Interactions.Find(LocalPC.PlayerInput);
    if (LookIndex == INDEX_NONE || InputIndex == INDEX_NONE || LookIndex < InputIndex)
        return;
    LocalPC.Interactions.Remove(LookIndex, 1);
    LocalPC.Interactions.Insert(InputIndex, 1);
    LocalPC.Interactions[InputIndex] = LookInput;
}

// ====================================================
// Looking
// ====================================================

// A soldier on foot, seen through their own eyes, not aiming down the sights or on a bipod, with no map or console up
simulated function bool CanLook()
{
    local ROPawn P;
    local ROHUD H;

    if (!bAllowed || LocalPC == None)
        return false;
    P = ROPawn(LocalPC.Pawn);
    if (P == None || P.Health <= 0 || P.DrivenVehicle != None || LocalPC.ViewTarget != P || !LocalPC.UsingFirstPersonCamera())
        return false;
    if (P.bBipodDeployed || (ROWeapon(P.Weapon) != None && ROWeapon(P.Weapon).bUsingSights))
        return false;
    H = ROHUD(LocalPC.myHUD);
    if (H != None && H.OverheadMapWidget != None && H.OverheadMapWidget.IsVisible())
        return false;
    return true;
}

// Still seeing through the soldier's eyes on foot, whether or not free looking is allowed right now (iron sights stop
// it, and the view springs back; getting into a vehicle or dying puts the view straight back)
simulated function bool OwnView()
{
    return LocalPC != None && ROPawn(LocalPC.Pawn) != None && LocalPC.Pawn.Health > 0 && LocalPC.Pawn.DrivenVehicle == None
        && LocalPC.ViewTarget == LocalPC.Pawn && LocalPC.UsingFirstPersonCamera();
}

// Mouse movement while free looking, already in the engine's rotation units
simulated function AddMouse(float DYaw, float DPitch)
{
    if (!bLooking)
        return;
    OffYaw = FClamp(OffYaw + DYaw, -(YAW_LIMIT + EDGE_GIVE), YAW_LIMIT + EDGE_GIVE);
    OffPitch = FClamp(OffPitch + DPitch, -(PITCH_DOWN_LIMIT + EDGE_GIVE), PITCH_UP_LIMIT + EDGE_GIVE);
}

// After the camera has its view for the frame: free looking or springing back, then the view turned by the offset
simulated event Tick(float DeltaTime)
{
    local float Left;

    super.Tick(DeltaTime);
    if (WorldInfo.NetMode == NM_DedicatedServer)
        return;
    if (LocalPC == None || LookInput == None)
    {
        DriveHead(DeltaTime);
        return;
    }

    bLooking = LookInput.bWantLook && CanLook();
    if (!OwnView())
        Recentre();
    for (Left = DeltaTime; Left > 0; Left -= MAX_STEP)
        UpdateOffsets(FMin(Left, MAX_STEP));
    ApplyToCamera();
    UpdateBody();
    SendHead();
}

// ====================================================
// The head others see
// ====================================================

// The owner's game sends the head turn while it changes, a few times a second at most
simulated function SendHead()
{
    local int Y, P;

    Y = Round(OffYaw / HEAD_STEP);
    P = Round(OffPitch / HEAD_STEP);
    if ((Y == SentYaw && P == SentPitch) || WorldInfo.RealTimeSeconds - SentAt < HEAD_SEND_TIME)
        return;
    SentYaw = Y;
    SentPitch = P;
    SentAt = WorldInfo.RealTimeSeconds;
    if (Role == ROLE_Authority)
        SetHead(Y, P);
    else
        ServerSetHead(Y, P);
}

unreliable server function ServerSetHead(int Y, int P)
{
    SetHead(Y, P);
}

function SetHead(int Y, int P)
{
    if (!bAllowed)
    {
        Y = 0;
        P = 0;
    }
    HeadYaw = Clamp(Y, -(YAW_LIMIT + EDGE_GIVE) / HEAD_STEP, (YAW_LIMIT + EDGE_GIVE) / HEAD_STEP);
    HeadPitch = Clamp(P, -(PITCH_DOWN_LIMIT + EDGE_GIVE) / HEAD_STEP, (PITCH_UP_LIMIT + EDGE_GIVE) / HEAD_STEP);
    bNetDirty = true;
}

// Every other game: the owner's soldier's head follows the sent turn, through the look-at node in its animation. The
// node is only touched while the soldier is on foot, and given back as it was once the look is over.
simulated function DriveHead(float DeltaTime)
{
    local rotator Look;
    local float WantWeight;

    if (OwnerPRI == None)
        return;
    FindHeadPawn();
    if (HeadPawn == None || HeadNode == None)
        return;

    CurHeadYaw = FInterpTo(CurHeadYaw, HeadYaw * HEAD_STEP, DeltaTime, HEAD_FOLLOW);
    CurHeadPitch = FInterpTo(CurHeadPitch, HeadPitch * HEAD_STEP, DeltaTime, HEAD_FOLLOW);
    WantWeight = 0.0;
    if ((HeadYaw != 0 || HeadPitch != 0) && HeadPawn.DrivenVehicle == None && HeadPawn.Health > 0)
        WantWeight = 1.0;
    if (HeadWeight == 0 && WantWeight == 0)
        return;
    HeadWeight = FInterpTo(HeadWeight, WantWeight, DeltaTime, HEAD_BLEND);
    if (HeadWeight < 0.01 && WantWeight == 0)
    {
        ReleaseHead();
        return;
    }

    Look = HeadPawn.GetBaseAimRotation();
    Look.Yaw += int(CurHeadYaw);
    Look.Pitch += int(CurHeadPitch);
    HeadNode.TargetLocation = HeadPawn.Mesh.GetBoneLocation('CHR_Head') + vector(Look) * HEAD_LOOK_DIST;
    HeadNode.LevelOfDistraction = 0.0; // the head only, so the chest and the weapon stay
    HeadNode.Weight = HeadWeight;
}

// The soldier whose head this is: found again when it changes (a new life), looked for twice a second at most
simulated function FindHeadPawn()
{
    local Pawn P;

    if (HeadPawn != None && !HeadPawn.bDeleteMe && HeadPawn.PlayerReplicationInfo == OwnerPRI)
        return;
    if (HeadPawn != None)
        ReleaseHead();
    HeadPawn = None;
    HeadNode = None;
    if (WorldInfo.RealTimeSeconds - PawnSearchAt < 0.5)
        return;
    PawnSearchAt = WorldInfo.RealTimeSeconds;

    foreach WorldInfo.AllPawns(class'Pawn', P)
    {
        if (P.PlayerReplicationInfo == OwnerPRI && ROPawn(P) != None && P.Mesh != None)
        {
            HeadPawn = P;
            HeadNode = AnimNodeHumanIKLookAt(P.Mesh.FindAnimNode(HEAD_NODE));
            if (HeadNode != None)
                HeadNodeWeight = HeadNode.Weight;
            return;
        }
    }
}

simulated function ReleaseHead()
{
    if (HeadNode != None && HeadPawn != None && !HeadPawn.bDeleteMe)
        HeadNode.Weight = HeadNodeWeight;
    HeadWeight = 0;
    CurHeadYaw = 0;
    CurHeadPitch = 0;
}

simulated function Recentre()
{
    OffYaw = 0;
    OffPitch = 0;
    VelYaw = 0;
    VelPitch = 0;
}

simulated function UpdateOffsets(float DeltaTime)
{
    if (bLooking)
    {
        // Past an edge it eases back to it: a soft stop, like the pilot's
        VelYaw = 0;
        VelPitch = 0;
        OffYaw = EaseToEdge(OffYaw, -YAW_LIMIT, YAW_LIMIT, DeltaTime);
        OffPitch = EaseToEdge(OffPitch, -PITCH_DOWN_LIMIT, PITCH_UP_LIMIT, DeltaTime);
        return;
    }
    if (OffYaw == 0 && OffPitch == 0)
        return;

    Spring(OffYaw, VelYaw, DeltaTime);
    Spring(OffPitch, VelPitch, DeltaTime);
    if (Abs(OffYaw) < SETTLE && Abs(OffPitch) < SETTLE && Abs(VelYaw) < SETTLE * 4 && Abs(VelPitch) < SETTLE * 4)
        Recentre();
}

static function float EaseToEdge(float Value, float Low, float High, float DeltaTime)
{
    if (Value > High)
        return Value - (Value - High) * FMin(1.0, EDGE_RETURN * DeltaTime);
    if (Value < Low)
        return Value - (Value - Low) * FMin(1.0, EDGE_RETURN * DeltaTime);
    return Value;
}

// One step of a damped spring pulling Value back to 0
static function Spring(out float Value, out float Speed, float DeltaTime)
{
    Speed += (-RETURN_STIFFNESS * Value - 2.0 * RETURN_DAMPING * Sqrt(RETURN_STIFFNESS) * Speed) * DeltaTime;
    Value += Speed * DeltaTime;
}

simulated function ApplyToCamera()
{
    local rotator R;

    if ((OffYaw == 0 && OffPitch == 0) || LocalPC.PlayerCamera == None)
        return;
    R = LocalPC.PlayerCamera.CameraCache.POV.Rotation;
    R.Yaw += int(OffYaw);
    R.Pitch = Clamp(NormalizeRotAxis(R.Pitch + int(OffPitch)), -16000, 16000);
    LocalPC.PlayerCamera.CameraCache.POV.Rotation = R;
}

// ====================================================
// The body in first person
// ====================================================

// Shown while free looking (or springing back), or always with bFirstPersonBodyAlways, on the player's own soldier. Not
// on a WW2 soldier, which shows its own.
simulated function bool WantsBody(ROPawn P)
{
    return P != None && OwnView() && !P.IsA('WW2Pawn') && P.Mesh != None && P.Mesh.SkeletalMesh != None
        && (LookInput.bFirstPersonBodyAlways || bLooking || OffYaw != 0 || OffPitch != 0);
}

simulated function UpdateBody()
{
    local ROPawn P;

    P = ROPawn(LocalPC.Pawn);
    if (BodyPawn != None && (BodyPawn != P || BodyPawn.bDeleteMe))
        RemoveBody();
    if (!WantsBody(P))
    {
        if (Body != None)
            Body.SetHidden(true);
        return;
    }

    if (Body == None)
    {
        Body = new(P) class'ACFirstPersonBody';
        BodyPawn = P;
        Body.CopyFrom(P.Mesh);
        P.AttachComponent(Body);
        Body.HideArms();
    }
    else if (Body.SkeletalMesh != P.Mesh.SkeletalMesh)
    {
        Body.CopyFrom(P.Mesh); // a new uniform or gear: the pawn's mesh was swapped
        Body.HideArms();
    }

    Body.SetHidden(false);
    Body.SetRotation(P.Mesh.Rotation);
    Body.SetTranslation(P.Mesh.Translation + vect(-1, 0, 0) * (P.bIsProning ? BODY_BACK_PRONE : (P.bIsCrouched ? BODY_BACK_CROUCH : BODY_BACK_STAND)));
}

simulated function RemoveBody()
{
    if (Body != None && BodyPawn != None && !BodyPawn.bDeleteMe)
        BodyPawn.DetachComponent(Body);
    Body = None;
    BodyPawn = None;
}

// The mutator command (mutate fpbody): always, only while free looking, or the other one of the two. Kept in the
// player's MutExtras_Client.ini.
reliable client function ClientSetBodyMode(string Mode)
{
    if (LookInput == None)
        InstallInput();
    if (LookInput == None)
        return;

    if (Mode ~= "always" || Mode ~= "on")
        LookInput.bFirstPersonBodyAlways = true;
    else if (Mode ~= "freelook" || Mode ~= "off")
        LookInput.bFirstPersonBodyAlways = false;
    else
        LookInput.bFirstPersonBodyAlways = !LookInput.bFirstPersonBodyAlways;
    LookInput.SaveConfig();

    if (LocalPC != None)
        LocalPC.ClientMessage("[Extras] Your body in first person: "$(LookInput.bFirstPersonBodyAlways ? "always shown" : "shown only while free looking")
            $". (mutate fpbody always / freelook)");
}

simulated event Destroyed()
{
    RemoveBody();
    ReleaseHead();
    if (LocalPC != None && LookInput != None)
        LocalPC.Interactions.RemoveItem(LookInput);
    LookInput = None;
    super.Destroyed();
}

defaultproperties
{
    TickGroup=TG_PostUpdateWork
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true // every game turns this player's head
    bReplicateMovement=false
    bSkipActorPropertyReplication=false
    NetUpdateFrequency=10
    bAllowed=true
}
