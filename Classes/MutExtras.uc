// 29th Extras Mutator
// Created by T/5 Scovel for the 29th Infantry Division Realism Unit
// ====================================================
// Test Branch Update (November 2022)
// ====================================================
// Code tech: T/5 Scovel
// ====================================================
class MutExtras extends ROMutator
	config(MutExtras_Server);

var RORoleInfoClasses       RORICSouth;
var RORoleInfoClasses       RORICNorth;
var array<ACDummyActor>     DummyActors;

var bool                    bisVanilla;
var array<Byte> 		    HitNum;
var array<String> 	        HitVicName;

var bool                    bAmbientFallbackChecked; // whether CheckAmbientSoundNeedsFallback has run yet this level
var bool                    bAmbientSoundNeedsClientFallback; // true if no client-side trigger reaches the level's AkStartAmbientSound node

var config Bool             bAITRoles, bMACVSOGRoles;
var config ENorthernForces  MyNorthForce;
var config ESouthernForces  MySouthForce;
var config bool             bUseDefaultFactions;
var config bool             bSmokeForEveryone;
var config bool             bLightGetGrenade;
var config bool             bAllAITWeapons;
var config bool             bEnableAmbientSoundFix;

// ====================================================
// Initialization
// ====================================================
simulated function PreBeginPlay()
{
    local Mutator mut;
    `log ("[MutExtras Debug] init");

    // Clean up duplicate MutExtras instances
    for (mut = ROGameInfo(WorldInfo.Game).BaseMutator; mut != none; mut = mut.NextMutator)
    {
        if (mut == ROGameInfo(WorldInfo.Game).BaseMutator && InStr(string(mut.name), "MutExtras",,true) != -1 && mut != self)
        {
            ROGameInfo(WorldInfo.Game).BaseMutator = mut.NextMutator;
            mut.Destroy();
        }
        else if (InStr(string(mut.NextMutator.name), "MutExtras",,true) != -1 && mut.NextMutator != self) 
        {
            mut.NextMutator = mut.NextMutator.NextMutator;
            mut.NextMutator.Destroy();
        }
    }
    
    // Check for other mods (WW2, Winter War, GOM) and set up vanilla replacements if none are present
    if (!IsWW2There() && !IsWWThere() && !IsMutThere("GOM"))
    {
        bisVanilla = true;
        ROGameInfo(WorldInfo.Game).PlayerControllerClass        = class'ACPlayerController';
        ROGameInfo(WorldInfo.Game).PlayerReplicationInfoClass   = class'ACPlayerReplicationInfo';
        ROGameInfo(WorldInfo.Game).PawnHandlerClass             = class'ACPawnHandler';
        ROGameInfo(WorldInfo.Game).HUDType                      = class'ACHUD';

        ROGameInfo(WorldInfo.Game).SouthRoleContentClasses = RORICSouth;
        ROGameInfo(WorldInfo.Game).NorthRoleContentClasses = RORICNorth;
    }

    ModifyVolumes();

    super.PreBeginPlay();
}

// ====================================================
// Player Modification
// ====================================================
function ModifyPlayer(Pawn Other)
{
    local ACPlayerReplicationInfo ACPRI;
    ACPRI = ACPlayerReplicationInfo(Other.PlayerReplicationInfo);

    //Make sure the pawns on the server have the rank and unit for the 29th helmet
    // if (ACPRI != None && ACPawn(Other) != None)
    // {
    ACPawn(Other).PlayerRank = ACPRI.PlayerRank;
    ACPawn(Other).PlayerUnit = ACPRI.PlayerUnit;
        
    //     // Force helmet update on the client
    //     ACPawn(Other).SetUnitAndRank();
    // }

    super.ModifyPlayer(Other);
}

// ====================================================
// Login/Logout Handling
// ====================================================
simulated function NotifyLogin(Controller NewPlayer)
{
    local ACPlayerController ACPC;
    local ACDummyActor DummyActor;

    // Spawn a dummy actor for each player to handle client-side replication
    DummyActor = Spawn(class'ACDummyActor', NewPlayer);
    DummyActors.AddItem(DummyActor);
    //`log ("[MutExtras LogIn] Spawning "$DummyActor);

    if (bEnableAmbientSoundFix)
    {
        if (!bAmbientFallbackChecked)
        {
            CheckAmbientSoundNeedsFallback();
        }
        if (bAmbientSoundNeedsClientFallback)
        {
            DummyActor.ClientTriggerAmbientSound();
        }
    }

    //SetTimer(10, false, 'CheckLoaded');

    `log("bisVanilla "$bisVanilla);
    // If running in vanilla mode, replace standard classes with AC variants
    if (bisVanilla)
    {
        // Handle faction setup if custom factions are enabled
        if (!bUseDefaultFactions)
        {
            DummyActor.FactionSetup(MyNorthForce, MySouthForce, bAITRoles, bMACVSOGRoles);
            DummyActor.ClientFactionSetup(MyNorthForce, MySouthForce, bAITRoles, bMACVSOGRoles);
        }

        ACPC = ACPlayerController(NewPlayer);

        if (ACPC != None)
        {
            ACPC.ReplacePawnHandler();
            ACPC.ClientReplacePawnHandler();
            ACPC.ReplaceRoles(bAITRoles, bMACVSOGRoles);
            ACPC.ClientReplaceRoles(bAITRoles, bMACVSOGRoles);
            // ACPC.VerifyAITRoles(bAITRoles, bMACVSOGRoles);
            // ACPC.ClientVerifyAITRoles(bAITRoles, bMACVSOGRoles);
            ACPC.ReplaceInventoryManager();
            ACPC.ClientReplaceInventoryManager();

            ACPC.SetupUnitAndRank();
        } 
    }
    else
    {
        // If other mods are present, delegate role replacement to the dummy actor
        DummyActor.ReplaceRoles(IsWW2There(), IsWWThere(), IsMutThere("GOM"));
        DummyActor.ClientReplaceRoles(IsWW2There(), IsWWThere(), IsMutThere("GOM"));
    }

    super.NotifyLogin(NewPlayer);
}

// Determines whether the level's AkStartAmbientSound Kismet node(s) are reachable from a
// bClientSideOnly event. If not (or if none exist to trace), late-joining clients will
// need ACDummyActor to force "Start All" locally
function CheckAmbientSoundNeedsFallback()
{
    local Sequence GameSeq;
    local array<SequenceObject> AmbientNodes, AllNodes;
    local int i;

    bAmbientFallbackChecked = True;
    bAmbientSoundNeedsClientFallback = False;

    GameSeq = WorldInfo.GetGameSequence();
    if (GameSeq == None)
        return;

    GameSeq.FindSeqObjectsByClass(class'SeqAct_AkStartAmbientSound', true, AmbientNodes);
    if (AmbientNodes.Length == 0)
        return; // No ambient sound node in the level, nothing to fall back to

    GameSeq.FindSeqObjectsByClass(class'SequenceObject', true, AllNodes);

    for (i = 0; i < AmbientNodes.Length; i++)
    {
        if (!IsFedByClientSideEvent(SequenceOp(AmbientNodes[i]), AllNodes))
        {
            bAmbientSoundNeedsClientFallback = True;
            return;
        }
    }
}

// Walks backward through the Kismet graph from TargetOp looking for an upstream bClientSideOnly event
function bool IsFedByClientSideEvent(SequenceOp TargetOp, array<SequenceObject> AllNodes)
{
    local array<SequenceOp> Visited;
    return IsFedByClientSideEventRecursive(TargetOp, AllNodes, Visited);
}

function bool IsFedByClientSideEventRecursive(SequenceOp TargetOp, array<SequenceObject> AllNodes, out array<SequenceOp> Visited)
{
    local int i, j, k;
    local SequenceOp Feeder;
    local SequenceEvent FeederEvent;

    if (Visited.Find(TargetOp) != INDEX_NONE)
        return False;
    Visited.AddItem(TargetOp);

    for (i = 0; i < AllNodes.Length; i++)
    {
        Feeder = SequenceOp(AllNodes[i]);
        if (Feeder == None || Feeder == TargetOp)
            continue;

        for (j = 0; j < Feeder.OutputLinks.Length; j++)
        {
            for (k = 0; k < Feeder.OutputLinks[j].Links.Length; k++)
            {
                if (Feeder.OutputLinks[j].Links[k].LinkedOp == TargetOp)
                {
                    FeederEvent = SequenceEvent(Feeder);
                    if (FeederEvent != None && FeederEvent.bClientSideOnly)
                        return True;

                    if (IsFedByClientSideEventRecursive(Feeder, AllNodes, Visited))
                        return True;
                }
            }
        }
    }
    return False;
}

simulated function NotifyLogout(Controller Exiting)
{
    local ACDummyActor DummyActor;

    // Find and destroy the dummy actor associated with the exiting player
    foreach DummyActors(DummyActor)
    {
        if (DummyActor.Owner == Exiting)
        {
            //`log ("[MutExtras LogOut] Destoying "$DummyActor);
            DummyActor.Destroy();
            break;
        }
    }

    super.NotifyLogout(Exiting);
}

// ====================================================
// Startup State
// ====================================================
auto state StartUp
{
    // function timer()
    // {
    //     ModifyVolumes();
    // }

    function timer2()
    {
        SetVicTeam();
    }

    Begin:
    // Schedule object loading and periodic checks
    SetTimer(1, false, 'LoadObjects');
    //SetTimer(10, false, 'CheckLoaded');
    SetTimer(10, true, 'timer2'); // Periodically check vehicle teams
    // SetTimer(1, false, 'timer'); // Periodically modify volumes
    SetTimer(0.25, true, 'UpdateOverflowMapLocations'); // Track positions for players who didn't get a native TeamPRIArray slot
}

// ====================================================
// Overflow Map Locations
// ====================================================
// ROTeamInfo.TeamPRIArray/TeamLocationArray are fixed to MAX_PLAYERS_PER_TEAM (32) slots. Once a
// team is full, AddToTeam() can't find a free slot, so the 33rd+ player never gets a replicated map
// position and is invisible on the overhead map. This periodically republishes their location via
// ACPlayerReplicationInfo.OverflowMapLocation so ACHUDWidgetOverheadMap can draw them separately.
function UpdateOverflowMapLocations()
{
    local Controller C;
    local ROPlayerReplicationInfo ROPRI;
    local ACPlayerReplicationInfo ACPRI;
    local ROTeamInfo ROTI;

    foreach WorldInfo.AllControllers(class'Controller', C)
    {
        if (C.PlayerReplicationInfo == None || C.Pawn == None)
            continue;

        ROPRI = ROPlayerReplicationInfo(C.PlayerReplicationInfo);
        if (ROPRI == None || ROPRI.bOnlySpectator)
            continue;

        ROTI = ROTeamInfo(ROPRI.Team);
        if (ROTI == None)
            continue;

        // TeamPRIArrayIndex defaults to 0 (not 255) when never assigned a slot, so it can't be
        // trusted alone - only skip if that slot in the team's roster actually points back to us
        if ((ROPRI.TeamPRIArrayIndex < ArrayCount(ROTI.TeamPRIArray)) && (ROTI.TeamPRIArray[ROPRI.TeamPRIArrayIndex] == ROPRI))
            continue;

        ACPRI = ACPlayerReplicationInfo(ROPRI);
        if (ACPRI != None)
        {
            ACPRI.OverflowMapLocation = C.Pawn.Location;
            ACPRI.OverflowIconType = GetOverflowIconType(C.Pawn, ROTI);
        }
    }
}

// Classifies a player's current Pawn for overhead map icon selection.
// Values: 0=Infantry, 1=Tank, 2=Transport, 3=Huey, 4=Cobra, 5=Loach, 6=Gunship
function byte GetOverflowIconType(Pawn P, ROTeamInfo ROTI)
{
    local ROVehicleHelicopter Heli;

    if (ROVehicleTank(P) != None)
        return 1;

    if (ROVehicleTransport(P) != None)
        return 2;

    Heli = ROVehicleHelicopter(P);
    if (Heli != None)
    {
        switch (ROTI.GetHeliType(Heli))
        {
            case VNHT_Huey:
                return 3;
            case VNHT_Cobra:
                return 4;
            case VNHT_Loach:
                return 5;
            case VNHT_Gunship:
                return 6;
        }
    }

    return 0;
}

// ====================================================
// Content Loading
// ====================================================
function LoadObjects()
{
    local ROMapInfo               ROMI;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    //`log ("[MutExtras LoadObjects]");
    // Dynamically load the settings object and add it to shared content references
    ROMI.SharedContentReferences.AddItem(class<Settings>(DynamicLoadObject("MutExtras.MutExtrasSettings", class'Class')));
}

function PrivateMessage(PlayerController receiver, coerce string msg)
{
    // Send a private message to a specific player
    receiver.TeamMessage(None, msg, '');
}

// ====================================================
// Console Commands
// ====================================================
singular function Mutate(string MutateString, PlayerController PC) //no prefixes, also call super function!
{
    local array<string>         Args;
    local string                command;
    local string                PlayerName;

    Args = SplitString(MutateString, " ", true);
    command = Caps(Args[0]);

    PlayerName = PC.PlayerReplicationInfo.PlayerName;

	Switch (Command)
    {
        case "SALUTE":
            // Trigger salute animation logic
            ACPlayerReplicationInfo(PC.PlayerReplicationInfo).bNeedsSalute = true;
            Salute(PC);
            break;

        case "CHANGERANK":
            // Change player rank
            ACPlayerController(PC).SetPlayerRank(Args[1]);
            break;

        case "CHANGEUNIT":
            // Change player unit
            ACPlayerController(PC).SetPlayerUnit(Args[1]);
            break;

        case "RESETMESH":
            // Reset pawn mesh
            ACPawn(PC.Pawn).CreatePawnMesh();
            break;

        case "ADDBOTS":
            // Add bots to the game. 5th arg (optional): overflow - force bots onto Args[2]'s team past
            // MAX_PLAYERS_PER_TEAM (32), ignoring team balance and the server's MaxPlayers cap. For
            // testing the overhead map overflow fix; requires a specific team (Args[2] != -1).
            AddBots(int(Args[1]), int(Args[2]), bool(Args[3]), bool(Args[4]));
            `log ("[MutExtras Debug]Added Bots");
            break;

        case "REMOVEBOTS":
            // Remove all bots
            RemoveBots();
            `log ("[MutExtras Debug]Removed Bots");
            break;

        case "SetSpeed":
            // Set player speed
            SetSpeed(PC, float(Args[1]), Args[2]);
            `log("[MutExtras Debug] SetSpeed");
            if (Args[2] ~= "all")
            {
                WorldInfo.Game.Broadcast(self, "[MutExtras] "$PlayerName$" set everyone's speed to "$Args[1]);
            }
            else
            {
                WorldInfo.Game.Broadcast(self, "[MutExtras] "$PlayerName$" set their speed to "$Args[1]);
            }
            break;

        case "ALLAMMO":
            // Toggle infinite ammo
            AllAmmo(PC);
            `log("[MutExtras Debug] Infinite Ammo");
            WorldInfo.Game.Broadcast(self, "[MutExtras] "$PlayerName$" toggled AllAmmo");
            break;
    }
    super.Mutate(MutateString, PC);
}

function Salute(PlayerController PC)
{
    // Play the salute animation on the pawn's arms
	ROPawn(PC.Pawn).ArmsMesh.PlayAnim('29thArms1st', ,false, false);
    //ROPawn(PC.Pawn).MyWeapon.PlayArmAnimation();
}

// ====================================================
// Bot Management
// ====================================================
function AddBots(int Num, optional int NewTeam = -1, optional bool bNoForceAdd, optional bool bOverflow)
{
    local ROGameInfo              ROGI;
	local ROAIController ROBot;
    local ROPlayerReplicationInfo ROPRI;
	local byte ChosenTeam;
	local byte SuggestedTeam;
	// do not add bots during server travel
    ROGI = ROGameInfo(WorldInfo.Game);

	if( ROGI.bLevelChange )
	{
		return;
	}

	// bOverflow: for testing the overhead map overflow fix. Skips the MaxPlayers cap below and, for each
	// bot, forces it onto NewTeam directly (see the SuggestedTeam branch), bypassing team balance entirely
	// so a team can be deliberately stacked past MAX_PLAYERS_PER_TEAM (32).
	while ( Num > 0 && (bOverflow || ROGI.NumBots + ROGI.NumPlayers < ROGI.MaxPlayers) )
	{
		// Create a new Controller for this Bot
	    ROBot = Spawn(ROGI.AIControllerClass);
        ROPRI = ROPlayerReplicationInfo(ROBot.PlayerReplicationInfo);

		// Assign the bot a Player ID
		ROBot.PlayerReplicationInfo.PlayerID = ROGI.CurrentID++;

		// Suggest a team to put the AI on
		if ( bOverflow && NewTeam != -1 )
		{
			SuggestedTeam = NewTeam;
		}
		else if ( ROGI.bBalanceTeams || NewTeam == -1 )
		{
            // Check team balance and role availability
			if ( ROGI.GameReplicationInfo.Teams[`AXIS_TEAM_INDEX].Size - ROGI.GameReplicationInfo.Teams[`ALLIES_TEAM_INDEX].Size <= 0
				&& ROGI.BotCapableNorthernRolesAvailable() )
			{
				SuggestedTeam = `AXIS_TEAM_INDEX;
			}
			else if( ROGI.BotCapableSouthernRolesAvailable() )
			{
				SuggestedTeam = `ALLIES_TEAM_INDEX;
			}
			// If there are no roles available on either team, don't allow this to go any further
			else
			{
				ROBot.Destroy();
				return;
			}
		}
		else if (ROGI.BotCapableNorthernRolesAvailable() || ROGI.BotCapableSouthernRolesAvailable())
		{
			SuggestedTeam = NewTeam;
		}
		else
		{
			ROBot.Destroy();
			return;
		}

		// Put the new Bot on the Team that needs it. bOverflow forces the requested team directly,
		// since PickTeam() would otherwise redirect bots to keep the teams balanced.
		if ( bOverflow && NewTeam != -1 )
		{
			ChosenTeam = SuggestedTeam;
		}
		else
		{
			ChosenTeam = ROGI.PickTeam(SuggestedTeam, ROBot);
		}
		// Set the bot name based on team
		ROGI.ChangeName(ROBot, ROGI.GetDefaultBotName(ROBot, ChosenTeam, ROTeamInfo(ROGI.GameReplicationInfo.Teams[ChosenTeam]).NumBots + 1), false);

		ROGI.JoinTeam(ROBot, ChosenTeam);

		ROBot.SetTeam(ROBot.PlayerReplicationInfo.Team.TeamIndex);

		// Have the bot choose its role
		if( !ROBot.ChooseRole() )
		{
			ROBot.Destroy();
			continue;
		}
        
        // Force rifleman role for specific class indices
        if (ROPRI.ClassIndex == 11 || ROPRI.ClassIndex == 8)
        {
            if (ROBot.PlayerReplicationInfo.Team.TeamIndex == `AXIS_TEAM_INDEX)
            {
                ROPRI.SelectRoleByClass(ROBot, class'RORoleInfoNorthernRifleman');
            }
            else
            {
                ROPRI.SelectRoleByClass(ROBot, class'RORoleInfoSouthernRifleman');
            }   
        }

		ROBot.ChooseSquad();

		if ( ROTeamInfo(ROBot.PlayerReplicationInfo.Team) != none && ROTeamInfo(ROBot.PlayerReplicationInfo.Team).ReinforcementsRemaining > 0 )
		{
			// Spawn a Pawn for the new Bot Controller
			ROGI.RestartPlayer(ROBot);
		}

		if ( ROGI.bInRoundStartScreen )
		{
			ROBot.AISuspended();
		}

		// Note that we've added another Bot
		if( !bNoForceAdd )
		    ROGI.DesiredPlayerCount++;
	    ROGI.NumBots++;
		Num--;
		ROGI.UpdateGameSettingsCounts();
	}
}

function RemoveBots()
{
    local ROAIController ROB;
    // Iterate through all AI controllers and destroy them
    foreach allactors(class'ROAIController', ROB)
    {
        ROB.Pawn.ShutDown();
        ROB.Pawn.Destroy();
        ROB.ShutDown();
        ROB.Destroy();
    }
}

// ====================================================
// Utility Functions
// ====================================================
function SetSpeed(PlayerController PC, float F, string S)
{
    // Apply speed multiplier to all players if S is "all"
    if (S ~= "all")
    {
        ForEach WorldInfo.AllControllers(class'PlayerController', PC)
        {
            if (0.5 <= F && F <= 20)
            {
                PC.Pawn.GroundSpeed =   PC.Pawn.Default.GroundSpeed * F;
	            PC.Pawn.WaterSpeed =    PC.Pawn.Default.WaterSpeed * F;
                PC.Pawn.AirSpeed =      PC.Pawn.Default.AirSpeed * F;
                PC.Pawn.LadderSpeed =   PC.Pawn.Default.LadderSpeed * F;
            }
            else
            {
                // Reset to default if F is out of range
                PC.Pawn.GroundSpeed =   PC.Pawn.Default.GroundSpeed;
	            PC.Pawn.WaterSpeed =    PC.Pawn.Default.WaterSpeed;
                PC.Pawn.AirSpeed =      PC.Pawn.Default.AirSpeed;
                PC.Pawn.LadderSpeed =   PC.Pawn.Default.LadderSpeed;
                // `log("Error");
            }
        }
    }
    // Apply speed multiplier to the specific player
    if (0.1 <= F && F <= 20)
	{
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed * F;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed * F;
        PC.Pawn.AirSpeed = PC.Pawn.Default.AirSpeed * F;
        PC.Pawn.LadderSpeed = PC.Pawn.Default.LadderSpeed * F;
    }
    else
    {
        PC.Pawn.GroundSpeed = PC.Pawn.Default.GroundSpeed;
	    PC.Pawn.WaterSpeed = PC.Pawn.Default.WaterSpeed;
        PC.Pawn.AirSpeed = PC.Pawn.Default.AirSpeed;
        PC.Pawn.LadderSpeed = PC.Pawn.Default.LadderSpeed;
        // `log("Error");
    }
}

function AllAmmo(PlayerController PC)
{
    // Enable infinite ammo for the player
	ROInventoryManager(PC.Pawn.InvManager).AllAmmo(true);
	ROInventoryManager(PC.Pawn.InvManager).bInfiniteAmmo = true;
	ROInventoryManager(PC.Pawn.InvManager).DisableClientAmmoTracking();
}

simulated function NameExists(ROVehicleBase VehBase)
{
	local int 				I, MaxHitsForVic;
	local bool 				bNameExists;
	local ROVehicle 		ROV;
    local array<string>     ROVName;

    ROV = ROVehicle(vehbase);
    ROVName = splitstring((string(vehbase.name)), "_", true);

    // Determine max hits based on vehicle name
	for (I = 0; I < ROVName.length ; I++)
	{
        if      (ROVName[I] ~= "T20"     ){MaxHitsForVic = 3; break;}
        else if (ROVName[I] ~= "T26"     ){MaxHitsForVic = 4; break;}
        else if (ROVName[I] ~= "T28"     ){MaxHitsForVic = 5; break;}  
		else if (ROVName[I] ~= "53K"     ){MaxHitsForVic = 1; break;}
        else if (ROVName[I] ~= "HT130"   ){MaxHitsForVic = 4; break;}
        else if (ROVName[I] ~= "Vickers" ){MaxHitsForVic = 4; break;}
        else    {MaxHitsForVic = 3;}
	}

    // Check if vehicle is already in the hit list
	for (I = 0; I < HitVicName.Length; I++)
	{
        //`log ("[MutExtras Debug]Hitvicname = "$HitVicName[I]$" HitNum = "$HitNum[I]);
		if (HitVicName[I] ~= string(vehbase.name))
		{
		    bNameExists = true;
		    HitNum[I] += 1;
            /* PrivateMessage(PlayerController(ROV.Seats[0].StoragePawn.Controller), "You have "$MaxHitsForVic-HitNum[I]$" hits left before your vehicle is blown up!");
            PrivateMessage(PlayerController(ROV.Seats[1].StoragePawn.Controller), "You have "$MaxHitsForVic-HitNum[I]$" hits left before your vehicle is blown up!"); */
            // `log ("[MutExtras Debug] Hitvicname "$HitVicName[I]$" has "$MaxHitsForVic-HitNum[I]$" hits remaining");
    
            // Blow up vehicle if max hits reached
            if (HitNum[I] >= MaxHitsForVic)
		    {
		        ROV.Health = 0;
		        ROV.BlowupVehicle();
                ROV.bDeadVehicle = true;
                `log ("[MutExtras Debug]Blew up the "$vehbase.name$" on hit # "$HitNum[I]);
                HitVicName.removeitem(HitVicName[I]);
                HitNum.removeitem(HitNum[I]);
		    }            
            // else {`log ("[MutExtras Debug] DAMAGE TEST SUCCESFUL ON "$vehbase.name$" Vehicle health = "$vehbase.Health$" Hit #"$HitNum[I]);}
		
        break;
		}
	}

    // Add vehicle to hit list if not found
    if (bNameExists == false)
	{
	    HitVicName.additem(string(vehbase.name));
	    HitNum.additem(byte(1));
        /* PrivateMessage(PlayerController(ROV.Seats[0].StoragePawn.Controller), "You have "$MaxHitsForVic-1$" hits left before your vehicle is blown up!");
        PrivateMessage(PlayerController(ROV.Seats[1].StoragePawn.Controller), "You have "$MaxHitsForVic-1$" hits left before your vehicle is blown up!"); */
        // `log ("[MutExtras Debug] Hitvicname "$HitVicName[I]$" has "$MaxHitsForVic-HitNum[I]$" hits remaining");
	    // `log (vehbase.name$" doesn't exist on the array, adding it");
	}
}

function ModifyVolumes()
{
    local ROVolumeAmmoResupply ROVAR;

    // Set all ammo resupply volumes to neutral team
    foreach AllActors(class'ROVolumeAmmoResupply', ROVAR)
    {
        ROVAR.Team = OWNER_Neutral;
    }
}

function SetVicTeam()
{
    local ROVehicle ROV;

    // Update vehicle team to match the driver's team
    foreach DynamicActors(class'ROVehicle', ROV)
    {
        if (ROV.bDriving == true && ROV.Team != ROV.Driver.GetTeamNum() && !ROV.bDeadVehicle)
        {
            ROV.Team = ROV.Driver.GetTeamNum();
            // `log ("[MutExtras Debug] Set "$ROV$" to team "$ROV.Driver.GetTeamNum());
        }
    }
}

// ====================================================
// Mod Detection
// ====================================================
function bool IsMutThere(string Mutator)
{
	local Mutator mut;

    mut = ROGameInfo(WorldInfo.Game).BaseMutator;

    // Check if a specific mutator is present in the mutator list
    for (mut = ROGameInfo(WorldInfo.Game).BaseMutator; mut != none; mut = mut.NextMutator)
    {
        // `log("[MutExtras] IsMutThere test "$string(mut.name));
        if(InStr(string(mut.name), Mutator,,true) != -1) 
        {
            return true;
        }
    }
    return false;
}

function bool IsWWThere()
{
    local string WWName;
    WWName = class'Engine'.static.GetCurrentWorldInfo().GetMapName(true);
    // Check if the current map is a Winter War map
    if ((InStr(WWName, "WWTE",,true) != -1) || (InStr(WWName, "WWSU",,true) != -1))
    {
        // `log ("[MutExtras Debug] Found WinterWar!");
        return true;
    }
    return false;
}

function bool IsWW2There()
{
    local string WWName;
    WWName = class'Engine'.static.GetCurrentWorldInfo().GetMapName(true);
    // Check if the current map is a WW2 map
    if ((InStr(WWName, "RRTE",,true) != -1) || (InStr(WWName, "RRSU",,true) != -1)
    || (InStr(WWName, "DRTE",,true) != -1) || (InStr(WWName, "DRSU",,true) != -1))
    {
        // `log ("[MutExtras Debug] Found WW2!");
        return true;
    }
    return false;
}

DefaultProperties
{
    RORICSouth=(LevelContentClasses=("MutExtras.ACPawnSouth"))
    RORICNorth=(LevelContentClasses=("MutExtras.ACPawnNorth"))
}