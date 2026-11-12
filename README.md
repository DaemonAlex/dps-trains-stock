# dps-trains-stock

Streamed train models, carriage sets and train data for FiveM: passenger, metro and freight consists, with no scripts. This resource ships the train models and tells the game what a train is made of; a train script (on DPS, `dps-trains`) decides where trains go and when.

Derived from *Trains Overhauled Edition*, a public rolling-stock pack. The pack's own C# train system, ticket purchase and `server.lua` are deliberately excluded; see [What was removed](#what-was-removed).

## What it is for

A train script needs trains to run. The stock game has few, and they look dated. This resource gives the server better passenger and freight stock, and tells the game which carriages make up each train. Every player then sees the same train.

## Features

- Train models (locomotives, passenger coaches and freight wagons) in `stream/`, each with a `_hi` model.
- `data/vehicles.meta` declares 31 train models. All use `VEHICLE_TYPE_TRAIN` and `FLAG_DONT_SPAWN_AS_AMBIENT`.
- `data/handling.meta` adds two handling entries: `FREIGHT` and `FREIGHTCAR`.
- `data/vehiclelayouts.meta` adds the train layouts (seats and door components).
- Train audio comes from the `dlc_dpstrains` wavepack and `data/bdtrain_sounds.dat54.rel`.
- Streamed props and ymaps: a grate, a railway bridge, a station cover, station ymaps (Sandy Shores, Paleto, La Mesa, Davis Quartz) and the ticket-machine ymap.

| Data file | Registered as | Purpose |
|---|---|---|
| `data/trains.xml` | `TRAINCONFIGS_FILE` | which carriages make up each consist |
| `data/vehicles.meta` | `VEHICLE_METADATA_FILE` | declares the models to the game |
| `data/handling.meta` | `HANDLING_FILE` | two entries: `FREIGHT`, `FREIGHTCAR` |
| `data/vehiclelayouts.meta` | `VEHICLE_LAYOUTS_FILE` | seats and door components |
| `dlc_dpstrains/` | `AUDIO_WAVEPACK` | train sounds |
| `stream/` | | the models, textures (`dpstraingen.ytd`) and ymaps |

## Consists (`data/trains.xml`)

`TRAINCONFIGS_FILE` **appends** to the vanilla table rather than replacing it. These sets come straight after the last vanilla one, in the order they appear in the file. The vanilla table grows with the game build, so the numbers depend on the build. `dps-trains/configs/metro.lua` puts the vanilla metro at 27 on builds 3095 to 3406 and at 28 from build 3407.

| Build 3095 to 3406 | Build 3407 and later | Config | What it is |
|---|---|---|---|
| 28 | 29 | `passenger_config01` | Blue passenger set (Axsellya Express): `streakcoaster` engine, 2x `streakc`, 1x `streakcab`. |
| 29 | 30 | `passenger_config02` | Brown passenger set (Brown Streak): `streak` engine and 3x `streakcoastercab`. |
| 30 | 31 | `freight_config01` | Freight set: `sd70mac` engine, 2x `freightflat`, 1x `freightcaboose`. |
| 31 | 32 | `metro_config01` | Metro set: two `facametrotrain` cars, the second one flipped. Stations are announced and doors beep. |
| 32 | 33 | `lrt_config01` | Tram set: two `tram` cars, the second one flipped. Stations are announced and doors beep. |

The Roxwood regional set (`rox_passenger_config01`) was removed on 31 October 2026, when Roxwood left the server. Every set after it moved down one.

Groups: `passenger_group` (`passenger_config01`, `passenger_config02`), `freight_group` (`freight_config01`) and `metro_group` (`metro_config01`).

The file only defines the sets. It does not move trains. You need a train script to spawn and run them.

On DPS, `dps-trains` uses these numbers (`configs/metro.lua`). It counts them on from the vanilla metro, so a new game build does not break them. Adding, removing or reordering a set in this file does. **A variation the game does not have crashes clients** that aren't on canary; there is no graceful failure. Keep the script and this file in step.

Keep consists short: long trains blink under OneSync (the old 9-car rakes were cut down for this). `streakc` is the only coach with rideable geometry; the coaches are `LAYOUT_BUS` and carry the riding system.

### Model names do not match liveries

Established in game, not inferred from the names:

```
BLUE (Amtrak)   streakcoaster (loco) · streakc · streakcab
BROWN           streak (loco) · streakcoastercab
```

The `coaster`-named cab car is the **brown** coach; plain `streakc` / `streakcab` are Amtrak stock. Pairing carriages with the similarly-named locomotive produces a mismatched rake every time.

### Ride heights

`carriage_vert_offset` is **1.64 to 1.65 for locomotives**, **1.76 for passenger carriages** and **0.4 for the metro**. Getting this wrong sits the coaches low in the rails.

## On its own, and with other scripts

**On its own.** Nothing moves. This resource has no scripts. It streams the models and registers the carriage sets. Any train script that spawns trains by variation number can use them.

**With a paid train pack (BigDaddy Trains Overhauled).** The models, sounds and station pieces here come from that pack. The pack's own train system is left out, so one script controls the trains. This resource holds copies of the pack's files. It does not call the pack. When the pack updates, copy the new model files into `stream/`. Then check that `data/trains.xml` still lists the sets in the same order.

**With a paid vehicle pack (`amb-ragsriches-vehicles`).** The metro set uses the model `facametrotrain`. That model is not in this resource. It is named here and streams from `amb-ragsriches-vehicles`. Without that resource the metro set has no model.

**With dps-trains.** dps-trains spawns these sets by number, runs them to a timetable and stops them at stations. dps-trains also keeps a list of the models in each set (`data/trains.lua`). Regenerate that list when a set changes here.

**With dps-traintools.** Players board these carriages and sit in them. The seat positions in dps-traintools are fitted to the model names in this pack.

**With dps-traintracks.** That resource adds track. Its track file names a carriage set from this file to run on it.

**With dps-transitapp.** No direct link. The phone app shows the trains that dps-trains runs with this stock.

## Prerequisites

- A game build that supports the `TRAINCONFIGS_FILE` data file type.
- `amb-ragsriches-vehicles`, for the metro set. See above.
- The `tram` model, for the tram set. It is not in this resource. The note in `data/trains.xml` calls it the game's default tram.
- A train script that spawns trains by variation.

## Installation

1. Copy the folder into your resources directory. Keep the folder name `dps-trains-stock`.
2. Make sure the folder contains `stream/`, `data/` and `dlc_dpstrains/train_sounds.awc`.
3. Add `ensure dps-trains-stock` to `server.cfg` before the train script. If you use the metro set, also ensure `amb-ragsriches-vehicles`.
4. Do not edit or remove the `data_file` lines in `fxmanifest.lua`. They register the train configs, vehicle metadata, handling, layouts, audio wavepack, sound data and the ytyp request.
5. Restart the server. Players should reconnect, because data files load when a client joins.

## Changing a consist

1. Edit the `<train_config>` block in `data/trains.xml`.
2. **On DPS, regenerate `dps-trains/data/trains.lua`.** That file tells the client which models to preload per variation, and a stale list makes train creation fail with `carriage hash '...' is not loaded`. This dependency is invisible from either end and has broken the railway more than once.
3. If you add or reorder configs, the variation numbers move: update every script that spawns trains by number.
4. Reboot the server. Clients must rejoin: `data_file` contents are read at join, not on resource restart.

## Customisation

- Metro length: open `data/trains.xml` and find `metro_config01`. It has two carriage lines. The first looks like this:

  ```xml
  <carriage model_name = "facametrotrain" max_peds_per_carriage = "4" flip_model_dir = "false" do_interior_lights = "true" carriage_vert_offset = "0.4" repeat_count = "1" />
  ```

  The second is the same with `flip_model_dir = "true"`. Remove the second line for a one-car metro. The metro ran as one car from 21 September to 2 November 2026: the flipped second car slammed into the first at the LS end of the Roxwood shuttle and threw riders out. That shuttle is gone, so the second car is back.
- Carriage options in each `<carriage>`: `max_peds_per_carriage` (passenger seats filled with peds), `flip_model_dir`, `do_interior_lights`, `carriage_vert_offset` and `repeat_count`.
- Set options on each `<train_config>`: `populate_train_dist`, `announce_stations`, `doors_beep`, `carriages_hang`, `carriages_swing`, `link_tracks_with_adjacent_stations`, `no_random_spawn` and `carriage_gap`.
- Handling values (mass, brakes, top speed) are in `data/handling.meta`.

## Weight

Texture memory is charged **per unique model, not per carriage**: a nine-car train repeating one coach costs less than a four-car train with four different ones. That is why the passenger consists reuse a single carriage type.

The textures were shrunk in September 2026 (to 1024, `foxbox` to 512), taking the set from about 1.1 GB to 0.3 GB in game. Before that, the freight wagons were the heavy ones (`freightstack`, `freightboxlarge`, `freightbox` 72 MB each, `foxbox` 80 MB).

To measure a `.ytd` exactly rather than guess: it is an RSC7 file, so skip the 16-byte header and zlib-inflate the rest. **The decompressed size is the VRAM figure** the server reports.

## What was removed

- **`BigDaddy-Trains.Client/Server.net.dll` and `server.lua`**: the pack ships a complete train system of its own. Running it alongside `dps-trains` would put two controllers on the same track.
- **`gta5.meta` / `replace_level_meta`**: declaring it produced `Could not find requested level (resources:/…/gta5)` on every client. The station `.ymap` builds and ticket machine were kept (they stream fine without the level meta) and are live in `stream/`.

## Troubleshooting

- Trains are invisible or untextured: the texture dictionary must match the `<residentTxd>` value in `data/vehicles.meta`, which is `dpstraingen`. Check that the `.ytd` in `stream/` has that exact name and is present on the server.
- No train sound: check the `AUDIO_WAVEPACK` line, which must read `data_file 'AUDIO_WAVEPACK' 'dlc_dpstrains'`. The folder `dlc_dpstrains` must contain `train_sounds.awc`, and `data/bdtrain_sounds.dat54.rel` must be listed in `files`.
- Metro set fails to spawn: `amb-ragsriches-vehicles` is missing, so the `facametrotrain` model does not load.
- `carriage hash '...' is not loaded`: the train script's preload list is stale (see Changing a consist, step 2).
- Edits to `trains.xml` or other data files do not show: restart the server and have clients reconnect.
- Trains crash a client: a script is asking for a variation number that does not exist. Check the number against the table above.
- XML errors break every train: check that `data/trains.xml` is still valid after any edit.

## Related (DPS)

| | |
|---|---|
| `dps-trains` | scheduling, movement, station stops |
| `dps-traintools` | boarding, seating, ambient riders |
| `dps-transitapp` | live arrivals on the phone |
| `dps-traintracks` | extra track data, no scripts |

## Recent changes

- **12 November 2026.** README: what it is for, how it works alone and with paid scripts, other DPS scripts.
- **10 November 2026.** The tram set (`lrt_config01`) is two default `tram` cars. The Flexity tram models are off the server: they were over the asset limit.
- **2 November 2026.** The metro set runs the `facametrotrain` model, and is two cars again.
- **31 October 2026.** Roxwood regional set removed. Roxwood left the server.
- **29 October 2026.** Flexity tram set added as `lrt_config01`.
- **4 October 2026.** Texture dictionary renamed to `dpstraingen`. Audio moved to `dlc_dpstrains/train_sounds.awc`.
- **10 September 2026.** Textures shrunk to 1024 (`foxbox` to 512): 1.1 GB down to 0.3 GB in game.

## Author

Made by [DaemonAlex](https://github.com/DaemonAlex) for DelPerroSands.

The models, sounds and station pieces are from Trains Overhauled by Big Daddy.

## Other DPS scripts

All of these are made for DelPerroSands and run together on one Qbox server. Each one works on
its own. The ones marked "pairs with" do more when both are running.

| Script | What it does |
|---|---|
| [dps-inventory](https://github.com/DaemonAlex/dps-inventory) | The inventory: ox_inventory with equipment slots, backpacks, armour plates and a self status panel, in the DelPerroSands colours. |
| [dps-medical](https://github.com/DaemonAlex/dps-medical) | Patient records, illness and diagnostic tests. A companion to wasabi_ambulance. Pairs with dps-inventory: symptoms and diagnoses show on the status panel. |
| [dps-insurance](https://github.com/DaemonAlex/dps-insurance) | Ties m-Insurance into the MDT, impound, hospital and medical chart. Pairs with dps-medical. |
| [dps-studio](https://github.com/DaemonAlex/dps-studio) | Build rooms, doors and portals in game from one panel (`/studio`), with owners and managers so staff do not have to support them. |
| [dps-shops](https://github.com/DaemonAlex/dps-shops) | Shop clerks who greet and react to a robbery, then player-owned shops. |
| [dps-fleet](https://github.com/DaemonAlex/dps-fleet) | Vehicle browser and workshop on one panel: extras, liveries and mods for emergency vehicles. |
| [dps-parking](https://github.com/DaemonAlex/dps-parking) | Parking with valet, impound, violations and reserved spots. |
| [dps-vehiclepersistence](https://github.com/DaemonAlex/dps-vehiclepersistence) | Vehicles stay where they were parked. Pairs with dps-parking. |
| [dps-towjob](https://github.com/DaemonAlex/dps-towjob) | Queue-based tow job with jg-mechanic integration. |
| [dps-services](https://github.com/DaemonAlex/dps-services) | Request a tow and follow it live on the lb-phone and lb-tablet. Pairs with dps-towjob. |
| [dps-autoshops](https://github.com/DaemonAlex/dps-autoshops) | Self-service repair shops when no mechanic is on duty. |
| [dps-cityworker](https://github.com/DaemonAlex/dps-cityworker) | City infrastructure job and career. |
| [dps-ainpcs](https://github.com/DaemonAlex/dps-ainpcs) | NPCs you can talk to, with trust, quests and intel. |
| [dps-badpeds](https://github.com/DaemonAlex/dps-badpeds) | Police interaction with NPCs: stops, arrests, intel and jail records. |
| [dps-gangwars](https://github.com/DaemonAlex/dps-gangwars) | Ambient gang NPCs, territory population and war reinforcements. |
| [dps-rotations](https://github.com/DaemonAlex/dps-rotations) | Moves dealers, harvests and other spots on a fixed schedule. |
| [dps-trains](https://github.com/DaemonAlex/dps-trains) | The train system. Pairs with dps-trains-stock, dps-traintools and dps-transitapp. |
| [dps-transitapp](https://github.com/DaemonAlex/dps-transitapp) | Live train arrival boards on the lb-phone. |
| [dps-faceplant](https://github.com/DaemonAlex/dps-faceplant) | City help, reports and staff tools on the lb-phone and lb-tablet. |
| [dps-chat](https://github.com/DaemonAlex/dps-chat) | A command box for voice-only servers. No chat feed. |
| [dps-filmmode](https://github.com/DaemonAlex/dps-filmmode) | One key hides every HUD layer and gives a smooth free camera for recording. |
