# dps-trains-stock

Rolling stock for the Del Perro Sands railway: the BigDaddy "Trains
Overhauled" models, audio, and consist definitions. Deliberately stripped to
assets only - the pack's C# scripts, ticket system, and gta5.meta are
excluded; scheduling and behavior belong to `dps-trains`.

## What it provides
- Streamed models: streak/coaster passenger family, SD70MAC/GEVO freight
  engines, ~17 freight car types, metro cars, ticket-machine ymap.
- `data/trains.xml` - the consist table. **CRITICAL: `TRAINCONFIGS_FILE`
  APPENDS to the vanilla table (indices 0-27 on b3258); customs start at 28.**
  Current consists: 28/29 = 9-car passenger sets (streakcoaster engine +
  streakc coaches - the coaches are LAYOUT_BUS and carry the riding system),
  30 = 9-car mixed freight. Keep consists at 9 cars max: longer trains blink
  under OneSync.
- vehicles.meta / handling / vehiclelayouts / audio for all of the above.

## Sharp edges
- trains.xml changes require players to RELOG (ingested once at join).
- Consists must pair engine families with their matching coaches; `streakc`
  is the only coach with rideable geometry.

Companion resources: `dps-trains` (engine/scheduling), `dps-traintools`
(boarding UX).
