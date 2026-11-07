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
