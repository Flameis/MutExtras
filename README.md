# MutExtras

Extended role systems and custom equipment for specialized gameplay.

## Configuration

Enable role systems in WebAdmin > Mutator Settings:

| Setting | Description |
| :--- | :--- |
| `bMACVSOGRoles` | Special operations roles with captured weapons and specialized equipment |
| `bAITRoles` | Enhanced roles matching 29th ID internal structure |

Both systems can be enabled simultaneously. Roles appear in role selection menu when enabled.

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
| `mutate changerank <rank>` | Change your rank insignia |
| `mutate changeunit <unit>` | Change your unit insignia |
| `mutate salute` or `*Salute*` in chat | Trigger salute animation |
| `mutate addbots <count> <team> <true/false>` | Add bots to game |
| `mutate removebots` | Remove all bots |
| `mutate setspeed <speed> [all]` | Change movement speed (self or all) |
| `mutate allammo` | Toggle infinite ammo |
| `mutate resetmesh` | Reset your character mesh |
