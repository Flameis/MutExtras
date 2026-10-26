// Puts the gunfire into server demos, so it can be heard when a demo is played back (for example with the RypelCam).
//
// The game sends each gunshot sound to every player who can hear it, and to the hidden camera a server demo is
// recorded from. But when a demo is played back that camera isn't brought back (the game can't load it), so every
// sound that was sent to it is lost: a played-back demo has the players and their shots, but no gunshots.
//
// MutExtras spawns one of these while a demo records, owned by the demo camera, so only the demo gets it (players
// on the server never do), and it comes back when the demo is played back. (MutDemoRec's DRDemoLink does the same.)
// - Gunfire (bGunfire): it watches every pawn's shots and writes each shot's sound into a short replicated list,
//   which the demo records like any other replicated value. On playback it plays each new sound in the list where it
//   was fired, the way the game plays a gunshot for a player. Covered: every single shot, and the tail sound when a
//   burst of automatic fire ends. The looping sound of automatic fire is already in demos (it is part of the pawn).
// - The viewer (bViewer): on playback the local player gets an ACDemoViewer, a spectator camera like the game's own.
//   The playback's own player has no proper camera controller, so without it the sounds the playback makes itself
//   (explosions, artillery, impacts) aren't heard either.
// - Ambient sound (bAmbient): on playback the map's ambient sound is started, as the late-join ambient sound fix does.
class ACDemoSoundRelay extends Actor;

struct DemoSound
{
    var AkEvent Sound;
    var Actor   Source;     // The shooter
    var vector  Location;   // Where the sound plays (the shooter's eyes, as the game does)
    var byte    Seq;        // Changes every time this slot gets a new sound (0: never used)
};

// The newest sounds, in turn. A slot is only reused 16 sounds later, by then long sent.
var repnotify DemoSound Sounds[16];
var bool    bGunfire, bViewer, bAmbient;

replication
{
    if (bNetDirty)
        Sounds;
    if (bNetInitial)
        bGunfire, bViewer, bAmbient;
}

// ---- Server
struct ShotWatch
{
    var Pawn    P;
    var byte    LastFlashCount;
    var vector  LastFlashLocation;
    var bool    bLooping;       // Its automatic fire loop was playing last time
};
var array<ShotWatch>    Watched;
var int                 NextSlot;
var byte                NextSeq;
var int                 SoundsAdded;    // Sounds put into the demo by this relay

// ---- Playback
var byte                PlayedSeq[16];
var bool                bViewerDone, bAmbientDone;

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    if (WorldInfo.IsPlayingDemo())
        SetTimer(0.5, true, 'SetUpPlayback');
}

event Tick(float DeltaTime)
{
    local Pawn P;
    local int i;

    if (Role < ROLE_Authority || !bGunfire)
        return;

    for (i = Watched.Length - 1; i >= 0; i--)
    {
        if (Watched[i].P == None || Watched[i].P.bDeleteMe)
            Watched.Remove(i, 1);
    }
    foreach WorldInfo.AllPawns(class'Pawn', P)
        WatchShots(P);
}

function int FindWatch(Pawn P)
{
    local int i;

    for (i = 0; i < Watched.Length; i++)
    {
        if (Watched[i].P == P)
            return i;
    }
    return INDEX_NONE;
}

// A weapon shot raises the pawn's flash count (projectile weapons, which is nearly all of them) or moves its flash
// location (instant hit): what the game uses to show the shot to other players. The end of a burst of automatic
// fire is the pawn's looping fire sound stopping.
function WatchShots(Pawn P)
{
    local int i, Shots;
    local bool bLooping;
    local ROWeapon W;

    W = ROWeapon(P.Weapon);
    bLooping = ROPawn(P) != None && ROPawn(P).WeaponAmbientSound != None;

    i = FindWatch(P);
    if (i == INDEX_NONE)
    {
        i = Watched.Length;
        Watched.Length = i + 1;
        Watched[i].P = P;
        Watched[i].LastFlashCount = P.FlashCount;
        Watched[i].LastFlashLocation = P.FlashLocation;
        Watched[i].bLooping = bLooping;
        return;
    }

    if (P.FlashCount != Watched[i].LastFlashCount && P.FlashCount != 0)
    {
        Shots = int(P.FlashCount) - int(Watched[i].LastFlashCount);
        if (Shots <= 0)
            Shots += 254; // the count skips 0 (0 means stopped firing) when it wraps past 255
    }
    if (Shots == 0 && P.FlashLocation != Watched[i].LastFlashLocation && !IsZero(P.FlashLocation))
        Shots = 1;
    Watched[i].LastFlashCount = P.FlashCount;
    Watched[i].LastFlashLocation = P.FlashLocation;

    if (W != None && !W.bSuppressSounds)
    {
        for (Shots = Min(Shots, 3); Shots > 0; Shots--)
            AddSound(ShotSound(W, P.FiringMode), P);
        if (Watched[i].bLooping && !bLooping)
            AddSound(LoopEndSound(W, P.FiringMode), P);
    }
    Watched[i].bLooping = bLooping;
}

// The sound the game plays for other players when the weapon fires (ROWeapon.PlayFiringSound), or None when it plays
// none for each shot: while the looping fire sound of an automatic weapon plays instead
function AkEvent ShotSound(ROWeapon W, int Mode)
{
    if (W.bPlayingLoopingFireSnd || Mode >= W.WeaponFireSnd.Length)
        return None;
    if (Mode < W.bLoopHighROFSounds.Length && W.bLoopHighROFSounds[Mode] && W.IsInState('WeaponFiring'))
        return None;
    return W.WeaponFireSnd[Mode].DefaultCue;
}

// The tail the game plays when a burst ends (ROWeapon.StopLoopingFireSound)
function AkEvent LoopEndSound(ROWeapon W, int Mode)
{
    if (Mode >= W.WeaponFireLoopEndSnd.Length)
        return None;
    return W.WeaponFireLoopEndSnd[Mode].DefaultCue;
}

function AddSound(AkEvent Sound, Pawn Source)
{
    if (Sound == None)
        return;
    if (NextSeq == 255)
        NextSeq = 1;
    else
        NextSeq++;
    Sounds[NextSlot].Sound = Sound;
    Sounds[NextSlot].Source = Source;
    Sounds[NextSlot].Location = Source.GetPawnViewLocation();
    Sounds[NextSlot].Seq = NextSeq;
    NextSlot = (NextSlot + 1) % ArrayCount(Sounds);
    SoundsAdded++;
    bForceNetUpdate = true;
}

// ---- Playback: the demo brings new sounds into the list

simulated event ReplicatedEvent(name VarName)
{
    local int i;

    if (VarName != 'Sounds')
    {
        super.ReplicatedEvent(VarName);
        return;
    }
    for (i = 0; i < ArrayCount(Sounds); i++)
    {
        if (Sounds[i].Seq != 0 && Sounds[i].Seq != PlayedSeq[i])
        {
            PlayedSeq[i] = Sounds[i].Seq;
            PlayDemoSound(Sounds[i].Sound, Sounds[i].Source, Sounds[i].Location);
        }
    }
}

// What the game does when it plays a gunshot for a player (ROPlayerController.WwiseClientHearSound and
// ClientHearSoundAdvanced): the reverb of the place it is fired in, the sound at that spot, and its echoes
simulated function PlayDemoSound(AkEvent Sound, Actor Source, vector Where)
{
    local ROPlayerController PC;
    local rotator EchoRotation;

    if (Sound == None)
        return;
    if (IsZero(Where) && Source != None)
        Where = Source.Location;

    if (Sound.bUseEnvironmentReverbSwitchGroup)
        SetReverb(Sound, Where);
    PostAkEventAtLocation(Sound, Where);

    PC = ROPlayerController(GetALocalPlayerController());
    if (Sound.bUseAdvancedSoundFunctionality && PC != None)
    {
        if (Source != None)
            EchoRotation = Source.GetAKRotation();
        PC.HearEchoes(Sound, Where, EchoRotation);
    }
}

simulated function SetReverb(AkEvent Sound, vector Where)
{
    local name EnvironmentName;
    local int i;

    EnvironmentName = WorldInfo.GetAkEnvironmentName(Where);
    for (i = 0; i < Sound.CustomSwitches.Length; i++)
    {
        if (Sound.CustomSwitches[i].SwitchGroupName == 'Environment_Reverb')
        {
            Sound.CustomSwitches[i].SwitchName = EnvironmentName;
            return;
        }
    }
    Sound.CustomSwitches.Insert(0, 1);
    Sound.CustomSwitches[0].SwitchGroupName = 'Environment_Reverb';
    Sound.CustomSwitches[0].SwitchName = EnvironmentName;
}

// ---- Playback: the viewer and the ambient sound

simulated function SetUpPlayback()
{
    if (bViewer && !bViewerDone)
        bViewerDone = class'ACDemoViewer'.static.TakeOverLocalPlayer(self);

    // A moment in, so the map's own start (if it has one that works on playback) goes first
    if (bAmbient && !bAmbientDone && WorldInfo.TimeSeconds - CreationTime > 2.0)
    {
        bAmbientDone = true;
        StartAmbientSound();
    }

    if ((!bViewer || bViewerDone) && (!bAmbient || bAmbientDone))
        ClearTimer('SetUpPlayback');
}

// Fires the "Start All" input of the map's AkStartAmbientSound Kismet node(s), "Stop All" first so a map that did start
// its ambience doesn't play it twice (as the ambient sound fix does for players who join late)
simulated function StartAmbientSound()
{
    local Sequence GameSeq;
    local array<SequenceObject> Nodes;
    local int i;

    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq == None)
        return;
    GameSeq.FindSeqObjectsByClass(class'SeqAct_AkStartAmbientSound', true, Nodes);
    for (i = 0; i < Nodes.Length; i++)
    {
        SequenceOp(Nodes[i]).ForceActivateInput(1); // "Stop All"
        SequenceOp(Nodes[i]).ForceActivateInput(0); // "Start All"
    }
    `log("[MutExtras] demo playback: started the map's ambient sound ("$Nodes.Length$" node(s))");
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bOnlyRelevantToOwner=true
    bAlwaysRelevant=false
    bHidden=true
    bSkipActorPropertyReplication=false
    NetUpdateFrequency=100
    NetPriority=3.0
}
