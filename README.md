# MutExtras

MutExtras adds the **29th's custom roles, weapons and equipment** to the game, lets you **change which factions fight each other**, puts **rank and unit patches on helmets**, and improves **spectating**. It also carries a handful of small fixes (sounds, HUD, map icons).

## Contents

1. What it adds
2. Roles and loadouts
3. Weapons and equipment
4. Factions
5. Helmet patches
6. Spectator mode
7. Fixes and small improvements
8. Commands
9. Settings
10. Works with other mods

---

## 1. What it adds

| Feature | In short |
| :--- | :--- |
| AIT roles | Roles that match the 29th's internal structure |
| MACV-SOG roles | Special operations roles with captured weapons |
| Custom weapons and kit | Extra ammo, extra grenades and mines, special variants |
| Faction switching | Put any Southern force against any Northern force |
| Helmet patches | Rank and unit patches that everyone can see |
| Salute and lineup role | A salute animation and a role for formations |
| Better spectating | See every player, with team colours, on the map and in the world |
| Quality-of-life fixes | Sound, HUD, map icon and vehicle fixes |

## 2. Roles and loadouts

- **AIT roles** (`bAITRoles`): replaces the normal role list with roles matching the 29th's internal structure. Roles exist for each force: PAVN, NLF, US Army, USMC, Australia and ARVN. Each force gets Rifleman, Light, Machine Gunner, Combat Engineer, Sniper, Support/Radioman and Commander roles, plus a tank crew role.
- **MACV-SOG roles** (`bMACVSOGRoles`): a special operations set for the Southern team (Rifleman, Light, Machine Gunner, Combat Engineer, Sniper, Support) with captured and specialised weapons, such as a suppressed XM21 and the MACV-SOG XM177E1 with 7 magazines. Turning this on also turns the AIT roles on.
- **Both can be on together.** The roles appear in the role selection screen.
- **Unlimited slots:** every role has no limit, except the commander (9).
- **Tank crew roles:** a tank crew role is added for both teams.
- **Pilot roles:** the pilot and transport pilot roles are added for the Southern team on maps that have pilots.
- **Lineup role:** a role for formations. It carries an M1 Garand and a "holster" item that plays a salute and a standing-at-attention pose.
- **Light ARVN** carries the game's own 30-round XM177E1 with 4 magazines. The 7-magazine XM177E1 is for the MACV-SOG roles only.
- **Role loadout list:** every role's weapon options are listed in `old docs/roleinfo_loadouts.csv`.
- **Two primaries:** a role whose secondary weapon is really a primary weapon (for example the Australian Combat Engineer's setup) can carry two primaries.
- **More placeable equipment:** the carry limit for placeable items is raised to 6.

## 3. Weapons and equipment

- **Ammo crates:** Radioman/Support roles can place a **resupply crate** (a US crate for the South, a VC crate for the North). You can place one at a time, at least 30 meters from any other crate, and nearby teammates are resupplied from it.
- **Bigger loads:** four claymores, four tripwire traps, four fougasse mines, three molotovs, four smoke grenades for the MACV-SOG roles, an M60 with extra magazines, and 200-round MG34 and RPD belts.
- **Special M79:** a grenade launcher variant whose alternate fire shoots a white phosphorus grenade.
- **RPG-7 against vehicles:** the RPG rocket is changed so a tank is **destroyed after a few hits** (a light tank 3, a T-26 4, a T-28 5, a 53-K 1, and so on). The ACAV, helicopters and skis are not affected.
- **Satchel charge:** a heavier satchel (500 damage, large radius, 7 second fuse).
- **Other weapons:** MACV-SOG variants of the AK, M1A1, M2 Carbine, M3A1, M40, M60, RPD and XM21, Type 56 AK variants, and a few experimental weapons (CIWS, RPPG).
- **Helicopters:** the Cobra, Loach, Huey and Bushranger used by the Builder menu are the 29th's versions. They work with the pilot roles, and the Loach's enemy spotting works with them.
- **Capture the Flag flag** *(in development)*: a flag item either team can pick up, that drops when its carrier dies, never disappears, and shows a beam above whoever carries it.

## 4. Factions

By default the map decides who fights whom. Turn **`bUseDefaultFactions` off** to pick the forces yourself:

| Setting | Choices |
| :--- | :--- |
| `MyNorthForce` | PAVN (0) or NLF (1) |
| `MySouthForce` | USA (0), USMC (1), Australia (2) or ARVN (3) |

Examples: ARVN against NLF, or USMC against PAVN. The choice is sent to every player as they join.

## 5. Helmet patches

Players can wear a **rank patch** and a **unit patch** on their helmet, and everyone sees them.

- A player sets their own with `mutate changerank <rank>` (for example `cpl`) and `mutate changeunit <unit>` (for example `DP2S4`).
- Admins can set another player's patches from the CMenu **Manage Players** menu.
- The server saves each player's patches against their Steam ID and puts them back every time they join. The patches are never stored on the player's own computer.
- *(In development)* New squad patches for 29th ID units.

## 6. Spectator mode

Spectators normally only see players near them. With MutExtras, spectators get:

- **Everyone on the overhead map:** a marker for every living player, using the game's own player and vehicle icons (tank, truck, each helicopter) in the team colour. Squad and team leaders get the leader icon.
- **Triangles over players:** a small triangle in the team colour sitting just above the head of every player in view.
- **Names when you look at someone:** the player nearest the middle of your screen shows their **name in their team colour** instead of the triangle. When that player is close (within about 40 meters), the **role icon they picked** is shown under the name in the team colour, like the base game does for friendlies. The triangle and the name sit right on top of the head.
- **The game's own name display is turned off** while you spectate, so the two do not double up. It is turned off in every place the game might read the setting from, and put back when you stop spectating. Your saved setting is never changed. (If the game still shows its own names as well, tell us.)
- **A clean map:** while the map is open, the names and triangles are hidden.

It does not replace any part of the game's screen, so it also works with WW2, Winter War and GOM (Gameplay Overhaul Mutator). Turn it off with `bDisableEnhancedSpectator`.

## 7. Fixes and small improvements

- **Round-start voice lines muted:** the commander speech and the spawn-in chatter at the start of a round are muted. Set `bAllowIntroVO` to keep them.
- **Ambient sound fix** (`bEnableAmbientSoundFix`): players who join after a map's ambient sound started now hear it, once and not doubled (fixes Sapa playing it twice).
- **Resupply HUD fix:** the "resupplied" icon no longer stays stuck on the weapon display after resupplying a machine gun.
- **More than 32 per team:** teammates beyond 32 on a team are now shown on the overhead map (the game normally drops them).
- **Custom objectives on the map:** objectives built with CMenu get their borders drawn on the overhead map.
- **Ammo areas for both teams:** ammo resupply areas work for either team.
- **Vehicles follow their driver:** a vehicle takes the team of whoever drives it, so either team can use it.
- **Team switching any time:** players are not made to wait before switching teams.
- **Bot commands that work:** `addbots` no longer gets stuck when a team has no free roles, and `removebots` really removes them.

## 8. Commands

Type these in the console as `mutate <command>`.

| Command | What it does |
| :--- | :--- |
| `mutate changerank <rank>` | Changes your helmet rank patch (for example `cpl`) |
| `mutate changeunit <unit>` | Changes your helmet unit patch (for example `DP2S4`) |
| `mutate salute` (or `*Salute*` in chat) | Plays the salute animation |
| `mutate addbots <count> <team> <true/false>` | Adds bots: how many, which team (0 or 1) and whether they spawn straight away. `mutate addbots 4` just raises the bot count |
| `mutate removebots` | Removes all bots |
| `mutate setspeed <speed> [all]` | Changes movement speed for you, or for everyone with `all` (for example `mutate setspeed 1.5 all`) |
| `mutate allammo` | Toggles infinite ammo for you |
| `mutate resetmesh` | Resets your character model if it looks wrong |

Testing console commands (type them directly, no `mutate`): `mcamera <1st, 3rd, free, fixed>`, `mfly`, `mwalk` and `mghost`.

## 9. Settings

Set in WebAdmin under **Mutators > MutExtras Settings**, or in `MutExtras_Server.ini`.

| Setting | What it does |
| :--- | :--- |
| `bAITRoles` | Use the 29th's AIT roles |
| `bMACVSOGRoles` | Use the MACV-SOG roles (also turns on the AIT roles) |
| `bUseDefaultFactions` | On: the map picks the forces. Off: you pick them below |
| `MyNorthForce` | The Northern force: PAVN (0) or NLF (1) |
| `MySouthForce` | The Southern force: USA (0), USMC (1), Australia (2) or ARVN (3) |
| `bEnableAmbientSoundFix` | Fix the ambient sound for late joiners |
| `bAllowIntroVO` | Keep the round-start voice lines (muted when off) |
| `bDisableEnhancedSpectator` | Turn the spectator overlay off (it is on by default) |

## 10. Works with other mods

- On a normal map, MutExtras replaces the roles, pawns and HUD map as described above.
- With **WW2 (Black Orchestra)**, **Winter War** or **GOM (Gameplay Overhaul Mutator)** loaded, MutExtras only adds tank crew roles (Wehrmacht, Commonwealth, Soviet, US and IJA tankers for WW2; Finnish and Soviet for Winter War; the 29th's crews for GOM) and fixes the tank crews' pilot flag. The spectator overlay works in all cases.

---

*Part of the 29th Infantry Division Mutator Suite*
