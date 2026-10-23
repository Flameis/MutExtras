# MutExtras

Extended role systems and custom equipment for specialized gameplay.

## Configuration

Enable role systems and faction switching in WebAdmin > Mutator Settings:

| Setting | Description |
| :--- | :--- |
| `bMACVSOGRoles` | Special operations roles with captured weapons and specialized equipment |
| `bAITRoles` | Enhanced roles matching 29th ID internal structure |
| `bUseDefaultFactions` | When disabled, allows custom faction selection for each team |
| `MyNorthForce` | Select Northern faction: PAVN (0) or NLF (1) |
| `MySouthForce` | Select Southern faction: USA (0), USMC (1), AUS (2), or ARVN (3) |
| `bEnableAmbientSoundFix` | Automatically triggers the map's ambient sound for players who join after it fires, if the level's Kismet doesn't already handle this client-side. The trigger is delayed, fires once and stops the ambience first so maps like Sapa don't play it twice |
| `bAllowIntroVO` | Set true to keep the round-start commander speech (muted by default). Also on the mutator settings page |

Other fixes: the "resupplied" element on the weapon HUD (ammo resupply info) no longer stays stuck on screen after resupplying a machine gun. This fix lives in `ACPlayerController`, so it only applies when MutExtras supplies the player controller (vanilla maps). Light ARVN uses the 29th's `ACWeap_XM177E1_Carbine_Late`, which keeps the 30 round XM177E1 but with 7 magazines like the other 29th loadouts.

Both role systems can be enabled simultaneously. Roles appear in role selection menu when enabled.

Faction switching allows you to customize which faction appears on each team. For example, you can set up ARVN vs NLF matches or USMC vs PAVN scenarios.

## Role Systems

**Radioman Ammo Crates**

When using bMACVSOGRoles or bAITRoles, Radioman/Support roles receive placeable ammo crates:
- Northern Radioman: VC Ammo Crate
- Southern Radioman: US Ammo Crate
- Can place one at a time
- Must be placed 30+ meters from other ammo crates
- Provides ammo resupply for nearby teammates

**Detailed Role Loadouts**

For complete weapon and equipment loadouts, see: [Link to role loadouts spreadsheet - TO BE ADDED]

## Additional Features

| Feature | Description |
| :--- | :--- |
| CTF Flag System (In Development) | Flag items for CTF modes, pickable by either team, drops on death, visual indicators |
| Squad Patches (In Development) | New squad insignia for 29th ID units |
| Tank Crew Roles | Automatically adds tank crew roles to Winter War and Black Orchestra maps |

## Commands

| Command | Description |
| :--- | :--- |
| `mutate changerank <rank>` | Change your rank insignia (e.g., `mutate changerank cpl`) |
| `mutate changeunit <unit>` | Change your unit insignia (e.g., `mutate changeunit DP2S4`) |
| `mutate salute` or `*Salute*` in chat | Trigger salute animation |
| `mutate addbots <count> <team> <true/false>` | Add bots to game (count, team index 0/1, spawn immediately true/false) |
| `mutate removebots` | Remove all bots from game |
| `mutate setspeed <speed> [all]` | Change movement speed multiplier (e.g., `mutate setspeed 2` or `mutate setspeed 1.5 all`) |
| `mutate allammo` | Toggle infinite ammo for yourself |
| `mutate resetmesh` | Reset your character mesh if visual glitches occur |
