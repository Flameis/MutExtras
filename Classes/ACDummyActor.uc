class ACDummyActor extends Actor;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    
    // Set up a timer to periodically check and fix the pilot flag for tanker roles
    SetTimer(2.0, true, 'FixTankerPilotFlag');
}

simulated function FactionSetup(ENorthernForces MyNorthForce, ESouthernForces MySouthForce, bool bAITRoles)
{
    local ROMapInfo ROMI;
    
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());
    
    if (ROMI == None)
        return;
    
    `log("[MutExtras Debug] ACDummyActor Setting up factions: North="$MyNorthForce$" South="$MySouthForce);
    
    ROMI.NorthernForce = ENorthernForces(min(1, MyNorthForce));
    ROMI.SouthernForce = ESouthernForces(min(3, MySouthForce));

    if (!bAITRoles)
    {
        ROMI.bInitializedRoles = false;
        ROMI.InitRolesForGametype(WorldInfo.GetGameClass(), 64, false);
    }
}

reliable client function ClientFactionSetup(ENorthernForces MyNorthForce, ESouthernForces MySouthForce, bool bAITRoles)
{
    FactionSetup(MyNorthForce, MySouthForce, bAITRoles);
}

simulated function ReplaceRoles(bool WW2, bool WW, bool GOM)
{
    local ROMapInfo ROMI;
    local RORoleCount SRC, NRC;
    local array<RORoleCount> RORCAN, RORCAS;
	local int 					I;
    local bool          bFoundNTank, bFoundSTank, bFoundPilot;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    RORCAN = ROMI.NorthernRoles;
    RORCAS = ROMI.SouthernRoles;

    ROMI.NorthernRoles.Length = 0;
    ROMI.SouthernRoles.Length = 0;
    ROMI.NorthernRoles.Length = RORCAN.Length;
    ROMI.SouthernRoles.Length = RORCAS.Length;

    ROMI.NorthernRoles = RORCAN;
    ROMI.SouthernRoles = RORCAS;

    for (I=0; I < ROMI.SouthernRoles.length; I++)
    {
		if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Pilot",, true) != -1)
        {
            bFoundPilot = true;
            // `log ("[MutExtras Debug] bFoundPilot");
			break;
        }
    }

    if (bFoundPilot)
    {
        SRC.RoleInfoClass = class'ACRoleInfoPilotSouth';
        ROMI.SouthernRoles.additem(SRC);

        SRC.RoleInfoClass = class'ACRoleInfoTransportPilotSouth';
        ROMI.SouthernRoles.additem(SRC);
    }

    if (WW2 == true)
    {
        for (I=0; I < ROMI.NorthernRoles.length; I++)
        {
            if (instr(ROMI.NorthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundNTank = true;
                `log ("[MutExtras Debug] Found NTank");
                break;
            }
        }
        for (I=0; I < ROMI.SouthernRoles.length; I++)
        {
            if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundSTank = true;
                `log ("[MutExtras Debug] Found STank");
                break;
            }
        }

        if (!bFoundNTank)
        {
            NRC.RoleInfoClass = GetWW2AxisTankerClass();
            if (NRC.RoleInfoClass != none)
            {
                NRC.Count = 255;
                ROMI.NorthernRoles.additem(NRC);
                `log ("[MutExtras] Added Axis tanker (Northern): "$NRC.RoleInfoClass);
            }
        }
        if (!bFoundSTank)
        {
            SRC.RoleInfoClass = GetWW2AlliedTankerClass();
            if (SRC.RoleInfoClass != none)
            {
                SRC.Count = 255;
                ROMI.SouthernRoles.additem(SRC);
                `log ("[MutExtras] Added Allied tanker (Southern): "$SRC.RoleInfoClass);
            }
        }
    }
    else if (WW == true)
    {
        for (I=0; I < ROMI.NorthernRoles.length; I++)
        {
            if (instr(ROMI.NorthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundNTank = true;
                `log ("[MutExtras Debug] Found NTank");
                break;
            }
        }
        for (I=0; I < ROMI.SouthernRoles.length; I++)
        {
            if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundSTank = true;
                `log ("[MutExtras Debug] Found STank");
                break;
            }
        }

        if (!bFoundNTank)
        {
            NRC.RoleInfoClass = GetWWAxisTankerClass();
            if (NRC.RoleInfoClass != none)
            {
                NRC.Count = 255;
                ROMI.NorthernRoles.additem(NRC);
                `log ("[MutExtras] Added Finnish tanker (Northern): "$NRC.RoleInfoClass);
            }
        }
        if (!bFoundSTank)
        {
            SRC.RoleInfoClass = GetWWAlliedTankerClass();
            if (SRC.RoleInfoClass != none)
            {
                SRC.Count = 255;
                ROMI.SouthernRoles.additem(SRC);
                `log ("[MutExtras] Added Soviet tanker (Southern): "$SRC.RoleInfoClass);
            }
        }
    }
    else if (GOM == true)
    {
        NRC.RoleInfoClass = class'ACRoleInfoTankCrewNorth';
        SRC.RoleInfoClass = class'ACRoleInfoTankCrewSouth';
        NRC.Count = 255;
        SRC.Count = 255;

		ROMI.NorthernRoles.AddItem(NRC);
        ROMI.SouthernRoles.AddItem(SRC);
    }

    //Infinite roles
    for (i = 0; i < ROMI.SouthernRoles.length; i++)
    {
        ROMI.SouthernRoles[i].Count = 255;
    }    
    for (i = 0; i < ROMI.NorthernRoles.length; i++)
    {
        ROMI.NorthernRoles[i].Count = 255;
    }
}

// Helper function to get the Finnish tanker class for Winter War
function class<RORoleInfo> GetWWAxisTankerClass()
{
    local class<RORoleInfo> TankerClass;
    
    // Winter War Axis is always Finnish
    TankerClass = class<RORoleInfo>(DynamicLoadObject("WinterWar.WWRoleInfoAxisTankCrew", class'Class', true));
    
    if (TankerClass == none)
    {
        `log ("[MutExtras] Warning: Could not load Winter War Finnish tanker class");
    }
    else
    {
        `log ("[MutExtras] Loaded Winter War Finnish tanker class");
    }
    
    return TankerClass;
}

// Helper function to get the Soviet tanker class for Winter War
function class<RORoleInfo> GetWWAlliedTankerClass()
{
    local class<RORoleInfo> TankerClass;
    
    // Winter War Allies is always Soviet
    TankerClass = class<RORoleInfo>(DynamicLoadObject("WinterWar.WWRoleInfoAlliesTankCrew", class'Class', true));
    
    if (TankerClass == none)
    {
        `log ("[MutExtras] Warning: Could not load Winter War Soviet tanker class");
    }
    else
    {
        `log ("[MutExtras] Loaded Winter War Soviet tanker class");
    }
    
    return TankerClass;
}

reliable client function ClientReplaceRoles(bool WW2, bool WW, bool GOM)
{
    ReplaceRoles(WW2, WW, GOM);
}

// Check and fix bIsPilot flag for dynamically added tanker roles
// Figure out a better way to do this later
simulated function FixTankerPilotFlag()
{
    local ROPlayerController ROPC;
    local RORoleInfo CurrentRole;
    local string RoleClassName;
    
    ROPC = ROPlayerController(Owner);
    
    if (ROPC != none && ROPC.PlayerReplicationInfo != none)
    {
        CurrentRole = ROPC.GetRoleInfo();
        
        if (CurrentRole != none && CurrentRole.bIsPilot)
        {
            RoleClassName = string(CurrentRole.Class.Name);
            
            // Check if this is one of the dynamically added tanker roles
            if (InStr(RoleClassName, "WW2RoleInfo", , true) != -1 && InStr(RoleClassName, "Tanker", , true) != -1)
            {
                CurrentRole.bIsPilot = false;
                `log ("[MutExtras] Fixed bIsPilot for WW2 tanker role: "$RoleClassName);
            }
            else if (InStr(RoleClassName, "WWRoleInfo", , true) != -1 && InStr(RoleClassName, "TankCrew", , true) != -1)
            {
                CurrentRole.bIsPilot = false;
                `log ("[MutExtras] Fixed bIsPilot for Winter War tanker role: "$RoleClassName);
            }
            else if (InStr(RoleClassName, "ACRoleInfoTankCrew", , true) != -1)
            {
                CurrentRole.bIsPilot = false;
                `log ("[MutExtras] Fixed bIsPilot for GOM tanker role: "$RoleClassName);
            }
        }
    }
}

// Helper function to get the appropriate Axis tanker class based on the faction
function class<RORoleInfo> GetWW2AxisTankerClass()
{
    local int AxisFaction;
    local string TankerClassName;
    local class<RORoleInfo> TankerClass;
    
    // Get the Axis faction index from WW2MapInfo
    // We need to get the AxisForces enum value through dynamic property lookup
    AxisFaction = GetWW2AxisFaction();
    
    // Map faction index to tanker class name based on EAxisFactions enum:
    // 0 = Wehrmacht, 1 = Wehrmacht_Winter, 2 = DAK, 3 = FMJ, 4 = Italy
    // 5 = Italy_Black, 6 = IJA, 7 = SNLF, 8 = SS
    switch (AxisFaction)
    {
        case 0: // Wehrmacht
        case 1: // Wehrmacht Winter
            TankerClassName = "WW2.WW2RoleInfoAxis_WH_Tanker";
            break;
        case 2: // DAK (Afrika Korps)
            TankerClassName = "WW2.WW2RoleInfoAxis_WH_Tanker"; // DAK uses Wehrmacht tanker
            break;
        case 3: // FMJ (Fallschirmjäger)
            TankerClassName = "WW2.WW2RoleInfoAxis_WH_Tanker"; // FJ uses Wehrmacht tanker
            break;
        case 4: // Italy
        case 5: // Italy Black
            TankerClassName = "WW2.WW2RoleInfoAxis_WH_Tanker"; // Italy uses Wehrmacht tanker (if Italy-specific doesn't exist)
            break;
        case 6: // IJA (Imperial Japanese Army)
        case 7: // SNLF (Special Naval Landing Forces)
            TankerClassName = "WW2.WW2RoleInfoAxis_IJA_Tanker";
            break;
        case 8: // SS
            TankerClassName = "WW2.WW2RoleInfoAxis_WH_Tanker"; // SS uses Wehrmacht tanker
            break;
        default:
            TankerClassName = "WW2.WW2RoleInfoAxis_WH_Tanker"; // Default to Wehrmacht
            break;
    }
    
    // Dynamically load the class
    TankerClass = class<RORoleInfo>(DynamicLoadObject(TankerClassName, class'Class', true));
    
    if (TankerClass == none)
    {
        `log ("[MutExtras] Warning: Could not load Axis tanker class: "$TankerClassName);
    }
    
    return TankerClass;
}

// Helper function to get the appropriate Allied tanker class based on the faction
function class<RORoleInfo> GetWW2AlliedTankerClass()
{
    local int AlliedFaction;
    local string TankerClassName;
    local class<RORoleInfo> TankerClass;
    
    // Get the Allied faction index from WW2MapInfo
    AlliedFaction = GetWW2AlliedFaction();
    
    // Map faction index to tanker class name based on EAlliedFactions enum:
    // 0 = US_Airborne, 1 = US_Army, 2 = Commonwealth, 3 = Commonwealth_Africa
    // 4 = Commonwealth_SF, 5 = US_Marines, 6 = SovietUnion, 7 = SovietUnion_Winter
    // 8 = NRA, 9 = NRAB, 10 = Italy, 11 = AUS, 12 = France
    switch (AlliedFaction)
    {
        case 0: // US Airborne
        case 1: // US Army
            TankerClassName = "WW2.WW2RoleInfoAllies_USA_Tanker";
            break;
        case 2: // Commonwealth
        case 3: // Commonwealth Africa
        case 4: // Commonwealth SF
            TankerClassName = "WW2.WW2RoleInfoAllies_CW_Tanker";
            break;
        case 5: // US Marines
            TankerClassName = "WW2.WW2RoleInfoAllies_USMC_Tanker";
            break;
        case 6: // Soviet Union
        case 7: // Soviet Union Winter
            TankerClassName = "WW2.WW2RoleInfoAllies_Sov_Tanker";
            break;
        case 8: // NRA
        case 9: // NRAB
            TankerClassName = "WW2.WW2RoleInfoAllies_USA_Tanker"; // Chinese use USA tanker as fallback
            break;
        case 10: // Italy (Allied)
            TankerClassName = "WW2.WW2RoleInfoAllies_CW_Tanker"; // Italy uses Commonwealth as fallback
            break;
        case 11: // AUS
            TankerClassName = "WW2.WW2RoleInfoAllies_CW_Tanker"; // Australia uses Commonwealth
            break;
        case 12: // France
            TankerClassName = "WW2.WW2RoleInfoAllies_USA_Tanker"; // France uses USA as fallback
            break;
        default:
            TankerClassName = "WW2.WW2RoleInfoAllies_USA_Tanker"; // Default to USA
            break;
    }
    
    // Dynamically load the class
    TankerClass = class<RORoleInfo>(DynamicLoadObject(TankerClassName, class'Class', true));
    
    if (TankerClass == none)
    {
        `log ("[MutExtras] Warning: Could not load Allied tanker class: "$TankerClassName);
    }
    
    return TankerClass;
}

// Get Axis faction from WW2MapInfo by inspecting existing roles
function int GetWW2AxisFaction()
{
    local ROMapInfo ROMI;
    local int i;
    local string RoleName;
    
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());
    
    // Inspect Northern (Axis) roles to determine faction
    for (i = 0; i < ROMI.NorthernRoles.Length; i++)
    {
        if (ROMI.NorthernRoles[i].RoleInfoClass != none)
        {
            RoleName = string(ROMI.NorthernRoles[i].RoleInfoClass.Name);
            
            // Check for faction-specific role identifiers
            if (InStr(RoleName, "IJA", , true) != -1 || InStr(RoleName, "Japanese", , true) != -1)
            {
                `log ("[MutExtras] Detected Axis faction: IJA (6)");
                return 6; // IJA
            }
            else if (InStr(RoleName, "SNLF", , true) != -1)
            {
                `log ("[MutExtras] Detected Axis faction: SNLF (7)");
                return 7; // SNLF
            }
            else if (InStr(RoleName, "DAK", , true) != -1 || InStr(RoleName, "Afrika", , true) != -1)
            {
                `log ("[MutExtras] Detected Axis faction: DAK (2)");
                return 2; // DAK
            }
            else if (InStr(RoleName, "ITA", , true) != -1 || InStr(RoleName, "Italian", , true) != -1)
            {
                `log ("[MutExtras] Detected Axis faction: Italy (4)");
                return 4; // Italy
            }
            else if (InStr(RoleName, "SS", , true) != -1)
            {
                `log ("[MutExtras] Detected Axis faction: SS (8)");
                return 8; // SS
            }
            else if (InStr(RoleName, "FMJ", , true) != -1 || InStr(RoleName, "Fallschirm", , true) != -1)
            {
                `log ("[MutExtras] Detected Axis faction: FMJ (3)");
                return 3; // FMJ
            }
        }
    }
    
    // Default to Wehrmacht
    `log ("[MutExtras] Detected Axis faction: Wehrmacht (0) [default]");
    return 0; // Wehrmacht
}

// Get Allied faction from WW2MapInfo by inspecting existing roles
function int GetWW2AlliedFaction()
{
    local ROMapInfo ROMI;
    local int i;
    local string RoleName;
    
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());
    
    // Inspect Southern (Allied) roles to determine faction
    for (i = 0; i < ROMI.SouthernRoles.Length; i++)
    {
        if (ROMI.SouthernRoles[i].RoleInfoClass != none)
        {
            RoleName = string(ROMI.SouthernRoles[i].RoleInfoClass.Name);
            
            // Check for faction-specific role identifiers
            if (InStr(RoleName, "Sov", , true) != -1 || InStr(RoleName, "Soviet", , true) != -1 || InStr(RoleName, "Russian", , true) != -1)
            {
                `log ("[MutExtras] Detected Allied faction: Soviet (6)");
                return 6; // Soviet Union
            }
            else if (InStr(RoleName, "USMC", , true) != -1 || InStr(RoleName, "Marine", , true) != -1)
            {
                `log ("[MutExtras] Detected Allied faction: USMC (5)");
                return 5; // US Marines
            }
            else if (InStr(RoleName, "CW", , true) != -1 || InStr(RoleName, "Commonwealth", , true) != -1 || InStr(RoleName, "British", , true) != -1)
            {
                `log ("[MutExtras] Detected Allied faction: Commonwealth (2)");
                return 2; // Commonwealth
            }
            else if (InStr(RoleName, "AUS", , true) != -1 || InStr(RoleName, "Australian", , true) != -1)
            {
                `log ("[MutExtras] Detected Allied faction: Australia (11)");
                return 11; // AUS
            }
            else if (InStr(RoleName, "NRA", , true) != -1 || InStr(RoleName, "Chinese", , true) != -1)
            {
                `log ("[MutExtras] Detected Allied faction: NRA (8)");
                return 8; // NRA
            }
        }
    }
    
    // Default to USA
    `log ("[MutExtras] Detected Allied faction: USA (1) [default]");
    return 1; // US Army
}