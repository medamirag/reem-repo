# PROGRESS - ReemGame

## Handoff

- **Who worked last:** Codex (builder)
- **Date:** 2026-11-07
- **Branch:** main
- **Audio:** User approved Reem's Stream sample. Installed that exact take and recorded the other 85 pending rows with their saved voices. Oak added another 12 dialogue and 6 vocabulary recordings. All 104 delivered rows are done. Reem and Thaaloob dialogue use v3 with synthesis-only warm/playful tags. Words use Reem multilingual v2 without tags. No fallback or explicit numeric settings were used. Full batch listening remains open.
- **Oak forest:** Spec section 12 and six new art originals. Enter via Pine Fork's left forward route. Start Sinjoob's search, collect three acorns, then choose whether to share. Meet Qunfood and choose whether to greet him. Either mistake can be repaired, and the two rewards cannot repeat. Save state tracks gifts, cards and acorns. The notebook shows the route, hints and both cards. Six new word IDs were generated via make_words.py. Oak's right exit uses provisional End until HoneyOrchard exists.
- **Checks:** Content check, Godot import/startup, both Oak paths and all four required paths passed. Both Oak paths tested real acorn holds, no duplicate rewards and both cards. The repair path also tested save/restore. Only permitted exit leaks appeared in the final checks.
- **Next:** Rock cave, then Meadow lake, Honey orchard, Hill slope, Waterfall path, Narrow pass and Hilltop festival. Packs remain in order 1, 3, 2, 4, 5, 6. Restore the remaining branch destinations as their rooms are registered. No Rock cave code or content started at this checkpoint.
- **How to play Oak:** Close and reopen Godot, press F5, start a new journey and reach Pine Fork via Stream or the meadow. Talk to Thaaloob and choose غَابَةُ الْبَلُّوطِ. Click Sinjoob, then the three acorns near the roots, then Sinjoob again. Try keeping all the acorns and then sharing to repair. Click Qunfood and try both choices. Press N to see earned cards. Hold an acorn before collecting to learn its name.

## Decisions to review

Choices made without asking (newest first).

- **Oak forest (Codex, 2026-11-07):** Reem narrates both animals because neither has an approved saved voice. The acorn gift moves one acorn out of Sinjoob's pile, and Qunfood's leaves are tracked as a festival gift. The path waits for both friends. Until HoneyOrchard is built, the right exit uses the MVP End. Existing regression paths use Pine Fork's provisional cave exit. Generated art sizes differ from the requested sheet dimensions. Sprite placement uses actual dimensions and the background fits proportionally.
- **Voice batch (Codex, 2026-11-07):** Reused the approved take and generated the other rows in the same saved voices. Connector supplied no explicit numeric settings. Delivery and imports can be checked here. Listening approval applies to the original Reem sample only.


- **Silent dialogue timing (Codex, 2026-11-06):** rendered screenshots found a short-line
  timer could expire while Popochiu still measured Arabic. Fixed in game/scripts/lines.gd
  without changing the plugin: wait for visible dialog, serial guard on old timers, and
  fallback reading duration max(2 seconds, text length × .055). Missing recordings remain
  audible silence. Rendered rerun reached DONE; no matched voice batch is claimed.
- **Editor visibility:** initial restricted process inventory showed no Godot; a later
  normal-access check found the editor open. Did not force-close it or discard possible
  unsaved user work. Disk files are committed source; close and reopen Godot before testing.


- **Pine Fork (Codex, 2026-11-06):** cave route is morally neutral. The wrong
  promise to ignore others wilts once; sign or fox offers repair, with no route penalty.
  Sign and drooping leaf use native shapes; route labels use existing Cairo text.
  Unbuilt OakForest/RockCave/MeadowLake exits temporarily use the existing End;
  replace these boundaries as stations are built. Reuse fox art/voice, no early fox card.
  Same unverified sample blocks new voice batches; 16 new lines and four words are
  explicitly problem, not claimed recorded.


- **Stream design (Codex, 2026-11-06):** Reem narrates duck/rabbit actions because the user
  limits recordings to the four saved voices. No new animal voice is assigned. Gate route
  selection has no moral penalty. Wrong route returns to a safe bank; fox stays reachable
  when borrowing the lantern. Feather is a saved festival contribution, not a consumable.
- Current repository has no original full STYLE block (only `STYLE: ...` in queue template).
  Use a descriptive match to the inspected farm reference; preserve this choice for review.

- **Voice registry (Codex, 2026-11-06):** Grandpa and Jad share the verified saved Jad voice. Preserve MVP settings as historical evidence; do not invent missing numeric defaults or reuse unrelated saved account voices for future characters. Verify supported settings and compare a sample before the next audio batch.

- **Highlight (Codex, 2026-11-06):** use the room's has_action rules, a brief soft gold outline,
  button plus H, no cooldown/cost or gameplay time limit. Put the button at the bottom left
  so it does not crowd the top inventory/Notebook/Settings controls. Positions are exported.

- **Notebook (Codex, 2026-11-06):** reuse existing art/word recordings; native drawn MVP map,
  no new bitmap art. Map shows the six built rooms and only allows visits already made.
  Hint steps/cards belong to the current journey; discovered words retain the MVP behavior.
  Only Shahd earns a card now, after her flowers open; Thaaloob has not yet been helped.
  New hints/card narration are Reem reading her notebook, queued as 35 unrecorded lines.


- **Settings (Codex, 2026-11-06):** open only at idle to avoid interrupting a dialogue, choice
  or transition; pause while open. Volumes cover word voices and ambience too. Text sizes are
  40/48/56 px, while headings/control labels retain a steady size to keep the panel usable.
  Preferences are separate from the journey save. Music is off by default, with an explicit
  note that this MVP has no tracks. No art or recording rows are needed for unspoken controls.

- **Save behavior (Codex, 2026-11-06):** autosave after entry scenes finish, so loading cannot
  skip an unanswered entry choice. Completed MVP journeys clear the save on entering End.
  New journey keeps discovered words, matching the previous MVP reset behavior.
- **Popochiu compatibility fix:** native JSON conversion is required to preserve typed room
  geometry. This is a small save/load fix in the installed plugin, not a version upgrade.
  Silent save/load feedback avoids an English confirmation modal blocking every room change.

Older MVP decisions are further down, under "MVP decisions to review".

1. **docs/PIPELINE.md** was updated (at the user's request) to the new roles and to "local
   folder is the source of truth, no pulling, push as a backup".
2. **`words.md` removed:** `content/word_queue.md` replaces it as the list for the voice studio.
   The words still come from the table in `tools/make_words.py`.
3. **art_queue.md layout:** a summary table with every column from PIPELINE.md, and the full
   prompt for each row in its own section below (like the MVP `assets.md`), because the prompts
   are too long for a table cell.
4. **voice_queue.md** lists the 4 MVP voices as `done` (so their descriptions are kept), and
   records Thaaloob's special settings (`eleven_v3`, stability 0.3, style 0.5, emotion tags).
5. **Working rules:** "stop and ask the user to test each room" became "write in PROGRESS.md how
   to test it and move on", as docs/PIPELINE.md asks ("don't ask the user during building").
6. **`word_path` and `word_girl` are marked `done`** in the word queue although they may need
   re-recording; only the user can judge by listening.
7. The old branch `claude/eloquent-mayer-iq1fbv` is left on GitHub (not deleted).

## Where things stand

**The whole MVP from game_spec.md is built**: Title, GrandpaRoom, Yard, Gate, MeadowFork,
BigTree, FoxRock, End screen, plus Reem's walk cycle. Nothing has been played by the user since
the GrandpaRoom fixes. The user asked to build everything first and test it all at once:
**Continue building from the current Handoff; the full visual/sound test remains pending.**

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

## Session 7: word discovery (new feature)

Press and HOLD (about 0.5 s, mouse or finger) on an object: a soft glow appears on it, its
Arabic name shows in a bubble near it (large, connected, right to left, Cairo font) and is
spoken. The first time each word is found, a small golden sparkle. A short click works as before.
- **Words:** `game_data/words.json` (38 words: id, Arabic with full diacritics, rooms, audio
  path `res://assets/audio/words/<id>.mp3`, and which props/characters/items use it).
  **To record:** `words.md` (columns File, Voice, Tone, Text). Both are made by
  `tools/make_words.py`: to change a word, edit that script and run
  `python tools/make_words.py` from the project folder.
- **Where the words are:** `game_data/word_areas.json`, one polygon per object, as fractions
  of the screen, per room. Easy to adjust by hand; where areas overlap, the smallest wins (the
  bucket over the well). Props, characters and inventory items use their own click shape, so
  they need no polygon; they win over background areas.
- **Check positions:** press **F2** in the game: every area is outlined with its id (cyan =
  background areas, pink = props/characters). F2 again hides them.
- **How the short click survives:** Popochiu acts as soon as the button goes down, so when a
  press lands on something that has a word, game/scripts/word_discovery.gd keeps it; released
  before 0.5 s, it hands the same press and release back to the game (a normal click). Moving
  the pointer more than 40 px also turns it back into a normal click.
- **Never during dialogue or a choice:** no words while a line is spoken, the GUI is blocked,
  a choice is open, the room is changing, or an inventory item is selected (and not on the
  title or end screen).
- **No audio yet:** the files do not exist yet, so the words show without sound, no error.
- **Count:** `Globals.discovered_words` (word id -> true), for a later reward.
- Checked with real mouse events in the playtest (`--path=words`): hold shows the right word,
  short press on the jug is a normal click, holding the basket names it without taking it, a
  short click on the basket still takes it, no word during dialogue, F2 on and off, Grandpa
  and the bucket in the Yard. green/sand/mixed still pass.

## Session 6 (user feedback)

- **No size change while talking:** the talk pulse is gone from every character (only the
  mouth moves now).
- **Left and right only:** Reem's walks always keep her height (CharacterReem.walk() keeps
  y), the walking bounce of the rig and the old bob are set to 0, and each room has one walking
  line (both entry points at the same height). Exception: the Choice 2 sand shortcut, where
  she walks diagonally across the grass into the flowers (see Decisions to review, 15).
  Shahd still bobs gently while flying (she is a bee in the air).
- **No walking "half way":** clicking empty floor does nothing (CharacterReem `can_move` =
  false). Reem walks only when the child clicks something that has an action, or an arrow.
- **Stuck at the bees after "walk on the path":** using the mirror needed selecting it in the
  bar and then clicking the flowers, which children do not discover. Now one click does
  everything (game_spec.md 1): clicking the closed flowers or the sunny grass uses the mirror
  if Reem has it. The same for the watering can on the trampled flowers in MeadowFork.
- **Cursor only over things that do something now:** each room says what has an action
  (ReemRoom.has_action). Examples: the closed flowers only after meeting Shahd, the trampled
  flowers only once Shahd asked and Reem has the watering can, the well until the can is
  taken, the mirror until it falls, Thaaloob only when he has something to say, closed exits
  never. Elsewhere the cursor stays the normal arrow.
- **Basket line first:** reem_s1_004 («سآخذُ السَّلّةَ…») is now said at the start of the room,
  right after her first three lines; taking the basket then goes straight to the mirror falling.
- Playtest now also fails if a click makes Reem move up or down. All three paths pass.

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

## MVP decisions to review (sessions 4 to 7)

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
16. **Word discovery choices:**
    - Words chosen from what is clearly visible: GrandpaRoom window, door, plant, cushion,
      table, jug, shelf, prayer rug (+ mirror, basket, girl); Yard door, window, well, bucket,
      jar, beehive, tree, sky, bird, path, grass, flower (+ grandfather); Gate gate, fence,
      sign, tree, cloud, sky, hill, path, flower, bird; MeadowFork tree, sign, path, grass,
      flower, rock, hill, sky, bird; BigTree tree, beehive, rock, shade, grass, path, sky,
      bird, flower (+ bee); FoxRock rock, tree, berries, stream, flower, grass, path, sky,
      hill, bird (+ fox). Items: lantern, notebook, watering can, mirror, basket, stone.
      Left out as unclear for children: the Quran stand on the shelf, the wall peg, the
      ceiling beams, the stone wall in the Yard, small pebbles; the Yard's hills (to stay at 12).
    - Word choices: bird = عُصْفُور (what children say, rather than طائِر); the honey jar item =
      عَسَل (honey) rather than جَرَّة, which is the big clay jar in the Yard; the hand mirror
      and Grandpa's wall mirror share مِرْآة; the small stone item = حَجَر, the big rocks =
      صَخْرَة; berries = تُوت; hill = تَلّ (also for the blue hills in the distance).
    - Words are written without tanween (pausal form, like your examples شَجَرَة, بَاب).
    - The sparkle is visual only (golden particles); no extra sound, so the word's voice is
      clear. The discovered count is not cleared by a new game and is not saved to disk.
    - The bubble stays 2.5 s (longer if the audio is longer), above the object, or below it
      when there is no room above.
    - Holding on the inventory bar's items names them too (they use their own shape).
15. Choice 2 sand is the one walk that goes up the screen: Reem cuts diagonally across the
    grass into the flowers (they are on the meadow above the path, as in bg4_fork). With
    left/right only, there is no way to show "cutting across the flowers" differently from
    "walking on the path". If you prefer, the flowers can be moved onto the path's edge and
    she tramples them while walking straight right.

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
mouth opens and closes while they talk (nobody changes size), Reem only walks left/right and
only to things you click, footsteps while walking (tile indoors, grass outside),
Reem's legs and arms move while she walks, the cursor changes over things you can click
(hand, open hand, speech bubble, eye, arrow), a white arrow at every exit that is open (click
the arrow to go), clicking something that has nothing to do does nothing.

**Play 1: all green**
1. Title: big Arabic title, button «ابدأ». Click it.
2. GrandpaRoom: Reem says 2 lines (her mouth moves while she talks), turns to the mirror,
   says a 3rd, then says she will take the basket. Clicking the empty floor does nothing. No
   arrow on the door yet, and clicking the door does nothing. Click the mirror (eye cursor):
   she repeats the 3rd line. The basket hangs under the mirror; click it (open hand cursor):
   she walks under it, reaches up, basket in the top bar (pickup sound),
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
12. Click the sunny grass (or the closed flowers) once: Reem uses the mirror, a soft
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
5. Left edge → MeadowFork. Click the flattened flowers (hand cursor): water sound,
   a line, flowers stand up again, the tree heals (chime).
6. Right edge (no question this time) → BigTree. Click Shahd: "well done" + the meeting.
7. Click the closed flowers: Reem remembers she hid the broken mirror (2 lines). Right exit: nothing.
8. Walk back left: MeadowFork → Gate → Yard. Click Grandpa: the late confession (5 lines),
   HandMirror, the tree heals.
9. Back right to BigTree. Click the flowers: beam, flowers open, honey, blossom.
10. FoxRock: **Choice 3 sand** «أُبادِلُه»: her line; the HandMirror leaves the bar, a shiny
    Stone arrives. The stream exit does nothing yet.
11. Click the Stone in the bar: it turns dull, Reem's line, the tree wilts, another line.
12. Click Thaaloob: 3 lines, the Stone goes, the HandMirror comes back, the tree heals.
13. Stream → end screen (the heart tree is not glowing this time: only 1 blossom) → title.

**Word discovery** (any room): hold the mouse button (or a finger) on the window, the door,
a tree, the sky, Grandpa, the fox... for half a second: a soft glow on it, its Arabic name in
a bubble, a golden sparkle the first time (no sound until the word files are recorded).
A short click on the same things still works as before. Holding during dialogue or a choice
does nothing. Press F2 to see all the areas, F2 again to hide them.

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
