# MutExtras

MutExtras adds the **29th's custom roles, weapons and equipment** to the game, lets you **change which factions fight each other**, and puts **rank and unit patches on helmets**. It also carries a handful of small fixes (sounds, HUD, ammo areas). The spectator view, map drawing and the map fixes for big teams are in MutCMenu.

## Contents

1. What it adds
2. Roles and loadouts
3. Weapons and equipment
4. Factions
5. Helmet patches
6. Fixes and small improvements
7. Free look
8. Commands
9. Settings
10. Works with other mods
11. Engineer fortifications

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
| Quality-of-life fixes | Sound, HUD, map icon and vehicle fixes |
| Free look | Hold a key to look around without moving your aim, like Arma or Squad, with your own body visible below you |

## 2. Roles and loadouts

- **AIT roles** (`bAITRoles`): replaces the normal role list with roles matching the 29th's internal structure. Roles exist for each force: PAVN, NLF, US Army, USMC, Australia and ARVN. Each force gets Rifleman, Light, Machine Gunner, Combat Engineer, Sniper, Support/Radioman and Commander roles, plus a tank crew role.
- **MACV-SOG roles** (`bMACVSOGRoles`): a special operations set for the Southern team (Rifleman, Light, Machine Gunner, Combat Engineer, Sniper, Support) with captured and specialised weapons, such as a suppressed XM21 and the MACV-SOG XM177E1 with 7 magazines. Turning this on also turns the AIT roles on.
- **Both can be on together.** The roles appear in the role selection screen.
- **Unlimited slots:** every role has no limit, except the commander (9).
- **Tank crew roles:** a tank crew role is added for both teams.
- **Pilot roles:** the pilot and transport pilot roles are added for the Southern team on maps that have pilots.
- **Lineup role:** a role for formations. It carries an M1 Garand and a "holster" item that plays a salute and a standing-at-attention pose. The pose stops when you move, crouch, go prone or change weapon, and it never cuts off the game's own moves (it used to stop other full-body animations, such as stance changes and bayonet stabs, five times a second).
- **Light ARVN** carries the game's own 30-round XM177E1 with 4 magazines. The 7-magazine XM177E1 is for the MACV-SOG roles only.
- **Role loadout list:** every role's weapon options are listed in `old docs/roleinfo_loadouts.csv`.
- **Two primaries:** a role whose secondary weapon is really a primary weapon (for example the Australian Combat Engineer's setup) can carry two primaries.
- **More placeable equipment:** the carry limit for placeable items is raised to 6.

## 3. Weapons and equipment

- **Ammo crates:** Radioman/Support roles can place a **resupply crate** (a US crate for the South, a VC crate for the North). You can place one at a time, at least 30 meters from any other crate, and nearby teammates are resupplied from it. **Any explosive can destroy a crate:** grenades, rockets, satchels, mines, artillery, tank shells and other mods' explosives all damage it from any side or angle, and one going off within about 2 meters destroys it. Napalm destroys it at once. Bullets, fire and gas don't hurt it.
- **Bigger loads:** four claymores, four tripwire traps, four fougasse mines, three molotovs, four smoke grenades for the MACV-SOG roles, an M60 with extra magazines, and 200-round MG34 and RPD belts.
- **Special M79:** a grenade launcher variant whose alternate fire shoots a white phosphorus grenade.
- **RPG-7 against vehicles:** the RPG rocket is changed so a tank is **destroyed after a few hits** (a light tank 3, a T-26 4, a T-28 5, a 53-K 1, and so on). The ACAV, helicopters and skis are not affected.
- **Satchel charge:** a heavier satchel (500 damage, large radius, 7 second fuse).
- **Other weapons:** MACV-SOG variants of the AK, M1A1, M2 Carbine, M3A1, M40, M60, RPD and XM21, Type 56 AK variants, and a few experimental weapons (CIWS, RPPG).
- **Helicopters:** the Cobra, Loach, Huey and Bushranger used by the Builder menu are the 29th's versions. They work with the pilot roles, and the Loach's enemy spotting works with them.
- **Capture the Flag flags** are now part of MutCMenu (see its README), because they depend on its `bLoadWW2` and `bLoadWW` settings and its admin list.

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

## 6. Fixes and small improvements

- **Round-start voice lines muted:** the commander speech and the spawn-in chatter at the start of a round are muted. Set `bAllowIntroVO` to keep them. The game queues these lines only a split second before they play, so they are checked for every frame (a slower check let some through).
- **Ambient sound fix** (`bEnableAmbientSoundFix`): players who join after a map's ambient sound started now hear it, once and not doubled (fixes Sapa playing it twice).
- **Resupply HUD fix:** the "resupplied" icon no longer stays stuck on the weapon display after resupplying a machine gun.
- **Ammo areas for both teams:** ammo resupply areas work for either team.
- **Vehicles follow their driver:** a vehicle takes the team of whoever drives it, so either team can use it.
- **Team switching any time:** players are not made to wait before switching teams.
- **Wind for smoke:** smoke drifts on the wind, and a map without a wind direction gives it none. MutExtras gives such a map a wind direction, facing a random way each time the map loads, or the way picked with `WindDirection`. With `bOverrideMapWind` the map's own wind is turned that way too (it keeps its strength). Turn the added wind off with `bDisableAddedWind`. Changes take effect from the next map. (How the smoke looks can only be checked by playing.)
- **Bot commands that work:** `addbots` no longer gets stuck when a team has no free roles, and `removebots` really removes them.

## 7. Free look

Hold your free look key and the mouse turns your head instead of your aim, like in Arma or Squad. Your weapon stays pointed where it was, and a shot still goes there. Let go and the view springs back to your aim with a little bounce, like the helicopter pilot's free look.

**Setting it up:** bind any key to `FreeLook` in the console, for example `setbind V FreeLook` (or `setbind MiddleMouseButton FreeLook`). A key bound only to `FreeLook` is used for nothing else. You can also add it to a key that already does something, for example `setbind LeftAlt "INF_Prone_Toggle | FreeLook"`, and that key does both. To get there without a binding, set `FreeLookKey=V` under `[MutExtras.ACFreeLookInput]` in `MutExtras_Client.ini`.

| What | How it works |
| :--- | :--- |
| Hold or toggle | Hold the key to look around (the default). Set `bFreeLookToggle=True` in `MutExtras_Client.ini` to switch it on and off with a press instead |
| How far | 100 degrees left and right, 70 degrees down and 60 degrees up from your aim. You can push about 10 degrees past an edge; it eases back to the edge, like the pilot's free look |
| Turning speed | The same as turning your aim, with your own mouse sensitivity and invert setting |
| When it doesn't work | Aiming down the sights, with a bipod deployed, in a vehicle or on a turret, with the overhead map open, when dead or spectating. If you aim down the sights while free looking, the view springs back |
| Your body | While you free look, your soldier's own body shows below you, so you don't see floating arms. It is moved every frame so its head sits just behind and below your eyes, standing, crouching or prone (the game's third person model doesn't line up with the first person view on its own, which put the camera inside the chest and pack). Use `mutate fpbody always` to see it all the time in first person, like the WW2 mod does, or `mutate fpbody freelook` to see it only while free looking (the default). `mutate fpbody` on its own switches between the two. Your choice is saved in your own `MutExtras_Client.ini` |
| What others see | Other players see your soldier's head turn the way you are looking, a few times a second. Only the head turns; your chest and weapon stay where you aim |
| Server | Admins can turn free look off for everyone with **Players can free look** (`bDisableFreeLook`) |

- **Works with the other mods:** nothing in the game is replaced. On a WW2 soldier the WW2 mod's own first person body is used instead of this one.
- **Only the view turns:** the server never sees your free look, only how far your head is turned for others to see. Where you aim and shoot is exactly as without it.
- *Tested by the harness: the keys, hold and toggle, the limits and the bounce, that the aim doesn't move, that the camera is turned, the body (shown, hidden, the upper arms hidden so the first person arms aren't doubled), `mutate fpbody` and the head turn sent and pointed. Not yet tried in a game: how it looks and feels, whether the body sits right (it may clip the collar or pack when you look straight down, and there may be a gap at the shoulders), and whether other players' heads visibly turn (it uses a head look-at node in the game's soldier animation that the game itself only finds and never uses on foot; if that node isn't active outside turrets, heads won't turn and this needs another way).*

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
| `mutate fpbody always` / `freelook` | Shows your own body in first person all the time, or only while free looking (see Free look). On its own it switches between the two |

Testing console commands (type them directly, no `mutate`): `mcamera <1st, 3rd, free, fixed>`, `mfly`, `mwalk` and `mghost`.

## 9. Settings

Set in WebAdmin under **Mutators > MutExtras Settings**, or in `MutExtras_Server.ini`. The page has a tab for each group of settings. Each setting has a plain label, on/off settings are **On** and **Off** buttons, and settings with a few fixed values (such as the number of Canberra planes) offer just those. The labels and button names come from the mod's text file in `Localization\INT` (`MutExtras.int`), which a server needs next to the mod; without it the page shows the setting names below and the buttons have no text. The tabs are **Roles**, **Factions** (the two forces are choices: PAVN or NLF, and a drop-down of US Army, USMC, Australian Army and ARVN) **Sound and fixes**, **Wind**, **Free look** and **Engineer fortifications**.

| Setting | What it does |
| :--- | :--- |
| `bAITRoles` | Use the 29th's AIT roles |
| `bMACVSOGRoles` | Use the MACV-SOG roles (also turns on the AIT roles) |
| `bUseDefaultFactions` | On: the map picks the forces. Off: you pick them below |
| `MyNorthForce` | The Northern force: PAVN (0) or NLF (1) |
| `MySouthForce` | The Southern force: USA (0), USMC (1), Australia (2) or ARVN (3) |
| `bEnableAmbientSoundFix` | Fix the ambient sound for late joiners |
| `bAllowIntroVO` | Keep the round-start voice lines (muted when off) |
| `bDisableAddedWind` | Don't give maps without wind a wind direction (shown on the page as "Give maps with no wind a wind direction", On by default) |
| `WindDirection` | Which way the wind blows smoke: 0 random each map (the default), 1 north, 2 north-east, 3 east, 4 south-east, 5 south, 6 south-west, 7 west, 8 north-west |
| `bOverrideMapWind` | Also turn the map's own wind to that direction (or a random one) |
| `bEngineerFortifications` | Engineers spawn with a sandbag kit and a barbed wire kit (off by default). See section 11 |
| `EngineerSandbagKits`, `EngineerWireKits` | Pieces in each kit (up to 20). 0 means the default: 3 sandbag walls, 2 stretches of wire |
| `bDisableFreeLook` | Turn free look off for every player (shown on the page as "Players can free look", On by default). Players who join after the change get it |

## 10. Works with other mods

- On a normal map, MutExtras replaces the roles and pawns as described above. It does not replace the HUD, so other mods can.
- With **WW2 (Black Orchestra)**, **Winter War** or **GOM (Gameplay Overhaul Mutator)** loaded, MutExtras only adds tank crew roles (Wehrmacht, Commonwealth, Soviet, US and IJA tankers for WW2; Finnish and Soviet for Winter War; the 29th's crews for GOM) and fixes the tank crews' pilot flag.

## 11. Engineer fortifications

With **Engineers spawn with a sandbag kit and a barbed wire kit** on (`bEngineerFortifications`, off by default), every combat engineer spawns with two extra items:

| Kit | What it places |
| :--- | :--- |
| **Sandbag Kit** | 3 sandbag walls (about 2.4 m long and 1.2 m high) |
| **Barbed Wire Kit** | 2 stretches of barbed wire fence (about 2.5 m each) |

Select a kit like any item: a see-through preview shows where the piece will go, green where it fits and red where it doesn't (too steep, no room, nothing to stand on). Click to place it. The piece goes across your view, centred where you aim, with the ammo crate's placing animation. You are told how many are left, and the kit is gone after its last piece.

- **Solid:** soldiers can't walk through a piece, and bullets don't go through it.
- **Destroyed by explosives only:** grenades, satchels, C4, rockets, tank shells, artillery and mines wear it down. A sandbag wall takes about one satchel, wire much less. Bullets do nothing to it.
- **Never on a soldier:** a piece that would trap someone isn't placed, and you keep it.
- **Every round starts clean:** pieces are removed when a new round starts.
- The number of pieces in each kit can be set (`EngineerSandbagKits`, `EngineerWireKits`).

*Tested by the harness: the kits and their numbers, where a piece goes and how it is turned, solid for soldiers and bullets, bullets doing nothing and a satchel destroying it, nothing placed on a soldier, the kit used up, and a new round clearing them. Not yet tried in a game: the arms and animation (they are the ammo crate's), how the preview and the kit's name in the weapon list look, and whether the game's placing hint still says it is an ammo crate.*

---

*Part of the 29th Infantry Division Mutator Suite*
