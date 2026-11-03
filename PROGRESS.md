# PROGRESS - ReemGame

Last updated: 2026-11-03 (session 5). Branch: `claude/eloquent-mayer-iq1fbv`.

## Where things stand

**The whole MVP from game_spec.md is built**: Title, GrandpaRoom, Yard, Gate, MeadowFork,
BigTree, FoxRock, End screen, plus Reem's walk cycle. Nothing has been played by the user since
the GrandpaRoom fixes. The user asked to build everything first and test it all at once:
**next step is the user's full test (checklist at the bottom), then fixing what they report.**

Confirmed by the user so far: Arabic text displays correctly (session 1); headless check on
Windows had no script errors (session 3); GrandpaRoom basket/mirror/choice reached the choice
popup (session 3, then the popup crash was fixed). User decisions: pick-up = keep the simple
bend-down motion; cracked mirror = lands just below the peg, close to the wall, 20% smaller.

## What was checked, and how

All of this ran in the cloud session with the same Godot 4.7.2 (Linux build):
- Import + headless run (`--quit-after 120`): no ERROR / SCRIPT ERROR except the usual
  "leaked at exit" lines, and "Aseprite command failed" during import (Popochiu's Aseprite
  importer, not used by this game, harmless).
- **Automatic playthrough** `tools/playtest.gd`, three paths, each from the title screen to the
  end screen and back to the title (new game). All pass with no errors:
  - `green`: green at every choice. Ends with blossoms 4, wilts 0, heart_full.
  - `sand`: sand at every choice, then fixes every mistake. Ends with blossoms 1, wilts 0, heart_1.
  - `mixed`: hides the mirror, then green, green. Ends with blossoms 3, wilts 0, heart_full.
  - Together they say **all 68 lines** of lines.json; also checks the door/Gate/exit locks.
- Screenshots of every room taken with a real renderer (Xvfb) and checked by eye.
- Not checked: sound (the cloud machine has no sound card), and anything only a person sees
  (does it feel right, is the text easy to read on a real screen).

Run the playtest yourself on Windows (optional; prints lines starting with [PLAYTEST]):
`"C:\Users\ACER\Desktop\Godot\Godot_v4.7.2-stable_win64_console.exe" --headless --path "C:\Users\ACER\Desktop\Games\reem-game" -- --playtest --path=green`
(also `--path=sand` and `--path=mixed`). Every line should say `ok`, and the last line `DONE`.

## Session 5 (user feedback after reading the build)

User asked for: mouths that move when talking; the basket near the mirror (it made no sense
that taking a basket from the floor made the mirror fall); clickable arrows showing where to
go; a cursor that shows what can be clicked. All done, all three playtests still pass.
- **Mouths:** `game/scripts/talking_mouth.gd` (node "Mouth" under each character's Sprite2D).
  While a character speaks, an open mouth flashes over the mouth drawn in their picture about
  7 times a second. Reem, Grandpa and Thaaloob use the open mouth from reem_face.png; Shahd
  (whose body picture has no mouth) shows her closed mouth from bees_sheet all the time and the
  open one while talking. Position/size of each mouth: select Sprite2D/Mouth in the character
  scene (position, Open Scale).
- **Basket:** now hangs on the wall right under the mirror, its handle tucked behind the
  mirror's frame (`prop_basket_prop.tscn`: position 800, 458). Reem walks under it, reaches up
  (a short stretch) and takes it; then the mirror wobbles and falls. This changes game_spec.md
  ("on the floor ... x 0.30, y 0.83") on the user's request.
- **Exit arrows:** `game/scripts/exit_arrow.gd`, added by ReemRoom to every exit (`exit_arrows`
  on each room; GrandpaRoom's is the Door). White arrow, dark outline, slides gently in its
  direction, clicking it uses the exit. It only shows while the exit works (Door after Choice 1,
  Gate right after the briefing, BigTree right once the flowers are open, FoxRock right once
  fox_done).
- **Cursors:** cursors.png cut into 5 pictures (assets/cut/cursors/, small copies 84 px tall)
  and put into Popochiu's cursor (game/gui/gui.gd `CURSORS`): pointing hand = use, open hand =
  pick up (basket, well), speech bubble = talk (characters), eye = look (mirror, sign, hives),
  curved arrow = exits (mirrored for left exits). The normal arrow and the hourglass are
  Popochiu's own.

## What was built (session 4)

Shared systems (game/scripts/):
- `reem_room.gd` (ReemRoom): base of every playable room. Fits background + foreground, puts Reem
  at the right spot for the room she came from (`entry_points`, exported), heart tree, ambience,
  footsteps, notebook hint, and sends clicks to the room script (`_on_object_clicked`,
  `_on_item_used_on`). Props/hotspots use `room_prop.gd` / `room_hotspot.gd`.
- `npc_character.gd`: Jad, Thaaloob, Shahd (talk pulse, clicks go to the room).
- `labels.gd`: every non-dialogue Arabic text, copied out of game_spec.md by a script.
- Off-screen lines (jad_s1_031, jad_s2_071) show in a narration box at the bottom
  (game/gui/components/narration_box/).
- `Choices.ask_one()` for the Yard's one-button choice.
- `Globals.new_game()`: full reset for «العودة إلى البداية» (flags, inventory, every room's memory).

Rooms (game/rooms/): grandpa_room (updated), yard, gate, meadow_fork, big_tree, fox_rock, end.
Characters (game/characters/): jad, thaaloob, shahd (+ two wandering bees in BigTree).
Reem's walk rig: game/characters/reem/reem_walk_rig.gd.

Art cutting: tools/cut_sheets.gd now works (it had a parse error) and was run. New pieces:
assets/cut/bees_sheet, grandpa_bench, reem_parts, reem_face. Every older `.tres` piece now uses
the exact box found by the cutter (several hand-measured boxes were wrong: the choice buttons
were clipped on the left, heart tree pictures had empty space).

Fixes found along the way: title text was tiny (font size set under the wrong name); English
hover text ("Use X with Y") removed; Grandpa/fox/bee faced the wrong way (Popochiu resets
flip_h; they now use a negative scale); Shahd's wings never moved (Popochiu turns off
per-frame processing on characters; moved to a child node).

## Decisions to review

Positions are starting points; all are exported or named nodes, so they are easy to move.
1. **Positions taken from the pictures where the spec's numbers did not match them:**
   - Walkable strips follow the visible paths: Yard and Gate y 0.76-0.89, MeadowFork 0.73-0.86,
     BigTree 0.77-0.88, FoxRock 0.73-0.87 (spec: about 0.78/0.80-0.95, which is mostly the
     foreground grass and flowers).
   - Yard `Well` hotspot x 0.27-0.44, y 0.30-0.68 (spec x 0.40-0.55: the well is further left).
   - Yard `Jad` at x 0.79, y 0.71: on the grass under the olive tree, not on the path (spec y 0.80).
   - MeadowFork `FlowersFork` at x 0.66, y 0.60 on the open grass above the path (spec y 0.75 is
     on the path). BigTree `FlowersShade` at x 0.27, y 0.64 in the tree's shadow (spec y 0.75).
   - FoxRock `Thaaloob` at x 0.67, y 0.75, just right of the rock (spec x 0.45 is in front of it).
   - BigTree `Shahd` at x 0.79, y 0.38, just above the hives.
   - FoxRock right exit: the stream area (top right) plus the right end of the path.
2. **Sizes:** Grandpa seated about 0.95 x Reem's height (spec "1.1 x standing, but seated");
   Thaaloob = Reem's height; Shahd about 1/5 of Reem; small bees a bit smaller than Shahd;
   heart tree on the end screen 440 px tall.
3. **MeadowFork walking:** no walkable "upper path". Green: Reem walks along the main path to the
   right exit. Sand: she walks straight across the grass, through the flowers, off to the right.
   Before the first choice she first walks to the middle of the path (marker `ChoiceSpot`).
4. **GrandpaRoom door does nothing until Choice 1 is answered.** Leaving before picking up the
   basket would skip the mirror story; Reem could then never get the HandMirror (game stuck).
5. **Things the spec does not say, chosen to keep the child moving:**
   - BigTree, talking to Shahd after meeting her while the flowers are still closed: bee_s2_023.
   - BigTree, clicking the flowers or the sunny spot while holding the mirror (instead of using
     it): reem_s2_026 (Grandpa's notebook hint).
   - FoxRock, clicking Thaaloob after Choice 3 green, or after trading but before wiping the
     stone: nothing happens.
   - The Stone can be clicked in any room, not only FoxRock.
   - `sfx_door` also plays when going back into the house from the Yard.
6. **Three extra "already happened" flags** in Globals (not in spec 4.5): gate_intro_done,
   fork_choice_done, fox_intro_done.
7. **Hover text is switched off** everywhere (Popochiu's is English).
8. **Pick-up:** bend-down motion (user's decision; used at the well). The basket uses a
   reach-up stretch instead, since it now hangs on the wall. Note: reem_pickup.png is actually clean
   (transparent background; the "dark glow" I saw earlier was hidden color in transparent
   pixels), only the acorn is drawn in. It could be used later with the acorn cut away.
9. **Walk rig:** used only while walking; standing and talking use reem_base.png. Built from
   reem_parts + the open eye and the smile from reem_face. It has no blush and the back arm is
   hidden behind the body. To go back to the simple bob: open
   game/characters/reem/character_reem.tscn, select CharacterReem, untick **Use Walk Rig**.
10. **Look of new UI:** narration box = dark brown rounded box at the bottom with light text;
    «يتبع…» large with a brown outline; end-screen button like the title's start button;
    title text got a brown outline. Sign text 24 px dark brown on the board.
11. GrandpaRoom: coming back from the Yard, Reem appears by the door (x 0.85, y 0.88), partly
    behind the foreground cushion (that cushion is part of fg1_room_fg).
12. Inventory: Popochiu's own SimpleClick bar at the top (from session 2), not the ui_inventory art.
13. Mouths: one open-mouth picture flashing over each character's drawn mouth (no lip sync to
    the actual words). Grandpa's and the fox's own mouth sheets (beard/muzzle pieces) were cut
    (assets/cut/grandpa_face, fox_face) but not used: they would replace the whole beard/muzzle
    and did not line up as well.
14. Exit arrows are drawn by code (no arrow art in the assets), 140 px long.

## Known problems

- Some Popochiu menus are still English (the settings button in the top bar and its popups:
  save/load, history, quit). Children may open them by accident.
- Not tested with sound; ambience levels are untested (GrandpaRoom's "very quiet" farm ambience
  uses the same volume as the Yard).
- Room and character scenes were written as text; when you open and save them in Godot, it may
  add `uid=` lines. That is normal.
- The old TestArabic room is still registered (not used). assets/art/*.import files still name
  an old path (harmless).
- tools/ also holds g.txt, s.txt, line143*.txt from an earlier session (not used by the game).

## Test checklist for the whole game

Press **F5**. Play it twice: once choosing every **green** button, once every **sand** button.
Everywhere: Arabic text connected and right to left, a voice with every line, the speaker's
mouth opens and closes while they talk, footsteps while walking (tile indoors, grass outside),
Reem's legs and arms move while she walks, the cursor changes over things you can click
(hand, open hand, speech bubble, eye, arrow), a white arrow at every exit that is open (click
the arrow to go), clicking something that has nothing to do does nothing.

**Play 1: all green**
1. Title: big Arabic title, button «ابدأ». Click it.
2. GrandpaRoom: Reem says 2 lines (her mouth moves while she talks), turns to the mirror,
   says a 3rd. No arrow on the door yet, and clicking the door does nothing. Click the mirror
   (eye cursor): she repeats the 3rd line. The basket hangs under the mirror; click it (open
   hand cursor): she walks under it, reaches up, speaks, basket in the top bar (pickup sound),
   the mirror wobbles, falls below the peg and cracks (crack sound). 2 more lines. Two wooden
   buttons appear. After the choice, an arrow appears on the door.
3. **Choice 1 green** «أُخبِرُ جدّي بالحقيقة»: her line; the cracked mirror stays.
4. Door: door sound, Yard. Reem appears in front of the house door.
5. (Optional) Walk right to the Gate before talking to Grandpa: no lines there, and the right
   exit does nothing. Come back left.
6. Click Grandpa: long talk; Lantern then Notebook appear in the bar. Then a single green
   button «عندي شيءٌ أقولُه لك». Click it: the confession, the HandMirror appears, the heart tree
   (top right) gets a blossom and grows for a moment (chime).
7. Click Grandpa again: one short line. Click the Notebook: nothing. Click the well: line +
   WateringCan. Click the well again: nothing.
8. Right edge: Gate. Reem prays, Grandpa's words appear in a box at the bottom (he is not on
   screen), Reem answers. Right edge: MeadowFork.
9. MeadowFork: Reem's first line. The sign reads «من فضلك، امشِ على الطريق»; click it: she
   reads it. Click the Notebook: same line.
10. Click the right edge: she walks to the middle, says a line, buttons appear.
    **Choice 2 green** «أمشي على الطريق»: her line, blossom, she walks to the right → BigTree.
11. BigTree: Shahd flaps above the hives, two small bees fly around. Right exit: nothing yet.
    Click Shahd: the meeting (6 lines). Click the hives: a line. Click the Notebook: the hint.
12. Click the HandMirror in the bar, then click the sunny grass (or the closed flowers): a soft
    beam of light, the flowers open (sound), 4 lines, HoneyJar, blossom. Click Shahd: thanks
    line. Right edge → FoxRock.
13. FoxRock: Thaaloob talks right away (4 lines), buttons appear.
    **Choice 3 green** «هذه أمانةٌ من جدّي»: 2 lines, blossom. The HandMirror stays.
14. Click the stream (right): Reem's line → end screen: big glowing heart tree, Grandpa's words
    in the bottom box, then «يتبع…» and «العودة إلى البداية». Click it → title screen.

**Play 2: all sand** (start again from the title)
1. GrandpaRoom **Choice 1 sand** «أُخبّئُ المرآة»: her line, she walks to the right cushion, the
   mirror disappears, the heart tree wilts (sad sound).
2. Yard: click Grandpa: the long talk, but no green button after it, no HandMirror. Click him
   again: one short line. Take the watering can from the well.
3. Gate (prayer and farewell), MeadowFork. Click the right edge.
   **Choice 2 sand** «أختصرُ فوقَ الزهور»: her line, she walks across the grass through the
   flowers, trample sound, flowers flattened, the tree wilts again → BigTree.
4. BigTree: click Shahd: she asks Reem to fix the flowers (3 lines). Click her again: one line.
5. Left edge → MeadowFork. Click the WateringCan, then the flattened flowers: water sound,
   a line, flowers stand up again, the tree heals (chime).
6. Right edge (no question this time) → BigTree. Click Shahd: "well done" + the meeting.
7. Click the closed flowers: Reem remembers she hid the broken mirror (2 lines). Right exit: nothing.
8. Walk back left: MeadowFork → Gate → Yard. Click Grandpa: the late confession (5 lines),
   HandMirror, the tree heals.
9. Back right to BigTree. Use the HandMirror on the flowers: beam, flowers open, honey, blossom.
10. FoxRock: **Choice 3 sand** «أُبادِلُه»: her line; the HandMirror leaves the bar, a shiny
    Stone arrives. The stream exit does nothing yet.
11. Click the Stone in the bar: it turns dull, Reem's line, the tree wilts, another line.
12. Click Thaaloob: 3 lines, the Stone goes, the HandMirror comes back, the tree heals.
13. Stream → end screen (the heart tree is not glowing this time: only 1 blossom) → title.

What to send me after testing: anything red in Godot's Debugger tab, and for anything that
looks or sounds wrong, the room and what you clicked (a screenshot helps).

## History (earlier sessions, short)

- Session 1: Popochiu set up; Arabic proof (TestArabic room) confirmed by the user.
- Session 2: title screen, GrandpaRoom, global systems (lines, choices, heart tree, inventory,
  flags, sound), AtlasTexture cut pieces measured by hand; could not run programs that session.
- Session 3: user's first tests of GrandpaRoom. Fixed: heart tree drawn huge, English
  "Can't INTERACT" text, Reem blocking clicks, basket click freezing (Popochiu grab() waits for
  an animation Reem has no: Reem now emits grab_done herself), choice popup crash, missing
  GrandpaRoom foreground.
- Session 4: everything above.
