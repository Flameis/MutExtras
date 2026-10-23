// Client-side drawing for spectators, fed by ACSpectatorInfo. Interactions are drawn after the HUD whatever HUD class
// the game (or WW2, Winter War, GOM) uses, so this does not replace or subclass any HUD element:
//  - the game's own player / vehicle icon in the team colour for every living player on the overhead map,
//  - a team coloured triangle just above every player in view,
//  - the player nearest the crosshair gets their name in their team colour instead of the triangle, and when they are
//    close, their role icon below the name,
//  - the game's own player name display is turned off while this is on, so the two do not double up.
// While the map is open only the map icons are drawn.
class ACSpectatorInteraction extends Interaction;

var ACSpectatorInfo Info;

var bool bNamesHidden;   // the game's own player name display is switched off
var byte SavedNames;     // the player's own setting for it, put back afterwards
var byte SavedClassNames; // the same for the HUD class's default, which the game may read instead
var byte SavedServerNames; // and the server's setting as this client was told it

const NAME_SCALE = 1.4;
const ROLE_ICON_DIST = 2000.0; // how close (unreal units, 40 meters) a looked at player must be to get their role icon
const NAME_RADIUS = 0.07; // how close to the screen centre (as a part of its width) a player must be to be read as "looked at"

// Colour for a team: whatever the running HUD uses (north is SideColors[0], south SideColors[1])
function color TeamColour(ROHUD H, byte Team)
{
    local color Fallback;

    if (H != None && Team < 2)
        return H.SideColors[Team];

    Fallback.R = 255;
    Fallback.G = 255;
    Fallback.B = 255;
    Fallback.A = 255;
    return Fallback;
}

// The game's own name display (distance setting 0 = none) is turned off while the overlay is on and put back afterwards.
// Where the game reads the setting is not known, so all three places are set: the running HUD, its class default and the
// server's setting as this client was told it. None of them is saved to the player's settings.
function SetDefaultNames(ROHUD H, bool bHide)
{
    local ROGameReplicationInfo ROGRI;

    if (H == None)
        return;

    ROGRI = ROGameReplicationInfo(H.WorldInfo.GRI);

    if (bHide && !bNamesHidden)
    {
        SavedNames = H.MyFriendlyPlayerNames;
        SavedClassNames = H.Class.default.MyFriendlyPlayerNames;
        H.MyFriendlyPlayerNames = 0;
        H.Class.default.MyFriendlyPlayerNames = 0;
        if (ROGRI != None)
        {
            SavedServerNames = ROGRI.FriendlyPlayerNames;
            ROGRI.FriendlyPlayerNames = 0;
        }
        bNamesHidden = true;
    }
    else if (!bHide && bNamesHidden)
    {
        H.MyFriendlyPlayerNames = SavedNames;
        H.Class.default.MyFriendlyPlayerNames = SavedClassNames;
        if (ROGRI != None)
            ROGRI.FriendlyPlayerNames = SavedServerNames;
        bNamesHidden = false;
    }
    else if (bHide && bNamesHidden && ROGRI != None && ROGRI.FriendlyPlayerNames != 0)
    {
        // The server sent its setting again
        SavedServerNames = ROGRI.FriendlyPlayerNames;
        ROGRI.FriendlyPlayerNames = 0;
    }
}

event PostRender(Canvas C)
{
    local PlayerController PC;
    local ROHUD H;
    local bool bActive;

    PC = PlayerController(Outer);
    H = (PC != None) ? ROHUD(PC.myHUD) : None;

    bActive = C != None && Info != None && !Info.bDeleteMe && Info.bSpectating && H != None
        && PC.PlayerReplicationInfo != None && PC.PlayerReplicationInfo.bOnlySpectator;

    SetDefaultNames(H, bActive);
    if (!bActive || !H.bShowHud)
        return;

    // With the map open the names and triangles would only clutter it
    if (H.OverheadMapWidget != None && H.OverheadMapWidget.IsVisible())
        DrawMap(C, H, H.OverheadMapWidget);
    else
        DrawWorld(C, PC, H);
}

// The game's own icon for what the player is in (infantry, a squad leader, tank, truck or one of the helicopters)
function Texture2D MapIcon(ROHUDWidgetOverheadMap OM, byte Packed)
{
    switch (Packed / class'ACSpectatorInfo'.const.KIND_STEP)
    {
        case class'ACSpectatorInfo'.const.KIND_TANK:
            return OM.FriendlyPlayerIconTank;
        case class'ACSpectatorInfo'.const.KIND_TRANSPORT:
            return OM.FriendlyPlayerIconTransport;
        case class'ACSpectatorInfo'.const.KIND_HUEY:
            return OM.FriendlyPlayerIconHelicopterHuey;
        case class'ACSpectatorInfo'.const.KIND_COBRA:
            return OM.FriendlyPlayerIconHelicopterCobra;
        case class'ACSpectatorInfo'.const.KIND_LOACH:
            return OM.FriendlyPlayerIconHelicopterLoach;
        case class'ACSpectatorInfo'.const.KIND_GUNSHIP:
            return OM.FriendlyPlayerIconHelicopterGunship;
    }

    if ((Packed & class'ACSpectatorInfo'.const.FLAG_LEADER) != 0 && OM.SquadLeaderIcon != None)
        return OM.SquadLeaderIcon;
    return OM.FriendlyPlayerIconRifle;
}

// The map is open: every player gets the game's friendly player icon in their team colour, all the same size
function DrawMap(Canvas C, ROHUD H, ROHUDWidgetOverheadMap OM)
{
    local ROHUDWidgetComponent MapComp, IconComp;
    local float ScaleX, ScaleY, X, Y, Size;
    local int i;
    local Texture2D Icon;
    local color Col;

    if (OM.HUDComponents.Length <= class'ROHUDWidgetOverheadMap'.const.ROOMT_FriendlyPlayerStart)
        return;

    MapComp = OM.HUDComponents[class'ROHUDWidgetOverheadMap'.const.ROOMT_Map];
    IconComp = OM.HUDComponents[class'ROHUDWidgetOverheadMap'.const.ROOMT_FriendlyPlayerStart];
    if (MapComp == None || IconComp == None || OM.MaxVisibleWorldX <= OM.MinVisibleWorldX || OM.MaxVisibleWorldY <= OM.MinVisibleWorldY)
        return;

    // North is up and east is right on the map. The map component's positions are relative to the widget, which the
    // game's own icons get added when it renders them (Render(Canvas, CurrentX, CurrentY))
    ScaleX = MapComp.CurWidth / (OM.MaxVisibleWorldY - OM.MinVisibleWorldY);
    ScaleY = MapComp.CurHeight / (OM.MaxVisibleWorldX - OM.MinVisibleWorldX);

    // The size the game gives an infantry icon at this zoom
    Size = (OM.CurrentZoom < 1.75 ? OM.PlayerSizeUnzoomed : OM.PlayerSizeZoomed) * OM.InfantrySize * IconComp.ScaleX;

    for (i = 0; i < class'ACSpectatorInfo'.const.MAX_SPECTATED; i++)
    {
        if (Info.SpecPRI[i] == None)
            continue;
        if (Info.SpecLoc[i].X < OM.MinVisibleWorldX || Info.SpecLoc[i].X > OM.MaxVisibleWorldX
            || Info.SpecLoc[i].Y < OM.MinVisibleWorldY || Info.SpecLoc[i].Y > OM.MaxVisibleWorldY)
            continue;

        Icon = MapIcon(OM, Info.SpecInfo[i]);
        if (Icon == None)
            continue;

        X = OM.CurrentX + MapComp.CurX + (Info.SpecLoc[i].Y - OM.MinVisibleWorldY) * ScaleX;
        Y = OM.CurrentY + MapComp.CurY + MapComp.CurHeight - (Info.SpecLoc[i].X - OM.MinVisibleWorldX) * ScaleY;

        Col = TeamColour(H, Info.SpecInfo[i] & class'ACSpectatorInfo'.const.FLAG_SOUTH);
        C.SetDrawColor(Col.R, Col.G, Col.B, 255);
        C.SetPos(X - Size * 0.5, Y - Size * 0.5);
        C.DrawTile(Icon, Size, Size, 0, 0, Icon.SizeX, Icon.SizeY);
    }
}

// Player on the screen, or false when they are behind the camera or off the edge
function bool ProjectToScreen(Canvas C, vector Loc, vector CamLoc, vector ViewDir, out vector Screen)
{
    if (((Loc - CamLoc) Dot ViewDir) <= 0)
        return false;

    Screen = C.Project(Loc);
    return Screen.X >= 0 && Screen.X <= C.ClipX && Screen.Y >= 0 && Screen.Y <= C.ClipY;
}

// A pawn the client can see for the entry if there is one (exact position and size), none otherwise
function Pawn FindPawn(PlayerController PC, ROPlayerReplicationInfo PRI)
{
    local Pawn P;

    foreach PC.WorldInfo.AllPawns(class'Pawn', P)
    {
        if (P.PlayerReplicationInfo == PRI)
            return P;
    }
    return None;
}

function vector HeadLocation(Pawn P, vector Fallback)
{
    if (P == None)
        return Fallback + vect(0, 0, 40);

    return P.Location + vect(0, 0, 1) * (P.CylinderComponent.CollisionHeight - 4);
}

function DrawWorld(Canvas C, PlayerController PC, ROHUD H)
{
    local vector CamLoc, ViewDir, Head, Screen;
    local rotator CamRot;
    local Pawn P;
    local int i, Best;
    local float D, BestD, Scale, Size, W, TH, Dist, TextScale, IconSize, IconBottom;
    local color Col;
    local string PlayerName;
    local Texture2D RoleIcon;

    PC.GetPlayerViewPoint(CamLoc, CamRot);
    ViewDir = vector(CamRot);
    Scale = FMax(1.0, C.ClipY / 1080.0);

    // The player looked at: nearest the crosshair, close enough to it and not behind a wall
    Best = -1;
    BestD = C.ClipX * NAME_RADIUS;
    for (i = 0; i < class'ACSpectatorInfo'.const.MAX_SPECTATED; i++)
    {
        if (Info.SpecPRI[i] == None)
            continue;
        P = FindPawn(PC, Info.SpecPRI[i]);
        if (P != None && P == PC.ViewTarget)
            continue;

        Head = HeadLocation(P, Info.SpecLoc[i]);
        if (!ProjectToScreen(C, Head, CamLoc, ViewDir, Screen))
            continue;

        D = Sqrt(Square(Screen.X - C.ClipX * 0.5) + Square(Screen.Y - C.ClipY * 0.5));
        if (D < BestD && PC.FastTrace(Head, CamLoc))
        {
            Best = i;
            BestD = D;
        }
    }

    for (i = 0; i < class'ACSpectatorInfo'.const.MAX_SPECTATED; i++)
    {
        if (Info.SpecPRI[i] == None)
            continue;
        P = FindPawn(PC, Info.SpecPRI[i]);
        if (P != None && P == PC.ViewTarget)
            continue;

        Head = HeadLocation(P, Info.SpecLoc[i]);
        if (!ProjectToScreen(C, Head, CamLoc, ViewDir, Screen))
            continue;

        Col = TeamColour(H, Info.SpecInfo[i] & class'ACSpectatorInfo'.const.FLAG_SOUTH);
        Dist = VSize(Head - CamLoc);

        if (i == Best)
        {
            // Close up, the role they picked is shown under the name, as the game does for friendlies
            RoleIcon = None;
            if (Dist <= ROLE_ICON_DIST && Info.SpecPRI[i].RoleInfo != None)
                RoleIcon = Info.SpecPRI[i].RoleInfo.ClassIcon;

            IconSize = (RoleIcon != None) ? 40.0 * Scale : 0.0;
            IconBottom = Screen.Y - 1 * Scale;

            PlayerName = Info.SpecPRI[i].PlayerName;
            C.Font = class'Engine'.static.GetMediumFont();
            TextScale = NAME_SCALE * Scale;
            C.TextSize(PlayerName, W, TH);
            W *= TextScale;
            TH *= TextScale;
            C.SetDrawColor(0, 0, 0, 255);
            C.SetPos(Screen.X - W * 0.5 + 2, IconBottom - IconSize - TH + 2);
            C.DrawText(PlayerName, true, TextScale, TextScale);
            C.SetPos(Screen.X - W * 0.5 - 1, IconBottom - IconSize - TH - 1);
            C.DrawText(PlayerName, true, TextScale, TextScale);
            C.SetDrawColor(Col.R, Col.G, Col.B, 255);
            C.SetPos(Screen.X - W * 0.5, IconBottom - IconSize - TH);
            C.DrawText(PlayerName, true, TextScale, TextScale);

            if (RoleIcon != None)
            {
                C.SetDrawColor(Col.R, Col.G, Col.B, 255);
                C.SetPos(Screen.X - IconSize * 0.5, IconBottom - IconSize);
                C.DrawTile(RoleIcon, IconSize, IconSize, 0, 0, RoleIcon.SizeX, RoleIcon.SizeY);
            }
        }
        else
        {
            // Smaller the further away, down to a minimum that can still be seen, sitting just above their head
            Size = FClamp(22000.0 / FMax(Dist, 1.0), 12.0, 26.0) * Scale;
            DrawTriangle(C, Screen.X, Screen.Y, Size, Col);
        }
    }
}

// Filled triangle pointing down at (X, Y), with a black edge
function DrawTriangle(Canvas C, float X, float Y, float Size, color Col)
{
    local float Row, Half, Top;
    local color Black;

    Black.A = 255;
    Top = Y - Size;

    for (Row = 0; Row <= Size + 4; Row += 1.0)
    {
        Half = (Size + 4 - Row) * 0.5;
        C.Draw2DLine(X - Half - 2, Top - 2 + Row, X + Half + 2, Top - 2 + Row, Black);
    }
    for (Row = 0; Row <= Size; Row += 1.0)
    {
        Half = (Size - Row) * 0.5;
        C.Draw2DLine(X - Half, Top + Row, X + Half, Top + Row, Col);
    }
}

defaultproperties
{
}
