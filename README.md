# dps-trains-stock

Rolling stock and consist definitions for the DPS railway. **Assets only — no
scripts.** This resource ships the train models and tells the game what a train
is made of; `dps-trains` decides where trains go and when.

Derived from *Trains Overhauled Edition*, a public rolling-stock pack. The
pack's own C# train system, ticket purchase, `server.lua` and station `.ymap`
files are deliberately excluded — see [What was removed](#what-was-removed).

## What it provides

| Data file | Registered as | Purpose |
|---|---|---|
| `data/trains.xml` | `TRAINCONFIGS_FILE` | which carriages make up each consist |
| `data/vehicles.meta` | `VEHICLE_METADATA_FILE` | declares the models to the game |
| `data/handling.meta` | `HANDLING_FILE` | two entries: `FREIGHT`, `FREIGHTCAR` |
| `data/vehiclelayouts.meta` | `VEHICLE_LAYOUTS_FILE` | seats and door components |
| `audiodirectory/` | `AUDIO_WAVEPACK` | train sounds |
| `stream/` | — | the models, plus station ymaps (Sandy Shores, Paleto, La Mesa, Davis Quartz) and the ticket-machine ymap |

## Consists

`TRAINCONFIGS_FILE` **appends** to the vanilla table rather than replacing it.
Vanilla occupies indices 0–27, so these start at **28**:

| Variation | Config | Rake (live, verified 2026-08-28) |
|---|---|---|
| 28 | `passenger_config01` | Axsellya Express — `streakcoaster` + `streakc` + `streakcab` |
| 29 | `passenger_config02` | Brown Streak — `streak` + `streakcoastercab` |
| 30 | `freight_config01` | `sd70mac` + `freightflat` + `freightcaboose` |
| 31 | `metro_config01` | `metrotrain` ×2 (vanilla model) |

Keep consists short — long trains blink under OneSync (the old 9-car rakes were
cut down for this). `streakc` is the only coach with rideable geometry; the
coaches are `LAYOUT_BUS` and carry the riding system.

`dps-trains` references these numbers directly in `configs/freight.lua`. **An
index the game does not have crashes clients** that aren't on canary — there is
no graceful failure — so the two files must stay in step.

### Model names do not match liveries

Established in game, not inferred from the names:

```
BLUE (Amtrak)   streakcoaster (loco) · streakc · streakcab
BROWN           streak (loco) · streakcoastercab
```

The `coaster`-named cab car is the **brown** coach; plain `streakc` / `streakcab`
are Amtrak stock. Pairing carriages with the similarly-named locomotive produces
a mismatched rake every time.

### Ride heights

`carriage_vert_offset` is **1.64–1.65 for locomotives** and **1.76 for
carriages**. Getting this wrong sits the coaches low in the rails.

## Changing a consist

1. Edit the `<train_config>` block in `data/trains.xml`.
2. **Regenerate `dps-trains/data/trains.lua`.** That file tells the client which
   models to preload per variation, and a stale list makes train creation fail
   with `carriage hash '...' is not loaded`. This dependency is invisible from
   either end and has broken the railway more than once.
3. Reboot the server. Clients must rejoin — `data_file` contents are ingested at
   join, not on resource restart.

## What was removed

- **`BigDaddy-Trains.Client/Server.net.dll` and `server.lua`** — the pack ships a
  complete train system of its own. Running it alongside `dps-trains` would put
  two controllers on the same track.
- **`gta5.meta` / `replace_level_meta`** — declaring it produced
  `Could not find requested level (resources:/…/gta5)` on every client. The
  station `.ymap` builds and ticket machine were kept (they stream fine without
  the level meta) and are live in `stream/`.

## Weight

The pack's freight wagons are heavy — `freightstack`, `freightboxlarge` and
`freightbox` are 72 MB each in texture memory, `foxbox` 80 MB. The passenger
stock is far cheaper: 11–17 MB per model.

Texture memory is charged **per unique model, not per carriage** — a nine-car
train repeating one coach costs less than a four-car train with four different
ones. That is why the passenger consists reuse a single carriage type.

To measure a `.ytd` exactly rather than guess: it is an RSC7 file, so skip the
16-byte header and zlib-inflate the rest — **the decompressed size is the VRAM
figure** the server reports.

## Requires

Nothing. It is a pure asset resource and must simply start **before**
`dps-trains` reads the consist table.

## Related

| | |
|---|---|
| `dps-trains` | scheduling, movement, station stops |
| `dps-traintools` | boarding, seating, ambient riders |
| `dps-transitapp` | live arrivals on the phone |
