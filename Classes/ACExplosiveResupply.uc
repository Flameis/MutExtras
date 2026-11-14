// Resupplying at a placed ammo crate (ACUSPlaceableAmmoResupply, ACVCPlaceableAmmoResupply), as the game does it
// (ROPlaceableAmmoResupply.ResupplyTimer and ROVolumeAmmoResupply.ResupplyPlayer), with a wait for explosives:
// - rounds for grenade launchers (the M79, a rifle's grenades such as the MAS-49's) and rocket launchers (the RPG) fill
//   up, then not again for a minute. The game gave one a second, with no wait at all.
// - grenades, satchels and the like come back once a minute, as in the game; it skipped the wait when bandages or
//   carried ammo were given at the same time.
// The waits are the server's, one per soldier, so walking to another crate doesn't skip them. A rifle grenade weapon
// still gets its rifle magazines while its grenades wait.
class ACExplosiveResupply extends Info
    dependson(ROVolumeAmmoResupply);

const EXPLOSIVE_COOLDOWN = 60.0; // seconds after grenade or rocket launcher rounds were filled before more are given

struct ExplosiveWait
{
    var ROPawn P;
    var float Until;     // no explosive rounds before this time
    var bool bFilling;   // being filled now: the wait starts once they are full
};
var array<ExplosiveWait> Waits; // one list for the whole server (one of these actors, made by the first crate)

// The server's one, made when there is none yet
static function ACExplosiveResupply Get(Actor From)
{
    local ACExplosiveResupply R;

    foreach From.DynamicActors(class'ACExplosiveResupply', R)
        return R;
    return From.Spawn(class'ACExplosiveResupply');
}

// Whether a weapon fires explosive rounds: grenade launchers and rocket launchers
static function bool IsExplosiveLauncher(ROWeapon W)
{
    return W != None && IsExplosiveClass(W.Class);
}

static function bool IsExplosiveClass(class<ROWeapon> C)
{
    return C != None && (C.default.WeaponClassType == ROWCT_Explosive || C.default.WeaponClassType == ROWCT_ATRocket
        || ClassIsChildOf(C, class'RORocketWeapon'));
}

// This soldier's place in the waits (made when missing); soldiers who are gone are dropped
function int WaitIndex(ROPawn ROP)
{
    local int i;

    for (i = Waits.Length - 1; i >= 0; i--)
    {
        if (Waits[i].P == None || Waits[i].P.bDeleteMe)
            Waits.Remove(i, 1);
    }
    for (i = 0; i < Waits.Length; i++)
    {
        if (Waits[i].P == ROP)
            return i;
    }
    Waits.Add(1);
    Waits[i].P = ROP;
    return i;
}

// Seconds this soldier still waits for explosive rounds (0 when none)
function float WaitLeft(ROPawn ROP)
{
    local int i;

    for (i = 0; i < Waits.Length; i++)
    {
        if (Waits[i].P == ROP)
            return FMax(0, Waits[i].Until - ROP.WorldInfo.TimeSeconds);
    }
    return 0;
}

// One magazine of a rifle's own ammo, never its grenades
static function bool GiveRifleMagOnly(ROWeapon W)
{
    local bool bGave;

    if (!W.bUseAltFireMode)
        return W.GaveSingleMagAmmoActual();
    W.SwapAmmoTypes(false, true);
    bGave = W.GaveSingleMagAmmoActual();
    W.SwapAmmoTypes(true, true);
    return bGave;
}

// The game's ResupplyPlayer with the explosives' wait. ItemType: 1 a magazine, 2 equipment (grenades and the like), 3
// bandages, 4 carried ammo. Equipment wins over bandages and carried ammo given at the same time.
function bool ResupplyPlayer(ROPawn ROP, out byte GivenMags, bool bResupplyTimeOK, optional out byte ItemType)
{
    local ROPlayerController ROPC;
    local ROPlayerReplicationInfo ROPRI;
    local ROGameReplicationInfo ROGRI;
    local Inventory Inv, NewInv;
    local ROWeapon W;
    local bool bResupplied, bGaveEquipment, bWaiting, bGave;
    local int i, j, NumOtherItems, OtherItemStart, RoleItemsIdx, WI, Primary;
    local int Indexes[`MAX_RESUPPLY_INFOS];
    local byte Count;

    ROPRI = ROPlayerReplicationInfo(ROP.PlayerReplicationInfo);
    ROGRI = ROGameReplicationInfo(ROP.WorldInfo.GRI);
    ROPC = ROPlayerController(ROP.Controller);
    if (ROPRI == None || ROGRI == None || ROP.InvManager == None)
        return false;
    RoleItemsIdx = ROGRI.RoleInfoItemsIdx;
    for (i = 0; i < `MAX_RESUPPLY_INFOS; i++)
        Indexes[i] = -1;

    WI = WaitIndex(ROP);
    bWaiting = ROP.WorldInfo.TimeSeconds < Waits[WI].Until;

    // Weapons: one magazine a second, as the game does; explosive rounds only when not waiting
    for (Inv = ROP.InvManager.InventoryChain; Inv != None; Inv = Inv.Inventory)
    {
        W = ROWeapon(Inv);
        if (W == None || W.IsGrenade() || W.IsA('ROOneShotWeapon'))
            continue;

        if (IsExplosiveLauncher(W))
        {
            if (bWaiting)
                continue;
            bGave = W.GiveInitialAmmo(true);
            if (bGave)
                Waits[WI].bFilling = true;
        }
        else if (W.IsA('RORifleGrenadeWeapon'))
        {
            if (bWaiting)
                bGave = GiveRifleMagOnly(W);
            else
            {
                bGave = W.GiveInitialAmmo(true);
                if (bGave)
                    Waits[WI].bFilling = true;
            }
        }
        else
            bGave = W.GiveInitialAmmo(true);

        if (bGave)
        {
            GivenMags = 1;
            if (ROPC != None)
                ROPC.ClientReceiveResupplyInfoSingleViaWeapon(W, W.InvIndex, true);
            ItemType = 1;
            return true;
        }
    }

    // Nothing more to fill: explosive rounds that were being filled are full now, and their wait starts
    if (Waits[WI].bFilling)
    {
        Waits[WI].bFilling = false;
        Waits[WI].Until = ROP.WorldInfo.TimeSeconds + EXPLOSIVE_COOLDOWN;
    }

    // Grenades, satchels and the like, once the minute's wait is over (as the game)
    if (bResupplyTimeOK && ROPRI.RoleInfo != None && ROPRI.RoleInfo.ActiveWeaponLoadout.PrimaryWeaponIndex != 255)
    {
        Primary = ROPRI.RoleInfo.ActiveWeaponLoadout.PrimaryWeaponIndex;
        NumOtherItems = ROPRI.RoleInfo.Items[RoleItemsIdx].NumOtherItemsForPrimary[Primary];
        if (NumOtherItems != 255)
        {
            OtherItemStart = ROPRI.RoleInfo.Items[RoleItemsIdx].OtherItemsStartIndexForPrimary[Primary];
            for (i = OtherItemStart; i < ROPRI.RoleInfo.Items[RoleItemsIdx].OtherItems.Length && (NumOtherItems == 0 || j < NumOtherItems); i++)
            {
                j++;
                if (i < ROPRI.RoleInfo.GetOtherItemsStart(ROPRI.ClassRank))
                    continue;
                if (ROPRI.RoleInfo.Items[RoleItemsIdx].OtherItems[i].default.WeaponClassType == ROWCT_Melee)
                    continue;
                if (ROPRI.RoleInfo.Items[RoleItemsIdx].OtherItems[i].default.WeaponClassType == ROWCT_ATRocket)
                    continue;
                if (ROInventoryManager(ROP.InvManager).RS2FindInventoryType(ROPRI.RoleInfo.Items[RoleItemsIdx].OtherItems[i]))
                    continue;
                NewInv = ROP.LoadAndCreateInventory(ROPRI.RoleInfo.Items[RoleItemsIdx].OtherItems[i].default.WeaponContentClass[0], true);
                if (NewInv != None)
                {
                    bGaveEquipment = true;
                    bResupplied = true;
                    if (Count < `MAX_RESUPPLY_INFOS)
                        Indexes[Count++] = NewInv.InvIndex;
                }
            }
        }
    }

    if (ROP.NumBandages != ROP.default.NumBandages)
    {
        ROP.NumBandages = ROP.default.NumBandages;
        bResupplied = true;
        ItemType = 3;
        if (Count < `MAX_RESUPPLY_INFOS)
            Indexes[Count++] = `ROII_Bandage;
    }

    if (ROP.bUsedCarriedMGAmmo)
    {
        ROP.bUsedCarriedMGAmmo = false;
        bResupplied = true;
        ItemType = 4;
        if (Count < `MAX_RESUPPLY_INFOS)
            Indexes[Count++] = `ROII_CarriedAmmo;
    }

    if (bGaveEquipment)
        ItemType = 2;

    if (Count > 0 && ROPC != None)
    {
        if (Count > 1)
            ROPC.ClientReceiveResupplyInfo(Indexes);
        else
            ROPC.ClientReceiveResupplyInfoSingle(Indexes[0]);
    }
    return bResupplied;
}

// ROPlaceableAmmoResupply.ResupplyTimer, with ResupplyPlayer above. Run once a second by the crate.
function CrateTimer(ROPlaceableAmmoResupply Crate)
{
    local Pawn Recvr;
    local bool bResupplied, bTimeOK;
    local ROPawn ROP;
    local float ResupplyTime;
    local byte GivenMags, ItemType;
    local RORoleInfo RORI;
    local ROPlayerReplicationInfo ROPRI;

    if (Crate.Role < ROLE_Authority || Crate.RemainingResupplyPoints <= 0)
        return;

    foreach Crate.TouchingActors(class'Pawn', Recvr)
    {
        ROP = ROPawn(Recvr);
        if (ROP == None || ROP.Health <= 0 || ROP.Controller == None)
            continue;
        ResupplyTime = ROP.GetLastResupplyTime();
        ROP.bCurrentResupplyActive = false;
        if (ROP.GetTeamNum() != Crate.Team)
            continue;
        ROP.bTouchingResupply = true;
        ROPRI = ROPlayerReplicationInfo(ROP.Controller.PlayerReplicationInfo);

        bResupplied = false;
        GivenMags = 0;
        ItemType = 0;
        bTimeOK = Crate.WorldInfo.TimeSeconds - ResupplyTime >= Crate.UpdateTime || ResupplyTime == 0;

        if (bTimeOK && ROPRI != None)
        {
            if (ROPRI.RoleIndex == `ROLE_INDEX_SQUADLEADER)
            {
                RORI = ROPRI.RoleInfo;
                if (RORI != None)
                    bResupplied = RORI.GiveNewSLEquipment(ROP);
            }
            else
            {
                bResupplied = Crate.GiveBonusItems(ROP, 0);
                bResupplied = Crate.GiveBonusItems(ROP, 1);
                if (bResupplied && PlayerController(ROP.Controller) != None)
                    PlayerController(ROP.Controller).ReceiveLocalizedMessage(class'ROLocalMessageResupply', 3);
                ROP.UpdateLastResupplyTime();
            }
        }

        bResupplied = ResupplyPlayer(ROP, GivenMags, bTimeOK, ItemType) || bResupplied;
        ROP.bCurrentResupplyActive = bResupplied;
        if (bResupplied)
            ROP.ClientResupplied(true);

        if (bResupplied && ItemType > 0)
        {
            switch (ItemType)
            {
                case 1:
                case 2:
                    Crate.RemainingResupplyPoints -= 5; // the game's weapon and equipment price
                    if (ROP.Controller != Crate.PlacerROPC)
                        Crate.PointAccum += 5;
                    break;
                case 3:
                case 4:
                    Crate.RemainingResupplyPoints -= 1; // bandages and carried ammo
                    if (ROP.Controller != Crate.PlacerROPC)
                        Crate.PointAccum += 1;
                    break;
            }
            if (ROP.Controller != Crate.PlacerROPC && Crate.PointAccum >= 10)
            {
                if (ROGameInfo(Crate.WorldInfo.Game) != None)
                    ROGameInfo(Crate.WorldInfo.Game).ScoreAmmoCrateResupply(Crate.PlacerROPC);
                Crate.PointAccum = 0;
            }
        }
    }

    if (Crate.RemainingResupplyPoints <= 0)
        Crate.CrateDestroyed();
}

defaultproperties
{
}
