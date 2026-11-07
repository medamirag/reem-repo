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
