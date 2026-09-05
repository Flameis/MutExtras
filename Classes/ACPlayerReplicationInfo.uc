class ACPlayerReplicationInfo extends ROPlayerReplicationInfo
	config(MutExtras_Client);

var repnotify string 	PlayerRank, PlayerUnit;
var repnotify bool 		bNeedsSalute;

// Replicated position for players who didn't get a native TeamPRIArray slot (team full at 32),
// used by ACHUDWidgetOverheadMap to still show them on the map. See MutExtras.UpdateOverflowMapLocations
var vector				OverflowMapLocation;

// What icon ACHUDWidgetOverheadMap should draw for OverflowMapLocation, set by
// MutExtras.GetOverflowIconType. Values: 0=Infantry, 1=Tank, 2=Transport, 3=Huey, 4=Cobra, 5=Loach, 6=Gunship
var byte				OverflowIconType;

// Without replication, only the player can see the helmet decals
replication
{
	if (bNetDirty)
		PlayerRank, PlayerUnit, bNeedsSalute, OverflowMapLocation, OverflowIconType;
}

simulated event ReplicatedEvent(name VarName)
{
    // local String Text;
	local ACPawn ACP;

	ForEach DynamicActors(class'ACPawn', ACP)
	{
		// find my pawn and tell it
		if ( ACP.PlayerReplicationInfo == self )
		{
			break;
		}
	}

    if (Role == Role_Authority)
    {
    //   Text = "Server";
    }
    else
    {
    //   Text = "Client";
    }

	if (VarName == 'PlayerRank')
	{
        // `Log(Self$":: ReplicatedEvent():: PlayerRank is "$PlayerRank$" on the "$Text);
	}
    else if (VarName == 'PlayerUnit')
	{
        // `Log(Self$":: ReplicatedEvent():: PlayerUnit is "$PlayerUnit$" on the "$Text);
	}
	else if (VarName == 'bNeedsSalute')
	{
        // `Log(Self$":: Pawn ReplicatedEvent():: bNeedsFBSalute is "$bNeedsSalute$" on the "$Text);
		if (bNeedsSalute)
		{
			ACP.Salute();
		}
	}
	else
	{
		Super.ReplicatedEvent(VarName);
	}
}

simulated function ClientInitialize(Controller C)
{
	local ROPlayerController ROPC;
	local bool bNewOwner;
	
	bNewOwner = (Owner != C);
	Super.ClientInitialize(C);
	
	if (bNewOwner)
	{
		self.UsedNames.Length = 0;
	}
	
	ROPC = ROPlayerController(C);
	if ( bNewOwner && ROPC != None && LocalPlayer(ROPC.Player) != None )
	{
		ClientInitializeUnlocks();
	}

	PawnHandlerClass = class'ACPawnHandler';
}

function bool SelectRoleByClass(Controller C, class<RORoleInfo> RoleInfoClass,
    optional out WeaponSelectionInfo WeaponSelection, optional out byte NewSquadIndex,
    optional out byte NewClassIndex, optional class<ROVehicle> TankSelection)
{
    // `log ("[MutExtras Debug]ACPlayerReplicationInfo.SelectRoleByClass()");

    ACPlayerController(C).ReplacePawnHandler();
    ACPlayerController(C).ReplaceInventoryManager();

    return super.SelectRoleByClass(C, RoleInfoClass, WeaponSelection,
        NewSquadIndex, NewClassIndex, TankSelection);

	PawnHandlerClass = class'ACPawnHandler';

	if( bBot )
    {
        PawnHandlerClass = class'ACPawnHandler';
    }
}

defaultproperties
{
	PlayerRank="pvt"
	PlayerUnit="pvt"
	PawnHandlerClass = class'ACPawnHandler';
}