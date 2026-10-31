// A wind direction MutExtras adds so smoke drifts on the wind: on a map that has none, or (bOverrideMapWind) to turn the
// map's own wind to the direction set in WindDirection. It is sent to every player, because the smoke is drawn on each
// player's own computer. When it replaces the map's wind, each computer turns the map's own wind sources to face the same
// way (they keep their strength) and this one is switched off, so the wind isn't doubled.
class ACWindSource extends WindDirectionalSource;

var repnotify bool bReplacesMapWind;

replication
{
    if (bNetInitial)
        bReplacesMapWind;
}

simulated event ReplicatedEvent(name VarName)
{
    if (VarName == 'bReplacesMapWind')
    {
        if (bReplacesMapWind)
            ReplaceMapWind();
    }
    else
        Super.ReplicatedEvent(VarName);
}

// Turns every other wind source to face this one's way, then switches this one off
simulated function ReplaceMapWind()
{
    local WindDirectionalSource Wind;

    bReplacesMapWind = true;
    foreach AllActors(class'WindDirectionalSource', Wind)
    {
        if (Wind != self)
            Wind.SetRotation(Rotation);
    }
    if (Component != None)
        DetachComponent(Component);
}

defaultproperties
{
    RemoteRole=ROLE_SimulatedProxy
    bAlwaysRelevant=true
    bReplicateMovement=true
    bNoDelete=false
}
