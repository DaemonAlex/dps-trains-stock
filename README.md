# dps-trains-stock

Streamed train models, carriage sets and train data for FiveM: passenger, metro and freight consists, with no scripts. This resource ships the train models and tells the game what a train is made of; a train script (on DPS, `dps-trains`) decides where trains go and when.

Derived from *Trains Overhauled Edition*, a public rolling-stock pack. The pack's own C# train system, ticket purchase and `server.lua` are deliberately excluded; see [What was removed](#what-was-removed).

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

`TRAINCONFIGS_FILE` **appends** to the vanilla table rather than replacing it. Vanilla occupies variations 0 to 27, so these start at **28**, in the order they appear in the file:

| Variation | Config | What it is |
|---|---|---|
| 28 | `passenger_config01` | Blue passenger set (Axsellya Express): `streakcoaster` engine, 2x `streakc`, 1x `streakcab`. |
| 29 | `passenger_config02` | Brown passenger set (Brown Streak): `streak` engine and 3x `streakcoastercab`. |
| 30 | `freight_config01` | Freight set: `sd70mac` engine, 2x `freightflat`, 1x `freightcaboose`. |
| 31 | `metro_config01` | Metro set: one `metrotrain` car (vanilla model). Stations are announced and doors beep. |
| 32 | `rox_passenger_config01` | Roxwood regional passenger set: `amb_statrac_loc` engine, 3x `streakc`, 1x `streakcab`. |

Groups: `passenger_group` (`passenger_config01`, `passenger_config02`), `freight_group` (`freight_config01`) and `metro_group` (`metro_config01`).

The file only defines the sets. It does not move trains. You need a train script to spawn and run them.

On DPS, `dps-trains` uses these numbers directly (`configs/metro.lua` and `configs/freight.lua`; the mainline regional trains run variation 32, the Roxwood shuttle 31). **A variation the game does not have crashes clients** that aren't on canary; there is no graceful failure. Keep the script and this file in step.

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

## Prerequisites

- A game build that supports the `TRAINCONFIGS_FILE` data file type.
- `amb-roxwood-trains`. `rox_passenger_config01` uses the model `amb_statrac_loc`, which is not in this resource. It is referenced by name only and must stream from `amb-roxwood-trains`. Without that resource the Roxwood set has no engine.
- `metrotrain` is a base game model and needs nothing extra.
- A train script that spawns trains by variation.

## Installation

1. Copy the folder into your resources directory. Keep the folder name `dps-trains-stock`.
2. Make sure the folder contains `stream/`, `data/` and `dlc_dpstrains/train_sounds.awc`.
3. Add `ensure dps-trains-stock` to `server.cfg` before the train script. If you use the Roxwood set, also ensure `amb-roxwood-trains`.
4. Do not edit or remove the `data_file` lines in `fxmanifest.lua`. They register the train configs, vehicle metadata, handling, layouts, audio wavepack, sound data and the ytyp request.
5. Restart the server. Players should reconnect, because data files load when a client joins.

## Changing a consist

1. Edit the `<train_config>` block in `data/trains.xml`.
2. **On DPS, regenerate `dps-trains/data/trains.lua`.** That file tells the client which models to preload per variation, and a stale list makes train creation fail with `carriage hash '...' is not loaded`. This dependency is invisible from either end and has broken the railway more than once.
3. If you add or reorder configs, the variation numbers move: update every script that spawns trains by number.
4. Reboot the server. Clients must rejoin: `data_file` contents are read at join, not on resource restart.

## Customisation

- Back to a two-car metro: open `data/trains.xml`, find `metro_config01`, and add a second metro carriage line. The original line looks like this:

  ```xml
  <carriage model_name = "metrotrain" max_peds_per_carriage = "4" flip_model_dir = "false" do_interior_lights = "true" carriage_vert_offset = "0.4" repeat_count = "1" />
  ```

  Add a second line with `flip_model_dir = "true"`, or set `repeat_count` to 2 on the single line. Note why it is one car on DPS: the flipped second car slammed into the first at the LS end of the Roxwood shuttle and threw riders out.
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
- Roxwood set has no engine or fails to spawn: `amb-roxwood-trains` is missing or starts after the train script.
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
