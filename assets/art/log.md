# Art generation log

Built-in image tool; exact prompts from assets.md, with no additions or references. Opaque backgrounds (transparency method: not applicable).

| Asset | Status | Size | Notes |
| --- | --- | --- | --- |
| R1 | done | 1536x1024 | Outfit and satchel present in all views. |
| G1 | done | 1536x1024 | Kufi, vest, walking stick and right ankle bandage present. |
| F1 | done | 1536x1024 | Two arms, two legs, purple scarf; no sharp teeth. |
| BG1 | done, review | 1672x941 | Native tool output size. Empty peg; no visible text. Book stand is open instead of closed; additional basket; rug rolled instead of folded. |

Stopped after the four requested style anchors. No other assets generated.

## Full run

Existing R1, G1, F1, BG1 skipped. Prompts from assets.md unchanged on first attempts; only requested corrections appended on retries. References attached exactly as listed.

| Asset | Status | Transparency | Notes |
| --- | --- | --- | --- |
| R2 | done | native | Retry separates limbs; native 1254x1254 canvas; slight three-quarter torso. |
| R3 | done | native | 11 separated pieces; head has no eyes or mouth. |
| R4 | done, review | native | Retry corrected complete heads to isolated facial parts in one row. Check scale against R2; wide native canvas. |
| R5 | done | native | Faces right; same outfit; reaching for an acorn. Native landscape canvas. |
| G2 | done | native | Full seated pose and four separate parts; separate head blank. |
| G3 | done, review | native | Retried once; mouths retain beard surrounds; eye pairs are front-facing rather than side-view. Nine groups separated. |
| F2 | done | native | Retry corrected arms and upward tail; two arms and two legs. Native square canvas. |
| F3 | done | native | 12 separated pieces; blank head; right-facing; real alpha verified. |
| F4 | done, review | native | Retry replaced full heads with nine feature groups. Mouths retain muzzle surrounds; check scale. Native wide canvas. |
| B1 | done, review | native | Retry corrected six legs and four wings per bee. Flower present; detached wing sets. Worried mouth appears missing. |
| I1 | done, review | native | Retry made mirrors rounder; still slightly oval. Matching pair with one crack. |
| I2 | done, review | native | Retry shortened handle; mirror still slightly oval. Empty basket and clear gap. |
| I3 | done | native | Notebook tied with string, green leaf; brass lantern with flame and ring. Separate, no text. |
| I4 | done | native | Green watering can, clay honey jar with cloth, string and honey drip; separated. |
| I5 | done | native | Matching pebble forms; honey with two sparkles; wiped grey state. |
| W1 | done | native | Three matching patch layouts; buds, open blooms, bent stems with footprint. |
| BG2 | done | native (opaque) | Empty area under olive tree, no bench or animals; horizontal path. |
| BG3 | done | native (opaque) | Open gate left; blank right-pointing sign; clear horizontal path. |
| BG4 | done | native (opaque) | Upward path branch, open grass middle-right, blank sign; no butterflies. |
| BG5 | done | native (opaque) | Clear left shadow versus right sunlight; three hive boxes; open ground. |
| BG6 | done | native (opaque) | Flat-topped central rock, berries left, stream visible far right. |
| FG1 | done | native | Plant and cushion only at bottom corners; rest transparent. Intended content occupies bottom corners. |
| FG2 | done | native | Bottom-edge plants, grass and flowers only; rest transparent. |
| FG3 | done | native | Bottom-edge foliage only; rest transparent. |
| FG4 | done | native | Bottom-edge foliage only; rest transparent. |
| FG5 | done | native | Bottom-edge foliage only; rest transparent. |
| FG6 | done | native | Bottom-edge foliage only; rest transparent. |
| U1 | done | native | Six empty slots; separate basket and notebook buttons; no text. |
| U2 | done | native | Four blank separate pieces: parchment, face rim, green and sand buttons. |
| U3 | done, review | native | Retried once; first retained for correct blossom counts. Sixth trunk differs; glow encroaches on fifth and reaches edges. |
| U4 | done | native | Five separated icons; five-finger open hand; right arrow; three bubble dots. Native wide canvas. |
| U5 | done | native (opaque) | Large empty upper sky; farmhouse, sunrise and distant hanging lanterns; no text. |
| U6 | done | native (opaque) | Stream, stepping stones, oak forest, cave and foreground lantern; no characters or text. |

## Final validation

All 37 assets present. Existing files skipped. Built-in image generation used; prompts copied verbatim for initial attempts and only named corrections appended for retries. Only listed references attached. All transparent assets have native real alpha; key_out was not needed.

The built-in tool exposes no size parameter; native generated dimensions are preserved without stretching or cropping. Size warnings remain for the following assets:

| Asset | Saved dimensions | Requested |
| --- | --- | --- |
| R2 | 1254x1254 | 1024x1024 |
| R4 | 2172x724 | 1536x1024 |
| R5 | 1536x1024 | 1024x1024 |
| G3 | 2172x724 | 1536x1024 |
| F2 | 1254x1254 | 1024x1024 |
| F4 | 2172x724 | 1536x1024 |
| B1 | 1774x887 | 1536x1024 |
| I1 | 1774x887 | 1536x1024 |
| I2 | 1774x887 | 1536x1024 |
| I3 | 1774x887 | 1536x1024 |
| I4 | 1774x887 | 1536x1024 |
| I5 | 1983x793 | 1536x1024 |
| W1 | 2172x724 | 1536x1024 |
| BG1 | 1672x941 | 1536x1024 |
| BG2 | 1672x941 | 1536x1024 |
| BG3 | 1672x941 | 1536x1024 |
| BG4 | 1672x941 | 1536x1024 |
| BG5 | 1672x941 | 1536x1024 |
| BG6 | 1672x941 | 1536x1024 |
| FG1 | 1671x941 | 1536x1024 |
| FG2 | 1672x941 | 1536x1024 |
| FG3 | 1671x941 | 1536x1024 |
| FG4 | 1672x941 | 1536x1024 |
| FG5 | 1672x941 | 1536x1024 |
| FG6 | 1671x941 | 1536x1024 |
| U1 | 2172x724 | 1536x1024 |
| U2 | 1774x887 | 1536x1024 |
| U3 | 2172x724 | 1536x1024 |
| U4 | 2172x724 | 1024x1024 |
| U5 | 1672x941 | 1536x1024 |
| U6 | 1672x941 | 1536x1024 |

Alpha verification: all 26 transparent PNGs contain alpha values spanning transparent and visible pixels. FG1-FG6 upper-half alpha range is 0-1 (invisible); opaque bottom corners are intended foreground content. check_art.py reports these as corner warnings because it assumes every corner must be empty. These are not solid backgrounds or missing alpha; retained artwork as specified rather than erasing corner plants/cushion.

Review priorities: R4 and G3 (existing facial sheets/scale); F4 (muzzle surrounds and scale); B1 (missing worried mouth); I1 and I2 (slightly oval mirrors); U3 (sixth trunk differs and glow overlaps/reaches edges); BG1 (existing open stand, rolled rug, extra basket). Also review native canvas sizes for game integration.

Completed generation through U6. No usage limit encountered. check_art.py run twice; final output saved to art/check_art_final.txt.

## Requested fixes - 2026-11-03

These entries supersede the earlier BG1 basket and G3 paired-eye findings. Built-in image tool used.

| Asset | Status | Transparency | Notes |
| --- | --- | --- | --- |
| BG1 | done, review | native (opaque) | Edited existing room using only BG1 as edit reference. Removed bottom-left floor basket and filled with matching wall and terracotta tiles. Other scene objects visually preserved. Native size remains 1672x941. Pixel-for-pixel identity outside the removal area is not guaranteed by the generative edit; review for subtle drift. Rolled rug and open stand intentionally retained as requested. Saved over original path. |
| G3 | done, review | native | Deleted previous file and regenerated from exact assets.md prompt plus requested single-eye correction, attaching only G1 and G2. Nine separated groups in one row: five bearded mouths and four single right-facing eye/eyebrow groups; no eye pairs, text or frame. Real RGBA alpha range 0-255 verified. Mouth groups remain broadly frontal; check placement/scale against G2. Native size 2172x724. |

Ran tools/check_art.py with installed Python runtime. All 37 assets found; no missing files or missing-alpha reports. Existing native-size warnings and intended FG1-FG6 opaque-bottom-corner warnings remain. Updated art/check_art_final.txt and art/review.html.

BG1 edit prompt: Remove only the woven wicker basket standing on the floor at the bottom-left, including its handles and shadow; seamlessly continue the same cream wall, wall-floor boundary and terracotta tiled floor; keep all other content, framing and lighting identical; opaque output, no text or frame.
G3 prompt: assets.md G3 verbatim, with correction requiring four single right-facing profile eyes/eyelids with one white eyebrow each, matching grandpa_bench.png; no eye pairs; five mouths and four eye groups in one row.
