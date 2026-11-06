// The free look key and the mouse while free looking (ACFreeLook). It sits in front of the game's own input, so while the
// key is held the mouse turns only the view and the aim gets nothing.
// The key is whatever the player binds to FreeLook ("setbind V FreeLook" in the console). The game has no FreeLook
// command: this watches the keys bound to it, so a key bound only to FreeLook is taken here and never reaches the game. A
// key bound to FreeLook and something else ("INF_Prone_Toggle | FreeLook") does both. FreeLookKey in
// MutExtras_Client.ini is a key that does it without a binding.
class ACFreeLookInput extends Interaction
    config(MutExtras_Client);

const BIND_COMMAND = "FreeLook";
const KEYS_CHECK_TIME = 2.0; // seconds between looks at the bindings (setbind can change them at any time)

var config bool bFreeLookToggle;        // a press switches free look on and off; hold to look when not set
var config bool bFirstPersonBodyAlways; // the soldier's own body shows in first person all the time, not only while free looking
var config name FreeLookKey;            // a key that free looks without a binding (none when not set)

var ACFreeLook Look;
var bool bWantLook;          // the key is held, or switched on
var array<name> LookKeys;    // the keys that free look
var array<byte> LookOnly;    // for each: 1 if FreeLook is all it is bound to, so it is taken here
var float KeysCheckedAt;

// Whether a binding's command has FreeLook in it, and whether that is all it has
static function bool BindsFreeLook(string Command, out byte bOnly)
{
    local array<string> Parts;
    local string Part;
    local int i;
    local bool bFound;

    ParseStringIntoArray(Command, Parts, "|", true);
    bOnly = 1;
    for (i = 0; i < Parts.Length; i++)
    {
        Part = Repl(Repl(Parts[i], " ", ""), Chr(9), ""); // a command name has no spaces in it
        if (Part ~= BIND_COMMAND)
            bFound = true;
        else if (Part != "")
            bOnly = 0;
    }
    return bFound;
}

function RefreshKeys()
{
    local PlayerController PC;
    local int i;
    local byte bOnly;

    PC = PlayerController(Outer);
    LookKeys.Length = 0;
    LookOnly.Length = 0;
    if (PC != None && PC.PlayerInput != None)
    {
        for (i = 0; i < PC.PlayerInput.Bindings.Length; i++)
        {
            if (BindsFreeLook(PC.PlayerInput.Bindings[i].Command, bOnly))
            {
                LookKeys.AddItem(PC.PlayerInput.Bindings[i].Name);
                LookOnly.AddItem(bOnly);
            }
        }
    }
    if (FreeLookKey != '' && LookKeys.Find(FreeLookKey) == INDEX_NONE)
    {
        LookKeys.AddItem(FreeLookKey);
        LookOnly.AddItem(1);
    }
    if (PC != None)
        KeysCheckedAt = PC.WorldInfo.RealTimeSeconds;
}

function bool InputKey(int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed = 1.f, optional bool bGamepad)
{
    local PlayerController PC;
    local int Index;

    PC = PlayerController(Outer);
    if (PC == None)
        return false;
    if (PC.WorldInfo.RealTimeSeconds - KeysCheckedAt > KEYS_CHECK_TIME || KeysCheckedAt == 0)
        RefreshKeys();

    Index = LookKeys.Find(Key);
    if (Index == INDEX_NONE)
        return false;

    if (EventType == IE_Pressed)
        bWantLook = bFreeLookToggle ? !bWantLook : true;
    else if (EventType == IE_Released && !bFreeLookToggle)
        bWantLook = false;
    return LookOnly[Index] == 1;
}

// While free looking the mouse turns the view, with the player's own sensitivity and invert setting
function bool InputAxis(int ControllerId, name Key, float Delta, float DeltaTime, optional bool bGamepad)
{
    local PlayerController PC;
    local float Sens;

    PC = PlayerController(Outer);
    if (Look == None || !Look.bLooking || PC == None || PC.PlayerInput == None)
        return false;

    Sens = PC.PlayerInput.MouseSensitivity;
    if (Key == 'MouseX')
    {
        Look.AddMouse(Delta * Sens * (PC.PlayerInput.bInvertTurn ? -1.0 : 1.0), 0);
        return true;
    }
    if (Key == 'MouseY')
    {
        Look.AddMouse(0, Delta * Sens * (PC.PlayerInput.bInvertMouse ? -1.0 : 1.0));
        return true;
    }
    return false;
}

defaultproperties
{
    OnReceivedNativeInputKey=InputKey
    OnReceivedNativeInputAxis=InputAxis
}
