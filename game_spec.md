# game_spec.md – Reem and the Festival of Nasim Valley, MVP

The complete description of the first playable version: 6 screens in 2 stations, plus a title screen and an end screen. Play time about 15 minutes. Target: children aged 6 to 10, Arabic only, mouse or touch.

Everything a line of dialogue says is in `game_data/lines.json` (text + audio file), keyed by the line ID used below, for example `reem_s1_001`.

---

## 1. Project setup (already done by the user)

- Godot 4.7.2, Compatibility renderer, project folder `ReemGame`.
- Popochiu 2.0.3 installed and enabled. Setup wizard: Modern / Hi-Res, 1920×1080, preview window 0.5x. If Popochiu asked for a GUI template, use the one installed; one click must do everything (walk, pick up, talk, use).
- Assets (read-only originals, never edit or move them):

```
res://assets/art/characters/reem/      reem_sheet, reem_base, reem_parts, reem_face, reem_pickup
res://assets/art/characters/grandpa/   grandpa_sheet, grandpa_bench, grandpa_face
res://assets/art/characters/fox/       fox_sheet, fox_base, fox_parts, fox_face
res://assets/art/characters/bees/      bees_sheet
res://assets/art/items/                mirror_states, handmirror_basket, notebook_lantern,
                                       wateringcan_honey, stone_states, flowers_states
res://assets/art/backgrounds/          bg1_room … bg6_fox_rock, fg1_room_fg … fg6_fox_rock_fg
res://assets/art/ui/                   ui_inventory, ui_dialogue, heart_tree_states, cursors,
                                       title_screen, to_be_continued
res://assets/audio/lines/              68 dialogue files, <line_id>.mp3
res://assets/audio/sfx/                13 files (see section 7)
res://assets/fonts/                    Arabic font (Cairo or Noto Naskh Arabic)
```

## 2. Preparing the art

Many images are **sheets** with several separate pieces on a transparent background (for example `handmirror_basket.png` holds the hand mirror on the left and the basket on the right). Before using them:

- Cut each sheet into its pieces automatically, by finding the separate non-transparent regions (connected alpha areas, ignoring tiny specks), and save each piece as its own PNG in `res://assets/cut/<sheet_name>/`, numbered left to right then top to bottom (`01.png`, `02.png`…). Then rename the pieces you need with clear names (see the table). Never modify the originals.
- Opaque images (backgrounds `bg*`, `title_screen`, `to_be_continued`, the `*_sheet` turnarounds) are used whole or as references, not cut.

| Sheet | Pieces needed (clear names) |
| --- | --- |
| mirror_states | `mirror_whole`, `mirror_cracked` |
| handmirror_basket | `hand_mirror`, `basket` |
| notebook_lantern | `notebook`, `lantern` |
| wateringcan_honey | `watering_can`, `honey_jar` |
| stone_states | `stone_shiny`, `stone_dull` |
| flowers_states | `flowers_closed`, `flowers_open`, `flowers_trampled` |
| heart_tree_states | `heart_0` (no blossom), `heart_1`, `heart_2`, `heart_3`, `heart_wilt` (3 blossoms + drooping branch), `heart_full` (glowing) |
| bees_sheet | `shahd_body`, `shahd_wings`, `bee_small_1`, `bee_small_1_wings`, `bee_small_2`, `bee_small_2_wings` (mouth pieces not needed in the MVP) |
| ui_inventory | `inventory_bar`, `btn_basket`, `btn_notebook` |
| ui_dialogue | `dialogue_box`, `face_frame`, `choice_green`, `choice_sand` |
| cursors | `cursor_use`, `cursor_pickup`, `cursor_exit`, `cursor_talk`, `cursor_look` |

## 3. Characters in the MVP (simple version)

The skeletal rig with the parts sheets comes **later**, not in the MVP. For now:

| Character | Popochiu character | Image | Behavior |
| --- | --- | --- | --- |
| Reem (player) | `Reem` | `reem_base.png` (faces right; flip when walking left) | While walking: gentle up-down bob (about 6 px, about 4 times per second). While speaking: a small, soft scale pulse. Use `reem_pickup.png` for about 0.6 s when picking something up. Height on screen: about 42% of the screen height, feet on the path. |
| Grandpa Sulaiman | `Jad` | first full piece of `grandpa_bench.png` (seated on the bench) | Never walks. Sits under the olive tree in the Yard. Small scale pulse while speaking. |
| Thaaloob | `Thaaloob` | `fox_base.png` | Stands next to the rock in FoxRock. Small pulse while speaking. |
| Shahd | `Shahd` | `shahd_body` + `shahd_wings` | Hovers near the hives in BigTree: wings flap fast (scale or rotate the wings, 10 to 15 times per second), the body bobs slowly. Two small bees wander around the hives the same way. |

Make all characters the same height relative to each other as in their turnaround sheets: Grandpa about 1.1× Reem standing (but he is seated), Thaaloob about Reem's height, Shahd small (about 1/5 of Reem's height).

## 4. Global systems

### 4.1 Speaking a line

Write one helper used for every line, for example `say_line(line_id)`:
1. Read the line from `game_data/lines.json`.
2. Show its Arabic `text` through the Popochiu dialogue text (the character named in `speaker` speaks it: Reem → Reem, Jad → Jad, Thaaloob → Thaaloob, Shahd → Shahd).
3. At the same time, play its `audio` file.
4. Wait until the audio finishes (plus 0.3 s) before the next line. A click skips to the end of the line.

Speaker names map to characters: `Reem`, `Jad`, `Thaaloob`, `Shahd`. `jad_s1_031` and `jad_s2_071` are spoken off-screen (Grandpa is not in the room): show the text without a character in the scene.

**Arabic text:** all on-screen text uses the Arabic font in `res://assets/fonts/`, right-to-left, properly connected. Check this works in the dialogue text and in the choice buttons before anything else. If Popochiu's text node does not shape Arabic correctly, fix the font and text-direction settings of that node.

### 4.2 Choices

At each choice, show the two wooden choice buttons (`choice_green` and `choice_sand`) with the Arabic labels given in the room descriptions, and wait for a click. Use Popochiu's dialog system if it fits; otherwise a small custom choice popup. Play `sfx_ui_click` on click.

### 4.3 The heart tree

A small heart tree in the top-right corner (about 140 px tall) shows the child's choices. Keep two numbers in a global state: `blossoms` (good deeds) and `wilts` (mistakes not yet fixed).

- **Bloom:** `blossoms += 1`, play `sfx_heart_bloom`, and briefly enlarge the tree.
- **Wilt:** `wilts += 1`, play `sfx_heart_wilt`.
- **Heal:** `wilts -= 1` (never below 0), play `sfx_heart_bloom`.
- **Picture:** if `wilts > 0` show `heart_wilt`, otherwise show `heart_0` to `heart_3` for `min(blossoms, 3)`. The end screen shows `heart_full` if `wilts == 0` and `blossoms >= 3`.

### 4.4 Inventory

The inventory bar (`inventory_bar`) sits at the bottom of the screen, opened by `btn_basket` or always visible: choose what fits the GUI template. Items appear as their pieces from section 2. Play `sfx_pickup` when an item is added.

| Inventory item | Image | How it is obtained |
| --- | --- | --- |
| `Basket` | basket | Grandpa's room |
| `Lantern` | lantern | Given by Grandpa |
| `Notebook` | notebook | Given by Grandpa. Clicking it in the inventory plays the current hint (see rooms) |
| `WateringCan` | watering_can | The well in the Yard |
| `HandMirror` | hand_mirror | Given by Grandpa after the confession |
| `HoneyJar` | honey_jar | Given by Shahd |
| `Stone` | stone_shiny, then stone_dull | Only if the child trades with Thaaloob |

### 4.5 Global state flags

`basket_taken`, `mirror_broken`, `chose_truth`, `mirror_hidden`, `briefed`, `confessed`, `trampled`, `told_to_fix`, `flowers_fixed`, `met_shahd`, `needs_mirror`, `flowers_open`, `fox_done`, `traded`, `stone_wiped`, `mirror_recovered`.

### 4.6 Sound

- Footsteps while walking: `sfx_steps_tile` in GrandpaRoom, `sfx_steps_grass` everywhere else (loop while walking, stop when stopped).
- Ambience, looping quietly under everything: `amb_farm` in GrandpaRoom (very quiet), Yard and Gate; `amb_meadow` in MeadowFork, BigTree and FoxRock.
- Doors and exits: `sfx_door` when leaving GrandpaRoom through the blue door.
- No music in the MVP. Add a settings toggle later.

---

## 5. Rooms

Positions are given as fractions of the screen (x from left, y from top, 0 to 1). They are starting points: the user will fine-tune them. Every room uses its background `bg*` and its foreground layer `fg*` on top of everything (the foreground is not clickable). Each room has a walkable area covering the path or floor.

### Title screen

`title_screen.png`. In the empty sky area, the title in large Arabic text: «ريم ومهرجان وادي النسيم». Below it a button «ابدأ». Click → GrandpaRoom.

### Station 1, room 1: GrandpaRoom (`bg1_room`, `fg1_room_fg`)

Walkable: the terracotta floor, roughly y 0.80 to 0.97. Reem starts at x 0.20, y 0.88.

**Props:**
- `Mirror` on the wall peg: image `mirror_whole`, at about x 0.41, y 0.27, about 13% of the screen width.
- `BasketProp` on the floor under the mirror, next to the low table: image `basket`, at about x 0.30, y 0.83.
- Exit: the blue door on the right (x 0.88 to 0.98) → Yard.

**On first entering:** `reem_s1_001`, then `reem_s1_002`.

**Click Mirror** (before it falls): `reem_s1_003`.

**Click BasketProp:**
1. Reem walks to it, pickup pose, `reem_s1_004`, add `Basket`, hide BasketProp. `basket_taken = true`.
2. The mirror shakes, falls to the floor near the basket's spot (short tween), `sfx_mirror_crack`, its image becomes `mirror_cracked`. `mirror_broken = true`.
3. `reem_s1_005`, `reem_s1_006`.
4. **Choice 1:** green «أُخبِرُ جدّي بالحقيقة» / sand «أُخبّئُ المرآة».
   - Green: `reem_s1_007a`. `chose_truth = true`. The cracked mirror stays on the floor.
   - Sand: `reem_s1_007b`. Reem walks to the right floor cushion, the mirror moves behind it and is hidden. `mirror_hidden = true`. **Wilt.**

### Station 1, room 2: Yard (`bg2_yard`, `fg2_yard_fg`)

Walkable: the sandy path, roughly y 0.78 to 0.95. Arriving from GrandpaRoom, Reem appears in front of the house door (x 0.15).

**Characters and props:**
- `Jad`, seated on his bench under the olive tree, at about x 0.80, y 0.80 (feet on the ground).
- `Well` hotspot: the stone well, about x 0.40 to 0.55, y 0.40 to 0.70.
- Exits: left (the house door) → GrandpaRoom; right edge → Gate.

**Talk to Jad, first time** (`briefed == false`): `reem_s1_010`, `jad_s1_011`, `reem_s1_012`, `jad_s1_013`, `reem_s1_014`, `jad_s1_015` (add `Lantern`), `reem_s1_016`, `jad_s1_017` (add `Notebook`), `reem_s1_018`, `jad_s1_019`. `briefed = true`.

**Then, if `chose_truth` and not `confessed`:** a choice with one button, green «عندي شيءٌ أقولُه لك». Click → `reem_s1_021a`, `jad_s1_022a`, `jad_s1_023`, `jad_s1_024`. Add `HandMirror`. `confessed = true`. **Bloom.**

**Talk to Jad later:**
- If `mirror_hidden` and not `confessed`: if `needs_mirror` is true, play the confession: `reem_s1_021b`, `jad_s1_022b`, `jad_s1_023b`, `reem_s1_024b`, `jad_s1_024`. Add `HandMirror`. `confessed = true`, `mirror_hidden = false`. **Heal.** If `needs_mirror` is still false, replay `jad_s1_019`.
- Otherwise replay `jad_s1_019`.

**Click Well:** if no `WateringCan` yet: `reem_s1_020`, add `WateringCan`. Otherwise nothing.

**Notebook hint here:** none (clicking the notebook does nothing in this room).

### Station 1, room 3: Gate (`bg3_gate`, `fg3_gate_fg`)

Walkable: the path, y 0.80 to 0.95. Exits: left → Yard; right → MeadowFork. The right exit only works when `briefed` is true (before that, Reem does not go: ignore the click).

**On first entering after `briefed`:** `reem_s1_030`, `jad_s1_031` (off-screen), `reem_s1_032`.

### Station 2, room 4: MeadowFork (`bg4_fork`, `fg4_fork_fg`)

Walkable: the main path along the bottom (y 0.80 to 0.95), the upper path that curves up and around the meadow edge, and, only after the sand choice, a strip across the flower patch.

**Props:**
- `Sign`: the wooden sign at about x 0.30, y 0.55. In Godot, write on its board in Arabic: «من فضلك، امشِ على الطريق», small, in a dark brown color.
- `FlowersFork`: image `flowers_open`, placed on the open grass patch at about x 0.70, y 0.75.
- Exits: left → Gate; right → BigTree.

**On first entering:** `reem_s2_001`.

**Click Sign:** `reem_s2_002`.

**First click on the right exit:**
1. `reem_s2_003`.
2. **Choice 2:** green «أمشي على الطريق» / sand «أختصرُ فوقَ الزهور».
   - Green: `reem_s2_004a`. Reem walks along the upper path to the right exit. **Bloom.** → BigTree.
   - Sand: `reem_s2_004b`. Reem walks straight across the flowers; `sfx_trample`; `FlowersFork` becomes `flowers_trampled`. `trampled = true`. **Wilt.** → BigTree.

Later exits to the right go along the path with no choice.

**Use WateringCan on FlowersFork** (only if `trampled` and `told_to_fix` and not `flowers_fixed`): `sfx_water_pour`, `reem_s2_013b`, `FlowersFork` becomes `flowers_open`. `flowers_fixed = true`. **Heal.**

**Notebook hint here:** `reem_s2_002`.

### Station 2, room 5: BigTree (`bg5_tree_bees`, `fg5_tree_bees_fg`)

Walkable: the path, y 0.80 to 0.95.

**Characters and props:**
- `Shahd` hovering near the hives, about x 0.80, y 0.45. The two small bees fly slowly around the hives.
- `FlowersShade`: image `flowers_closed`, in the tree's shadow on the left, about x 0.25, y 0.75.
- `SunSpot` hotspot: the bright sunny grass on the right, about x 0.55 to 0.70, y 0.65 to 0.80.
- `Hives` hotspot: the three hive boxes, about x 0.70 to 0.98, y 0.45 to 0.65.
- Exits: left → MeadowFork; right → FoxRock, which only works when `flowers_open` is true.

**Talk to Shahd:**
- If `trampled` and not `told_to_fix`: `bee_s2_010b`, `reem_s2_011b`, `bee_s2_012b`. `told_to_fix = true`. Stop here.
- If `told_to_fix` and not `flowers_fixed`: replay `bee_s2_012b`. Stop.
- If `trampled` and `flowers_fixed` and not `met_shahd`: `bee_s2_014b`, then the common part.
- If not `met_shahd`: the common part: `reem_s2_020`, `bee_s2_021`, `reem_s2_022`, `bee_s2_023`, `bee_s2_024`, `reem_s2_025`. `met_shahd = true`.
- If `flowers_open`: replay `bee_s2_031`.

**Click Hives:** `reem_s2_027`.

**Use HandMirror on SunSpot or on FlowersShade** (only after `met_shahd`):
1. A soft beam of light goes from the mirror in Reem's hand, over the sunny grass, to the flowers (a simple glowing line or polygon that fades in and out).
2. `sfx_flowers_open`, `FlowersShade` becomes `flowers_open`.
3. `reem_s2_030`, `bee_s2_031`, `reem_s2_032`, `bee_s2_033`. Add `HoneyJar`. `flowers_open = true`. **Bloom.**

**If the child clicks FlowersShade or SunSpot without having the HandMirror** (after `met_shahd`): `reem_s2_041b`, `reem_s2_042b`. `needs_mirror = true`. (The child goes back to Grandpa in the Yard.)

**Notebook hint here** (after `met_shahd`): `reem_s2_026`.

### Station 2, room 6: FoxRock (`bg6_fox_rock`, `fg6_fox_rock_fg`)

Walkable: the path, y 0.80 to 0.95.

**Characters and props:**
- `Thaaloob` standing next to the big rock, about x 0.45, y 0.80.
- Exits: left → BigTree; right, the stream → End.

**On first entering** (or first click on Thaaloob): `fox_s2_050`, `reem_s2_051`, `fox_s2_052`, `fox_s2_053`, then **Choice 3:** green «هذه أمانةٌ من جدّي» / sand «أُبادِلُه».
- Green: `reem_s2_054a`, `fox_s2_055a`. **Bloom.** `fox_done = true`.
- Sand: `reem_s2_054b`. Remove `HandMirror`, add `Stone` (shiny). `traded = true`.

**After trading, use or click the Stone in the inventory:** it becomes `stone_dull`, `reem_s2_055b` (**Wilt**), `reem_s2_056b`. `stone_wiped = true`.

**Talk to Thaaloob after `stone_wiped`:** `reem_s2_057b`, `fox_s2_058b`. Remove `Stone`, add `HandMirror`. `reem_s2_059b`. **Heal.** `mirror_recovered = true`, `fox_done = true`.

**Right exit:** only when `fox_done` is true. → `reem_s2_070`, then End.

### End screen

`to_be_continued.png`, the heart tree shown large in the center (`heart_full` or the current state, see 4.3), `jad_s2_071` played as narration with its text shown, then the words «يتبع…» in large Arabic text. A button «العودة إلى البداية» → Title screen (reset all state).

---

## 6. Checklist per room (done = all true)

- The background and foreground are in place and fill the screen; no stretching.
- Reem walks only on the walkable area, at a size that looks right with the furniture or path.
- Every line plays its audio and shows its Arabic text correctly (connected, right-to-left).
- Every choice works both ways, and the heart tree changes as described.
- Every exit leads to the right room, and Reem appears at the matching side.
- No errors in Godot's Output panel when playing the room from start to finish.

## 7. Sound effects

`sfx_mirror_crack`, `sfx_pickup`, `sfx_heart_bloom`, `sfx_heart_wilt`, `sfx_trample`, `sfx_flowers_open`, `sfx_steps_grass`, `sfx_steps_tile`, `sfx_door`, `sfx_water_pour`, `sfx_ui_click`, `amb_farm`, `amb_meadow` – all in `res://assets/audio/sfx/` as `.mp3`.

## 8. Later (not in the MVP)

Skeletal animation with the parts sheets and lip sync with the mouth sheets; music with a settings toggle; touch-screen tuning and Android export; the other stations of the valley.


## 9. Base game systems (ROADMAP step 2)

### 9.1 Save and continue

- One automatic save, slot 1, at the end of each gameplay room's entry sequence. Saving after
  the sequence keeps its choice and first-visit dialogue complete before recording the room.
- Title: with a save, show the Continue and New journey labels from ROADMAP 3.7; without one,
  show the existing Start button. Both buttons use Cairo and right-to-left Arabic.
- Continue restores Popochiu room/character/item state, inventory, story flags, heart counters,
  player position and discovered words. Do not repeat first-visit entry dialogue when loading.
- New journey clears the automatic save and resets story flags, inventory and visited rooms.
  Keep the child's discovered-word collection, matching the MVP's existing new-game behavior.
- Entering the MVP End screen clears the automatic save; returning to Title starts fresh.
- Autosaves and loading are silent: no confirmation popup that requires another click.
- Saved room shapes retain Godot types through native JSON conversion. The save reader also
  accepts the original plain JSON format; only new saves guarantee preserved shape types.
- Changes inside a room are recorded on entering the next room, as requested by ROADMAP 3.7.
- Automatic check: add --path=save to the existing playtest command. It checks title Continue,
  restored room/position, story flags, inventory, words, and a clean new journey.


### 9.2 Settings

- A persistent Arabic Settings button is available on Title, End and idle gameplay screens;
  F10 opens it too. The existing inventory-bar gear opens this same panel.
- Open only when no dialogue, choice, scripted action or room transition is running. Pause
  the scene while the panel is open. Close by its large Back button or Escape/F10, and restore
  the previous GUI blocking state. Touch/mouse input cannot reach the story behind the panel.
- Controls: music on/off (off by default), voice volume 0–100%, effects volume 0–100%,
  and story text size normal/large/larger (40/48/56 px at the 1920×1080 design size).
- Voice volume controls dialogue and discovered-word recordings. Effects volume controls all
  existing effects and ambience. Music uses a separate bus; this MVP has no music tracks, so
  enabling it adds no sound. Say this plainly in a small Arabic note in the panel.
- Text size changes character dialogue, narration, choice labels and discovered-word bubbles.
  Keep Cairo, connected RTL Arabic and all original dialogue/word text unchanged.
- Apply changes immediately and persist separately in user://reem_settings.cfg. New journey
  and Continue never reset preferences. Default volumes are 100%; music defaults off.
- New interface labels are stored in game_data/ui_labels.json, with full diacritics. These are
  unspoken controls; no voice or art queue rows are needed for this feature.
- Test: --path=settings exercises the actual controls, independent voice/effects buses, word
  playback routing, larger Arabic text, blocked story input, persistence and reopening.


### 9.3 Notebook

This replaces the MVP inventory item's single immediate hint with the full notebook pages.

- Once Grandpa gives Notebook, its inventory click, a top-screen notebook button or N opens
  four Arabic pages: hints, discovered words, valley map, friend cards. Escape/Back/N closes.
  Open at idle only; pause gameplay, cancel unfinished word holds, and block story input.
- Hints start with one gentle nudge; More reveals a clearer hint, then the answer. Repeat
  replays the current hint. Select a context from room and puzzle flags; changing context
  resets to that context's remembered step. Hint text/audio IDs are in notebook.json and
  lines.json (Reem voice); all newly spoken hints enter voice_queue.md as todo. Missing audio
  is silent, not a blocker. Notebook playback uses ReemVoice and stops on page change/close.
- Words page lists only discovered IDs, copying their text/audio from words.json. Tap a word
  to replay its existing recording. Show a friendly empty-page message before finding any.
- Map page draws a parchment-style trail for the six built MVP rooms; labels/positions/edges
  are data in notebook.json. Visited places are enabled; current place is marked. Unvisited
  places are locked. Clicking a visited place closes the notebook and travels with the normal
  Popochiu transition/autosave. Title/End/TestArabic are never travel destinations. Expand this
  provisional MVP map when building further stations. No new bitmap map artwork is needed.
- Album shows only earned cards: for now Shahd after helping her open the flowers, using the
  existing shahd_body artwork and a simple fact about bees collecting flower nectar. No card
  for Thaaloob yet: Reem has not helped him in the MVP. Later Narrow pass awards his card.
  Card name/fact text and narration IDs are in notebook.json/lines.json and voice_queue.md.
- Globals.friend_cards and Globals.hint_steps are dictionaries saved through the custom
  save hooks. They reset with New journey; discovered words keep the previous behavior.
  Existing saves with flowers_open backfill Shahd's earned card. Room visits use Popochiu.
- Cairo/RTL and selected text size apply to page text. Large content scrolls. Interface labels
  live in ui_labels.json. Reused images/word audio need no queue rows; new hints/card narration
  go to voice_queue.md. Test with --path=notebook, plus the existing regression playtests.


### 9.4 Hotspot highlight

- In an idle gameplay room, a bottom-left Arabic Where can I click? button or H briefly
  outlines actionable props, characters, open exits and visible inventory items in soft gold.
- No story time limit, cost or cooldown. Repeating simply refreshes the visual glow.
  It never clicks an object, reveals a word, selects an item or changes puzzle flags.
- Exclude Reem, invisible/non-clickable objects, locked exits and targets the room marks as
  having no action. Background word-only areas are still found by long press, not this button.
- The glow ignores mouse/touch input. Hide it during dialogue, choices, transitions, selected
  inventory-item use, Settings and Notebook. Never show it on Title/End/TestArabic.
- Use interaction polygons transformed through the current camera, plus visible inventory
  rectangles. Duration and button position are exported in hotspot_highlight.gd for adjustment.
- Reuse native drawing; no new image/voice/word queue rows. Test with --path=highlight.

## 10. Stream (ROADMAP step 3, morning alternative)

One room `Stream`, 1920×1080. Gate offers Meadow (existing right arrow) or Stream
(upper arrow with Arabic label); this route choice has no heart change. Both
routes require Grandpa's briefing. Left exit returns to Gate at any time.
Right exit leads to PineFork once bridge, route and lantern are resolved.

Art: `bg7_stream.png` uses farm background as style reference. Shallow stream in
the middle distance, displaced stepping stones; dry continuous foreground path
y .80–.95. No Reem, fox, log or animals baked in. Duck family at (.44,.69), Arnoob
at (.70,.73), Thaaloob at (.84,.76). Character turnaround sheets precede their
derived right-facing sprites. A lightweight log beside the water at (.28,.70)
rolls to span a narrow channel; no child walks through water. All positions editable.

On first entry: `reem_stream_arrive`. Click Ducks -> `reem_stream_ducks` until
helped. Click Log -> `reem_stream_log`, roll it into place, duck family crosses
with a short tween, `reem_stream_thanks`; bloom once, earn duck card and coloured
feather festival contribution. Repeated clicks never duplicate rewards.

After bridge, click Arnoob or right exit: `reem_stream_rabbit`, choice Map / Follow.
Map -> `reem_stream_map`, bloom once, route resolved. Follow ->
`reem_stream_lost`, wilt once: background dims softly, Reem returns to the same
safe bank, never stranded. Click Arnoob again or right exit offers repair Map /
Look around. Map -> `reem_stream_found`, heal once, route resolved. Look around
repeats the nudge, no additional penalty. Notebook map remains available; no timer.

Then click Thaaloob or right exit: `fox_stream_offer`, choice Keep / Lend.
Keep -> `reem_stream_keep`, bloom once. Lend -> remove Lantern,
`fox_stream_borrow`, wilt once; fox stays visible and reachable. Click him again:
`reem_stream_ask_back`, return Lantern, `fox_stream_return`, heal once.
No fox friend card yet. Exit requires Lantern returned and all puzzles complete.

Flags in saved Globals.stream: introduced, bridge, route, lost, lantern_choice,
lent, feather. Reset on New journey. Dict values, inventory, earned card and heart
survive save/load. Hints: bridge / map repair / lantern return, each three steps.
Map adds Stream after first visit, connected to Gate. Reem narrates animal actions
until those animals have approved saved voices; never substitute another voice.
Duck card uses derived duck image and the fact that duck feathers help repel water.
New word objects are identified only after finished images are inspected; add via
tools/make_words.py and hand-edit word_areas.json. No hand edits to words.json.

Checks: required four MVP paths plus Stream green and wrong/repair paths, repeated
reward clicks, exit locks, lantern custody, card, hints, words, save/load and reset.

## 11. Pine Fork (meeting 1, late morning)

`PineFork`, one 1920×1080 room, dry lower path y .80–.95, three visible branching
paths labelled Oak forest, Rock cave, Meadow lake. Reem enters left; Thaaloob at
(.64,.78), sign at (.40,.61). Reuse original fox art/voice without redesign.
New background `bg8_pine_fork.png` references bg1_room; no baked fox, sign text or
people. Runtime Arabic labels use Cairo. Log all provisional route exits below.

Both Stream's right exit and completed FoxRock's right exit meet here. Left exit
returns to the arrival route saved in Globals.pine.origin. Notebook map has edges
from both branches and enables visited destinations only.

First entry `reem_pine_arrive`. Clicking fox or any forward exit before meeting
him: `fox_pine_offer`, choice Think about others / Accept skipping help.
Kind: `reem_pine_kind`, bloom once, meeting resolved. Tempting: `reem_pine_skip`,
wilt once, meeting resolved; a small leaf on the sign visibly droops. No path is
bad by itself: the cave is allowed. `fox_pine_cave` explicitly separates route
choice from the promise to ignore others. No fox friend card.

Click sign after the wrong choice: `reem_pine_repair`, choose Help when needed /
Think a little. Help heals once and lifts sign leaf; thinking leaves it available,
no added penalty. Clicking fox can also offer this repair. Every route remains
available after the meeting, even with the repair pending; no game over or timer.
Children may revisit this station through the map to heal later.

Forward route hotspots: ExitOak → OakForest, ExitCave → RockCave, ExitLake →
MeadowLake. Until each adjacent station exists, its exit goes to provisional MVP
End; this is an implementation boundary, never a claim that valley is complete.
Hints: meet fox / inspect sign / pick a route, three stages each. Flags saved in
Globals.pine: introduced, met, promised, origin. Reset on New journey. All reward
changes guarded for repeat clicks. New words identified from generated art only.
Tests: entry from both routes, kind/wrong/repair, no repeat reward, any route allowed,
save roundtrip, wrong promise visible on return, words, required four regressions.

## 12. Oak forest (noon)

OakForest branches from PineFork and rejoins at HoneyOrchard. A dry path runs across the lower screen. Sinjoob waits near the oak at left, Qunfood beside the leaves at right, and three visible acorns sit beside the roots. OakForest is optional in the valley route. Its left exit returns to PineFork. Its right exit opens once both friends are helped and uses provisional End until HoneyOrchard exists.

Click Sinjoob to start searching. Click the three acorns in any order. Each moves into his pile once. Then click Sinjoob and choose to suggest sharing or keep all the nuts. Sharing earns his card and festival nuts. Keeping them wilts once and leaves the pile visible. Click him again to repair by sharing, heal once, and earn the same rewards.

Click Qunfood to meet him. Choose to greet him or walk away because of his spines. Greeting lets him help Reem gather leaves, earns his card and festival leaves, and blooms once. Walking away wilts once. Qunfood stays reachable and the next click offers a greeting to repair. Reem narrates until approved voices exist for both animals.

Save distinct search, collection, choice, repair and reward flags. Update the notebook with the visited route, three-stage hints for the nut search and each repair, and cards for both friends. Long presses teach visible oak forest words and never collect an acorn. Check both first-choice paths, all repairs, save and restore, and repeated clicks.

## 13. Rock cave (noon)

RockCave branches from PineFork and exits to HoneyOrchard, using provisional End until that station exists. A broad safe path remains visible in soft reflected daylight. The left exit always returns to PineFork. Qatqoota waits near the left entrance, Ankoob and a damaged web sit in the middle, and Thaaloob waits on the right. No jump scare, countdown or total blackout.

Click Qatqoota and choose to offer the lantern or laugh at her fear. Offering it creates a warm pool of light and lets her walk a short way alongside Reem. She earns her card and offers to ring the festival bell. Laughing wilts once and leaves her at the entrance. The next conversation allows repair through the lantern choice, with no extra wilt on repetition.

Click Ankoob to see his web and choose to keep trying or give up. Giving up wilts once. Retry whenever ready. The web shows a four-anchor example sequence using shapes as well as colours. The child then clicks matching anchors in order. An incorrect anchor clears only the current attempt and leaves the example available. Completing the pattern earns Ankoob's card and festival threads and heals a previous give-up wilt or adds a blossom.

After helping both friends, click Thaaloob. He praises Reem's voice and asks her to put down her basket and sing. Reem can keep the basket close or put it down. If she puts it down, he tries to grab the honey. When HoneyJar is present, remove it and save fox_took_honey for Narrow pass. If Reem came via Stream without honey, Thaaloob finds no jar. Reem can pick her basket back up to repair the careless choice in either case. The jar stays with Thaaloob until Narrow pass if taken. Exit unlocks once the encounter ends, and the room remains revisitable.

Save progress, both cards, bell and thread rewards, pending repairs and honey custody. Add notebook hints and the visited route from Pine Fork. Reem narrates Qatqoota and Ankoob until each has a verified saved voice. Record Thaaloob with his saved voice. Long presses teach visible cave objects without advancing the web or story.

## 14. Meadow lake (afternoon)

MeadowLake branches from PineFork. The walking path stays on dry ground, with Dafdoof on the left bank, Ghazlana by three visible hoofprints and the wooden boat tied to the right dock. Left returns to PineFork. Right leads to HoneyOrchard once the frog and gazelle are helped, with provisional End until the orchard exists.

Click Dafdoof to learn that his voice is gone. Offer a spoonful of honey from HoneyJar and make warm honey water, or keep it all. If Reem arrives without HoneyJar, the boat can offer a small reserve spoonful so the puzzle remains available. Sharing warms the cup, brings back Dafdoof's song, and earns his card and the reed flute. Keeping the honey wilts once. Click Dafdoof again to share and heal. Keep the HoneyJar inventory item because only a spoonful was used.

Click Ghazlana to learn she went beyond where her mother asked her to stay. Follow three hoofprints along the bank in order. A wrong print leaves the current clue active. The last print leads to a safe reunion point and earns her card. The child's actions cannot send her into the water.

The boat introduces itself at its dock and mentions a future trip to the sea. It stays tied until the Gull island pack is built and unlocked. Reem narrates Dafdoof, Ghazlana and the boat until they have verified saved voices. Save the reserve honey, choices, hoofprint progress, rewards and cards. Notebook hints and the map update as the station progresses. Holding a hoofprint teaches the word and never advances the search.

## 15. Honey orchard (meeting 2, before sunset)

HoneyOrchard accepts arrivals from OakForest, RockCave and MeadowLake. Save the branch of arrival so the left arrow returns there. A dry foreground path crosses an orchard with Dubb at the left, Thaaloob in the middle, and the missing festival lanterns beside a shallow stream at the right. The two forward routes lead to HillSlope and WaterfallPath once both tasks are resolved. Until those rooms exist their arrows use provisional End.

Dubb has his head stuck in a honey jar. Click him to choose to speak softly or pull hard. Pulling hard makes him cry and wilts once. Dubb stays reachable. Speak softly to ready the repair. Then click the rim to loosen it with a small spoonful of honey. Use the honey at the orchard rim if Reem has no jar. The jar slides off, Dubb earns his card, and he offers to carry festival lanterns. Heal any earlier wilt or earn a blossom.

Thaaloob says that Dubb took the lanterns. Choose to look for evidence or accuse Dubb. Accusing wilts once and has a visible consequence for Dubb. Inspect the wet lanterns at the stream to learn they fell there. Return to Dubb to correct the accusation or report the evidence. The same repair remains available after leaving and returning. Once both tasks are done, the child can choose either forward route without a heart change.

Reem narrates Dubb until there is a verified saved voice. Use Thaaloob's saved voice for his own lines. Save the branch, rescue steps, accusation, evidence and lantern carrier reward. Add a map node, progressive hints and Dubb's card. Hold to teach objects such as the jar and lanterns without changing their story state.

## 16. Hill slope (sunset)

HillSlope branches from HoneyOrchard and leads to NarrowPass. Keep a continuous dry path below a gentle grassy hill. Tawoos waits at left. A simple frame at centre can show a folded festival lantern, a ribbon, and a coloured feather. The left arrow returns to the orchard. The right arrow opens once Tawoos gives the feathers, with provisional End until NarrowPass exists.

Tawoos refuses to lend feathers because he thinks only his feathers are beautiful. Click him and choose to show what everyone made together or flatter him. Flattery wilts once and leaves the display empty. Click him again to choose the display and repair. Show the three parts by clicking the display after that choice. It visibly combines his feather with the orchard lantern and ribbon, which can be shown on every route. Tawoos lends his coloured feathers and earns his card. Heal a previous wilt or add a blossom. Extra clicks do not repeat the reward. The feathers are saved for the big lantern.

Reem narrates Tawoos until a verified saved voice exists. Add progressive hints, a visited map node and vocabulary on the peacock, display and background. A word hold must not complete the display. Save the choice, pending repair and reward.

## 17. Waterfall path (sunset)

Use dialogue IDs reem_waterfall_arrive, reem_waterfall_provoked, reem_waterfall_throw, reem_waterfall_ask, reem_waterfall_roll and reem_waterfall_gift. The card uses reem_waterfall_name and reem_waterfall_fact. Persist the introduced, provoked, threw, ready and lantern_hanger flags.

WaterfallPath branches from HoneyOrchard and rejoins HillSlope at NarrowPass. Keep Reem on the dry foreground trail. The waterfall and its pool remain behind the path. Qarqoor waits by a low tree beside one fallen fruit. The left arrow goes back to HoneyOrchard. The right arrow opens after Qarqoor agrees to hang the high festival lanterns, with provisional End until NarrowPass exists.

On the first click, Qarqoor rolls a fruit onto the path to provoke Reem. Offer a choice to stay calm and ask why, or throw it back. Throwing back moves the fruit aside, wilts once, and keeps Qarqoor reachable. Reem can return and ask him calmly. He admits he wanted someone to play with. Click the fallen fruit to roll it gently back as a game. Qarqoor agrees to climb and hang the lanterns. Heal a prior wilt or add a blossom once. A word hold on the fruit must not advance the game.

Save the conversation, pending repair, game and lantern-hanger reward. Add progressive notebook hints, the visited map route, Qarqoor's card and visible vocabulary. Reem narrates until Qarqoor has a verified saved voice. The fruit stays on the ground and never hits anyone. The waterfall introduces no timer or hazard.

## 18. Illustrated valley map

The parchment button on station screens and the M key open the illustrated map. The cross and Escape close it. The map pauses the room while it is open. Title and ending cinematics have no map button.

Map positions are fractions of the illustration in game_data/map_places.json. Each entry names its room, word label, neighbouring places and pack. Leaf markers use the existing Popochiu saved room visits. Cream clouds cover unvisited valley markers and locks mark unavailable packs. Reem's pin bobs over her current room. A tap displays the place name in right-to-left Cairo and plays its recording when available. A visited destination asks for confirmation before moving Reem there.

The first opening shows Grandpa's introduction and plays the queued recording when installed. The map uses a short paper rustle. Add future rooms to the place data as they are built.

## 19. Narrow pass (dusk)

NarrowPass accepts both HillSlope and WaterfallPath. A wide safe foreground trail runs between two boulders at dusk. Thaaloob waits on the right of the gap with his tail caught by a small loose stone. Save the branch Reem used so the left exit returns there, with HillSlope as the fallback for a direct test run. The right exit opens to HilltopFestival once Thaaloob is free. Use the provisional End until that room exists.

Click Thaaloob. Reem can offer to help or walk away. Walking away leaves him caught, wilts once and keeps the stone and Thaaloob reachable. Click him again to choose help. Then click the loose stone to roll it away without blocking Reem's path. Thaaloob apologises. If he took the HoneyJar in RockCave, he returns it. He asks to join the festival. Reem forgives him and invites him to come with her. Save the pending repair, the freed state and whether Thaaloob joins. Heal a previous wilt or add a blossom once. Repeated clicks cannot duplicate the HoneyJar or the reward.

Use reem_pass_arrive, fox_pass_help, reem_pass_leave, reem_pass_stone, fox_pass_sorry, fox_pass_honey, fox_pass_join and reem_pass_welcome. Use saved Thaaloob for his own lines. Add notebook hints, both route connections and vocabulary for visible rocks, path, fox and tail. A hold on the loose stone teaches the word without freeing Thaaloob.

## 20. Hilltop festival and endings (night)

Persist the introduced and completed flags, the number of repaired mistakes and the six pack unlocks. Use the reem_festival and jad_festival line IDs in the voice queue. The return-to-title button keeps the festival save and the title's new journey button starts another route.

HilltopFestival opens from NarrowPass. The fairground has a dry foreground path, a long table, a large unlit lantern at the centre, and hooks for little lanterns. It can be revisited. Its left exit returns to NarrowPass. The child clicks the large lantern after the helped friends assemble. Play the ceremony once and persist the completed state. Allow the child to see the ending again without adding rewards.

Show only the animals whose help or repair is recorded. Use the earned notebook cards, Thaaloob's rescue flag, and Shahd's flower flag. Display nuts, leaves, the bell, silk, the reed flute, coloured feathers and the feather from Stream only when their reward flags are present. Dubb brings lanterns and carries Grandpa in as a surprise. Qarqoor raises the high lanterns when present. Grandpa recognises the good deeds and repaired mistakes in short conditional lines. He invites another route based on a friend Reem did not meet.

The large lantern and string lights glow when Reem lights them. The ending shows the final heart tree, including wilts that were left unresolved. Keep the last valley save so Continue returns to the finished festival, and let the child revisit stations to repair mistakes. Unlock the six pack map regions after the ceremony. Their individual entrances and stations open as their packs are built.

## 21. Gull island (pack 1)

After the festival, the talking boat at MeadowLake offers a trip across the water. Accept from the dock. The pack has three linked stations: GullShore, TideCave and GullLighthouse. Add all three to the illustrated map. The return boat stays reachable in every settled state.

At GullShore, the old turtle explains tide marks and asks Reem to put three pieces of litter in the basket. Reem can pick up the litter or leave it. Leaving it wilts a branch and the tide still leaves the litter reachable. Collecting all three repairs the choice. The tide rock shows high or low tide. Reem can click it to wait safely for the next tide without a timer. Low tide exposes the cave route. Tapping the tied boat returns to MeadowLake unless the small storm is still active.

At TideCave, the shy octopus shows three shapes beside coloured pools. Click the matching shapes in the order the octopus shows. Wrong shapes restart the attempt without a penalty. Completing the pattern earns its card and a polished lens. Both the shore and lighthouse routes remain reachable after entering the cave, regardless of tide.

At GullLighthouse, the gull wants to keep all three shells. Reem can let him pile them up or leave some on the beach. The wrong choice visibly unbalances the pile and wilts once. Revisit the choice and share to repair. The storm is gentle and quiet. Fit the polished lens in the lantern to light the lighthouse. The boat returns when the light is on. The turtle, octopus and gull get earned cards. Use Reem narration pending verified saved voices. Use Thaaloob's saved voice for a short gull-side story in which he wants to trade a shiny shell and learns to leave it at the shore.

Save tide, litter, pending mistakes, cave pattern, lens, lighthouse, storm and cards. The map shows the unlocked pack only after the festival. Hold on the station objects to hear their words without advancing puzzles.

## 22. Ramadan lantern night (pack 3)

From the farm yard after the festival, click the Ramadan lantern and choose to visit. RamadanLane, HedgehogCourt and IftarShelter are three safe dry walking rooms at dusk. The left lane arrow returns to Yard. Each room has a distinct lit area and shadowed puzzle objects. The lantern is a toggle. Turning it on reveals outlined objects and lets Reem select them. Turning it off hides only puzzle objects. The path and exits stay visible, and there is no countdown or real-world time dependency.

In RamadanLane, the musaharati shows Reem how the lantern reveals two baskets and a water jug in the dark. Find both baskets to clear the path. In HedgehogCourt, the hedgehog family asks Reem to collect dates for a traveller. Reem can keep them for herself or share. Keeping wilts once and leaves the tray empty. Turn the lantern back on, find the dates and share them to repair the choice. In IftarShelter, set the dates and water together to make a surprise iftar. Thaaloob offers to keep the last date, then returns it to the shared tray. The traveller joins the family when the meal is ready, just before Maghrib in the story.

Save the lantern state, discoveries, dates, pending choice and meal. The musaharati, hedgehog family and traveller appear through Reem narration pending verified saved voices. Use Thaaloob's saved voice. Add the new rooms to the map, progressive notebook hints, word areas and a hedgehog family card. No quoted religious text is needed.

## 23. Old city market (pack 2)

From Gate after the festival, choose the market road. MarketGate leads to MarketStalls and ScaleCourtyard. The left route always stays open. If Reem has no honey jar, the market gate merchant offers a small local jar for the counting exercise. Selling it places five large reusable game coins on the trade board.

At MarketStalls, the baker offers bread for three coins. Use the three coin slots to choose the exact count. Paying the wrong number returns every coin and lets Reem try again. The market cat asks to share bread. Keeping it visibly leaves the cat's dish empty and wilts once. Return and choose to share to repair. Earn a market cat card and keep two coins after the trade.

At ScaleCourtyard, Thaaloob disguises himself as a merchant. His scale tilts even when both pans hold the same one-unit weight. Reem can accept his first deal or test the scale. Accepting wilts once and can be repaired. Place an identical weight on each pan and use the balance lever. The unfair tilt is visible. Show it to the baker, and Thaaloob puts the counterweight back in its marked centre position. Repeat the experiment to show a fair balance. The stall stays open after repair, with no lost coins.

Save the honey sale, coin count, bread, cat choice, test weights and fair scale. Add all three places to the maps. Reem narrates the old baker and merchant pending approved saved voices. Use saved Thaaloob. Include object vocabulary for coin, bread, cat, scales and weights.

## 24. Snow Trail (pack 4)

After the festival, take the snow trail from HillSlope. SnowEdge, SnowTracks and SledHill are three safe, walkable rooms. The left route back to the valley stays open. The winter trail is bright with soft daylight and no slippery movement on the walking path.

At SnowEdge, a cold goldfinch waits beside an empty shelter. Reem can share a soft bundle or keep it. Keeping it leaves the bird shivering gently and wilts once. Offer it again to repair the choice. Click the shelter to put the bundle inside and earn the goldfinch card.

At SnowTracks, Arnoob in his white winter fur points to his own paired rabbit prints and the young deer's split hoofprints. Thaaloob offers to follow his own paw prints, then helps Reem compare them. Find three deer print groups from left to right. Wrong prints leave the trail open and the current progress unchanged. Use both shape and spacing so colour is unnecessary.

At SledHill, the young deer waits safely below the hill. Click the wooden board to slide down a clearly marked gentle track. The ride is a brief animation with no steering, timer or failure. At the bottom, click the deer to bring it to a sheltered spot before sunset in the story. Earn a deer card and keep the return arrow open. Save shelter help, the print sequence, slide completion and deer rescue. Reem narrates new animals pending verified saved voices. Use Thaaloob's saved voice for his cameo.

## 25. Ant Kingdom (pack 5)

After the festival, click the giant flower at MeadowFork. Reem becomes small beside its petals. GiantBloom, DewBank and AntCity use oversized surroundings and a smaller Reem sprite. The left exit always lets Reem retrace her route and return to normal size.

At GiantBloom, an ant worker has stopped carrying seeds. Reem can leave the work to the ant or offer to carry one seed together. Leaving the whole load with the ant wilts once. Return and offer to share the load to repair. Click the seed, then the ant earns a rest and Reem earns its card.

At DewBank, a drop of water is a lake. Click a floating leaf to align it with both dry banks. The beetle guard then shows the crossing and earns a card. The safe foreground remains available if the leaf is moved back. Thaaloob tries to hurry across and then helps wait for the leaf to be aligned.

At AntCity, the queen asks Reem to place three seeds in order by size. Incorrect seeds leave the previous good placements intact. When the seeds are stored, gentle oversized raindrops appear outside. Click the tunnel entrance to join the colony in shelter. The queen thanks Reem and earns a card. There is no countdown or falling hazard on the walking path. Save seed help, bridge alignment, seed order, rain and shelter. Add all three rooms to both maps and use only saved voices, with Reem narrating the ants and beetle.

## 26. Star Observatory (pack 6)

After the festival, take the mountain path beside the hilltop exit. OwlPerch, ObservatoryDome and StarRidge are three safe night rooms. The owl gives Reem a ride to the dome, shown with a short gentle lift and room transition. All returns are open from a dry path.

At OwlPerch, a cheeky bat offers to help read the stars. Reem can listen or rush on without hearing him. Rushing leaves the path clue unclear and wilts once. Return and listen to repair. The bat earns a card. Then click the owl to fly to the dome and earn its card.

At ObservatoryDome, the astronomer shows a fictional route of four stars. Reem clicks the marked stars in the shown sequence and a line connects each accepted point. Wrong stars leave the previous connections and example visible. Complete the route to open the ridge path. The example uses shape and arrangement without requiring a colour distinction.

At StarRidge, a small lost animal caravan waits beside a safe path. Thaaloob wants to follow a bright star in the wrong direction, then helps compare the route with the dome chart. Click three safe trail markers in the same order as the map. The caravan walks to the warm shelter. All moves are untimed and none can fail permanently. Save the bat choice, owl ride, connected stars, marker progress and caravan arrival. Add map locations, hints, cards and words. Reem narrates the owl, bat and astronomer pending approved voices. Use the saved Thaaloob voice for his cameo.
