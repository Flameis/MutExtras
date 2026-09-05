// Server-side, player-ID-keyed cache for the 29th helmet rank/unit patches.
// Mirrors MutRealismMatch.RMNameChanger: the values live only in a server config
// file (never on the client), keyed by SteamID, and are re-applied to the
// player's PlayerReplicationInfo (which replicates to everyone) on every login.
class ACPatchChanger extends Info
    config(MutExtras_PatchChanger);

struct PlayerPatchEntry
{
    var string SteamID;
    var string PlayerName; // Reference only (for admins matching IDs to players) - never read back for logic
    var string PlayerRank;
    var string PlayerUnit;
};

var config array<PlayerPatchEntry>    CachedPlayerPatches;

function PrivateMessage(PlayerController receiver, coerce string msg)
{
    receiver.TeamMessage(None, msg, '');
}

// Finds the cached patch entry for a player by SteamID, creating one (seeded from
// their current, default-property patch) if this is the first time we've seen them.
function int FindCachedPlayerPatches(PlayerController NewPlayer)
{
    local ACPlayerReplicationInfo   ACPRI;
    local int                       i;
    local bool                      bFound;
    local PlayerPatchEntry          NewEntry;

    ACPRI = ACPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
    if (ACPRI == None)
        return -1;

    for (i = 0; i < CachedPlayerPatches.Length; i++)
    {
        if (CachedPlayerPatches[i].SteamID == class'OnlineSubsystem'.static.UniqueNetIdToString(ACPRI.UniqueId))
        {
            bFound = true;
            return i; //If the ID matches then return the array index
        }
    }
    if (!bFound && Len(class'OnlineSubsystem'.static.UniqueNetIdToString(ACPRI.UniqueId)) != 0)
    {
        NewEntry.SteamID = class'OnlineSubsystem'.static.UniqueNetIdToString(ACPRI.UniqueId);
        NewEntry.PlayerName = ACPRI.PlayerName;
        NewEntry.PlayerRank = ACPRI.PlayerRank;
        NewEntry.PlayerUnit = ACPRI.PlayerUnit;
        CachedPlayerPatches.AddItem(NewEntry);
        SaveConfig();
        i = CachedPlayerPatches.Length - 1;
        return i; //Save the config and return the index
    }
    else
    {
        `log ("[MutExtras PatchChanger] FindCachedPlayerPatches failed!");
        return -1;
    }
}

// Applies a player's cached rank/unit patch on login. ACPRI.PlayerRank/PlayerUnit
// replicate to every client (see ACPlayerReplicationInfo's replication block), so
// this is the only place the patch needs to be set.
function InitPatches(PlayerController NewPlayer)
{
    local ACPlayerReplicationInfo   ACPRI;
    local ROPlayerReplicationInfo   ROPRI;
    local int                       I;

    ACPRI = ACPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
    ROPRI = ROPlayerReplicationInfo(NewPlayer.PlayerReplicationInfo);
    if (ACPRI == None)
        return;

    I = FindCachedPlayerPatches(NewPlayer);

    if (I != -1 && Len(ROPRI.SteamId64) != 0)
    {
        ACPRI.PlayerRank = CachedPlayerPatches[I].PlayerRank;
        ACPRI.PlayerUnit = CachedPlayerPatches[I].PlayerUnit;
    }
}

function MutChangeRank(PlayerController target, string NewRank)
{
    local ACPlayerReplicationInfo   ACPRI;
    local ROPlayerReplicationInfo   ROPRI;
    local int                       I;
    local PlayerPatchEntry          UpdatedEntry;

    ACPRI = ACPlayerReplicationInfo(target.PlayerReplicationInfo);
    ROPRI = ROPlayerReplicationInfo(target.PlayerReplicationInfo);

    if (ACPRI == None)
        return;

    I = FindCachedPlayerPatches(target);

    if (Len(ROPRI.SteamId64) != 0 && I != -1)
    {
        `log("[MutExtras PatchChanger] Changed "$ROPRI.PlayerName$"'s rank patch to "$NewRank);

        UpdatedEntry = CachedPlayerPatches[I];
        UpdatedEntry.PlayerName = ROPRI.PlayerName; // Keep the reference name current
        UpdatedEntry.PlayerRank = NewRank;
        CachedPlayerPatches.Remove(I, 1);
        CachedPlayerPatches.InsertItem(I, UpdatedEntry);
        SaveConfig();

        ACPRI.PlayerRank = NewRank;
    }
    else
    {
        `log("[MutExtras PatchChanger] MutChangeRank failed");
        PrivateMessage(target, "[MutExtras] ChangeRank failed");
    }
}

function MutChangeUnit(PlayerController target, string NewUnit)
{
    local ACPlayerReplicationInfo   ACPRI;
    local ROPlayerReplicationInfo   ROPRI;
    local int                       I;
    local PlayerPatchEntry          UpdatedEntry;

    ACPRI = ACPlayerReplicationInfo(target.PlayerReplicationInfo);
    ROPRI = ROPlayerReplicationInfo(target.PlayerReplicationInfo);

    if (ACPRI == None)
        return;

    I = FindCachedPlayerPatches(target);

    if (Len(ROPRI.SteamId64) != 0 && I != -1)
    {
        `log("[MutExtras PatchChanger] Changed "$ROPRI.PlayerName$"'s unit patch to "$NewUnit);

        UpdatedEntry = CachedPlayerPatches[I];
        UpdatedEntry.PlayerName = ROPRI.PlayerName; // Keep the reference name current
        UpdatedEntry.PlayerUnit = NewUnit;
        CachedPlayerPatches.Remove(I, 1);
        CachedPlayerPatches.InsertItem(I, UpdatedEntry);
        SaveConfig();

        ACPRI.PlayerUnit = NewUnit;
    }
    else
    {
        `log("[MutExtras PatchChanger] MutChangeUnit failed");
        PrivateMessage(target, "[MutExtras] ChangeUnit failed");
    }
}

defaultproperties
{
}
