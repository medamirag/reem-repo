# Claude Fable: reduced animation scope

## Scope and prepared assets

Reem is final and unchanged. FULL preparation is limited to **Grandpa** and **Thaaloob**: source-cut transparent parts, measured pivots and static Skeleton2D scenes. LIGHT characters retain their current single sprite and receive only eyes-closed, mouth-open and mouth-closed overlays plus one combined ears/tail piece when applicable. Pack animals and minor characters are **CODE ONLY**: use existing sprites, no new images or bones.

There are **107 active PNG deliverables**, down from 745 requested parts. The art queue retains **645 cancelled rows** with the exact status `cancelled: scope reduced`; seven new compact rows cover Jad/combined extras/support artwork. Do not revive them. `tools/prepare_fable_inventory.py` is now read-only and cannot recreate the old scope. `docs/rigs/character_manifest.json` is the current exact file list and tier map; cancelled queue rows are history, not missing work.

No runtime animation or character replacement was authored in preparation. New static scenes are isolated under game/rig_parts. Integrating and animating them is Fable's job.

## FULL rigs

| Character | Approved source | Static scene | Layout / bone map | Review |
| --- | --- | --- | --- | --- |
| Grandpa | `assets/cut/grandpa_bench/grandpa_seated.png` | `game/rig_parts/grandpa/static_rig.tscn` | `game/rig_parts/grandpa/layout.json` | `docs/rigs/grandpa_parts.png` |
| Thaaloob | `assets/art/characters/fox/fox_base.png` | `game/rig_parts/fox/static_rig.tscn` | `game/rig_parts/fox/layout.json` | `docs/rigs/fox_parts.png` |

These are cuts of the approved sprite, not generated redesigns. All parts use the full original canvas and original source coordinates. Source pixels remain on visible surfaces; only concealed joint/trunk areas and surfaces behind facial overlays are filled. The original eyes-open and neutral-smile crops restore the approved face. Neutral assemblies and the `full_rigs_comparison.png` sheet compare the original and reassembled source pose. The earlier generated `grandpa_head_REJECTED.png` is historical and must never be used; `game/rig_parts/grandpa/head_blank.png` is its source-cut replacement.

Grandpa's approved sprite is **seated**, with a bandaged ankle, cane, chair and footstool. Preserve that pose and injury: do not invent a standing walk. His concealed near hand is a source-derived duplicate of the visible hand and remains hidden at neutral; concealed upper thighs are overlap surfaces under the robe. The seat/stool stays outside the breathing Body bone. His static joints permit seated gestures. Thaaloob is a biped, not a four-legged fox.

**Grandpa and Jad are the same person.** This request explicitly gives Grandpa FULL scope and the existing Jad single-sprite appearance LIGHT scope, so both options are supplied from the same approved sprite. The current runtime class is `CharacterJad`. Choose either the FULL replacement or the LIGHT overlays for a given appearance; never display both rigs on one actor. Keep the saved Jad voice. Festival/costume appearances keep their existing pictures and use code-only motion until explicitly requested otherwise.

## LIGHT rigs: retain the original single sprite

Every LIGHT folder contains `eyes_closed.png`, `mouth_open.png`, `mouth_closed.png` and its `layout.json`. The manifest records the original canvas and measured feature boxes/anchors. Render overlays in the sprite's **unflipped source coordinate system**, inheriting the original scale and flip; do not position them with guessed room coordinates. For a Sprite2D child overlay with this same canvas, copy the picture's `centered`, `offset`, `flip_h` and `flip_v` properties explicitly (visual offset/flip do not automatically propagate to children), and keep the overlay's local transform at identity. Handle negative scale and flip flags once, not twice.

| Character / source key | Additional optional piece | Files |
| --- | --- | --- |
| ankoob (ankoob) | none | `game/rig_parts/ankoob/eyes_closed.png`, `game/rig_parts/ankoob/mouth_open.png`, `game/rig_parts/ankoob/mouth_closed.png` |
| arnoob (arnoob) | ears | `game/rig_parts/arnoob/eyes_closed.png`, `game/rig_parts/arnoob/mouth_open.png`, `game/rig_parts/arnoob/mouth_closed.png`, `game/rig_parts/arnoob/ears.png` |
| bees (Shahd) | none | `game/rig_parts/bees/eyes_closed.png`, `game/rig_parts/bees/mouth_open.png`, `game/rig_parts/bees/mouth_closed.png` |
| dafdoof (dafdoof) | none | `game/rig_parts/dafdoof/eyes_closed.png`, `game/rig_parts/dafdoof/mouth_open.png`, `game/rig_parts/dafdoof/mouth_closed.png` |
| dubb (dubb) | ears | `game/rig_parts/dubb/eyes_closed.png`, `game/rig_parts/dubb/mouth_open.png`, `game/rig_parts/dubb/mouth_closed.png`, `game/rig_parts/dubb/ears.png` |
| duck (duck) | tail | `game/rig_parts/duck/eyes_closed.png`, `game/rig_parts/duck/mouth_open.png`, `game/rig_parts/duck/mouth_closed.png`, `game/rig_parts/duck/tail.png` |
| ghazlana (ghazlana) | tail | `game/rig_parts/ghazlana/eyes_closed.png`, `game/rig_parts/ghazlana/mouth_open.png`, `game/rig_parts/ghazlana/mouth_closed.png`, `game/rig_parts/ghazlana/tail.png` |
| qarqoor (qarqoor) | tail | `game/rig_parts/qarqoor/eyes_closed.png`, `game/rig_parts/qarqoor/mouth_open.png`, `game/rig_parts/qarqoor/mouth_closed.png`, `game/rig_parts/qarqoor/tail.png` |
| qatqoota (qatqoota) | tail | `game/rig_parts/qatqoota/eyes_closed.png`, `game/rig_parts/qatqoota/mouth_open.png`, `game/rig_parts/qatqoota/mouth_closed.png`, `game/rig_parts/qatqoota/tail.png` |
| qunfood (qunfood) | ears | `game/rig_parts/qunfood/eyes_closed.png`, `game/rig_parts/qunfood/mouth_open.png`, `game/rig_parts/qunfood/mouth_closed.png`, `game/rig_parts/qunfood/ears.png` |
| sinjoob (sinjoob) | tail | `game/rig_parts/sinjoob/eyes_closed.png`, `game/rig_parts/sinjoob/mouth_open.png`, `game/rig_parts/sinjoob/mouth_closed.png`, `game/rig_parts/sinjoob/tail.png` |
| tawoos (tawoos) | tail | `game/rig_parts/tawoos/eyes_closed.png`, `game/rig_parts/tawoos/mouth_open.png`, `game/rig_parts/tawoos/mouth_closed.png`, `game/rig_parts/tawoos/tail.png` |
| duckling1 (duckling1) | tail | `game/rig_parts/duckling1/eyes_closed.png`, `game/rig_parts/duckling1/mouth_open.png`, `game/rig_parts/duckling1/mouth_closed.png`, `game/rig_parts/duckling1/tail.png` |
| duckling2 (duckling2) | tail | `game/rig_parts/duckling2/eyes_closed.png`, `game/rig_parts/duckling2/mouth_open.png`, `game/rig_parts/duckling2/mouth_closed.png`, `game/rig_parts/duckling2/tail.png` |
| duckling3 (duckling3) | tail | `game/rig_parts/duckling3/eyes_closed.png`, `game/rig_parts/duckling3/mouth_open.png`, `game/rig_parts/duckling3/mouth_closed.png`, `game/rig_parts/duckling3/tail.png` |
| jad (Jad single-sprite appearance of Grandpa) | none | `game/rig_parts/jad/eyes_closed.png`, `game/rig_parts/jad/mouth_open.png`, `game/rig_parts/jad/mouth_closed.png` |

Shahd uses `bees` artwork and retains her existing wing layers; do not split new wings/antennae. Ankoob retains the existing body plus existing procedural legs: its source is intentionally upside down, with the face near the bottom of the image. Do not rotate its source overlays to look upright in the file. Ducklings are separate current sprites. Qunfood's family reuses the same source where appropriate, but pack/minor appearances remain code-only. Retain every current sprite and source alpha; these are overlays, not replacement designs.

Blink overlays cover the measured eye features only. Mouth overlays cover the existing mouth feature; when a source already has an open mouth (duck/frog/spider), the open overlay is its unchanged source crop. Tail/ears are one source-cut piece, not a limb kit. **Before rotating an optional tail/ears overlay, mask its original source region on the base sprite** to avoid two copies; leave it hidden while idle until that masking exists. Duck closed-bill overlays also have `erase_runs.mouth_closed` source-pixel masks (each row is `[y, x_start, x_end_exclusive]`; the polygon is an approximate guide only) in layout.json: build that mask in memory and mask the open bill on the unchanged base before displaying its source-cut closed overlay. The exact runs preserve head feathers and the closed overlay restores the small jaw surface previously concealed by the lower bill, and restore the base for open state. The current runtime is untouched, so no duplicate tails/eyes are currently introduced.

## CODE ONLY: no new images

**ant_beetle**, **ant_queen**, **ant_worker**, **astronomer**, **goldfinch**, **gull_bird**, **gull_octopus**, **gull_turtle**, **iftar_traveller**, **market_baker**, **market_cat**, **musaharati**, **observatory_bat**, **observatory_owl**, **snow_deer**, **wooden_boat**.

Use existing sprite textures and small code-driven breathing, speaking bounce and gentle hops. Restore the original rest transform after each effect. No sprite deformation that inflates limbs, no flashing/scary motion, no new art/voice requests for these effects. Pack variants (winter Arnoob, festival Grandpa, hedgehog family etc.) keep their current art; reuse actor identity without demanding another cutout kit. Small bee workers, festival crowd instances and narrated minor prop actors use CODE ONLY even where they share a base-valley art folder. Old MISSING review templates for cancelled/code-only designs are historical inventories; the current manifest has no review-art requirement for them.

## Approved Reem template and quality rules

- Rig scene: `game/characters/reem/reem_cutout.tscn`; animation code: `game/characters/reem/reem_walk_rig.gd`.
- Pivots: `game/characters/reem/cutout_layout.json`; source builder: `tools/build_reem_cutout.py`, `tools/reem_torso_art.py`.
- Final reference: `docs/reem_walk_final/walk_game_100pct.png` and `torso_game_400pct.png`.

One intact torso, fixed original view. Rotate limbs at real joints; keep their widths constant. Full rigs require generous concealed overlap, attached hands/feet and continuous natural black contours. No stepped cuts exposed under the scarf/neck, duplicate parallel borders, white wedges or loose black dashes. Linear filtering and antialiased edges are required. Keep the far limb's depth and original scale; place room characters by their feet/Y baseline.

For Thaaloob's future walk, use exactly mirrored contact/down/passing/up poses across frames 1/5, 2/6, 3/7 and 4/8, opposing same-side arms/legs, gentle elbow bend, fixed torso view, slight delayed cloth/tail sway, body bob and eased interpolation. Cadence follows travel distance. Plant feet without sliding, use appropriate heel/toe or paw roll and lift passing feet clearly. Grandpa remains seated; LIGHT/CODE ONLY characters do not need full limb gait systems.

Preserve speech timing, stable eye/mouth anchors, original dialogue tone, inventory, room transitions and saves/Continue. Mouth closes when voice ends. Read AGENTS.md and actual Popochiu source/templates before touching runtime APIs. Do not substitute saved voices or edit Arabic data.

Check neutral assembly over a 50% original overlay, then remove the reference overlay. Inspect actual game size and 400% before committing. PNG canvases preserve source scale; scene root is the feet origin recorded in layout.json. The FULL roots use the original canvas bottom centre (Grandpa 302,982; Thaaloob 627,1254), matching the old centered Sprite2D offsets and preserving padding. Copy the old picture's complete effective transform, including negative scale and flip flags; do not shift to a guessed visible-sole point or mirror twice. **Reem's walk is final: no changes unless a defect is visible at game size.**

## Rebuild and short checks

1. `python tools/build_fable_assets.py` regenerates only active source cuts/overlays and review sheets.
2. `python tools/build_fable_skeletons.py` rebuilds the two static skeleton scenes and bone maps after the art builder.
3. `python tools/review_fable_assets.py` regenerates the composite face reviews and full-rig game-size/400% evidence.
4. `python tools/check_fable_assets.py` checks real files, nonempty alpha, source canvases, tier boundaries, neutral visible pixels and retained cancellations.
5. `python tools/check_content.py` checks queues/data. Headless `tools/check_fable_bones.gd` loads/instantiates both static skeletons; no AnimationPlayer or movement is installed.

## Remaining known issues outside this art preparation

- BUGS.md #13: inward arrival spacing in DewBank/NarrowPass is fixed and passes headless clearance, but still awaits visual confirmation. Other listed gameplay bugs are verified; do not invent a hard-open-bug list.
- Native mouse-helper targeting has a documented direct-call fallback; do not claim real-click coverage from that fallback.
- Eleven new recordings from the previous checkpoint decode successfully, but audible voice/pronunciation/pace/loudness comparison is still pending in the queues. No voices were regenerated by this reduced-scope task.
- Existing orchard negative Rect2i diagnostic and exit leaks/Aseprite warnings are documented separately. Use short focused checks; no full windowed regression unless requested.

## Next session

Integrate one FULL character at a time, starting from these static source-cut scenes; then LIGHT overlays; finally CODE ONLY effects. Take focused game-size/400% captures for changes, update the Handoff, commit and push main. Do not pull between tools. No cancelled art batch remains to be generated.
