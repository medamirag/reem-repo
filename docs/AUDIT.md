# AUDIT.md – the whole game against docs/ROADMAP.md and game_spec.md

Audit by Claude Code on 2026-11-08, at commit `fde41b0`. Nothing was fixed: this file only records what was found.

## Summary

**Real completion: 83%** (30 of 36 items: 25 ok, 10 incomplete counted as half, 1 broken). If each pack is counted by its length instead (about a quarter of the roadmap's 30 to 45 minutes), it is **about 79%**. See "How the percentage is counted" at the bottom.

Everything in the roadmap exists and is wired up: all 12 base-valley stations, the 9 game-wide systems, the 6 packs and the 2 free events, in 37 registered rooms. All 360 lines and 153 words have their audio files, and every line and word is used. All 100 finished art queue rows have their files, and all 25 friend cards, 51 hint sets and 36 map places point to real data. **Every automatic check passes:** the content check, import, startup and all 40 playtest paths (two needed a rerun, explained under "Automatic checks").

What keeps it from being finished:

1. **The six packs are much smaller than the roadmap.** Each has 3 rooms with about one task per room, about 14 to 25 lines, and a single Thaaloob line instead of "a new short Thaaloob story". The roadmap asks for 30 to 45 minutes per pack; from the amount of content they look closer to 5 to 10 minutes (estimate, not timed).
2. **New characters have no voices of their own.** Only Reem, Jad, Shahd and Thaaloob speak. Every animal added after the MVP (the duck, Arnoob, Sinjoob, Qunfood, Qatqoota, Ankoob, Dafdoof, Ghazlana, Dubb, Tawoos, Qarqoor and all pack characters) is described by Reem instead of speaking.
3. **Nobody has listened to most of the audio yet.** About 410 new recordings (296 dialogue rows and 115 words since the MVP) have been delivered and checked as files only; pace, pronunciation and loudness are not compared with the MVP voices.
4. **Small problems:** three hint sets repeat a step instead of giving three different hints; Grandpa's map introduction has almost no diacritics; and the GUI theme points at a file inside Godot's `.godot` cache folder, which a fresh copy of the project does not have.

Not checked here (needs a person): the Arabic layout on a real screen, touch on a phone or tablet, timings, and whether the game feels right for a child.

## Base valley (ROADMAP section 2)

Status values: **ok** = exists, every choice has its consequence and repair, and its images, words and voices are real. **incomplete** = exists but something the roadmap asks for is missing or thinner. **placeholder** = uses a stand-in image or sound. **broken** = does not work.

| Item | Status | What's wrong |
| --- | --- | --- |
| Farm: GrandpaRoom, Yard, Gate (MVP) | ok | Mirror choice: hiding it wilts and confessing in the Yard repairs it. |
| Flower meadow: MeadowFork, BigTree, FoxRock (MVP) | ok | Path choice: trampling wilts, watering repairs. Stone trade: trading is repaired by wiping the stone and asking for the mirror back. |
| Stream | ok | Both choices work: following Arnoob wilts and reading the map repairs; lending the lantern to Thaaloob wilts and taking it back repairs. Log bridge and the duck's feather work. The duck and Arnoob do not speak (see "Character voices"). |
| Pine Fork (meeting 1) | ok | The "skip helping others" choice wilts and the repair choice heals it. |
| Oak forest | ok | Sinjoob (keep / share) and Qunfood (avoid / greet) both wilt and repair; nuts and leaves are saved. Hint `oak_search` repeats its second step (see Hints). |
| Rock cave | ok | Kitten (mock / light), Ankoob's web (give up / try again) and Thaaloob's flattery (put the basket down) all wilt and repair. Ankoob now uses painted art (body plus 8 animated legs, commit `98db691`); the old `ankoob_base` row stays `problem` in the art queue as history. |
| Meadow lake | ok | Honey for Dafdoof (keep / share) wilts and repairs; reed flute saved. Ghazlana is found by following hoofprints, with no wrong option, so "obeying parents' advice" is only in the story. The boat introduces the Gull island trip. |
| Honey orchard (meeting 2) | ok | Pulling Dubb and accusing him both wilt and both repair. |
| Hill slope | ok | Flattering Tawoos wilts; showing the shared display repairs. |
| Waterfall path | ok | Throwing the fruit back wilts; asking calmly repairs. |
| Narrow pass (meeting 3) | ok | Leaving Thaaloob wilts; coming back to help repairs. He returns the honey only if he took it in the cave. |
| Hilltop festival and endings | ok | Only friends helped on this journey appear; final heart tree; Grandpa names repaired mistakes and suggests an unvisited branch; packs unlock. Hint `festival_light` repeats its second step. |

## Game-wide systems (ROADMAP section 3)

| Item | Status | What's wrong |
| --- | --- | --- |
| 1. Heart tree over the whole journey | ok | Up to 12 extra flowers after the first three; wilted branches stay visible; end screen shows the final state. |
| 2. Friend cards album | ok | 25 cards, each with an existing picture and recorded name and fact, all awarded in play and shown in the notebook. No card for Arnoob (he is not helped in the story). |
| 3. Word discovery and words page | ok | 153 words, all with audio, all placed in rooms (4 to 19 per room); the notebook has a words page listing found words. |
| 4. Valley map and fast travel | incomplete | Map, pins, locks and travel work, and all 36 places have recorded names. Grandpa's introduction `jad_map_intro` has almost no diacritics (AGENTS.md asks for full diacritics in new dialogue). |
| 5. Hints in three steps | incomplete | 51 hint sets, all with real lines. Three repeat a line, so they give only two different steps: `oak_search` (`reem_oak_search` twice), `festival_light` (`reem_festival_light` twice), `market_sale` (`reem_market_arrive` twice). |
| 6. Hotspot highlight | ok | |
| 7. Save, continue, new journey | ok | Autosave; the title shows Continue when a save exists. |
| 8. Settings | ok | Music on/off (off by default), voice volume, effects volume, three text sizes; saved between runs. |
| 9. Parent corner | ok | Behind a two-digit sum; shows prompts for the choices met in this journey. |

## Expansion packs (ROADMAP section 4)

All six open after the festival, from the entrance the roadmap names, and each has 3 rooms, its mechanic, its exciting moment, cards and words. Every pack choice wilts and is repaired. What is missing is length and Thaaloob's story.

| Item | Status | What's wrong |
| --- | --- | --- |
| 1. Gull island (GullShore, TideCave, GullLighthouse) | incomplete | Tides by clicking the tide rock; storm and lighthouse repair; turtle, octopus and gull cards; leaving the litter and taking the shells both wilt and repair. Thaaloob has one line (`fox_gull_trade`). 25 lines in all: well short of 30 to 45 minutes. |
| 2. Old city market (MarketGate, MarketStalls, ScaleCourtyard) | incomplete | Selling, counting coins, the bread for the cat (wilt and repair) and Thaaloob's tilted scale exposed with equal weights. Thaaloob has two lines; 18 lines in all. |
| 3. Ramadan lantern night (RamadanLane, HedgehogCourt, IftarShelter) | incomplete | The lantern reveals hidden supplies; keeping the dates wilts and sharing repairs; iftar for the traveller. The musaharati, the family and the traveller are only described by Reem. Thaaloob has one line; 14 lines in all. |
| 4. Snow trail (SnowEdge, SnowTracks, SledHill) | incomplete | Footprints to compare, the sled ride, the goldfinch (wilt and repair) and the deer rescue; Arnoob in white fur. Thaaloob has one line; 17 lines in all. |
| 5. Ant kingdom (GiantBloom, DewBank, AntCity) | incomplete | Shrinking, the dew-drop lake, the leaf bridge, sorting seeds and the rain tunnel; leaving the worker wilts and helping repairs. The roadmap's lazy ant is a worker who "stopped carrying seeds". Thaaloob has one line; 21 lines in all. |
| 6. Star observatory (OwlPerch, ObservatoryDome, StarRidge) | incomplete | The owl flight, the bat (rushing wilts, listening repairs), connecting four star shapes and guiding the caravan. Thaaloob has one line; 18 lines in all. |

## Free events (ROADMAP section 4)

| Item | Status | What's wrong |
| --- | --- | --- |
| Tree day (TreeDay) | ok | Opens from the Yard after the festival; the watering choice wilts and repairs; card and hints. |
| Mother's day (MotherGarden) | ok | Opens from the Yard after the festival; the sharing choice wilts and repairs; card and hints. |

## Content and files (across the whole game)

| Item | Status | What's wrong |
| --- | --- | --- |
| Dialogue lines (`game_data/lines.json`) | ok | 360 lines (Reem 308, Thaaloob 23, Jad 21, Shahd 8). Every line has its audio file, every line is used by the game, no line ID used in code is missing, and there are no audio files without a line. |
| Words (`game_data/words.json`) | ok | 153 words; all have audio, all are placed, no extra audio files. `words.json` matches `tools/make_words.py`. |
| Art (`content/art_queue.md`) | ok | 101 rows: 100 `done` with their files, plus `ankoob_base` left as `problem` (replaced by `ankoob_body` and `ankoob_leg`). 27 small props are drawn as simple SVG shapes under `game/` (coins, shells, star shapes, footprints, the sled…), as noted in Decisions to review; they are not stand-ins for characters. |
| Voice and word queues | ok | 296 voice rows and 153 word rows, all `done`. The 68 MVP lines were recorded before the queue existed, so they are not in it. |
| Character voices | incomplete | Only Reem, Jad, Shahd and Thaaloob speak. Every character added after the MVP is narrated by Reem (Decisions to review), so none of them has a voice in `AGENTS.md`'s saved-voices table. |
| Listening review | incomplete | About 410 recordings since the MVP are checked as delivered files only; pace, pronunciation and loudness against the MVP voices are still open. Also open from the MVP: `word_path` and `word_girl` measured oddly. |
| GUI theme (`game/gui/resources/gui_theme.tres`) | broken | Lines 7, 75, 82 and 89 load `res://.godot/imported/radio_button.png`, a file in Godot's cache folder. It works on this computer, but a fresh copy (cloud session, new computer) has no `.godot` folder, so those radio-button pictures will be missing there. |

## Automatic checks

Run on Windows with Godot 4.7.2 (`_console` build). "Passed" means the path printed `DONE` with no `FAIL` line and no `ERROR` / `SCRIPT ERROR` apart from the usual exit leaks. Times are for one run; most paths ran with the game window open so the user could watch.

| Check | Result | Notes |
| --- | --- | --- |
| `tools/check_content.py` | passed | "360 lines, 153 words, queues, areas, art, notebook and map" |
| Import (`--import`) | passed | |
| Startup (`--quit-after 120`) | passed | |
| `green`, `sand`, `mixed` (story playthroughs) | passed | 121 to 141 s each |
| `words`, `save`, `highlight`, `valley_map` | passed | |
| `notebook`, `settings`, `dialogue_timing` | passed | headless run |
| `stream`, `stream_sand`, `stream_words` | passed | headless run |
| `pine` | passed | |
| `pine_sand` | passed | First windowed run printed one `FAIL` ("Pine real hold discovers word_lake") but still reached `DONE`. It passed headless and again windowed, so it is a flaky hold test (the real mouse cursor can disturb a held press in a window), not a game bug. |
| `oak`, `oak_sand` | passed | |
| `cave`, `cave_sand`, `cave_empty` | passed | |
| `lake`, `lake_sand`, `orchard`, `orchard_sand` | passed | |
| `hill`, `hill_sand`, `waterfall`, `waterfall_sand` | passed | |
| `narrow_pass`, `narrow_pass_sand`, `festival` | passed | |
| `gull`, `ramadan`, `market`, `stars`, `ants` | passed | |
| `snow` | passed | The first run was aborted at "click SnowFox" because the computer went to sleep (each step may take 90 real seconds). The headless rerun passed in 60 s. |
| `tree_day`, `mother_day`, `parent` | passed | |

Not covered by the playtests: `station_shots` (needs screenshots by eye), sound, real touch input and play duration.

## How the percentage is counted

Each row in the tables above counts once: **ok** = 1, **incomplete** or **placeholder** = 0.5, **broken** = 0. There are 36 rows: 12 base stations (all ok), 9 systems (7 ok, 2 incomplete), 6 packs (all incomplete), 2 events (ok) and 7 content rows (4 ok, 2 incomplete, 1 broken). That gives 25 + 10 × 0.5 + 0 = 30 of 36 = **83%**. Counting each pack as 0.25 instead of 0.5 (its content is about a quarter of the roadmap's length) gives 28.5 of 36 = **79%**. This measures what is built and wired up; it does not include the hands-on checks a person still has to do (listening, Arabic on a real screen, touch, timing).
