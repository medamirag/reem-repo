# BUGS.md – problems found by the real-player playtest

Found by running `tools/playtest.gd` in real-player mode (`--real`: a real 1920x1080 window, real mouse clicks, a screenshot after every step) and looking at every screenshot. Screenshot paths are from the run that found the bug; `tests/screenshots/` is overwritten by every run, so a smaller copy of each one is kept in `docs/bugs/`.

Status: **open**, **fixed** (fix made, not yet confirmed by a rerun) or **verified** (the rerun's screenshot shows it fixed; the "after" copy is the same name with `_fixed` in `docs/bugs/`).

| # | Bug | Screenshot | Status |
| --- | --- | --- | --- |
| 1 | Dialogue text is hard to read over busy backgrounds, and Grandpa's lines float far above his head | `tests/screenshots/green/022_Yard_line_jad_s1_011.png` (`docs/bugs/022_Yard_line_jad_s1_011.jpg`) | verified |
| 2 | The inventory bar covers the top buttons (map, notebook, settings) | `tests/screenshots/green/038_Yard_item_Notebook.png` (`docs/bugs/038_Yard_item_Notebook.jpg`) | verified |
| 3 | The wrong-choice board's text is hard to read (white on pale wood) | `tests/screenshots/green/089_PineFork_choice.png` (`docs/bugs/089_PineFork_choice.jpg`) | verified |
| 4 | At the lake reunion, Ghazlana's mother stands inside the boat | `tests/screenshots/green/105_MeadowLake_line_reem_lake_reunion.png` (`docs/bugs/105_MeadowLake_line_reem_lake_reunion.jpg`) | verified |
| 5 | Thaaloob is a third smaller at Narrow Pass than everywhere else | `tests/screenshots/green/136_NarrowPass_NarrowPass.png` (compare `083_FoxRock_FoxRock.png`) | verified |
| 6 | At the festival, Grandpa (on Dubb) and Thaaloob are drawn at about half their size | `tests/screenshots/green/150_HilltopFestival_line_jad_festival_arrive.png` | verified |
| 7 | A new journey starts with Reem half hidden behind the big plant in Grandpa's room | `tests/screenshots/green/157_GrandpaRoom_GrandpaRoom.png` | verified |
| 8 | In the notebook, the page that is open looks greyed out, as if it could not be used | `tests/screenshots/green/038_Yard_item_Notebook.png` | verified |

## Details

### 1. Dialogue text hard to read; Grandpa's text far above him

- **What a child sees:** in the Yard, Grandpa's «وعليكم السلام» appears in the top-right corner, about 200 px above his head, as thin dark letters on the olive leaves, right next to the heart tree. Other lines have the same problem over leaves, reeds and the festival stalls.
- **Cause:** the text above a speaker (`game/gui/components/dialog_text/dialog_overhead/dialog_overhead_custom.gd`) has no outline, so it disappears on busy art. Grandpa sits, but his speech point is the standing height of Reem and Thaaloob (`dialog_pos = Vector2(0, -500)` in `game/characters/jad/character_jad.tscn`).
- **Fix:** a cream outline around the overhead text; Grandpa's speech point lowered to his seated height (`-380`).

### 2. The inventory bar covers the top buttons

- **What a child sees:** the map button (top left), «دفتري» and «الإعدادات» sit inside the top strip where the inventory bar slides down. Moving the mouse up to press one of them opens the bar, which then covers the button; the basket is drawn on top of the map button.
- **Cause:** the bar (`game/gui/components/simple_click_bar_high_res/`) is 120 px tall across the whole top and opens when the mouse is within about 60 px of the top. The three buttons are at y = 16 to 100 (`game/scripts/valley_map.gd`, `reem_notebook.gd`, `reem_settings.gd`).
- **Fix:** the three buttons move just below the bar (y = 132), so they never sit under it.

### 3. The wrong-choice board's text is hard to read

- **What a child sees:** the second (sand-coloured) choice board has white letters on pale wood, for example «أوافق على ترك المساعدة».
- **Cause:** both choice labels use the default white text (`game/gui/components/choice_popup/choice_popup.gd`).
- **Fix:** dark brown text on the sand board, and a dark green outline on the green board's white text.

### 4. Ghazlana's mother stands inside the boat

- **What a child sees:** after following the hoofprints, the mother gazelle appears behind the boat's hull, as if standing in it.
- **Cause:** `MotherStandIn` is placed at x = 1630 (`game/rooms/meadow_lake/room_meadow_lake.tscn`), where the boat is; Ghazlana joins her at x = 1420.
- **Fix:** the mother stands on the grass left of the boat (x = 1130) and Ghazlana next to her (x = 1000).

### 5. Thaaloob too small at Narrow Pass

- **What a child sees:** Thaaloob is about two thirds of Reem's height at Narrow Pass, but as tall as Reem in FoxRock and the orchard.
- **Cause:** at Narrow Pass he is a prop with his own copy of the fox picture at scale 0.24 (`game/rooms/narrow_pass/room_narrow_pass.tscn`); the Thaaloob character uses 0.3617.
- **Fix:** the same 0.3617 scale, with his click area, his stuck tail point and the stone pinning it moved to match.
- **Left to decide:** at his real size the tail's tip is above the ground, so the stone (which must stay on the ground) now sits just under the tail instead of over it. If the tail should look pinned, the fox needs a pose with the tail on the ground, or a second rock drawn over the tail.

### 6. Grandpa and Thaaloob too small at the festival

- **What a child sees:** Grandpa riding Dubb is about a third of his size in the Yard (179 px against about 430 px); Thaaloob is 220 px instead of about 454 px.
- **Cause:** the festival draws every guest as a picture of a fixed height (`game/rooms/hilltop_festival/room_hilltop_festival.gd`).
- **Fix:** Thaaloob at his normal height (454 px), Grandpa riding Dubb at 300 px and Grandpa without Dubb at 400 px. The other small animals keep their festival sizes (see Decisions to review in PROGRESS.md).

### 7. Reem starts behind the plant

- **What a child sees:** on a new journey, Reem stands behind the big foreground plant in Grandpa's room, with half of her hidden.
- **Cause:** the room's default start point is 20% across (`entry_points` in `game/rooms/grandpa_room/room_grandpa_room.tscn`), where the foreground plant is.
- **Fix:** start at 30% across, in front of the cushion and clear of the plant.

### 8. The open notebook page looks disabled

- **What a child sees:** the tab of the page that is open («مساعدة») is pale grey on cream, so it looks switched off instead of selected.
- **Cause:** the open tab is a disabled button (`game/scripts/reem_notebook.gd`), drawn with the theme's disabled look.
- **Fix:** the open tab is drawn highlighted (warm yellow with a brown border and dark text) while staying unclickable.

## What has been played this way so far

- `green` (the whole main story: Title, GrandpaRoom, Yard, Gate, MeadowFork, BigTree, FoxRock, PineFork, MeadowLake, HoneyOrchard, HillSlope, NarrowPass, HilltopFestival, End, and a new journey): 157 screenshots, all looked at. Passes with real clicks and no layout warnings, before and after the fixes.
- `notebook_clicks` (new): open the notebook from the inventory, close it with ×, and click in the room again, twice. Passes. Real Windows mouse clicks gave the same result.
- Not yet run with `--real`: the sand and mixed stories, the branch rooms that `green` skips (Stream, Oak forest, Rock cave, Waterfall path), the six packs, the two events, and the system paths. Run each with `-- --playtest --real --path=<name>` and look at `tests/screenshots/<name>/`.

## Known headless-only message

- `orchard_sand` run headless prints "ERROR: Rect2i size is negative" six times right after the DubbJar click, then passes. It happens at the audit commit (`fde41b0`) too, and not in runs with a window, so it comes from Godot's text layout without a real renderer, not from the game. Ignore it in headless runs; a real-player run of that path should stay clean.

## Not bugs (problems in the test itself, fixed in tools/playtest.gd)

- The inventory bar is hidden above the screen until the mouse reaches the top; the test first clicked the hidden item. It now moves to the top and waits for the bar to slide in, like a player.
- The old screenshot helper replayed a line for a photo, so the next click only skipped the line. Real-player mode no longer replays lines.
- Real clicks return before the game reacts; the test now waits until Popochiu's click is over (`E.clicked`), the line is finished (`Lines.busy`) and any choice is answered.
