//=============================================================================
// ACHUDWidgetOverheadMap
//=============================================================================
// ROTeamInfo.TeamPRIArray/TeamLocationArray are fixed-size (MAX_PLAYERS_PER_TEAM,
// 32) native arrays. Once a team is full, AddToTeam() can't find a free slot for
// a newly-joining player, so they never get a replicated map position and are
// invisible on the overhead map for the rest of the round.
//
// This draws a simple, uniform icon for those "overflow" players (33rd+ on a
// team) using ACPlayerReplicationInfo.OverflowMapLocation, which MutExtras
// periodically republishes for anyone stuck without a TeamPRIArray slot. Up to
// MAX_PLAYERS_PER_TEAM overflow players are supported (64 per team total).
//=============================================================================
class ACHUDWidgetOverheadMap extends ROHUDWidgetOverheadMap;

var ROHUDWidgetComponent OverflowPlayerIcons[`MAX_PLAYERS_PER_TEAM];

// Which player (if any) currently owns each icon slot. Kept stable across frames - unlike
// position/visibility, the death fade relies on a slot's UpdateTime persisting from the frame
// a player was last alive, so the same player must keep the same slot for as long as possible.
var ROPlayerReplicationInfo OverflowIconOwner[`MAX_PLAYERS_PER_TEAM];

// "SL#" labels shown next to an overflow squad leader's icon, one per squad (like native, which
// only needs MAX_SQUADS of these since only one player per squad can be its leader at a time)
var ROHUDWidgetComponent OverflowSLLabels[`MAX_SQUADS];

// Slightly smaller than native's real squad leader icon (TransportSize) so overflow squad
// leaders stay visually distinct from a "real" one, while still standing out from regular icons
const OVERFLOW_SL_SIZE = 2.5;

// Interpolation disabled (looked weird in practice) - icons now snap straight to their target
// position each update instead. Left commented out rather than removed in case it's revisited.
// var vector OverflowIconSmoothedLocation[`MAX_PLAYERS_PER_TEAM];
// var float OverflowLastUpdateTime;
// const OVERFLOW_INTERP_RATE = 8.0;

function Initialize(PlayerController HUDPlayerOwner)
{
	local int i;

	super.Initialize(HUDPlayerOwner);

	OverflowPlayerIcons[0].Initialize();
	for ( i = 1; i < `MAX_PLAYERS_PER_TEAM; i++ )
	{
		OverflowPlayerIcons[i] = new class'ROHUDWidgetComponent';
		OverflowPlayerIcons[i].Tex = OverflowPlayerIcons[0].Tex;
		OverflowPlayerIcons[i].Width = OverflowPlayerIcons[0].Width;
		OverflowPlayerIcons[i].Height = OverflowPlayerIcons[0].Height;
		OverflowPlayerIcons[i].TexWidth = OverflowPlayerIcons[0].TexWidth;
		OverflowPlayerIcons[i].TexHeight = OverflowPlayerIcons[0].TexHeight;
		OverflowPlayerIcons[i].DrawColor = OverflowPlayerIcons[0].DrawColor;
		OverflowPlayerIcons[i].SortPriority = OverflowPlayerIcons[0].SortPriority;
		OverflowPlayerIcons[i].bFadedOut = true;
		OverflowPlayerIcons[i].bVisible = false;

		OverflowPlayerIcons[i].Initialize();
	}

	// One "SL#" text label per squad, matching the native ROOMT_SLSpawnLabel setup
	for ( i = 0; i < `MAX_SQUADS; i++ )
	{
		OverflowSLLabels[i] = new class'ROHUDWidgetComponent';
		OverflowSLLabels[i].Text = SquadLeaderShortString $ string(i + 1);
		OverflowSLLabels[i].TextFont = HUDComponents[ROOMT_ObjectiveLabelStart].TextFont;
		OverflowSLLabels[i].TextScale = HUDComponents[ROOMT_ObjectiveLabelStart].TextScale;
		OverflowSLLabels[i].TextAlignment = HUDComponents[ROOMT_ObjectiveLabelStart].TextAlignment;
		OverflowSLLabels[i].DrawColor = HUDComponents[ROOMT_ObjectiveLabelStart].DrawColor;
		OverflowSLLabels[i].SortPriority = HUDComponents[ROOMT_ObjectiveLabelStart].SortPriority;
		OverflowSLLabels[i].bDropShadow = HUDComponents[ROOMT_KeyArtilleryTargetLabel].bDropShadow;
		OverflowSLLabels[i].DropShadowOffset = HUDComponents[ROOMT_KeyArtilleryTargetLabel].DropShadowOffset;
		OverflowSLLabels[i].DropShadowColor = HUDComponents[ROOMT_KeyArtilleryTargetLabel].DropShadowColor;
		OverflowSLLabels[i].bVisible = false;

		OverflowSLLabels[i].Initialize();
	}
}

function UpdateWidget()
{
	local int i, IconIndex, LiveIdx;
	local float IconSizeModifier;
	// local float DeltaTime, InterpAlpha; // interpolation disabled, see below
	// local bool bFreshClaim; // only used by the interpolation logic below
	local array<int> ClaimedSlots; // fixed-size bool arrays aren't supported, so track claimed slot indices instead
	local array<PlayerReplicationInfo> LivePRIList;
	local array<vector> LiveLocList;
	local PlayerReplicationInfo PRI;
	local ROPlayerReplicationInfo ROPRI;
	local ACPlayerReplicationInfo ACPRI;
	local ROTeamInfo MyTeam;
	local ROPlayerReplicationInfo MyROPRI;
	local ROGameReplicationInfo ROGRI;
	local Pawn P;
	local vector TargetLocation;
	local float IconX, IconY;

	super.UpdateWidget();

	if ( PlayerOwner == none || PlayerOwner.PlayerReplicationInfo == none || PlayerOwner.PlayerReplicationInfo.Team == none || WorldInfo.GRI == none )
	{
		for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
		{
			OverflowPlayerIcons[i].bVisible = false;
			OverflowIconOwner[i] = none;
		}
		for ( i = 0; i < `MAX_SQUADS; i++ )
		{
			OverflowSLLabels[i].bVisible = false;
		}
		return;
	}

	// Nothing to update while the map isn't actually shown - RenderWidget already skips drawing
	// in this case too, so leaving everything in its last state here is harmless
	if ( bHiddenTemporarily || !IsVisible() )
		return;

	// Interpolation disabled, see the declarations above
	// DeltaTime = FClamp(WorldInfo.TimeSeconds - OverflowLastUpdateTime, 0.0, 0.5);
	// OverflowLastUpdateTime = WorldInfo.TimeSeconds;

	MyTeam = ROTeamInfo(PlayerOwner.PlayerReplicationInfo.Team);
	MyROPRI = ROPlayerReplicationInfo(PlayerOwner.PlayerReplicationInfo);
	ROGRI = ROGameReplicationInfo(WorldInfo.GRI);

	// Mirrors what ROTeamInfo.TeamLocationArray itself does natively (per its own comment:
	// "Updated periodically from server, overridden locally if Pawn is relevant") - if a
	// teammate's actual Pawn already happens to be relevant/replicated to us (nearby, etc.), use
	// its live position instead of the periodically-replicated OverflowMapLocation, for free
	foreach WorldInfo.AllPawns(class'Pawn', P)
	{
		if ( P.PlayerReplicationInfo != none && P.Health > 0 )
		{
			LivePRIList.AddItem(P.PlayerReplicationInfo);
			LiveLocList.AddItem(P.Location);
		}
	}

	// Re-shown below for whichever squads actually have a visible overflow leader this frame
	for ( i = 0; i < `MAX_SQUADS; i++ )
	{
		OverflowSLLabels[i].bVisible = false;
	}

	foreach WorldInfo.GRI.PRIArray(PRI)
	{
		if ( PRI == PlayerOwner.PlayerReplicationInfo )
			continue;

		ROPRI = ROPlayerReplicationInfo(PRI);
		if ( ROPRI == none || ROPRI.Team != MyTeam || ROPRI.bOnlySpectator )
			continue;

		// TeamPRIArrayIndex defaults to 0 (not 255) when never assigned a slot, so it can't be
		// trusted alone - only skip if that slot in the team's roster actually points back to us
		// (they're already drawn by the native friendly-icon system in that case)
		if ( (ROPRI.TeamPRIArrayIndex < ArrayCount(MyTeam.TeamPRIArray)) && (MyTeam.TeamPRIArray[ROPRI.TeamPRIArrayIndex] == ROPRI) )
			continue;

		ACPRI = ACPlayerReplicationInfo(ROPRI);
		if ( ACPRI == none )
			continue;

		IconX = ACPRI.OverflowMapLocation.X;
		IconY = ACPRI.OverflowMapLocation.Y;

		if ( IconX <= MinVisibleWorldX || IconX >= MaxVisibleWorldX || IconY <= MinVisibleWorldY || IconY >= MaxVisibleWorldY )
			continue;

		// Reuse this player's existing slot if they have one, so a dead player's fade timer
		// (which relies on UpdateTime being left alone once they die) isn't reset or handed
		// to someone else mid-fade
		IconIndex = -1;
		// bFreshClaim = false; // interpolation disabled
		for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
		{
			if ( OverflowIconOwner[i] == ROPRI )
			{
				IconIndex = i;
				break;
			}
		}
		if ( IconIndex == -1 )
		{
			for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
			{
				if ( ClaimedSlots.Find(i) == INDEX_NONE && OverflowIconOwner[i] == none )
				{
					IconIndex = i;
					OverflowIconOwner[i] = ROPRI;
					// bFreshClaim = true; // interpolation disabled
					break;
				}
			}
		}
		if ( IconIndex == -1 )
			continue; // no free slots this frame

		ClaimedSlots.AddItem(IconIndex);
		OverflowPlayerIcons[IconIndex].bVisible = true;

		if ( ROPRI.bDead )
		{
			if ( ROGRI != none && ROGRI.bDisableTeamDeathIcons )
			{
				OverflowPlayerIcons[IconIndex].bFadedOut = true;
				OverflowPlayerIcons[IconIndex].bVisible = false;
			}
			else
			{
				// UpdateTime is left untouched here - it was last set to the current time on
				// the final frame this player was alive (below), which is what the fade below
				// counts from
				OverflowPlayerIcons[IconIndex].Tex = DeadPlayerIcon;
				OverflowPlayerIcons[IconIndex].CurWidth = DeadPlayerIconSize * OverflowPlayerIcons[IconIndex].ScaleX;
				OverflowPlayerIcons[IconIndex].CurHeight = OverflowPlayerIcons[IconIndex].CurWidth;
				OverflowPlayerIcons[IconIndex].DrawColor = class'HUD'.default.WhiteColor;

				if ( WorldInfo.TimeSeconds > OverflowPlayerIcons[IconIndex].UpdateTime + 2.0 )
				{
					if ( WorldInfo.TimeSeconds < OverflowPlayerIcons[IconIndex].UpdateTime + 5.0 )
					{
						OverflowPlayerIcons[IconIndex].DrawColor.A = Min(HUDComponents[ROOMT_Map].DrawColor.A, 255 * (1.0 - ((WorldInfo.TimeSeconds - OverflowPlayerIcons[IconIndex].UpdateTime - 2.0) / 3.0)));
					}
					else
					{
						OverflowPlayerIcons[IconIndex].bFadedOut = true;
						OverflowPlayerIcons[IconIndex].bVisible = false;
					}
				}

				OverflowPlayerIcons[IconIndex].SetScreenLocation(
					HUDComponents[ROOMT_Map].X + ((IconY - MinVisibleWorldY) * (HUDComponents[ROOMT_Map].Width / (MaxVisibleWorldY - MinVisibleWorldY))) - (OverflowPlayerIcons[IconIndex].CurWidth / 2.0),
					HUDComponents[ROOMT_Map].Y + HUDComponents[ROOMT_Map].Height - ((IconX - MinVisibleWorldX) * (HUDComponents[ROOMT_Map].Height / (MaxVisibleWorldX - MinVisibleWorldX))) - (OverflowPlayerIcons[IconIndex].CurHeight / 2.0));
			}

			continue; // done - skip the alive-only handling below
		}

		OverflowPlayerIcons[IconIndex].bFadedOut = false;
		OverflowPlayerIcons[IconIndex].UpdateTime = WorldInfo.TimeSeconds;

		// Prefer this player's live Pawn position (built into LivePRIList/LiveLocList above) over
		// the periodically-replicated OverflowMapLocation when it's available
		LiveIdx = LivePRIList.Find(ROPRI);
		if ( LiveIdx != INDEX_NONE )
		{
			TargetLocation = LiveLocList[LiveIdx];
		}
		else
		{
			TargetLocation = ACPRI.OverflowMapLocation;
		}

		// Interpolation disabled (looked weird in practice) - snap straight to the target position.
		// if ( bFreshClaim )
		// {
		// 	OverflowIconSmoothedLocation[IconIndex] = TargetLocation;
		// }
		// else
		// {
		// 	InterpAlpha = FClamp(DeltaTime * OVERFLOW_INTERP_RATE, 0.0, 1.0);
		// 	OverflowIconSmoothedLocation[IconIndex] = VLerp(OverflowIconSmoothedLocation[IconIndex], TargetLocation, InterpAlpha);
		// }
		IconX = TargetLocation.X;
		IconY = TargetLocation.Y;

		// Same squad as the viewer gets the squad highlight colour, like the native icons do;
		// everyone else on the team gets the generic team colour
		if ( MyROPRI != none && MyROPRI.SquadIndex < `MAX_SQUADS && ROPRI.SquadIndex == MyROPRI.SquadIndex )
		{
			OverflowPlayerIcons[IconIndex].DrawColor = SquadDrawColor;
		}
		else
		{
			OverflowPlayerIcons[IconIndex].DrawColor = TeamDrawColor;
		}

		// Squad leaders always show the squad leader icon, regardless of what they're doing/
		// riding in, matching native. Otherwise pick the icon texture and native size modifier
		// to match ACPRI.OverflowIconType (set server-side by MutExtras.GetOverflowIconType
		// from the player's current Pawn)
		if ( ROPRI.bIsSquadLeader )
		{
			OverflowPlayerIcons[IconIndex].Tex = SquadLeaderIcon;
			IconSizeModifier = OVERFLOW_SL_SIZE;
		}
		else
		{
			switch ( ACPRI.OverflowIconType )
			{
				case 1: // Tank
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconTank;
					IconSizeModifier = TankSize;
					break;
				case 2: // Transport
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconTransport;
					IconSizeModifier = TransportSize;
					break;
				case 3: // Huey
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconHelicopterHuey;
					IconSizeModifier = TransportSize;
					break;
				case 4: // Cobra
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconHelicopterCobra;
					IconSizeModifier = TransportSize;
					break;
				case 5: // Loach
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconHelicopterLoach;
					IconSizeModifier = TransportSize;
					break;
				case 6: // Gunship
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconHelicopterGunship;
					IconSizeModifier = TransportSize;
					break;
				default: // Infantry
					OverflowPlayerIcons[IconIndex].Tex = FriendlyPlayerIconRifle;
					IconSizeModifier = InfantrySize;
					break;
			}
		}

		// Native friendly icons recompute CurWidth/CurHeight every update from PlayerSizeUnzoomed/
		// Zoomed * (size modifier) * Scale rather than relying on the component's base Width/Height -
		// match that exactly, or icons end up the wrong size (worse the further zoom is from 1.75)
		if ( CurrentZoom < 1.75f )
		{
			OverflowPlayerIcons[IconIndex].CurWidth = PlayerSizeUnzoomed * IconSizeModifier * OverflowPlayerIcons[IconIndex].ScaleX;
			OverflowPlayerIcons[IconIndex].CurHeight = PlayerSizeUnzoomed * IconSizeModifier * OverflowPlayerIcons[IconIndex].ScaleY;
		}
		else
		{
			OverflowPlayerIcons[IconIndex].CurWidth = PlayerSizeZoomed * IconSizeModifier * OverflowPlayerIcons[IconIndex].ScaleX;
			OverflowPlayerIcons[IconIndex].CurHeight = PlayerSizeZoomed * IconSizeModifier * OverflowPlayerIcons[IconIndex].ScaleY;
		}

		OverflowPlayerIcons[IconIndex].SetScreenLocation(
			HUDComponents[ROOMT_Map].X + ((IconY - MinVisibleWorldY) * (HUDComponents[ROOMT_Map].Width / (MaxVisibleWorldY - MinVisibleWorldY))) - (OverflowPlayerIcons[IconIndex].CurWidth / 2.0),
			HUDComponents[ROOMT_Map].Y + HUDComponents[ROOMT_Map].Height - ((IconX - MinVisibleWorldX) * (HUDComponents[ROOMT_Map].Height / (MaxVisibleWorldX - MinVisibleWorldX))) - (OverflowPlayerIcons[IconIndex].CurHeight / 2.0));
		OverflowPlayerIcons[IconIndex].Update(WorldInfo.TimeSeconds);

		// Show the "SL#" label next to the icon, positioned the same way native does it
		if ( ROPRI.bIsSquadLeader && ROPRI.SquadIndex < `MAX_SQUADS )
		{
			OverflowSLLabels[ROPRI.SquadIndex].bVisible = true;
			OverflowSLLabels[ROPRI.SquadIndex].SetScreenLocation(
				OverflowPlayerIcons[IconIndex].CurX + OverflowPlayerIcons[IconIndex].CurWidth + 6 * OverflowPlayerIcons[IconIndex].ScaleY,
				OverflowPlayerIcons[IconIndex].CurY + 2 * OverflowPlayerIcons[IconIndex].ScaleY,
				true, true);
		}
	}

	for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
	{
		if ( ClaimedSlots.Find(i) == INDEX_NONE )
		{
			OverflowIconOwner[i] = none;
			OverflowPlayerIcons[i].bVisible = false;
			OverflowPlayerIcons[i].bFadedOut = true;
		}
	}
}

// Native icon arrays (EnemySpottedIcons, TunnelSpottedIcons, ...) all get their scale
// resynced here on every resolution/canvas change - without this, OverflowPlayerIcons keeps
// whatever scale a freshly-`new`'d ROHUDWidgetComponent starts with, which drifts further out
// of sync with the map's actual rendered scale the more the map is zoomed
function HandleCanvasSizeChange(Canvas HUDCanvas, float ScaleX, float ScaleY)
{
	local int i;

	super.HandleCanvasSizeChange(HUDCanvas, ScaleX, ScaleY);

	for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
	{
		if ( OverflowPlayerIcons[i] != none )
		{
			OverflowPlayerIcons[i].SetScale(ScaleY, ScaleY);
		}
	}

	for ( i = 0; i < `MAX_SQUADS; i++ )
	{
		if ( OverflowSLLabels[i] != none )
		{
			OverflowSLLabels[i].SetScale(ScaleY, ScaleY);
		}
	}
}

function RenderWidget(Canvas HUDCanvas)
{
	local int i;

	super.RenderWidget(HUDCanvas);

	if ( bHiddenTemporarily || !IsVisible() )
		return;

	for ( i = 0; i < `MAX_PLAYERS_PER_TEAM; i++ )
	{
		if ( OverflowPlayerIcons[i].bVisible && !OverflowPlayerIcons[i].bFadedOut )
		{
			OverflowPlayerIcons[i].Render(HUDCanvas, CurrentX, CurrentY);
		}
	}

	for ( i = 0; i < `MAX_SQUADS; i++ )
	{
		if ( OverflowSLLabels[i].bVisible )
		{
			OverflowSLLabels[i].Render(HUDCanvas, CurrentX, CurrentY);
		}
	}
}

defaultproperties
{
	Begin Object Class=ROHUDWidgetComponent Name=OverflowPlayerTexture
		Width=8
		Height=8
		TexWidth=64
		TexHeight=64
		Tex=Texture2D'VN_UI_Textures.OverheadMap.UI_Overhead_PlayerIcon'
		DrawColor=(R=80,G=160,B=240,A=255)
		bFadedOut=true
		bVisible=false
		SortPriority=DSP_SkyHigh
	End Object
	OverflowPlayerIcons(0)=OverflowPlayerTexture
}
