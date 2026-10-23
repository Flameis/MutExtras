// Spectator overlay data, one per player and replicated only to its owner. The native team arrays (positions, names)
// are only sent to players on a team, so a spectator knows nothing about the players out of sight. While the owner is a
// spectator, the server keeps a snapshot of every living player in here, and a client-side Interaction
// (ACSpectatorInteraction) draws the map markers, head triangles and coloured names from it.
// Nothing here replaces a HUD, widget or controller class, so it works on top of WW2, Winter War and GOM.
class ACSpectatorInfo extends Info;

// Packed into SpecInfo: bit 0 is the team (0 north, 1 south), bit 1 is set for squad and team leaders, and the vehicle
// the player is in goes on top of that as KIND * KIND_STEP
const FLAG_SOUTH = 1;
const FLAG_LEADER = 2;
const KIND_STEP = 4;
const KIND_INFANTRY = 0;
const KIND_TANK = 1;
const KIND_TRANSPORT = 2;
const KIND_HUEY = 3;
const KIND_COBRA = 4;
const KIND_LOACH = 5;
const KIND_GUNSHIP = 6;
const MAX_SPECTATED = 128;

// Fixed arrays because dynamic ones can't be replicated; only the slots that changed are sent. A slot with no PRI is empty.
var ROPlayerReplicationInfo SpecPRI[MAX_SPECTATED];
var vector SpecLoc[MAX_SPECTATED];
var byte SpecInfo[MAX_SPECTATED];
var bool bSpectating;

var ACSpectatorInteraction Overlay; // client-side
var PlayerController OverlayOwner;  // client-side

replication
{
    if (bNetDirty && Role == ROLE_Authority)
        bSpectating, SpecPRI, SpecLoc, SpecInfo;
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    if (WorldInfo.NetMode != NM_DedicatedServer)
        SetTimer(0.5, true, 'InstallOverlay');
}

// The owner arrives with the first replication, so keep trying until it is the local player
simulated function InstallOverlay()
{
    local PlayerController PC;

    PC = PlayerController(Owner);
    if (PC == None)
        return;

    ClearTimer('InstallOverlay');
    if (LocalPlayer(PC.Player) == None)
        return;

    OverlayOwner = PC;
    Overlay = new(PC) class'ACSpectatorInteraction';
    Overlay.Info = self;
    PC.Interactions.AddItem(Overlay);
}

simulated event Destroyed()
{
    if (OverlayOwner != None && Overlay != None)
    {
        Overlay.SetDefaultNames(ROHUD(OverlayOwner.myHUD), false);
        OverlayOwner.Interactions.RemoveItem(Overlay);
    }
    Overlay = None;

    super.Destroyed();
}

// What the pawn is, for the icon on the map. Same classification as MutExtras.GetOverflowIconType
function byte GetKind(Pawn P, ROTeamInfo ROTI)
{
    local ROVehicleHelicopter Heli;

    if (ROVehicleTank(P) != None)
        return KIND_TANK;

    if (ROVehicleTransport(P) != None)
        return KIND_TRANSPORT;

    Heli = ROVehicleHelicopter(P);
    if (Heli != None)
    {
        if (ROTI != None)
        {
            switch (ROTI.GetHeliType(Heli))
            {
                case VNHT_Cobra:
                    return KIND_COBRA;
                case VNHT_Loach:
                    return KIND_LOACH;
                case VNHT_Gunship:
                    return KIND_GUNSHIP;
            }
        }
        return KIND_HUEY;
    }

    return ROVehicle(P) != None ? KIND_TRANSPORT : KIND_INFANTRY;
}

// Fills the arrays with everyone on a team who is alive; returns how many there are
function int BuildSnapshot()
{
    local Controller C;
    local ROPlayerReplicationInfo ROPRI;
    local int Count, i;
    local byte Data;

    foreach WorldInfo.AllControllers(class'Controller', C)
    {
        ROPRI = ROPlayerReplicationInfo(C.PlayerReplicationInfo);
        if (Count >= MAX_SPECTATED || ROPRI == None || ROPRI.bOnlySpectator || ROPRI.Team == None || ROPRI.Team.TeamIndex > 1
            || C.Pawn == None || C.Pawn.bDeleteMe || C.Pawn.Health <= 0)
            continue;

        Data = ROPRI.Team.TeamIndex;
        Data += GetKind(C.Pawn, ROTeamInfo(ROPRI.Team)) * KIND_STEP;
        if (ROPRI.bIsSquadLeader || (ROPRI.RoleInfo != None && ROPRI.RoleInfo.bIsTeamLeader))
            Data += FLAG_LEADER;

        SpecPRI[Count] = ROPRI;
        SpecLoc[Count] = C.Pawn.Location;
        SpecInfo[Count] = Data;
        Count++;
    }

    for (i = Count; i < MAX_SPECTATED; i++)
    {
        SpecPRI[i] = None;
        SpecInfo[i] = 0;
    }
    return Count;
}

// Server: refreshes the snapshot while the owner is a spectator, and clears it when they are not
function Refresh()
{
    local PlayerController PC;
    local int i;

    PC = PlayerController(Owner);
    if (PC == None || PC.PlayerReplicationInfo == None || !PC.PlayerReplicationInfo.bOnlySpectator)
    {
        if (bSpectating)
        {
            bSpectating = false;
            for (i = 0; i < MAX_SPECTATED; i++)
                SpecPRI[i] = None;
        }
        return;
    }

    bSpectating = true;
    BuildSnapshot();
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bOnlyRelevantToOwner=true
    bReplicateMovement=false
    NetUpdateFrequency=4
}
