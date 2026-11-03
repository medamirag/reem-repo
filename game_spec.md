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
