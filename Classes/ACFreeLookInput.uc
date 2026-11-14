// The free look key and the mouse while free looking (ACFreeLook). It sits in front of the game's own input, so while the
// key is held the mouse turns only the view and the aim gets nothing.
// The key is FreeLookKey in the player's MutExtras_Client.ini, set with "mutate freelookkey V". It is empty until the
// player picks one, and nothing is written to the game's own input settings. The key is taken here and never reaches the
// game, so it can't clash with whatever else it is bound to.
class ACFreeLookInput extends Interaction
    config(MutExtras_Client);

var config bool bFreeLookToggle;        // a press switches free look on and off; hold to look when not set
var config bool bFirstPersonBodyAlways; // the soldier's own body shows in first person all the time, not only while free looking
var config name FreeLookKey;            // the free look key (none until the player sets one)

var ACFreeLook Look;
var bool bWantLook;          // the key is held, or switched on

function bool InputKey(int ControllerId, name Key, EInputEvent EventType, optional float AmountDepressed = 1.f, optional bool bGamepad)
{
    if (FreeLookKey == '' || Key != FreeLookKey)
        return false;

    if (EventType == IE_Pressed)
        bWantLook = bFreeLookToggle ? !bWantLook : true;
    else if (EventType == IE_Released && !bFreeLookToggle)
        bWantLook = false;
    return true;
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
