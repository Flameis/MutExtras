class ACDummyActor extends Actor;

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
        /* for (I=0; I < ROMI.NorthernRoles.length; I++)
        {
            if (instr(ROMI.NorthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundNTank = true;
                // `log ("[MutExtras Debug] Found NTank");
                break;
            }
        }
        for (I=0; I < ROMI.SouthernRoles.length; I++)
        {
            if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundSTank = true;
                // `log ("[MutExtras Debug] Found STank");
                break;
            }
        }

        if (!bFoundNTank)
        {
            NRC.RoleInfoClass = class'ACRoleInfoTankCrewFinnish';
            ROMI.NorthernRoles.additem(NRC);
        }
        if (!bFoundSTank)
        {
            SRC.RoleInfoClass = ROMI.default.SouthernRoles[7].RoleInfoClass;
            ROMI.SouthernRoles.additem(SRC);
        } */
    }
    else if (WW == true)
    {
        for (I=0; I < ROMI.NorthernRoles.length; I++)
        {
            if (instr(ROMI.NorthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundNTank = true;
                // `log ("[MutExtras Debug] Found NTank");
                break;
            }
        }
        for (I=0; I < ROMI.SouthernRoles.length; I++)
        {
            if (instr(ROMI.SouthernRoles[I].RoleInfoClass.Name, "Tank",, true) != -1)
            {
                bFoundSTank = true;
                // `log ("[MutExtras Debug] Found STank");
                break;
            }
        }

        if (!bFoundNTank)
        {
            NRC.RoleInfoClass = class'ACRoleInfoTankCrewFinnish';
            ROMI.NorthernRoles.additem(NRC);
        }
        if (!bFoundSTank)
        {
            SRC.RoleInfoClass = ROMI.default.SouthernRoles[7].RoleInfoClass;
            ROMI.SouthernRoles.additem(SRC);
        }
    }
    else if (GOM == true)
    {
        SRC.RoleInfoClass = class'ACRoleInfoTankCrewSouth';
        NRC.RoleInfoClass = class'ACRoleInfoTankCrewNorth';
        SRC.Count = 255;
        NRC.Count = 255;

        ROMI.SouthernRoles.AddItem(SRC);
		ROMI.NorthernRoles.AddItem(NRC);
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

reliable client function ClientReplaceRoles(bool WW2, bool WW, bool GOM)
{
    ReplaceRoles(WW2, WW, GOM);
}