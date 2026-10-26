// The spectator camera for watching a demo (made by ACDemoSoundRelay when a demo is played back, never on a server).
// The same as MutDemoRec's DRDemoViewer, for when MutExtras does the demo work.
//
// When a demo plays, the game never brings back the demo camera it was recorded from, and gives the viewer's player a
// bare controller that isn't properly the local player's. So there is no spectating, and the sounds the playback
// makes itself (explosions, artillery, impacts) have no one to hear them. This takes over the local player instead,
// the way the game's debug camera does (SwitchController), so it is the local player's camera and listener.
//
// It is the game's demo camera (DemoRecSpectator), with the controls of the game's own spectator:
//  - Fire: next player. Alt fire: previous player.
//  - Iron sights: next camera mode (free camera, third person, first person, map cameras, free roam).
//  - Quick grenade: free roam. Mouse wheel: free roam camera speed.
// It starts on the first player it finds, in third person. MutCMenu's spectator view comes with it when MutCMenu is
// on the server (its info for the demo camera is in the demo).
class ACDemoViewer extends DemoRecSpectator;

var PlayerController    PlaybackController;     // The controller the playback gave the player (kept: it may need it)

// Called on the playback by ACDemoSoundRelay. Returns true once the local player has a viewer (made now, or already)
static function bool TakeOverLocalPlayer(Actor Maker)
{
    local Engine E;
    local LocalPlayer LP;
    local PlayerController Old;
    local ACDemoViewer Viewer;

    E = class'Engine'.static.GetEngine();
    if (E == None || E.GamePlayers.Length == 0)
        return false;
    LP = E.GamePlayers[0];
    if (LP == None || LP.Actor == None)
        return false;
    if (DemoRecSpectator(LP.Actor) != None) // ours, or another mod's demo camera already took over
        return true;

    Old = LP.Actor;
    Viewer = Maker.Spawn(default.Class,,, Old.Location, Old.Rotation);
    if (Viewer == None)
        return false;
    Viewer.TakeOver(LP, Old);
    return true;
}

simulated event PreBeginPlay()
{
    super.PreBeginPlay();
    // Made on the playback, where there is no game to give it player info; its spectator state needs some
    if (PlayerReplicationInfo == None)
        InitPlayerReplicationInfo();
}

// A spectator's player info, made here
function InitPlayerReplicationInfo()
{
    PlayerReplicationInfo = Spawn(class'ROPlayerReplicationInfo', self,, vect(0,0,0), rot(0,0,0));
    if (PlayerReplicationInfo == None)
        return;
    PlayerReplicationInfo.PlayerName = "Demo camera";
    PlayerReplicationInfo.bIsSpectator = true;
    PlayerReplicationInfo.bOnlySpectator = true;
    PlayerReplicationInfo.bOutOfLives = true;
    PlayerReplicationInfo.bWaitingPlayer = false;
}

function TakeOver(LocalPlayer LP, PlayerController Old)
{
    local class<HUD> HUDClass;

    PlaybackController = Old;
    // The playback's controller is left with a voice chat callback, which only the local player's controller has
    // cleared when the map ends; left there, the map can't be unloaded when the demo ends (and the game stops)
    if (ROPlayerController(Old) != None && Old.OnlineSub != None && Old.OnlineSub.VoiceInterface != None)
        Old.OnlineSub.VoiceInterface.ClearPlayerTalkingDelegate(ROPlayerController(Old).OnPlayerTalking);
    LP.SwitchController(self);
    if (PlayerCamera == None)
        SpawnPlayerCamera();
    if (myHUD == None && WorldInfo.GRI != None && WorldInfo.GRI.GameClass != None)
    {
        HUDClass = WorldInfo.GRI.GameClass.default.HUDType;
        if (HUDClass != None)
            ClientSetHUD(HUDClass);
    }
    bFindPlayer = true;
    InitLocalSpectating();
    `log("[MutExtras] demo playback: "$self$" is the viewer (was "$Old$")");
}

// ---- The game's spectator controls, in a demo (where there is no server to ask)

// Back through the players (the reverse of DemoViewNextPlayer)
function DemoViewPrevPlayer()
{
    local Pawn P, Prev, Last;

    Prev = None;
    Last = None;
    foreach WorldInfo.AllPawns(class'Pawn', P)
    {
        if (P.PlayerReplicationInfo == None)
            continue;
        if (RealViewTarget == P.PlayerReplicationInfo || ViewTarget == P)
            Prev = Last;
        Last = P;
    }
    if (Prev == None)
        Prev = Last;
    if (Prev != None)
        SetViewTarget(Prev);
}

unreliable server function ServerViewPrevTarget()
{
    switch (CurrentSpectateMode)
    {
    case SMODE_PawnFreeCam:
    case SMODE_PawnThirdPerson:
    case SMODE_PawnFirstPerson:
        DemoViewPrevPlayer();
        break;
    case SMODE_Viewpoint:
        ViewMapViewpoint(-1);
        break;
    }
    if (CurrentSpectateMode == SMODE_PawnFirstPerson && ROVehicleBase(ViewTarget) != None)
    {
        CurrentSpectateMode = SMODE_PawnThirdPerson;
        ClientSetCameraMode('ThirdPerson');
    }
}

// Free roam (the game's checks are on its server, which a demo doesn't have)
reliable server function ServerSetRoamingSpectate()
{
    CurrentSpectateMode = SMODE_Roaming;
    MyRealViewTarget = None;
    RealViewTarget = None;
    bFindPlayer = false;
    ServerViewSelf();
    SetCameraMode('FirstPerson');
}

auto state Spectating
{
    exec function StartAltFire(optional byte FireModeNum)
    {
        ServerViewPrevTarget(); // the game's spectator: previous player (the demo camera's own: an aim debug view)
    }

    exec function PrevWeapon()
    {
        SpectatorCameraSpeed = FClamp(SpectatorCameraSpeed + CameraSpeedIncrease, CameraSpeedMin, CameraSpeedMax);
    }

    exec function NextWeapon()
    {
        SpectatorCameraSpeed = FClamp(SpectatorCameraSpeed - CameraSpeedIncrease, CameraSpeedMin, CameraSpeedMax);
    }

    // The demo camera's player following, which it only does as the network copy of the server's camera; this one is
    // made here
    event PlayerTick(float DeltaTime)
    {
        local Pawn P;

        Global.PlayerTick(DeltaTime);

        if (RealViewTarget == None && MyRealViewTarget != None)
            RealViewTarget = MyRealViewTarget;

        if ((RealViewTarget == None || RealViewTarget == PlayerReplicationInfo) && bFindPlayer)
        {
            DemoViewNextPlayer();
            if (RealViewTarget != None && RealViewTarget != PlayerReplicationInfo)
            {
                bFindPlayer = false;
                CurrentSpectateMode = SMODE_PawnThirdPerson;
                SetCameraMode('ThirdPerson');
            }
        }
        else if (RealViewTarget != None && RealViewTarget != PlayerReplicationInfo
            && (Pawn(ViewTarget) == None || Pawn(ViewTarget).PlayerReplicationInfo != RealViewTarget))
        {
            // the player switched pawns (respawned, got in a vehicle)
            foreach WorldInfo.AllPawns(class'Pawn', P)
            {
                if (P.PlayerReplicationInfo == RealViewTarget)
                {
                    SetViewTarget(P);
                    break;
                }
            }
        }

        if (Pawn(ViewTarget) != None)
        {
            TargetViewRotation = ViewTarget.Rotation;
            TargetViewRotation.Pitch = Pawn(ViewTarget).RemoteViewPitch << 8;
            if (ROPawn(ViewTarget) != None)
                ROPawn(ViewTarget).SetPosition();
        }
    }
}

defaultproperties
{
    RemoteRole=ROLE_None
    bFindPlayer=true
}
