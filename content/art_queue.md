# art_queue.md – images the game still needs

Artist (Codex), see docs/PIPELINE.md: generate every row with Status `todo`, in order, exactly as described in its section below. Use the Prompt exactly as written, attach the reference images listed under "Attach" (paths in this project), and follow the Background rule (transparent or opaque). Save at the "Save as" path.

After each image, check: no text or letters, no border or frame, the character matches its references, characters face right, correct number of arms and legs, separate pieces have clear gaps between them, and a transparent background is really transparent. Also check the row's "Extra check". Regenerate once if a check fails; then set Status to `done` or `problem: <short reason>`. Never delete rows.

Style rules: every new character gets a turnaround sheet first, and that sheet is attached to all its later images. Every new background attaches `assets/art/backgrounds/bg1_room.png` (or the station's first background) as a style reference. Every prompt starts with the STYLE block from the MVP (copied into each section, so each prompt can be used on its own).

Originals in `assets/` are never edited: new images are new files with the names below.

| ID | Save as | Attach | Background | Size | Prompt | Extra check | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| bg7_stream | `assets/art/backgrounds/bg7_stream.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg7_stream below | Dry continuous foreground walking path; shallow narrow water; no characters or log. | done |
| duck_sheet | `assets/art/characters/duck/duck_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See duck_sheet below | Three matching adult views; three ducklings in separate lower row; no overlap. | done |
| arnoob_sheet | `assets/art/characters/arnoob/arnoob_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See arnoob_sheet below | Three identical full-body views, two ears, two arms, two feet; right-facing middle view. | done |
| duck_family | `assets/art/characters/duck/duck_family.png` | `assets/art/characters/duck/duck_sheet.png` | transparent | 1536x1024 | See duck_family below | Real alpha; matches reference | done |
| arnoob_base | `assets/art/characters/arnoob/arnoob_base.png` | `assets/art/characters/arnoob/arnoob_sheet.png` | transparent | 1536x1024 | See arnoob_base below | Real alpha; matches reference | done |
| stream_log | `assets/art/items/stream_log.png` | `assets/art/backgrounds/bg1_room.png` | transparent | 1536x1024 | See stream_log below | Real alpha; matches reference | done |
| bg8_pine_fork | `assets/art/backgrounds/bg8_pine_fork.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg8_pine_fork below | Three paths; continuous lower walking path; welcoming cave | done |

| bg9_oak_forest | `assets/art/backgrounds/bg9_oak_forest.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg9_oak_forest below | Clear silhouette and correct background | done |
| sinjoob_sheet | `assets/art/characters/sinjoob/sinjoob_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See sinjoob_sheet below | Clear silhouette and correct background | done |
| sinjoob_base | `assets/art/characters/sinjoob/sinjoob_base.png` | `assets/art/characters/sinjoob/sinjoob_sheet.png` | transparent | 1536x1024 | See sinjoob_base below | Clear silhouette and correct background | done |
| qunfood_sheet | `assets/art/characters/qunfood/qunfood_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See qunfood_sheet below | Clear silhouette and correct background | done |
| qunfood_base | `assets/art/characters/qunfood/qunfood_base.png` | `assets/art/characters/qunfood/qunfood_sheet.png` | transparent | 1536x1024 | See qunfood_base below | Clear silhouette and correct background | done |
| oak_acorn | `assets/art/items/oak_acorn.png` | `assets/art/backgrounds/bg1_room.png` | transparent | 1024x1024 | See oak_acorn below | Clear silhouette and correct background | done |

| bg10_rock_cave | `assets/art/backgrounds/bg10_rock_cave.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg10_rock_cave below | Clean edges, readable silhouette | done |
| qatqoota_sheet | `assets/art/characters/qatqoota/qatqoota_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See qatqoota_sheet below | Clean edges, readable silhouette | done |
| qatqoota_base | `assets/art/characters/qatqoota/qatqoota_base.png` | `assets/art/characters/qatqoota/qatqoota_sheet.png` | transparent | 1536x1024 | See qatqoota_base below | Clean edges, readable silhouette | done |
| ankoob_sheet | `assets/art/characters/ankoob/ankoob_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See ankoob_sheet below | Clean edges, readable silhouette | done |
| ankoob_base | `assets/art/characters/ankoob/ankoob_base.png` | `assets/art/characters/ankoob/ankoob_sheet.png` | transparent | 1536x1024 | See ankoob_base below | Clean edges, readable silhouette | problem: both attempts failed visible leg-count check |

| bg11_meadow_lake | `assets/art/backgrounds/bg11_meadow_lake.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg11_meadow_lake below | Clear silhouette and correct background | done |
| dafdoof_sheet | `assets/art/characters/dafdoof/dafdoof_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See dafdoof_sheet below | Clear silhouette and correct background | done |
| dafdoof_base | `assets/art/characters/dafdoof/dafdoof_base.png` | `assets/art/characters/dafdoof/dafdoof_sheet.png` | transparent | 1536x1024 | See dafdoof_base below | Clear silhouette and correct background | done |
| ghazlana_sheet | `assets/art/characters/ghazlana/ghazlana_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See ghazlana_sheet below | Clear silhouette and correct background | done |
| ghazlana_base | `assets/art/characters/ghazlana/ghazlana_base.png` | `assets/art/characters/ghazlana/ghazlana_sheet.png` | transparent | 1536x1024 | See ghazlana_base below | Clear silhouette and correct background | done |
| wooden_boat_sheet | `assets/art/characters/wooden_boat/wooden_boat_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See wooden_boat_sheet below | Clear silhouette and correct background | done |
| wooden_boat_base | `assets/art/characters/wooden_boat/wooden_boat_base.png` | `assets/art/characters/wooden_boat/wooden_boat_sheet.png` | transparent | 1536x1024 | See wooden_boat_base below | Clear silhouette and correct background | done |

| bg12_honey_orchard | `assets/art/backgrounds/bg12_honey_orchard.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg12_honey_orchard below | Clear silhouette and correct background | done |
| dubb_sheet | `assets/art/characters/dubb/dubb_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See dubb_sheet below | Clear silhouette and correct background | done |
| dubb_base | `assets/art/characters/dubb/dubb_base.png` | `assets/art/characters/dubb/dubb_sheet.png` | transparent | 1536x1024 | See dubb_base below | Clear silhouette and correct background | done |
| dubb_jar | `assets/art/items/dubb_jar.png` | `assets/art/backgrounds/bg1_room.png` | transparent | 1024x1024 | See dubb_jar below | Clear silhouette and correct background | done |
| orchard_lanterns | `assets/art/items/orchard_lanterns.png` | `assets/art/backgrounds/bg1_room.png` | transparent | 1536x1024 | See orchard_lanterns below | Clear silhouette and correct background | done |

| bg13_hill_slope | `assets/art/backgrounds/bg13_hill_slope.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1920x1080 | See bg13_hill_slope below | Clear silhouette and correct background | done |
| tawoos_sheet | `assets/art/characters/tawoos/tawoos_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 1536x1024 | See tawoos_sheet below | Clear silhouette and correct background | done |
| tawoos_base | `assets/art/characters/tawoos/tawoos_base.png` | `assets/art/characters/tawoos/tawoos_sheet.png` | transparent | 1536x1024 | See tawoos_base below | Clear silhouette and correct background | done |
| tawoos_feather | `assets/art/items/tawoos_feather.png` | `assets/art/backgrounds/bg1_room.png` | transparent | 1024x1024 | See tawoos_feather below | Clear silhouette and correct background | done |

| map_valley | `assets/art/ui/map_valley.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See map_valley below | No lettering | done |
| map_pin_reem | `assets/art/ui/map_pin_reem.png` | `assets/art/backgrounds/bg1_room.png`, `assets/art/characters/reem/reem_sheet.png` | transparent | square | See map_pin_reem below | No lettering | done |
| map_fog | `assets/art/ui/map_fog.png` | `assets/art/backgrounds/bg1_room.png` | transparent | square | See map_fog below | No lettering | done |
| map_check | `assets/art/ui/map_check.png` | `assets/art/backgrounds/bg1_room.png` | transparent | square | See map_check below | No lettering | done |
| map_button | `assets/art/ui/map_button.png` | `assets/art/backgrounds/bg1_room.png` | transparent | square | See map_button below | No lettering | done |
| bg14_waterfall_path | `assets/art/backgrounds/bg14_waterfall_path.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg14_waterfall_path below | No lettering | done |
| qarqoor_sheet | `assets/art/characters/qarqoor/qarqoor_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See qarqoor_sheet below | No lettering | done |
| qarqoor_base | `assets/art/characters/qarqoor/qarqoor_base.png` | `assets/art/characters/qarqoor/qarqoor_sheet.png` | transparent | portrait | See qarqoor_base below | No lettering | done |
| qarqoor_fruit | `assets/art/items/qarqoor_fruit.png` | `assets/art/backgrounds/bg1_room.png` | transparent | square | See qarqoor_fruit below | No lettering | done |
| bg15_narrow_pass | `assets/art/backgrounds/bg15_narrow_pass.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg15_narrow_pass below | No lettering | done |
| pass_loose_stone | `assets/art/items/pass_loose_stone.png` | `assets/art/backgrounds/bg1_room.png` | transparent | square | See pass_loose_stone below | No lettering | done |
| bg16_hilltop_festival | `assets/art/backgrounds/bg16_hilltop_festival.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg16_hilltop_festival below | No lettering | done |
| festival_big_lantern | `assets/art/items/festival_big_lantern.png` | `assets/art/backgrounds/bg1_room.png` | transparent | portrait | See festival_big_lantern below | No lettering | done |
| festival_jad_seated | `assets/art/characters/grandpa/grandpa_festival_seated.png` | `assets/art/characters/grandpa/grandpa_sheet.png` | transparent | square | See festival_jad_seated below | No lettering | done |
| bg17_gull_shore | `assets/art/backgrounds/bg17_gull_shore.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg17_gull_shore below | No lettering | done |
| gull_turtle_sheet | `assets/art/characters/gull_turtle/gull_turtle_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See gull_turtle_sheet below | No lettering | done |
| gull_turtle_base | `assets/art/characters/gull_turtle/gull_turtle_base.png` | `assets/art/characters/gull_turtle/gull_turtle_sheet.png` | transparent | landscape | See gull_turtle_base below | No lettering | done |
| bg18_tide_cave | `assets/art/backgrounds/bg18_tide_cave.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg18_tide_cave below | No lettering | done |
| gull_octopus_sheet | `assets/art/characters/gull_octopus/gull_octopus_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See gull_octopus_sheet below | No lettering | done |
| gull_octopus_base | `assets/art/characters/gull_octopus/gull_octopus_base.png` | `assets/art/characters/gull_octopus/gull_octopus_sheet.png` | transparent | landscape | See gull_octopus_base below | No lettering | done |
| bg19_gull_lighthouse | `assets/art/backgrounds/bg19_gull_lighthouse.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg19_gull_lighthouse below | No lettering | done |
| gull_bird_sheet | `assets/art/characters/gull_bird/gull_bird_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See gull_bird_sheet below | No lettering | done |
| gull_bird_base | `assets/art/characters/gull_bird/gull_bird_base.png` | `assets/art/characters/gull_bird/gull_bird_sheet.png` | transparent | portrait | See gull_bird_base below | No lettering | done |
| bg20_ramadan_lane | `assets/art/backgrounds/bg20_ramadan_lane.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg20_ramadan_lane below | No lettering | done |
| bg21_hedgehog_court | `assets/art/backgrounds/bg21_hedgehog_court.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg21_hedgehog_court below | No lettering | done |
| bg22_iftar_shelter | `assets/art/backgrounds/bg22_iftar_shelter.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg22_iftar_shelter below | No lettering | done |
| musaharati_sheet | `assets/art/characters/musaharati/musaharati_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See musaharati_sheet below | No lettering | done |
| musaharati_base | `assets/art/characters/musaharati/musaharati_base.png` | `assets/art/characters/musaharati/musaharati_sheet.png` | transparent | portrait | See musaharati_base below | No lettering | done |
| traveller_sheet | `assets/art/characters/iftar_traveller/iftar_traveller_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See traveller_sheet below | No lettering | done |
| traveller_base | `assets/art/characters/iftar_traveller/iftar_traveller_base.png` | `assets/art/characters/iftar_traveller/iftar_traveller_sheet.png` | transparent | portrait | See traveller_base below | No lettering | done |

<!-- One section per row, in the same order:

## <ID>

- **Save as:** `assets/art/...`
- **Attach:** `assets/art/...` (or none)
- **Background:** opaque | transparent
- **Size:** 1536x1024
- **Extra check:** ...

**Prompt:**

```text
STYLE: ...
```
-->

## bg7_stream

- **Save as:** `assets/art/backgrounds/bg7_stream.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080
- **Extra check:** Dry continuous foreground walking path; shallow narrow water; no characters or log.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame.
A peaceful sunny morning stream in an Arab countryside valley. Wide side-view adventure background. A narrow turquoise shallow channel meanders in the middle distance between grassy banks, displaced smooth stepping stones, reeds, rounded pebbles, distant olive trees and gentle hills. Broad uninterrupted dry sandy walking path across the entire bottom 20 percent. Leave open space on the near bank for a movable log and duck family. No bridge, log, animals or people. Gentle, welcoming, no danger.
```

## duck_sheet

- **Save as:** `assets/art/characters/duck/duck_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024
- **Extra check:** Three matching adult views; three ducklings in separate lower row; no overlap.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame.
Character turnaround reference sheet on plain cream. A kind mother duck, white feathers, warm brown wing tips, orange bill and two orange webbed feet, small teal neck ribbon, gentle expressive eyes. Top row: full body front, right-facing side, back, same design and size, each separated by generous empty space. Lower row: exactly three small fluffy yellow ducklings, each in right-facing side view, two feet each, generous gaps. No clothing except the ribbon; no labels or props.
```

## arnoob_sheet

- **Save as:** `assets/art/characters/arnoob/arnoob_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024
- **Extra check:** Three identical full-body views, two ears, two arms, two feet; right-facing middle view.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame.
Character turnaround reference sheet on plain cream. Arnoob, a cheerful hasty small sandy-brown rabbit, cream muzzle and belly, two long upright ears, large kind dark eyes, tiny pink nose, short round tail, modest short teal waistcoat, no trousers needed on this animal. Three separate full-body views, front, right-facing side, back, consistent proportions, two arms and two feet, large clear gaps. Friendly youthful animal, no text or labels.
```

## duck_family

- **Save as:** `assets/art/characters/duck/duck_family.png`
- **Attach:** `assets/art/characters/duck/duck_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024
- **Extra check:** Real alpha, full bodies, right-facing, matches reference.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame.
Exactly one mother duck and three yellow ducklings, matching the reference sheet, full bodies in right-facing side view. Mother on the left, three smaller ducklings in a row to the right. Generous clear gaps between all four birds, all have two orange webbed feet, no overlap, no ground or shadow. Isolated game sprite sheet on real transparent background.
```

## arnoob_base

- **Save as:** `assets/art/characters/arnoob/arnoob_base.png`
- **Attach:** `assets/art/characters/arnoob/arnoob_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024
- **Extra check:** Real alpha, full bodies, right-facing, matches reference.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame.
Exactly one Arnoob rabbit matching the reference turnaround sheet, full body in right-facing side view, two upright ears, two arms, two feet, sandy-brown fur and teal waistcoat. Neutral kind expression, no ground or shadow. Isolated game sprite on real transparent background.
```

## stream_log

- **Save as:** `assets/art/items/stream_log.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** 1536x1024
- **Extra check:** Real alpha, full bodies, right-facing, matches reference.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame.
Exactly one short light brown wooden log, horizontal side view with rounded cut ends and gentle bark texture, simple thick silhouette, no sharp splinters. A child-sized movable game prop to roll into a tiny stream bridge. No scenery, ground or shadow. Isolated on real transparent background.
```

Stream checks (2026-11-06): all six images inspected: no text/frame, consistent right-facing characters, full limbs, separated birds, real RGBA alpha confirmed for sprites. Background generated 1672×941 (16:9), not the requested 1920×1080; fitted proportionally by ReemRoom. Originals preserved.

## bg8_pine_fork

- **Save as:** `assets/art/backgrounds/bg8_pine_fork.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080
- **Extra check:** three separate paths, no baked characters or sign, no scary darkness.

**Prompt:**

```text
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame. A peaceful late-morning pine grove crossroads in an Arab countryside valley. Wide side-view point-and-click adventure background, 1920x1080. Broad continuous dry sandy walking path across bottom 20 percent. Three clearly separate footpaths in the middle distance: left toward rounded oak trees, middle toward a welcoming small cave in smooth pale rock with a sunlit entrance, right toward a distant blue lake with reeds. Tall rounded pine trees and visible pine cones beside the foreground path. Leave an open grassy patch for a freestanding sign at left centre and a fox at right centre. No sign, animals, people, writing, dark threatening areas or scary effects.
```

Pine Fork art check (2026-11-06): no text/border/characters; three paths, friendly lit cave, pine cones and lake visible. Generated 1672×941, proportional fit. Sign/leaf and labels use native Godot shapes/text, no new bitmap. Existing fox original reused.


## bg9_oak_forest

- **Save as:** `assets/art/backgrounds/bg9_oak_forest.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink contours, soft textured paint, rich natural colours, bright welcoming lighting. Match the reference style. No writing, frames or watermark. A sunny oak forest at noon, wide side-view adventure game environment. A broad unobstructed dry sandy footpath spans the lower quarter. Giant oak roots left at x 25%, loose leaves right at x 70%, ferns and leafy oak canopy. Leave space for squirrel and hedgehog sprites. No animals, acorns or people.
```


## sinjoob_sheet

- **Save as:** `assets/art/characters/sinjoob/sinjoob_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink contours, soft textured paint, rich natural colours, bright welcoming lighting. Match the reference style. No writing, frames or watermark. Turnaround of an auburn squirrel with a large curled tail, cream muzzle, ochre waistcoat and curious eyes. Three separated full-body views front, right-facing profile and back on cream. Consistent design and correct limbs.
```


## sinjoob_base

- **Save as:** `assets/art/characters/sinjoob/sinjoob_base.png`
- **Attach:** `assets/art/characters/sinjoob/sinjoob_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink contours, soft textured paint, rich natural colours, bright welcoming lighting. Match the reference style. No writing, frames or watermark. Single full-body right-facing sprite of an auburn squirrel with a large curled tail, cream muzzle, ochre waistcoat and curious eyes, matching the attached turnaround exactly. Plain isolated alpha transparency with no ground or shadow.
```


## qunfood_sheet

- **Save as:** `assets/art/characters/qunfood/qunfood_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink contours, soft textured paint, rich natural colours, bright welcoming lighting. Match the reference style. No writing, frames or watermark. Turnaround of a shy rounded hedgehog with soft chestnut spines, beige face, small green neckerchief and gentle eyes. Three separated full-body views front, right-facing profile and back on cream. Consistent design and correct limbs.
```


## qunfood_base

- **Save as:** `assets/art/characters/qunfood/qunfood_base.png`
- **Attach:** `assets/art/characters/qunfood/qunfood_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink contours, soft textured paint, rich natural colours, bright welcoming lighting. Match the reference style. No writing, frames or watermark. Single full-body right-facing sprite of a shy rounded hedgehog with soft chestnut spines, beige face, small green neckerchief and gentle eyes, matching the attached turnaround exactly. Plain isolated alpha transparency with no ground or shadow.
```


## oak_acorn

- **Save as:** `assets/art/items/oak_acorn.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** 1024x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink contours, soft textured paint, rich natural colours, bright welcoming lighting. Match the reference style. No writing, frames or watermark. One isolated large recognizable oak acorn with chestnut brown nut and knobbly green-brown cup. True alpha, no ground or shadow.
```

## bg10_rock_cave

- **Save as:** `assets/art/backgrounds/bg10_rock_cave.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No letters, frame or watermark. Wide welcoming limestone cave, late noon reflected gold and cool blue. Broad continuous flat dry path in lower quarter. Soft daylight through left and right openings. Smooth rock shelf center for a web game drawn in Godot. Subtle rounded stalactites safely above path. No characters, spiderweb, frightening silhouettes, text or darkness hiding the path.
```

## qatqoota_sheet

- **Save as:** `assets/art/characters/qatqoota/qatqoota_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No letters, frame or watermark. Three separated matching full-body turnaround views of a small shy cream kitten with amber patches, rounded paws and dusty blue neck ribbon: front, right-facing profile, back on plain cream.
```

## qatqoota_base

- **Save as:** `assets/art/characters/qatqoota/qatqoota_base.png`
- **Attach:** `assets/art/characters/qatqoota/qatqoota_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No letters, frame or watermark. Single full-body right-facing sprite of a small shy cream kitten with amber patches, rounded paws and dusty blue neck ribbon, matching reference. True alpha background, no ground or shadow.
```

## ankoob_sheet

- **Save as:** `assets/art/characters/ankoob/ankoob_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No letters, frame or watermark. Three separated matching full-body turnaround views of a friendly small purple-brown spider with exactly eight thin rounded legs, warm eyes and tiny gold scarf: front, right-facing profile, back on plain cream.
```

## ankoob_base

- **Save as:** `assets/art/characters/ankoob/ankoob_base.png`
- **Attach:** `assets/art/characters/ankoob/ankoob_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No letters, frame or watermark. Single full-body right-facing sprite of a friendly small purple-brown spider with exactly eight thin rounded legs, warm eyes and tiny gold scarf, matching reference. True alpha background, no ground or shadow.
```

## bg11_meadow_lake

- **Save as:** `assets/art/backgrounds/bg11_meadow_lake.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Wide afternoon lakeside meadow, clear warm sunlight, reeds and round stones along the far bank. Lower quarter is an uninterrupted broad dry sandy path. Short wooden dock on far right, still open water behind dock. No boat, people, animals, hoofprints or furniture. Style reference for brushwork only, not room contents.
```

## dafdoof_sheet

- **Save as:** `assets/art/characters/dafdoof/dafdoof_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Three separated matching full-body turnaround views of a little moss-green frog with a cream belly, wide friendly eyes and a red neckerchief: front, right-facing profile and back on cream.
```

## dafdoof_base

- **Save as:** `assets/art/characters/dafdoof/dafdoof_base.png`
- **Attach:** `assets/art/characters/dafdoof/dafdoof_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Single full-body right-facing sprite of a little moss-green frog with a cream belly, wide friendly eyes and a red neckerchief, matching reference. Real transparent background, no ground or shadow.
```

## ghazlana_sheet

- **Save as:** `assets/art/characters/ghazlana/ghazlana_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Three separated matching full-body turnaround views of a small tan gazelle with large kind eyes, white belly, dark leg markings and a lilac scarf: front, right-facing profile and back on cream.
```

## ghazlana_base

- **Save as:** `assets/art/characters/ghazlana/ghazlana_base.png`
- **Attach:** `assets/art/characters/ghazlana/ghazlana_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Single full-body right-facing sprite of a small tan gazelle with large kind eyes, white belly, dark leg markings and a lilac scarf, matching reference. Real transparent background, no ground or shadow.
```

## wooden_boat_sheet

- **Save as:** `assets/art/characters/wooden_boat/wooden_boat_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Three separated matching full-body turnaround views of a small warmly smiling wooden rowboat with a blue stripe and two subtle carved eyes near the bow, no human limbs: front, right-facing profile and back on cream.
```

## wooden_boat_base

- **Save as:** `assets/art/characters/wooden_boat/wooden_boat_base.png`
- **Attach:** `assets/art/characters/wooden_boat/wooden_boat_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint, natural colours. No letters, frames or watermark. Single full-body right-facing sprite of a small warmly smiling wooden rowboat with a blue stripe and two subtle carved eyes near the bow, no human limbs, matching reference. Real transparent background, no ground or shadow.
```

## bg12_honey_orchard

- **Save as:** `assets/art/backgrounds/bg12_honey_orchard.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Wide honey orchard just before sunset, rows of fruit trees with golden leaves, gentle peach and purple sky. Broad dry continuous walking path in lower quarter. Narrow shallow stream in middle distance at right with flat stones. Keep left foreground space for a bear and jar, central space for a fox. No characters, furniture, houses, jar or lanterns. Style reference only for brushwork.
```

## dubb_sheet

- **Save as:** `assets/art/characters/dubb/dubb_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Three clearly separated front, right profile and rear views of a round young brown bear with cream muzzle, light belly and green neckerchief, kind eyes, two arms two legs, plain cream background.
```

## dubb_base

- **Save as:** `assets/art/characters/dubb/dubb_base.png`
- **Attach:** `assets/art/characters/dubb/dubb_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Single full-body right-facing sprite of the same young brown bear from reference with cream muzzle, light belly, green neckerchief and kind eyes. True alpha. No ground or shadow.
```

## dubb_jar

- **Save as:** `assets/art/items/dubb_jar.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** 1024x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One rounded honey pot of warm terracotta, lying sideways with opening facing down-left, big enough to cover a bear cub head. A small honey drip at the rim. Isolated alpha sprite, no ground or shadow.
```

## orchard_lanterns

- **Save as:** `assets/art/items/orchard_lanterns.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure. Rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Two unlit festival lanterns lying beside each other, one amber and one muted blue, small water drops on their metal frames, clean silhouette. Isolated transparent sprite, no ground or shadow.
```

## bg13_hill_slope

- **Save as:** `assets/art/backgrounds/bg13_hill_slope.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1920x1080

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Wide gentle grassy hillside at warm sunset, rounded distant hills and lavender sky, winding trail rising far right. Continuous broad dry walking path across lower quarter. Leave clear foreground room for peacock at left and display at center. No people, animals, furniture or buildings. Style reference for brushwork only.
```

## tawoos_sheet

- **Save as:** `assets/art/characters/tawoos/tawoos_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Three separated full-body turnaround views front, right-facing profile and back of a proud but kind sapphire-blue peacock with a small blue crest, teal and emerald folded tail, and exactly two legs. Plain cream background. No signs or accessories.
```

## tawoos_base

- **Save as:** `assets/art/characters/tawoos/tawoos_base.png`
- **Attach:** `assets/art/characters/tawoos/tawoos_sheet.png`
- **Background:** transparent
- **Size:** 1536x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One full-body right-facing sapphire-blue peacock matching the turnaround, small crest, folded emerald and teal tail, two feet visible. Real alpha transparency with no ground or shadow.
```

## tawoos_feather

- **Save as:** `assets/art/items/tawoos_feather.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** 1024x1024

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One isolated peacock tail feather with teal, emerald and sapphire eye markings. Large readable silhouette, no shadow, true transparency.
```

## map_valley

- **Save as:** `assets/art/ui/map_valley.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** opaque
- **Size:** 16:9 landscape

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Top-down children's treasure map on warm parchment, soft palette, no text letters or labels. Bottom left Grandpa's red-roof farm; dirt trail forks via flower meadow and blue stream to tall pine fork. Three trails from pines via oak forest, grey hill with cave mouth, and round lake with small wooden dock, rejoining at orchard with beehives. Then two trails via gentle green slope and little waterfall to narrow gap between two rocks, then hilltop festival top right, unlit lanterns. Smaller faded edge features: lighthouse island and seagulls bottom right across lake, walled town with market awning at left off farm road, mountain with dome observatory top left, giant flower and tiny anthill in meadow. Clear spaces for icons at each site.
```

## map_pin_reem

- **Save as:** `assets/art/ui/map_pin_reem.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`, `assets/art/characters/reem/reem_sheet.png`
- **Background:** transparent
- **Size:** square

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Reem’s face matching her reference sheet in a round teal #2BB3A8 badge with a small downward point, a compact map pin. One isolated icon on true alpha.
```

## map_fog

- **Save as:** `assets/art/ui/map_fog.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** square

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Single soft opaque white-cream cloud puff with feathered edges for hiding a map landmark. Isolated on true alpha.
```

## map_check

- **Save as:** `assets/art/ui/map_check.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** square

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. A small simple green leaf badge for a visited landmark, clear dark outline, single isolated icon on true alpha.
```

## map_button

- **Save as:** `assets/art/ui/map_button.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** transparent
- **Size:** square

**Prompt:**

```text
STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Small rolled parchment treasure-map icon with two rolled edges, no marks or lettering, single isolated icon on true alpha.
```

## bg14_waterfall_path

- **Save as:** `assets/art/backgrounds/bg14_waterfall_path.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

A sunset forest path beside a small waterfall in the middle distance, continuous broad dry flat dirt foreground across the lower third for a 2D side view walking game. Waterfall and shallow blue pool behind the path at centre-right. Left a small low leaning tree beside a mossy rock, and ground clear for the monkey and one separate fruit sprite. Warm coral light, green foliage, soft blue pool. No furniture, people, animals or fruit on the foreground trail.

## qarqoor_sheet

- **Save as:** `assets/art/characters/qarqoor/qarqoor_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Standalone character turnaround reference sheet on plain warm cream. Qarqoor is a cheerful young golden-brown monkey with pale peach face, round ears, a sweeping curved tail, five simple digits on each hand, large warm eyes, and no clothing. Show front, profile facing right, and back with generous gaps. Each has two arms, two legs, one tail. Gentle smile.

## qarqoor_base

- **Save as:** `assets/art/characters/qarqoor/qarqoor_base.png`
- **Attach:** `assets/art/characters/qarqoor/qarqoor_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Standalone fully transparent game sprite of Qarqoor, using the reference sheet only for design. One cheerful young golden-brown monkey facing left three-quarter, pale peach face, round ears, one curved tail, two arms and two legs. Feet visible on a shared baseline. No scenery or shadow.

## qarqoor_fruit

- **Save as:** `assets/art/items/qarqoor_fruit.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Standalone transparent sprite, one small round golden orange fruit with a green leaf. Smooth recognizable round silhouette that can roll. No scenery, ground, basket or shadows.

## bg15_narrow_pass

- **Save as:** `assets/art/backgrounds/bg15_narrow_pass.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

A wide dry dirt path runs across the entire lower third of a side-view game scene, through a safe gap framed by two large rounded boulders at dusk. A low right boulder leaves enough empty space for a fox and separate stone sprite. Muted lavender rocks, green scrub, warm violet-peach sky. Gentle atmosphere, no characters, no furniture, no falling rocks.

## pass_loose_stone

- **Save as:** `assets/art/items/pass_loose_stone.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Standalone isolated small rounded grey-violet stone with a moss patch, slightly flat oval shape that can roll. Transparent background, no ground or objects.

## bg16_hilltop_festival

- **Save as:** `assets/art/backgrounds/bg16_hilltop_festival.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

A welcoming hilltop festival at night, storybook side view. Deep navy sky, dusky green hills, subtle stars. Small stall awnings behind a broad dry foreground path, simple empty long low wooden table to the right, and a wooden beam with several small UNLIT gold parchment lanterns. Leave the central area behind the foreground clear for a separately composited large lantern and the full dry lower third clear for characters. No people or animals. No flames or illuminated lanterns.

## festival_big_lantern

- **Save as:** `assets/art/items/festival_big_lantern.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Single large ornamental brass and warm cream parchment festival lantern, unlit, simple rounded hexagonal form with a small top handle and crescent motif, fully visible, straight on. Isolated on transparent background. No person, scenery, hanging rope, flame, light or halo.

## festival_jad_seated

- **Save as:** `assets/art/characters/grandpa/grandpa_festival_seated.png`
- **Attach:** `assets/art/characters/grandpa/grandpa_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One seated Grandpa Sulaiman, warm kindly elderly Arab man from the attached turnaround, exact facial features, beard and clothing colours. Three-quarter facing left, seated with knees gently folded and hands in lap, whole figure visible. No chair or ground, isolated transparent character sprite.

## bg17_gull_shore

- **Save as:** `assets/art/backgrounds/bg17_gull_shore.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Bright morning at a small sandy island beach, side-on 2D walking room, broad flat dry trail in the lower third. A short empty wooden dock with a tied little boat at the far left, tide pools and water behind the foreground, distant cave entrance on the far right, blue sea, rounded reeds and shore stones. Leave open spaces on the sand for three litter props and a turtle. No characters or text.

## gull_turtle_sheet

- **Save as:** `assets/art/characters/gull_turtle/gull_turtle_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Three separate front, right side and rear views of a kindly old sea turtle character on plain warm cream. Real sea turtle anatomy with four flippers, small tail, sage green face and gently patterned ochre shell. Soft cartoon eyes, no accessories.

## gull_turtle_base

- **Save as:** `assets/art/characters/gull_turtle/gull_turtle_base.png`
- **Attach:** `assets/art/characters/gull_turtle/gull_turtle_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Single kindly old sea turtle from the reference sheet, three-quarter facing left. Four flippers, sage green face, ochre patterned shell, warm eyes, no accessories or scenery. Isolated transparent sprite.

## bg18_tide_cave

- **Save as:** `assets/art/backgrounds/bg18_tide_cave.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Light cheerful tidal cave, side-on scene, rounded lavender rock with gaps for sunlight. Three small distinct shallow tide pools (teal, lavender and gold highlights) behind a wide continuous dry sandy walking trail in the lower third. No characters, symbols, traps, text or lettering.

## gull_octopus_sheet

- **Save as:** `assets/art/characters/gull_octopus/gull_octopus_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Two separate front and side views of a small shy friendly octopus on plain warm cream. Dusty rose body, eight gently curling arms spaced so their count is clear, two wide eyes, no clothes or accessories. Clear turnaround character reference.

## gull_octopus_base

- **Save as:** `assets/art/characters/gull_octopus/gull_octopus_base.png`
- **Attach:** `assets/art/characters/gull_octopus/gull_octopus_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

A single small shy octopus using the attached design, dusty rose and lavender, eight distinct curved arms, two warm eyes, no scenery. Isolated transparent game sprite.

## bg19_gull_lighthouse

- **Save as:** `assets/art/backgrounds/bg19_gull_lighthouse.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Friendly hill beside the sea with a stout white and coral lighthouse in the centre. A dim blue-grey cloud bank over the sea and a small steady swell. A wide dry path across the lower third, a low stone wall and unlit accessible lamp on a low plinth just right of centre. No lightning, danger, animals or text.

## gull_bird_sheet

- **Save as:** `assets/art/characters/gull_bird/gull_bird_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Three separate front, right side and back views of a slightly cheeky friendly small seagull on plain warm cream. White body, grey wings, two yellow webbed feet, orange-tipped yellow beak, gentle expression and clean readable shape.

## gull_bird_base

- **Save as:** `assets/art/characters/gull_bird/gull_bird_base.png`
- **Attach:** `assets/art/characters/gull_bird/gull_bird_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One friendly slightly cheeky seagull from the attached sheet, standing, facing left three-quarter, two yellow webbed feet, two grey wings, white body, yellow orange-tipped beak. No scenery. Fully transparent.

## bg20_ramadan_lane

- **Save as:** `assets/art/backgrounds/bg20_ramadan_lane.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Side view of a quiet village lane near a farm at blue hour in Ramadan. A broad dry flat dirt path spans the bottom third. Warm stone walls, crescent moon, a few small warmly glowing windows, a wooden porch at left and three softly shadowed alcoves along the lower middle, clear for props. Gentle blue and violet night with warm gold accents, no people, letters or writing.

## bg21_hedgehog_court

- **Save as:** `assets/art/backgrounds/bg21_hedgehog_court.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Friendly Arab village courtyard at blue hour, dry wide continuous foreground path, date palm and low bench, warm clay wall, three shadowed recesses with empty space for separate date props, lanterns on hooks, moon, no people or animals and no text.

## bg22_iftar_shelter

- **Save as:** `assets/art/backgrounds/bg22_iftar_shelter.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Small welcoming open-air stone shelter at late dusk in a village. Broad dry horizontal foreground path. A low empty wooden table with woven rug behind the path, soft warm windows, crescent sky and quietly lit archway. Room for a seated traveller beside the table, no people, animals, text or writing.

## musaharati_sheet

- **Save as:** `assets/art/characters/musaharati/musaharati_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Front, right side and rear turnaround of an adult Arab village night caller with dark trimmed beard, soft friendly eyes, teal vest over cream thobe and white cap, holding one simple small hand drum. Plain warm cream and generous gaps, no letters or scenery.

## musaharati_base

- **Save as:** `assets/art/characters/musaharati/musaharati_base.png`
- **Attach:** `assets/art/characters/musaharati/musaharati_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One standing friendly Arab night caller in his teal vest, cream thobe and white cap, matching the turnaround. One small hand drum held naturally, two arms and two feet. Isolated transparent three-quarter view facing left.

## traveller_sheet

- **Save as:** `assets/art/characters/iftar_traveller/iftar_traveller_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Front, profile and rear character reference sheet, gentle middle-aged Arab traveller with short grey beard, warm brown robe and muted purple scarf, one cloth travel bag, plainly dressed. No letters, background scenery or other people.

## traveller_base

- **Save as:** `assets/art/characters/iftar_traveller/iftar_traveller_base.png`
- **Attach:** `assets/art/characters/iftar_traveller/iftar_traveller_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One gentle middle-aged traveller, matching the sheet exactly, seated three-quarter facing left with travel bag set beside him within one sprite. Short grey beard, warm brown robe and muted purple scarf. Isolated transparent, no table or ground.
