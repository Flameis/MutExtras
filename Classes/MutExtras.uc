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

var config array<String>    PlayerRankAndUnit;
// var config array<String>    DefaultPlayerRankAndUnit;
var config array<String>    ModSearchNames;
var config Bool             bAITRoles;

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
        
        ROGameInfo(WorldInfo.Game).SouthRoleContentClasses = RORICSouth;
        ROGameInfo(WorldInfo.Game).NorthRoleContentClasses = RORICNorth;
    }

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
	ACPawn(Other).PlayerRank = ACPRI.PlayerRank;
	ACPawn(Other).PlayerUnit = ACPRI.PlayerUnit;

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

    //SetTimer(10, false, 'CheckLoaded');

    // If running in vanilla mode, replace standard classes with AC variants
    if (bisVanilla)
    {
        ACPC = ACPlayerController(NewPlayer);

        if (ACPC != None)
        {
            ACPC.ReplacePawnHandler();
            ACPC.ClientReplacePawnHandler();
            ACPC.ReplaceRoles(bAITRoles);
            ACPC.ClientReplaceRoles(bAITRoles);
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
    function timer()
    {
        ModifyVolumes();
    }

    function timer2()
    {
        SetVicTeam();
    }

    Begin:
    // Schedule object loading and periodic checks
    SetTimer(1, false, 'LoadObjects');
    //SetTimer(10, false, 'CheckLoaded');
    SetTimer(2, true, 'timer2'); // Periodically check vehicle teams
    SetTimer(10, true); // Periodically modify volumes
}

// ====================================================
// Content Loading
// ====================================================
function CheckLoaded()
{
    local ROMapInfo               ROMI;
    local int i;
    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    // Log all shared content references for debugging
    for (i=0; i<ROMI.SharedContentReferences.length; i++)
    {
        `log ("[MutExtras CheckLoaded] SharedContentReferences = "$ROMI.SharedContentReferences[i]);
    }
}

function LoadObjects()
{
    local ROMapInfo               ROMI;

    ROMI = ROMapInfo(WorldInfo.GetMapInfo());

    //`log ("[MutExtras LoadObjects]");
    // Dynamically load the settings object and add it to shared content references
    ROMI.SharedContentReferences.AddItem(class<Settings>(DynamicLoadObject("MutExtrasTB.MutExtrasSettings", class'Class')));
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
            // Add bots to the game
            AddBots(int(Args[1]), int(Args[2]), bool(Args[3]));
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
function AddBots(int Num, optional int NewTeam = -1, optional bool bNoForceAdd)
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

	while ( Num > 0 && ROGI.NumBots + ROGI.NumPlayers < ROGI.MaxPlayers )
	{
		// Create a new Controller for this Bot
	    ROBot = Spawn(ROGI.AIControllerClass);
        ROPRI = ROPlayerReplicationInfo(ROBot.PlayerReplicationInfo);

		// Assign the bot a Player ID
		ROBot.PlayerReplicationInfo.PlayerID = ROGI.CurrentID++;

		// Suggest a team to put the AI on
		if ( ROGI.bBalanceTeams || NewTeam == -1 )
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

		// Put the new Bot on the Team that needs it
		ChosenTeam = ROGI.PickTeam(SuggestedTeam, ROBot);
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
            `log ("[MutExtras Debug] Hitvicname "$HitVicName[I]$" has "$MaxHitsForVic-HitNum[I]$" hits remaining");
    
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
            else {`log ("[MutExtras Debug] DAMAGE TEST SUCCESFUL ON "$vehbase.name$" Vehicle health = "$vehbase.Health$" Hit #"$HitNum[I]);}
		
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
        `log ("[MutExtras Debug] Hitvicname "$HitVicName[I]$" has "$MaxHitsForVic-HitNum[I]$" hits remaining");
	    `log (vehbase.name$" doesn't exist on the array, adding it");
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


/* function bool AreModsThere()
{
	local Mutator mut;
    local string ModName, MapName;
    
    // Look for the mod by checking the mutator list
    mut = ROGameInfo(WorldInfo.Game).BaseMutator;
    foreach ModSearchNames(ModName)
    {
        // Look for the mod by checking the map name
        MapName = class'Engine'.static.GetCurrentWorldInfo().GetMapName(true);
        if ((InStr(MapName, ModName,, true) != -1))
        {
            return true;
        }

        // Look for the mod by checking the mutator list
        for (mut = ROGameInfo(WorldInfo.Game).BaseMutator; mut != none; mut = mut.NextMutator)
        {
            // `log("[MutExtras] IsMutThere test "$string(mut.name));
            if(InStr(string(mut.name), ModName,,true) != -1) 
            {
                return true;
            }
        }
        return false;
    }
} */

DefaultProperties
{
    RORICSouth=(LevelContentClasses=("MutExtrasTB.ACPawnSouth"))
    RORICNorth=(LevelContentClasses=("MutExtrasTB.ACPawnNorth"))
}