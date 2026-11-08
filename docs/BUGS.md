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
| 9 | English hover text («Use Hand Mirror with») appears at the bottom edge, cut in half, while an item is held | `tests/screenshots/sand/090_BigTree_after_HandMirror_on_FlowersShade.png` (`docs/bugs/090_BigTree_after_HandMirror_on_FlowersShade.jpg`) | verified |
| 10 | The DewBank leaf bridge is a tiny leaf icon stretched 19 times: blurry blocks that cross the whole dew drop and the dialogue | `tests/screenshots/ants/018_DewBank_line_reem_ant_dew.png` (`docs/bugs/018_DewBank_line_reem_ant_dew.jpg`) | verified |
| 11 | The settings and notebook buttons cover two of the observatory's sky stars (a real click on the crescent star hits «الإعدادات») | `tests/screenshots/stars/028_ObservatoryDome_after_TriangleStar.png` (`docs/bugs/028_ObservatoryDome_after_TriangleStar.jpg`) | verified |
| 12 | While the two choice boards are shown, the cursor is the hourglass (wait) instead of the pointer | `tests/screenshots/mother_day/007_MotherGarden_choice.png` (`docs/bugs/007_MotherGarden_choice.jpg`) | verified |

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

### 9. English hover text while an item is held

- **What a child sees:** after using the mirror on the wrong spot, «Use Hand Mirror with» in English sits on the bottom edge of the screen, half of it below the screen.
- **Cause:** Popochiu writes "Use X with Y" when the mouse is over something while an item is held. The game clears Popochiu's hover text, but in `game/gui/gui.gd` it returned early when an item was held, before clearing.
- **Fix:** the hover text is cleared first in `gui.gd`, and the hover text component (`game/gui/components/hover_text/hover_text_custom.gd`) now never shows any text.

### 10. The leaf bridge is a stretched icon

- **What a child sees:** in DewBank (ants pack), the floating leaf is a huge blurry green bar of blocks, tilted across the whole dew drop and over the dialogue box.
- **Cause:** the LeafBridge prop (`game/rooms/dew_bank/room_dew_bank.tscn`) used the 80x80 leaf icon `game/scripts/ants/leaf.svg` at scale 19 x 3.
- **Fix:** a new placeholder drawn at its real size, `game/scripts/ants/leaf_bridge.svg` (520x120, scale 1), and a row `dew_leaf_bridge` in `content/art_queue.md` so Codex can paint the real leaf.

### 11. Top buttons cover the observatory stars

- **What a child sees:** in the observatory dome (stars pack), the crescent star is under «الإعدادات» and the circle star partly under «دفتري»; clicking the crescent opens the settings.
- **Cause:** fix #2 moved the top buttons down to y = 132, into the dome's sky.
- **Fix:** the circle star moves up (y 155 to 122) and the crescent star down (y 245 to 322), clear of both buttons; the chart's thread follows the stars by itself. A new check, `--path=hud_layout`, opens every room scene and fails if any clickable thing sits under the map, notebook, settings or hint button; the real-player HUD lint now also includes those four buttons.

### 12. Hourglass cursor during choices

- **What a child sees:** the two wooden choice boards appear, but the mouse pointer is an hourglass, which says "wait", not "choose".
- **Cause:** `Choices.ask_two` (`game/scripts/choices.gd`) blocks the GUI, and Popochiu shows the wait cursor while blocked.
- **Fix:** the pointer cursor is shown as soon as the boards appear (as the map already does); unblocking puts the normal one back.

## What has been played this way so far

- `green` (the whole main story: Title, GrandpaRoom, Yard, Gate, MeadowFork, BigTree, FoxRock, PineFork, MeadowLake, HoneyOrchard, HillSlope, NarrowPass, HilltopFestival, End, and a new journey): 157 screenshots, all looked at. Passes with real clicks and no layout warnings, before and after the fixes.
- `notebook_clicks` (new): open the notebook from the inventory, close it with ×, and click in the room again, twice. Passes. Real Windows mouse clicks gave the same result.
- All 39 other paths (2026-11-08): sand, mixed, words, save, highlight, valley_map, notebook, settings, dialogue_timing, the branch rooms (stream, pine, oak, cave, lake, orchard, hill, waterfall, narrow_pass, each with its sand version), festival, the six packs (gull, ramadan, market, snow, ants, stars), the two events (tree_day, mother_day) and parent: 2,097 screenshots. Every path reached DONE. The screenshots were compared with each other and with green, and every one that looked new (116) was looked at; bugs #9 to #12 came from this run. The other test failures were problems in the test itself (see "Not bugs").

## Known harmless engine message

- `orchard_sand` prints "ERROR: Rect2i size is negative" right after the DubbJar click (six times headless, twice with a window), then passes. It happens at the audit commit (`fde41b0`) too. The screenshot at that moment (`tests/screenshots/orchard_sand/020_HoneyOrchard_line_reem_orchard_free.png`) looks right, so it is an engine message from Godot's drawing code with nothing visible wrong. Left as is.

## Not bugs (problems in the test itself, fixed in tools/playtest.gd)

- The inventory bar is hidden above the screen until the mouse reaches the top; the test first clicked the hidden item. It now moves to the top and waits for the bar to slide in, like a player.
- The old screenshot helper replayed a line for a photo, so the next click only skipped the line. Real-player mode no longer replays lines.
- Real clicks return before the game reacts; the test now waits until Popochiu's click is over (`E.clicked`), the line is finished (`Lines.busy`) and any choice is answered.
- Real-player runs of `highlight` checked the glow one frame too early after opening the settings; it now waits two frames.
- In `settings`, the path itself answers a choice while its screenshot is taken; the choice helper now skips a choice that is already gone (it printed a SCRIPT ERROR).
