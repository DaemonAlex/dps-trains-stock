# dps-trains-stock

Streamed train models, carriage sets and train data for FiveM: passenger, metro and freight consists, with no scripts.

## Features

- Train models (locomotives, passenger coaches and freight wagons) in `stream/`, each with a `_hi` model.
- `data/vehicles.meta` declares 31 train models. All use `VEHICLE_TYPE_TRAIN` and `FLAG_DONT_SPAWN_AS_AMBIENT`.
- `data/handling.meta` adds two handling entries: `FREIGHT` and `FREIGHTCAR`.
- `data/vehiclelayouts.meta` adds the train layouts.
- Train audio comes from the `dlc_dpstrains` wavepack and `data/bdtrain_sounds.dat54.rel`.
- Streamed props and ymaps: a grate, a railway bridge, a station cover and four ymap files.

### Train configs in `data/trains.xml`

| Config | What it is |
|---|---|
| `passenger_config01` | Blue passenger set: `streakcoaster` engine, 2x `streakc`, 1x `streakcab`. |
| `passenger_config02` | Brown passenger set: `streak` engine and 3x `streakcoastercab`. |
| `freight_config01` | Freight set: `sd70mac` engine, 2x `freightflat`, 1x `freightcaboose`. |
| `metro_config01` | Metro set: one `metrotrain` car. Stations are announced and doors beep. |
| `rox_passenger_config01` | Roxwood regional passenger set (game variation 33): `amb_statrac_loc` engine, 3x `streakc`, 1x `streakcab`. |

Groups: `passenger_group` (`passenger_config01`, `passenger_config02`), `freight_group` (`freight_config01`) and `metro_group` (`metro_config01`).

The file only defines the sets. It does not move trains. You need a train script to spawn and run them.

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

## Customisation

- Back to a two-car metro: open `data/trains.xml`, find `metro_config01`, and add a second metro carriage line. The original line looks like this:

  ```xml
  <carriage model_name = "metrotrain" max_peds_per_carriage = "4" flip_model_dir = "false" do_interior_lights = "true" carriage_vert_offset = "0.4" repeat_count = "1" />
  ```

  Add a second line with `flip_model_dir = "true"`, or set `repeat_count` to 2 on the single line. A flipped second car makes the set look right running either direction.
- Carriage options in each `<carriage>`: `max_peds_per_carriage` (passenger seats filled with peds), `flip_model_dir`, `do_interior_lights`, `carriage_vert_offset` and `repeat_count`.
- Locomotives use `carriage_vert_offset` of 1.64 to 1.65. Passenger coaches use 1.76. Metro uses 0.4.
- Set options on each `<train_config>`: `populate_train_dist`, `announce_stations`, `doors_beep`, `carriages_hang`, `carriages_swing`, `link_tracks_with_adjacent_stations`, `no_random_spawn` and `carriage_gap`.
- Do not mix up the passenger models. `streakcoastercab` is the brown coach and `streakc` and `streakcab` are blue, whatever the names suggest.
- Variation numbers follow the order of configs in the file. If you add or reorder configs, update any script that spawns trains by number.
- Handling values (mass, brakes, top speed) are in `data/handling.meta`.

## Troubleshooting

- Trains are invisible or untextured: the texture dictionary must match the `<residentTxd>` value in `data/vehicles.meta`, which is `dpstraingen`. Check that the `.ytd` in `stream/` has that exact name and is present on the server.
- No train sound: check the `AUDIO_WAVEPACK` line, which must read `data_file 'AUDIO_WAVEPACK' 'dlc_dpstrains'`. The folder `dlc_dpstrains` must contain `train_sounds.awc`, and `data/bdtrain_sounds.dat54.rel` must be listed in `files`.
- Roxwood set has no engine or fails to spawn: `amb-roxwood-trains` is missing or starts after the train script.
- Edits to `trains.xml` or other data files do not show: restart the server and have clients reconnect.
- Trains crash a client: a script is asking for a variation number that does not exist. Check the number against the order of configs in `data/trains.xml`.
- XML errors break every train: check that `data/trains.xml` is still valid after any edit.
