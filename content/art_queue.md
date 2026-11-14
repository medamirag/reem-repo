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
| ankoob_body | `assets/art/characters/ankoob/ankoob_body.png` | assets/art/characters/ankoob/ankoob_sheet.png | transparent | 1254x1254 | See ankoob_body below | No additional limbs, clear alpha | done |
| ankoob_leg | `assets/art/characters/ankoob/ankoob_leg.png` | None on retry | transparent | 1774x887 | See ankoob_leg below | No additional limbs, clear alpha | done |

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
| bg23_market_gate | `assets/art/backgrounds/bg23_market_gate.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg23_market_gate below | No lettering | done |
| bg24_market_stalls | `assets/art/backgrounds/bg24_market_stalls.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg24_market_stalls below | No lettering | done |
| bg25_scale_court | `assets/art/backgrounds/bg25_scale_court.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg25_scale_court below | No lettering | done |
| market_baker_sheet | `assets/art/characters/market_baker/market_baker_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See market_baker_sheet below | No lettering | done |
| market_baker_base | `assets/art/characters/market_baker/market_baker_base.png` | `assets/art/characters/market_baker/market_baker_sheet.png` | transparent | portrait | See market_baker_base below | No lettering | done |
| market_cat_sheet | `assets/art/characters/market_cat/market_cat_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See market_cat_sheet below | No lettering | done |
| market_cat_base | `assets/art/characters/market_cat/market_cat_base.png` | `assets/art/characters/market_cat/market_cat_sheet.png` | transparent | square | See market_cat_base below | No lettering | done |
| bg26_snow_edge | `assets/art/backgrounds/bg26_snow_edge.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg26_snow_edge below | No lettering | done |
| bg27_snow_tracks | `assets/art/backgrounds/bg27_snow_tracks.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg27_snow_tracks below | No lettering | done |
| bg28_sled_hill | `assets/art/backgrounds/bg28_sled_hill.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg28_sled_hill below | No lettering | done |
| goldfinch_sheet | `assets/art/characters/goldfinch/goldfinch_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See goldfinch_sheet below | No lettering | done |
| goldfinch_base | `assets/art/characters/goldfinch/goldfinch_base.png` | `assets/art/characters/goldfinch/goldfinch_sheet.png` | transparent | square | See goldfinch_base below | No lettering | done |
| snow_deer_sheet | `assets/art/characters/snow_deer/snow_deer_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See snow_deer_sheet below | No lettering | done |
| snow_deer_base | `assets/art/characters/snow_deer/snow_deer_base.png` | `assets/art/characters/snow_deer/snow_deer_sheet.png` | transparent | square | See snow_deer_base below | No lettering | done |
| arnoob_winter | `assets/art/characters/arnoob/arnoob_winter.png` | `assets/art/characters/arnoob/arnoob_base.png` | transparent | landscape | See arnoob_winter below | No lettering | done |
| bg29_giant_bloom | `assets/art/backgrounds/bg29_giant_bloom.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg29_giant_bloom below | No lettering, check limbs | done |
| bg30_dew_bank | `assets/art/backgrounds/bg30_dew_bank.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg30_dew_bank below | No lettering, check limbs | done |
| bg31_ant_city | `assets/art/backgrounds/bg31_ant_city.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg31_ant_city below | No lettering, check limbs | done |
| ant_worker_sheet | `assets/art/characters/ant_worker/ant_worker_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See ant_worker_sheet below | No lettering, check limbs | done |
| ant_worker_base | `assets/art/characters/ant_worker/ant_worker_base.png` | `assets/art/characters/ant_worker/ant_worker_sheet.png` | transparent | portrait | See ant_worker_base below | No lettering, check limbs | done |
| ant_queen_sheet | `assets/art/characters/ant_queen/ant_queen_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See ant_queen_sheet below | No lettering, check limbs | done |
| ant_queen_base | `assets/art/characters/ant_queen/ant_queen_base.png` | `assets/art/characters/ant_queen/ant_queen_sheet.png` | transparent | portrait | See ant_queen_base below | No lettering, check limbs | done |
| ant_beetle_sheet | `assets/art/characters/ant_beetle/ant_beetle_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See ant_beetle_sheet below | No lettering, check limbs | done |
| ant_beetle_base | `assets/art/characters/ant_beetle/ant_beetle_base.png` | `assets/art/characters/ant_beetle/ant_beetle_sheet.png` | transparent | landscape | See ant_beetle_base below | No lettering, check limbs | done |
| bg32_owl_perch | `assets/art/backgrounds/bg32_owl_perch.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg32_owl_perch below | Check silhouette, palette and no lettering | done |
| bg33_observatory_dome | `assets/art/backgrounds/bg33_observatory_dome.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg33_observatory_dome below | Check silhouette, palette and no lettering | done |
| bg34_star_ridge | `assets/art/backgrounds/bg34_star_ridge.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg34_star_ridge below | Check silhouette, palette and no lettering | done |
| observatory_owl_sheet | `assets/art/characters/observatory_owl/observatory_owl_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See observatory_owl_sheet below | Check silhouette, palette and no lettering | done |
| observatory_owl_base | `assets/art/characters/observatory_owl/observatory_owl_base.png` | `assets/art/characters/observatory_owl/observatory_owl_sheet.png` | transparent | square | See observatory_owl_base below | Check silhouette, palette and no lettering | done |
| observatory_bat_sheet | `assets/art/characters/observatory_bat/observatory_bat_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See observatory_bat_sheet below | Check silhouette, palette and no lettering | done |
| observatory_bat_base | `assets/art/characters/observatory_bat/observatory_bat_base.png` | `assets/art/characters/observatory_bat/observatory_bat_sheet.png` | transparent | landscape | See observatory_bat_base below | Check silhouette, palette and no lettering | done |
| astronomer_sheet | `assets/art/characters/astronomer/astronomer_sheet.png` | `assets/art/backgrounds/bg1_room.png` | opaque | landscape | See astronomer_sheet below | Check silhouette, palette and no lettering | done |
| astronomer_base | `assets/art/characters/astronomer/astronomer_base.png` | `assets/art/characters/astronomer/astronomer_sheet.png` | transparent | portrait | See astronomer_base below | Check silhouette, palette and no lettering | done |
| bg35_tree_day | `assets/art/backgrounds/bg35_tree_day.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg35_tree_day below | No lettering, clear walking lane | done |
| bg36_mother_garden | `assets/art/backgrounds/bg36_mother_garden.png` | `assets/art/backgrounds/bg1_room.png` | opaque | 16:9 landscape | See bg36_mother_garden below | No lettering, blank card and clear walking lane | done |
| dew_leaf_bridge | `assets/art/items/dew_leaf_bridge.png` | `assets/art/backgrounds/bg30_dew_bank.png` | transparent | 2172x724 | See dew_leaf_bridge below | One long leaf only, real alpha, wide and flat (about 4:1) | done |
| pass_tail_rock | `assets/art/items/pass_tail_rock.png` | `assets/art/backgrounds/bg15_narrow_pass.png` | transparent | 1536x1024 | See pass_tail_rock below | One rock only, real alpha, sandstone like the Narrow Pass boulders, round enough to roll | done |
| bg4_fork_shortcut | `assets/art/backgrounds/bg4_fork_shortcut.png` | `assets/art/backgrounds/bg4_fork.png`, `assets/art/backgrounds/bg5_tree_bees.png` | opaque | 16:9 | See bg4_fork_shortcut below | Preserve framing and main road, no text | done |
| bg4_fork_wildflowers | `assets/art/backgrounds/bg4_fork_wildflowers.png` | `assets/art/backgrounds/bg4_fork_shortcut.png` | opaque | 16:9 | See bg4_fork_wildflowers below | Keep composition and clean road, no text | done |
| bg_stream_bridge | `assets/art/backgrounds/bg_stream_bridge.png` | `assets/art/backgrounds/bg7_stream.png` | opaque | 16:9 | See bg_stream_bridge below | Same banks and stones, footbridge in perspective, no text | done |
| bridge_planks | `assets/art/items/bridge_planks.png` | `assets/art/backgrounds/bg7_stream.png` | transparent | landscape | See bridge_planks below | Isolated planks and rope, true alpha | done |

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

## bg23_market_gate

- **Save as:** `assets/art/backgrounds/bg23_market_gate.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

A warm old walled Arab town entrance in morning sunlight, side view for 2D game. Broad dry path across lower third, round stone gate arch in background, quiet honey merchant's empty wood stall with teal awning, pots and olive trees. Leave foreground open for Reem and separate character. No people, animals, text or lettering.

## bg24_market_stalls

- **Save as:** `assets/art/backgrounds/bg24_market_stalls.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

A friendly old Arab market lane with an empty bakery stall, three little clay oven openings behind a low table, baskets of simple round flatbreads, warm sandstone walls, dark red and ochre fabric awnings. Side-view walking game scene with broad dry lower-third path. Leave left clear for baker, right near an empty dish for market cat. No people, animals or text.

## bg25_scale_court

- **Save as:** `assets/art/backgrounds/bg25_scale_court.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Small quiet stone weighing courtyard in an old Arab market, side view, broad continuous dry path along the foreground, warm gold sandstone and pale teal awning. Leave a clear empty low plinth at middle for a separately drawn moveable beam balance, two empty benches either side. No scales painted in, no people, animals, labels or text.

## market_baker_sheet

- **Save as:** `assets/art/characters/market_baker/market_baker_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Kind elderly Arab baker, short grey beard, rust red waistcoat, beige shirt, cream apron and simple wrapped cap. Three separated front, right profile and rear views on warm cream, two hands and two feet per view, no bakery scene or writing.

## market_baker_base

- **Save as:** `assets/art/characters/market_baker/market_baker_base.png`
- **Attach:** `assets/art/characters/market_baker/market_baker_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One standing old Arab baker from the reference with matching face, apron and cap, holding one round flatbread at waist. Three-quarter facing left, two arms and two feet. Isolated transparent game sprite.

## market_cat_sheet

- **Save as:** `assets/art/characters/market_cat/market_cat_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Friendly small grey and white old-market cat with four paws, one tail and two green eyes. Front, right side and rear separated views on warm cream. Distinct darker grey ears and white face, no accessories, no props, no text.

## market_cat_base

- **Save as:** `assets/art/characters/market_cat/market_cat_base.png`
- **Attach:** `assets/art/characters/market_cat/market_cat_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One small grey and white market cat from attached sheet with four paws and one visible tail, standing three-quarter facing left. Friendly green eyes. Fully transparent and no floor, scenery or text.

## bg26_snow_edge

- **Save as:** `assets/art/backgrounds/bg26_snow_edge.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Bright winter forest edge in a gentle storybook style. Broad dry compacted snow path across lower third, safe flat footing, soft snowbanks, sparse spruce and sunny pale-blue sky. A small low wooden bird shelter with an empty tray at centre-right. Leave space for a small goldfinch near left. No characters, text, falling snow or dark storm.

## bg27_snow_tracks

- **Save as:** `assets/art/backgrounds/bg27_snow_tracks.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Side-view snowy woodland path, warm soft winter daylight, rounded pines and low pale-blue snow banks. Broad flat uninterrupted walkable lower third, snow floor clear of any footprints so separate tracks can be composited. Open space for a rabbit at left and fox at right. No characters or text.

## bg28_sled_hill

- **Save as:** `assets/art/backgrounds/bg28_sled_hill.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Gentle safe snowy hill with broad smooth diagonal sled trail from middle-left high ground to low right, open flat walkable snow strip along lower third, rounded snowy pines, warm late afternoon sunshine. At far right a dry tree shelter and room for a little deer. No people, animals, board, writing or hazards.

## goldfinch_sheet

- **Save as:** `assets/art/characters/goldfinch/goldfinch_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Three separate front, right profile and rear views of a friendly small European goldfinch. Red face patch, black and white head, warm brown body, distinctive yellow wing bars, two tiny feet and one short tail. Warm cream background and no scene or writing.

## goldfinch_base

- **Save as:** `assets/art/characters/goldfinch/goldfinch_base.png`
- **Attach:** `assets/art/characters/goldfinch/goldfinch_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Single friendly small goldfinch from the reference, three-quarter facing left. Red face patch and black and white head, yellow wing bars, two small feet, no extra appendages, isolated transparent, no ground or shadow.

## snow_deer_sheet

- **Save as:** `assets/art/characters/snow_deer/snow_deer_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Turnaround sheet of a small young red deer fawn with soft chestnut fur, white spots along back, tall ears, no antlers, four slender legs and small hooves, one short tail. Three separate front, right profile and rear views. Warm cream, no scene, accessories or text.

## snow_deer_base

- **Save as:** `assets/art/characters/snow_deer/snow_deer_base.png`
- **Attach:** `assets/art/characters/snow_deer/snow_deer_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One gentle young red deer fawn from the reference sheet, chestnut fur with white spots, four slender legs with hooves, small tail, tall ears, no antlers. Three-quarter facing left, isolated fully transparent with no scene or ground.

## arnoob_winter

- **Save as:** `assets/art/characters/arnoob/arnoob_winter.png`
- **Attach:** `assets/art/characters/arnoob/arnoob_base.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Arnoob in his white winter coat. Keep the exact pose, eyes, pink nose, teal vest, gold buttons and outlines of arnoob_base. Change only orange fur to warm ivory and white. Fully transparent.

## bg29_giant_bloom

- **Save as:** `assets/art/backgrounds/bg29_giant_bloom.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Tiny creature perspective under an enormous pink wildflower in sunny meadow. Side-view game background, broad walkable dry soil path across lower third, enormous green stems and softly textured yellow pollen, large pebbles at sides. Leave clear centre for one oversized seed and an ant. No characters, writing or scene labels.

## bg30_dew_bank

- **Save as:** `assets/art/backgrounds/bg30_dew_bank.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Tiny insect view of a huge round dew drop like a lake between two low dry banks, enormous blades of grass and flower stems behind it. Clear safe soil foreground across lower third, empty water surface for a separate floating leaf sprite. Soft blue, sage, gold. Side view, no characters, no writing or letters.

## bg31_ant_city

- **Save as:** `assets/art/backgrounds/bg31_ant_city.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Cozy tiny ant kingdom in cross section, warm ochre rounded underground chambers behind a wide dry floor. Three empty storage niches, a visible safe tunnel opening on right and a small window onto grass at upper left. Warm lantern-like light but no scary shadows, no characters, no seeds or writing.

## ant_worker_sheet

- **Save as:** `assets/art/characters/ant_worker/ant_worker_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Two separated three-quarter and dorsal views of a friendly small amber ant worker, head, thorax and abdomen, two short antennae, two eyes, exactly six legs (three per side), all attached to thorax, no other arms or legs. Plain warm cream turnaround, no accessories.

## ant_worker_base

- **Save as:** `assets/art/characters/ant_worker/ant_worker_base.png`
- **Attach:** `assets/art/characters/ant_worker/ant_worker_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One friendly amber ant worker from the sheet, three-quarter top view, exactly six visible legs with three per side attached only to thorax, two antennae, two eyes, three body sections. Transparent, no scene or shadow.

## ant_queen_sheet

- **Save as:** `assets/art/characters/ant_queen/ant_queen_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Friendly rounded violet ant queen with amber highlights, three body sections and exactly six visible legs with three per side attached to thorax, two antennae and two eyes, longer abdomen. One small leaf tiara above eyes. Two separated three-quarter and dorsal views on warm cream, no other limbs.

## ant_queen_base

- **Save as:** `assets/art/characters/ant_queen/ant_queen_base.png`
- **Attach:** `assets/art/characters/ant_queen/ant_queen_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One friendly violet and amber ant queen from reference, leaf tiara, exactly six legs, two antennae, two eyes, three body sections. Top three-quarter view with all legs separate. Isolated transparent, no other props.

## ant_beetle_sheet

- **Save as:** `assets/art/characters/ant_beetle/ant_beetle_sheet.png`
- **Attach:** `assets/art/backgrounds/bg1_room.png`
- **Background:** Opaque

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

Kind small teal and bronze guard beetle, round wing cases with centre seam, six visible legs with three on each side, two short antennae, large warm eyes, no weapons or clothing. Two separated three-quarter and top views, plain warm cream.

## ant_beetle_base

- **Save as:** `assets/art/characters/ant_beetle/ant_beetle_base.png`
- **Attach:** `assets/art/characters/ant_beetle/ant_beetle_sheet.png`
- **Background:** Transparent

STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark.

One friendly teal and bronze beetle matching the turnaround, exact six distinct legs with three per side, two antennae, big warm eyes. Isolated fully transparent, no scenery, props, shadow or writing.

## bg32_owl_perch

- **Save as:** `assets/art/backgrounds/bg32_owl_perch.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Welcoming dry mountain foothill at night, side-on game scene. Broad flat dry path in lower third, soft blue mountains and stars in open sky, one low oak branch at left and a broad safe ledge at right. Leave foreground open for separate owl and bat sprites. Calm with moonlight, no characters, writing or steep hazard.

## bg33_observatory_dome

- **Save as:** `assets/art/backgrounds/bg33_observatory_dome.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Inside a cosy old stone observatory with a brass telescope to the left and a wide dome opening onto a clear blue starry sky above centre. Broad dry flat wooden floor across lower third, empty right desk and open dark area above centre for separate interactive stars. Warm lantern glow and deep blue sky. No people, symbols, star lines or writing.

## bg34_star_ridge

- **Save as:** `assets/art/backgrounds/bg34_star_ridge.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Night mountain valley with a broad, continuous safe dry foreground trail and three low stone marker places, distant blue hills and soft stars, inviting shelter with warm window on the far right. No cliffs on walking ground, no characters, writing or text.

## observatory_owl_sheet

- **Save as:** `assets/art/characters/observatory_owl/observatory_owl_sheet.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Friendly tawny brown owl with cream breast, large round amber eyes, small ear tufts, two feet, two wings and one tail. Three separated front, right side and rear views on cream. No props, scenery or writing.

## observatory_owl_base

- **Save as:** `assets/art/characters/observatory_owl/observatory_owl_base.png`
- **Reference:** `assets/art/characters/observatory_owl/observatory_owl_sheet.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Single friendly tawny owl from the reference, three-quarter facing left, two feet, two wings and amber eyes, wings relaxed. Isolated transparent, no branch or ground.

## observatory_bat_sheet

- **Save as:** `assets/art/characters/observatory_bat/observatory_bat_sheet.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Friendly small lavender bat, two curved wings, two ears, small pair of feet, two eyes, no sharp teeth. Two separated front and side views, warm cream, no scene or lettering.

## observatory_bat_base

- **Save as:** `assets/art/characters/observatory_bat/observatory_bat_base.png`
- **Reference:** `assets/art/characters/observatory_bat/observatory_bat_sheet.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Single friendly lavender bat matching attached reference, two wings extended, two small feet, two ears, kind eyes, no sharp teeth, no props or scenery. Fully transparent.

## astronomer_sheet

- **Save as:** `assets/art/characters/astronomer/astronomer_sheet.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Kind elderly Arab astronomer distinct from Grandpa Sulaiman, round glasses, grey beard, indigo robe over beige shirt and tan wrapped cap. Front, right profile and rear on cream, no writing or objects.

## astronomer_base

- **Save as:** `assets/art/characters/astronomer/astronomer_base.png`
- **Reference:** `assets/art/characters/astronomer/astronomer_sheet.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One standing kind elderly astronomer matching attached reference, indigo robe, round glasses, grey beard and tan cap. Three-quarter facing left, two hands and two feet, fully transparent background, no scenery.

## bg35_tree_day

- **Save as:** `assets/art/backgrounds/bg35_tree_day.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Landscape 16:9 Arab valley garden on a bright spring morning. Painted fence on left, an earthen planting bed at centre-right with a single small slightly drooped young sapling, terracotta water pitcher at far right, yellow flowers and stones around the edges, large calm ground lane across the bottom third for a walking character. No people, animals, signs, text or labels. Match the warm parchment, honey-gold, teal and soft olive palette of the attached room.

## bg36_mother_garden

- **Save as:** `assets/art/backgrounds/bg36_mother_garden.png`
- **Reference:** `assets/art/backgrounds/bg1_room.png`
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Opaque 16:9 sunny Arab courtyard with a low wooden craft table centre-left, blank cream folded card on the tabletop, wicker basket of pink and yellow flowers on the right, warm sandstone walls and teal wooden window, terracotta flower pots, broad clear walking area across the bottom third. No people, animals, words, letters or symbols on the card. Match warm parchment, honey gold, teal and soft olive palette of the attached room.

## ankoob_body

- **Save as:** `assets/art/characters/ankoob/ankoob_body.png`
- **Reference:** assets/art/characters/ankoob/ankoob_sheet.png
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. Round abdomen above a friendly head, dorsal view, no legs, true transparent canvas.

## ankoob_leg

- **Save as:** `assets/art/characters/ankoob/ankoob_leg.png`
- **Reference:** None on retry
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One bent chestnut spider leg with attachment on the left and tip on the right, transparent canvas.

## dew_leaf_bridge

- **Save as:** `assets/art/items/dew_leaf_bridge.png`
- **Reference:** `assets/art/backgrounds/bg30_dew_bank.png`
- **Use:** the LeafBridge prop in DewBank (ants pack), drawn about 520x120 px; it floats tilted on the dew drop, then lies flat as a bridge. Replaces the placeholder `game/scripts/ants/leaf_bridge.svg` (docs/BUGS.md #10).
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One long flat fresh green leaf seen from the side, lying horizontally like a small boat or bridge, gentle upturned tip on the right, stem on the left, soft sage and spring green with a visible central vein. Wide and flat, about four times longer than tall. Isolated on real transparent background, no water, ground, insects or shadow.

## pass_tail_rock

- **Save as:** `assets/art/items/pass_tail_rock.png`
- **Reference:** `assets/art/backgrounds/bg15_narrow_pass.png`
- **Use:** the LooseStone prop in NarrowPass, drawn about 180x120 px in front of Thaaloob so it covers the lower part of his tail and pins it (his white tail tip stays visible above it). When Reem frees him it rolls away to the right. Replaces the placeholder (the small `pass_loose_stone.png` scaled up) in `game/rooms/narrow_pass/room_narrow_pass.tscn` (docs/BUGS.md #5).
- **Prompt:** STYLE: Warm hand-painted 2D children's storybook adventure, rounded forms, brown ink outlines, soft textured paint. No writing, frame or watermark. One medium rounded sandstone rock in the same warm pink-ochre colours, soft shading and brown ink outlines as the boulders in the attached Narrow Pass background, a few small cracks and a little tuft of dry grass at its base. Rounded, slightly wider than tall, sturdy enough to pin a fox's tail but clearly able to roll. Side view, isolated on real transparent background, no ground, shadow, animals or other rocks.

## bg4_fork_shortcut

- **Reference:** `assets/art/backgrounds/bg4_fork.png`
- **Prompt:** Edit the original locally. Keep the trees, hills, sky, blank sign, foreground flowers and palette. Remove the northbound road and replace it with matching plants. Use bg5_tree_bees as the destination reference. A distant Big Tree and two hives sit on the upper right hill. The wide road dips low and winds far right before curling back to the tree. A straight worn-grass shortcut starts beside the blank sign and heads directly to the tree. Place tiny pink, yellow and white wildflowers on and along it. No separate flower patch, stones or text.

## bg4_fork_wildflowers

- **Reference:** `assets/art/backgrounds/bg4_fork_shortcut.png`
- **Prompt:** Preserve the composition and style. Widen the diagonal shortcut to a third to half the main road width with broken earth, flattened grass and tufts. Scatter varied wildflowers in irregular clusters and singles across the grass, with some on the shortcut. Keep the main road clear. No text.

## bg_stream_bridge

- **Reference:** `assets/art/backgrounds/bg7_stream.png`
- **Prompt:** Edit the exact Stream art. Preserve the scene outside the stepping stones. A small flat handmade footbridge spans both banks on the stepping stones, with three parallel planks tied with rope and thin, low branch rails. Wider near the viewer, narrower at the far bank. No characters or text.

## bridge_planks

- **Reference:** `assets/art/backgrounds/bg7_stream.png`
- **Prompt:** Three small flat golden planks bundled with rope, lying flat, side view, same storybook shading. One isolated prop on transparent alpha. No ground, shadow or text.

## Reem procedural cutout — 2026-11-13

| ID | Save as | Attach | Background | Size | Prompt | Extra check | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| reem_rig_atlas | `game/characters/reem/cutout/atlas.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; atlas from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_head | `game/characters/reem/cutout/head.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; head from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_eyes_open | `game/characters/reem/cutout/eyes_open.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; eyes_open from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_eyes_closed | `game/characters/reem/cutout/eyes_closed.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; eyes_closed from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_mouth_closed | `game/characters/reem/cutout/mouth_closed.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; mouth_closed from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_mouth_open | `game/characters/reem/cutout/mouth_open.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; mouth_open from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_mouth_smile | `game/characters/reem/cutout/mouth_smile.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; mouth_smile from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_mouth_sad | `game/characters/reem/cutout/mouth_sad.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; mouth_sad from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_mouth_surprised | `game/characters/reem/cutout/mouth_surprised.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; mouth_surprised from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_torso | `game/characters/reem/cutout/torso.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; torso from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_arm_upper_back | `game/characters/reem/cutout/arm_upper_back.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; arm_upper_back from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_arm_lower_back | `game/characters/reem/cutout/arm_lower_back.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; arm_lower_back from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_hand_back | `game/characters/reem/cutout/hand_back.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; hand_back from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_arm_upper_front | `game/characters/reem/cutout/arm_upper_front.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; arm_upper_front from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_arm_lower_front | `game/characters/reem/cutout/arm_lower_front.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; arm_lower_front from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_hand_front | `game/characters/reem/cutout/hand_front.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; hand_front from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_leg_upper_back | `game/characters/reem/cutout/leg_upper_back.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; leg_upper_back from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_leg_lower_back | `game/characters/reem/cutout/leg_lower_back.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; leg_lower_back from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_foot_back | `game/characters/reem/cutout/foot_back.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; foot_back from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_leg_upper_front | `game/characters/reem/cutout/leg_upper_front.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; leg_upper_front from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_leg_lower_front | `game/characters/reem/cutout/leg_lower_front.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; leg_lower_front from shared atlas | Real alpha; reference match; overlapping joints | done |
| reem_rig_foot_front | `game/characters/reem/cutout/foot_front.png` | `assets/art/characters/reem/reem_sheet.png`, `assets/art/characters/reem/reem_base.png` | transparent | common character scale | See Reem cutout prompt below; foot_front from shared atlas | Real alpha; reference match; overlapping joints | done |

### Reem cutout prompt
STYLE: Warm hand-painted 2D children’s storybook adventure, clear dark brown outlines, soft textured brushwork, rounded friendly shapes, warm natural colours, simple readable silhouettes, matching the attached ReemGame reference. No text, letters, numbers, watermark, border or frame. Create one transparent production atlas with exactly 5 equal columns and 5 equal rows of isolated parts, each wholly within its cell, generous gaps, no visible grid. Match attached Reem sheet and current sprite exactly: right facing, cream hijab and trousers, teal long tunic, brown crossbody bag and shoes. Row-major cells: head including scarf and blank face WITHOUT eyes eyebrows or mouth; open eye with eyebrow; closed eye with eyebrow; closed neutral mouth; open speaking mouth; smile mouth; sad mouth; surprised O mouth; torso with tunic and attached bag/strap but no arms/head/legs; back upper arm; back lower arm; back hand; front upper arm; front lower arm; front hand; back upper leg; back lower leg; back foot; front upper leg; front lower leg; front foot; four empty cells. Limbs relaxed downward, rounded overlapping ends at joints. Keep head shape, face profile and clothing identical to sprite. Small facial parts proportionate to head. Atlas for skeletal cutout animation. All parts at consistent native scale where possible, with large head and torso fitting cell.

## Reem source-aligned cutouts — 2026-11-14

These are non-generative extractions of unchanged pixels from the original sprite. They replace the differently proportioned generated body pieces in the active rig; the earlier atlas and all its queue rows remain preserved. Upper/lower arms, hands, upper/lower legs and feet are separate, overlapping weighted sections in the Godot scene. Open eyes and the neutral mouth use exact source rectangles; other face variants share their anchors.

| ID | Save as | Attach | Background | Size | Prompt | Extra check | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| reem_aligned_head | `game/characters/reem/aligned/head.png` | `assets/art/characters/reem/reem_base.png` | transparent | 1254x1254 | Extract original head pixels without repainting, scaling, recolouring or moving them; preserve source coordinates | Exact source colours and alpha; shared bone weights over overlapping joints | done |
| reem_aligned_torso | `game/characters/reem/aligned/torso.png` | `assets/art/characters/reem/reem_base.png` | transparent | 1254x1254 | Extract original torso pixels without repainting, scaling, recolouring or moving them; preserve source coordinates | Exact source colours and alpha; shared bone weights over overlapping joints | done |
| reem_aligned_arm_front | `game/characters/reem/aligned/arm_front.png` | `assets/art/characters/reem/reem_base.png` | transparent | 1254x1254 | Extract original arm_front pixels without repainting, scaling, recolouring or moving them; preserve source coordinates | Exact source colours and alpha; shared bone weights over overlapping joints | done |
| reem_aligned_arm_back | `game/characters/reem/aligned/arm_back.png` | `assets/art/characters/reem/reem_base.png` | transparent | 1254x1254 | Extract original arm_back pixels without repainting, scaling, recolouring or moving them; preserve source coordinates | Exact source colours and alpha; shared bone weights over overlapping joints | done |
| reem_aligned_leg_front | `game/characters/reem/aligned/leg_front.png` | `assets/art/characters/reem/reem_base.png` | transparent | 1254x1254 | Extract original leg_front pixels without repainting, scaling, recolouring or moving them; preserve source coordinates | Exact source colours and alpha; shared bone weights over overlapping joints | done |
| reem_aligned_leg_back | `game/characters/reem/aligned/leg_back.png` | `assets/art/characters/reem/reem_base.png` | transparent | 1254x1254 | Extract original leg_back pixels without repainting, scaling, recolouring or moving them; preserve source coordinates | Exact source colours and alpha; shared bone weights over overlapping joints | done |
