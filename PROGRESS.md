# PROGRESS - ReemGame

## Handoff


- **Who worked last:** Codex (builder), Reem eight-pose walk refinement.
- **Date / branch:** 2026-11-14 / main.
- **User confirmed:** Reem's face is now correct. Preserve it. No work on other characters until Reem is approved.
- **Done:** Replaced the old sinusoidal flat-foot gait with eight keyed contact/down/passing/up poses (each leg), sine Tween interpolation, opposing relaxed shoulder arcs and slight elbow bending. Cadence follows actual character travel, so the existing movement speed is preserved. Upper body dips on contact/down, rises on passing/up and has a tiny forward lean.
- **Feet / trousers:** Heel, flat-sole and toe contact compensate ankle position while the actor moves. Swing feet tilt toe-down, lift smoothly and return continuously to heel contact. Walking hips/ankles converge to a side-view stance so feet actually pass each other. Hidden hip corrections keep targets reachable and knee flexion within 35 degrees, without scaling/inflating the legs. Hands, cuffs and ankles retain continuous shared skinning.
- **Tunic / seams:** Torso stays stable; a separate Hem bone adds a delayed small sway and roughly 10 source pixels of extra overlap while walking. It returns to exact rest size at idle. Tunic renders ahead of trousers. Source-colour ownership follows the curved hem, with separate hidden trouser caps. Removed duplicated coat/scarf outline fragments from the moving limb layers. All original assets and facial shader/features remain unchanged.
- **Files:** `game/characters/reem/reem_walk_rig.gd`, `reem_cutout.tscn`, `aligned/*.png`; deterministic rebuild in `tools/build_reem_cutout.py`. Inspector stride range/default is now 60–90 native pixels; rig clamps legacy room overrides to 90. Existing art queue rows remain done, with a refinement note.
- **Review evidence:** `docs/reem_walk/eight_poses.png` contains eight actual Godot captures, not retouched drawings. `legs_closeups.png` shows all knees/feet enlarged. Neutral side-by-side, source-size captures and talking/blinking captures are included. Several early renders exposed cloth distortion and original-edge fragments; those were corrected before the final sheet. Rebuild instructions are in its README.
- **Checks:** Final isolated fixture passed neutral source registration, all facial anchors, overlay removal, opposing arms on all eight poses, forward knees, maximum 35-degree flexion, gentle shoe angles, front/back order, flat stance planting and heel/toe roll planting. Pixel check: zero missing/protruding neutral pixels, zero solid-source differences above 12/255, max 3/255 GPU rounding. Approved neutral/talking/blinking face crops compare identically with the previous captures. Content and focused headless `reem_animation` passed through DONE (speech, blink, expressions, room reuse, inventory and Continue). Usual exit leaks and existing Aseprite/UID warnings only. Logs: `.godot/walk-visual-final.log`, `walk-import-final.log`, `walk-integration-final.log`.
- **How to check:** Open the eight-pose image first. Reopen Godot, open `game/rooms/yard/room_yard.tscn`, press F6 and click along the path. Only the isolated Reem preview was opened during this turn; no full windowed route tests or desktop mouse actions.
- **What is next:** User review of Reem's updated walk. Only after approval, apply the same approach to Grandpa, Thaaloob and the animals.
- **Half-finished:** None for this walk correction. Earlier unrelated native mouse-helper limitations remain documented below.
- **Backup:** Commit and push this refinement to origin/main; the final response records the resulting commit.

### Previous handoff (Reem source alignment)

- **Who worked last:** Codex (builder), Reem cutout alignment correction.
- **Date:** 2026-11-14
- **Branch:** main
- **Done:** Reem now uses the editable `game/characters/reem/reem_cutout.tscn`, instantiated by character_reem.gd. Its neutral pose uses untouched pixels from reem_base.png, extracted to six transparent layers under `game/characters/reem/aligned/`. Original assets and previous generated pieces remain unchanged. The six derived layers are recorded done in the art queue.
- **Body/joints:** Source-pixel pivots in `cutout_layout.json` locate shoulders, elbows, cuff wrists, hips hidden inside the tunic, knees and ankles. Upper/lower arm, hand, upper/lower leg and foot sections overlap and share continuous Skeleton2D skin weights. The scarf/sleeve borders share motion too. Near-side limbs render after far-side limbs. The original standing silhouette, clothing, bag, skin and face are restored.
- **Face:** Measured original eye bounds (686..750, 199..276) and mouth bounds (736..772, 316..333) replaced the old guessed rectangles. Eye anchor is (718.5,238.5); all mouth variants share (754,324). The neutral eye/mouth are exact source crops. The existing other mouths and a native closed eyelid use those anchors; a shader blanks only baked features beneath them. No left-behind mouth tail, iris strip or dark blink rectangle remains.
- **Walking:** Measured leg lengths replace the former arbitrary 110px bones. Forward-bending two-bone solving and ankle counter-rotation keep soles level, with distance-driven planting. Effective stride is capped at 120 native pixels; small hip lowering keeps all targets within reach. Hands and cuffs remain connected through shared weights.
- **Overlay:** Alignment fixture temporarily added the original at exactly 50% opacity and the same source scale/origin. It removed it before final captures, with an explicit no-overlay assertion. The shipping cutout scene contains no reference overlay; the character's original hidden Sprite2D remains only for Popochiu scale/facing compatibility.
- **Evidence inspected:** `docs/reem_alignment/neutral_side_by_side.png`, `face_closeups.png`, `walk_four_frames.png`, four individual walk images and the temporary `overlay_50.png`. Actual Godot renders were inspected at native size and enlarged. Early rigid-joint seams, an incomplete feature mask and screenshot framing were corrected before the final captures. Review README explains the captures and rebuild steps.
- **Quantitative checks:** `tools/check_reem_cutout.py` verifies the source layers preserve original alpha at every pixel. Final rendered neutral: zero missing/protruding visible pixels, zero solid-source colour differences above 12/255, maximum channel difference 4/255 (render rounding). The alignment fixture also passed source registration, all five mouth anchors, the eye anchor, temporary-overlay removal, forward knees, level soles, front/back order and planted-foot root travel.
- **Integration checks:** Content, clean final import, startup and focused headless `--playtest --path=reem_animation` passed (blink, talking end/start, three tones, room reuse, inventory and Continue restoring position). Usual exit leaks and existing Aseprite/UID import warnings only. Logs: .godot/align-visual-final.log, align-import-final.log, align-game-integration.log and align-startup.log. No full route runs or other character changes.
- **Rebuild:** Run `tools/build_reem_cutout.py` with Pillow after changing source-pixel pivots/masks in cutout_layout.json. It deterministically re-extracts original pixels and builds scene grids/weights. The scene is directly inspectable in Godot. `tools/reem_alignment_review.gd` is an isolated renderer/checker; it does not advance a story save.
- **How to check:** Open the linked review images first. Reopen Godot, open `game/rooms/yard/room_yard.tscn` and press F6; click the path to walk, wait for a blink and click Grandpa for speech. To inspect the rig, open reem_cutout.tscn and expand Skeleton2D/Body and the named mesh sections.
- **What is next:** Wait for the user's visual approval of Reem. Only then apply the same approach to Grandpa, Thaaloob and the animals.
- **Half-finished:** None in this alignment change. The inherited native mouse-helper targeting issue is unrelated and remains in earlier Handoffs.
- **Backup:** Commit and push this alignment fix on main; final response records the resulting commit.

### Previous handoff (mirror UI fixes)


- **Who worked last:** Codex (builder), GrandpaRoom mirror UI bugs #19–21.
- **Date:** 2026-11-14
- **Branch:** main
- **Done:** Logged and fixed the three reported bugs in docs/BUGS.md. All character speech, offscreen narration and system dialogue now share `game/gui/components/dialog_text/subtitle_bar.gd`: cream rounded panel at the viewport bottom, bold dark-brown Cairo, full connected RTL text, smart wrapping and content-driven height. A small Arabic speaker name appears when available. No typewriter truncation or overhead text remains.
- **Cursor:** `game/gui/gui.gd::_use_normal_pointer` hides both the software Cursor layer and the GUI cursor-template sprite, uses the native visible arrow, and updates the old cursor coordinates for Popochiu APIs. Blocked dialogue, choice and inventory cursor changes cannot reveal an hourglass.
- **Mirror spacing/depth:** Mirror inspection and basket pickup stop Reem at x=570 (basket offset -230). `prop_mirror.gd::show_fallen` moves the sorting origin to the bottom of the frame while keeping its painted position unchanged. Room/Props/Characters retain Popochiu Y sorting; foreground art retains its explicit front layer.
- **Evidence:** `docs/bugs/grandpa_mirror_subtitles_fixed.png` shows the reported full line in the bar and no hourglass. `grandpa_mirror_spacing_fixed.png` shows Reem's feet clear of the fallen frame. The original line's trailing ellipsis belongs to lines.json and was preserved.
- **Checks:** Content check, import and focused headless `--playtest --path=mirror_ui` passed: mirror approach, basket/choice flags, bottom baseline, full bold RTL subtitles, wrapping, shared narration, blocked/wait cursor, and longest dialogue at 44/56 pixels. Only GrandpaRoom was visually tested, with no full routes. Logs: .godot/mirror-headless-final.log and mirror-window.log; usual exit leaks and existing import warnings remain.
- **Windowed limitation:** The known mouse helper targeting issue recurred ('under nothing', choice over ChoicePopup); it used its direct-call fallback. Screenshots and scene assertions passed, but native clicks are not claimed as verified. Test window closed normally.
- **Existing editor change:** Preserved Godot's saved default Reem sliders in the Arabic preview scene first, in commit 166d47e.
- **How to check:** Reopen Godot, double-click `game/rooms/grandpa_room/room_grandpa_room.tscn` in FileSystem, press F6. Click the wall mirror, then the hanging basket. Reem should stay left of the fallen frame; every line should be in the cream bottom bar and the arrow should follow the mouse. Choose either story option normally.
- **What is next:** Reem animation/art still awaits the user's approval before Grandpa, Thaaloob or animal animation work. The inherited native mouse test-helper issue remains a separate follow-up.
- **Half-finished:** No unfinished fix code; native mouse targeting remains unverified as above.
- **Backup:** Commit this mirror-scene fix on main and push to origin/main; final response records the resulting commit.

### Previous handoff (Reem animation)


- **Who worked last:** Codex (builder), Reem procedural cutout animation.
- **Date:** 2026-11-14 (work began 2026-11-13)
- **Branch:** main
- **Done:** Generated a transparent atlas against both existing Reem references, extracted 21 separate textures under `game/characters/reem/cutout/`, and marked all new art queue rows done. Originals under assets were untouched. Reem now always shows the same Skeleton2D/Bone2D rig: eased distance-driven walking with two-bone planted-foot solving, eased start/stop, small bob, breathing, random 2–5 second blink, voice-timed mouth, tone-based happy/sad/surprised expressions, and greeting wave. Existing hidden Sprite2D remains the size/facing reference for Popochiu. Pickup and reach use the visible skeleton.
- **Effects:** `game/scripts/reem_effects.gd` adds CPU petals at the heart-tree blossom, sparkles on inventory/good deeds/new notebook cards, and watering drops at MeadowFork and TreeDay. `reem_parallax.gd` adds three restrained depth masks in Yard and Stream only, including Stream's built-bridge texture.
- **Controls:** CharacterReem Inspector exports Use Walk Rig, Walk Stride, Walk Bob and Idle Breathing. Bone names and all texture paths are in `reem_walk_rig.gd`. Re-extract the shared atlas with `tools/extract_reem_cutout.py` (Pillow); alpha bounds ignore faint fringe pixels and two cell boundaries have explicit crop offsets.
- **Review:** `docs/reem_animation/review.png`, four full Yard PNGs, and `walking.gif`. Blink image is a natural closed-eye frame during the wave; the first requested blink had reopened by render time. GIF uses twelve captured walking frames.
- **Checks:** Content consistency passed. Clean headless import passed apart from permitted exit leaks/Aseprite messages and existing UID warnings. Focused headless `--playtest --path=reem_animation` passed blink, mouth start/end, all expressions, rig reuse Yard→Stream, inventory and Continue restoring position and the visible rig. No full route runs. Final logs are in .godot/reem-*.log.
- **Windowed limitation:** Yard screenshots were inspected and exposed/fixed alpha-padding gaps and two atlas-cell overlaps. Automated native mouse targeting returned 'under nothing'; its direct-call fallback is not counted as a real click. Desktop Computer Use then reported 'Computer Use app approval timed out'. Final Yard window closed after its manual-click timeout. **Two native clicks remain unverified**, despite passing headless interactions/save checks. No other playable room was opened in a window.
- **How to check:** Reopen Godot. In FileSystem, open `game/rooms/yard/room_yard.tscn` and press F6. Click the path to walk; wait for a blink; click Grandpa to talk and the well to collect the can. Review the GIF and expression screenshots first. No changes to Arabic line text or voices.
- **What is next:** Wait for the user's approval of Reem's appearance and motion. Only after approval, apply the same approach to Grandpa, Thaaloob and then the animals. Existing voice work remains pending separately.
- **Half-finished:** Native two-click check is pending due to desktop approval timeout; no half-built game code. Visual approval of generated art and joint outlines remains pending.
- **Backup:** Commit and push this Reem feature on main; see this session's final response for the result.

### Previous handoff (2026-11-08)


- **Who worked last:** Codex (builder), installing the two queued artwork replacements.
- **Date:** 2026-11-08
- **Branch:** main
- **Notebook map:** Open the notebook and click the Map tab. It opens the shared illustrated map without labels. Click a place marker to see its name on parchment. Notebook tabs and word controls use dark brown Cairo text. The focused two-click screenshot check passed. See BUGS.md #18 for evidence.
- **Stream bridge:** Two new originals are installed and marked done. The old log scene ID now picks up the planks. Click the stones to build and watch all three ducklings cross and gather with the mother. The old dialogue IDs, bridge flag, feather, duck card and blossom are preserved. The windowed check opened Stream directly and passed both clicks, with three screenshots in docs/bugs. The Stream entry and map button have extra clearance. The plank word is added as text and its recording is queued.
- **Flower Meadow:** The new bg4_fork_wildflowers background keeps the previous versions and shows a winding road to the distant Big Tree and a wider, straight, patchy shortcut with scattered wildflowers. Both route clicks lead to BigTree, with the original lines, wilt and repair flags. The sign text is centred. The focused two-click windowed check passed. See BUGS.md #16 and the before and after screenshots. The shortcut word is available as text and its recording is queued.
- **Meadow check:** From Gate, go right to MeadowFork. Click the broad road or right arrow for a blossom, or the worn diagonal trail for a wilt. After Shahd asks for repair, return with the watering can and click the trail.
- **Gate fix:** Moved the Stream arrow, label and click area onto the dirt path. The Market exit moved to foreground sand to keep the exits separate after unlock. The help button has a solid background. The user’s before screenshot is in docs/bugs and BUGS.md lists issues #14 and #15. The after screenshot confirms the arrow is on sand and the help text is readable. The real-click test entered Stream. Remaining route checks are in .godot/gatefix-*.log.
- **Real-player playtests:** `tools/playtest.gd` has a `--real` mode (run without `--headless`, see AGENTS.md "Real-player mode"): a 1920x1080 window, real mouse moves and clicks (including the inventory bar, choices and the notebook's ×), a screenshot after every step and spoken line in `tests/screenshots/<path>/` (git-ignored), and layout checks on each. The fast headless mode is unchanged. New path `notebook_clicks`.
- **Bugs:** `docs/BUGS.md` lists the 8 problems found in the `green` screenshots, all fixed and verified by a second real run: outlined dialogue text and Grandpa's speech point; the map, notebook and settings buttons moved below the inventory bar (y 132); readable choice boards; the lake reunion moved off the boat; Thaaloob at his real size at Narrow Pass and at the festival, and Grandpa larger on Dubb; Reem's start spot clear of the plant; the open notebook tab highlighted. Evidence (before and `_fixed`) is in `docs/bugs/`.
- **Real-player run of every other path (2026-11-08):** all 39 other paths reached DONE with real clicks (2,097 screenshots; every new-looking one was looked at). Four more bugs, now fixed (`docs/BUGS.md` #9 to #12): English hover text «Use Hand Mirror with» while holding an item; the DewBank leaf bridge was an 80 px icon stretched 19x (new placeholder `game/scripts/ants/leaf_bridge.svg` and art row `dew_leaf_bridge`, todo, for Codex); the moved top buttons covered two observatory stars (stars moved); the hourglass cursor during choices (pointer now). New check `--path=hud_layout`: every room scene, no clickable thing under the map/notebook/settings/hint buttons (run it after moving a button or a prop near the screen edges). The real-player HUD lint now includes those buttons too.
- **Artwork:** Installed the painted dew_leaf_bridge and pass_tail_rock textures. No art rows remain todo. The existing leaf and stone words already map to these props.
- **Checks:** Content, headless import and startup, ants, narrow_pass, green, sand, mixed and words passed.
- **Real-player verification:** After user approval, green, ants and narrow_pass passed with real clicks. Inspected the two states of each prop and saved evidence in docs/bugs. Recorded the exit arrow overlapping Reem’s feet on arrival as open issue #13 in docs/BUGS.md.
- **Instruction files:** AGENTS.md now says the playtest has a path per route/station/pack/event/system (always run green, sand, mixed and words plus the paths for what you changed, one at a time) and points to `addons/popochiu/plugin.cfg` for the Popochiu version (2.2.1, not 2.0.3). The per-batch recording notes moved verbatim from AGENTS.md to `content/voice_log.md`: **record each new voice batch there**, and only the saved voice and its settings in the AGENTS.md registry. docs/PIPELINE.md says the same (changed at the user's request). No game files changed.
- **Audit item 1:** Replaced all cache references in the GUI theme with one tracked sprite sheet under game/gui/resources. Content, import, startup, green, sand, mixed and words passed.
- **Audit item 2:** The three repeated hint sets now have distinct nudges, clues and actions. Nine Reem recordings are queued. Content, startup, notebook, green, sand, mixed and words passed.
- **Audit item 3:** The map uses fully diacritised jad_map_intro_vocalised with a fresh take from saved Jad. Original line and audio preserved. Content, import, startup, valley_map, green, sand, mixed and words passed.
- **Audit item 4 pending:** 29 proposed post-MVP cast designs and preview lines are in the Voices table, with pending saved IDs in AGENTS.md. The connected voice designer requires user-supplied briefs and preview text. No new voices were saved and Reem narration is still wired.
- **Next:** Finish character voices before the six pack expansions, as requested. For each voice, verify the saved ID and sample, record direct speech as new IDs, and then replace the corresponding Reem narration calls.
- **Test notes:** `pine_sand`'s real-hold step on `word_lake` failed once in a windowed run and passed headless and windowed afterwards: flaky with a real mouse over the window. `snow` aborted once only because the computer slept.
- **Valley map:** Added all five art files and marked their rows done. The parchment button and M open the map in playable rooms. Escape or × closes it. It uses saved room visits for the leaf markers and travel, and the first introduction is saved when the map closes. All existing playable rooms, the remaining valley destinations and six pack entrances are in game_data/map_places.json. WaterfallPath already has a position. Keep adding rooms and pack IDs as they are built.
- **Map audio:** Grandpa's introduction and all 22 place-name recordings are installed and marked done. Page turn uses a short generated paper rustle in game/audio. Map feature was pushed as 3decfda. The recordings arrived in the Waterfall batch.
- **Map checks:** Content, import, startup, valley_map, green, sand, mixed and words passed. The dedicated route checked title exclusion, keyboard open and close, the pin, locked and unvisited places, and both answers before travel. Godot reported the usual exit leaks.
- **How to play the map:** Reopen Godot and press F5. Start a journey, then click the parchment in the top left or press M. Reem's pin should bob over her room. Tap a cloud to see the place name, or visit the Yard and tap the leaf on Grandpa's house. Choose لَا to stay on the map or نَعَم to return to Grandpa's house. Press Escape or click × to close.
- **Audio:** User approved Reem's Stream sample. Installed that exact take and recorded the other 85 pending rows with their saved voices. Oak added another 12 dialogue and 6 vocabulary recordings. All 104 delivered rows are done. Reem and Thaaloob dialogue use v3 with synthesis-only warm/playful tags. Words use Reem multilingual v2 without tags. No fallback or explicit numeric settings were used. Full batch listening remains open.
- **Oak forest:** Spec section 12 and six new art originals. Enter via Pine Fork's left forward route. Start Sinjoob's search, collect three acorns, then choose whether to share. Meet Qunfood and choose whether to greet him. Either mistake can be repaired, and the two rewards cannot repeat. Save state tracks gifts, cards and acorns. The notebook shows the route, hints and both cards. Six new word IDs were generated via make_words.py. Oak's right exit uses provisional End until HoneyOrchard exists.
- **Rock cave:** Section 13, registered room and visited map route. Qatqoota accepts lantern help and promises the bell. Ankoob has a four-anchor sequence with retry, healed mistakes and saved thread reward. Thaaloob can take HoneyJar only when present. Basket recovery heals the choice and custody remains saved for Narrow pass. Added 16 dialogue and 3 vocabulary recordings, two cards and context hints. Ankoob now uses two painted images assembled in Godot after two single-sprite drafts failed the leg-count check.
- **Meadow lake:** Section 14, registered lake branch, seven new art files, 14 dialogue and five word recordings. Dafdoof recovers his song and gives a reed flute when Reem shares honey. The boat offers one reserve spoonful for the Stream route, stays docked and mentions the Gull island trip. Follow Ghazlana’s three hoofprints to reunite her with her mother. Both friends have cards, save state and hints. New words cover frog, gazelle, boat, dock and hoofprint. Existing words cover other visible scenery.
- **Honey orchard:** Section 15, meeting point for all three branches. Dubb can be calmed and freed or repaired after pulling the jar. Thaaloob can be challenged with evidence or corrected after accusing Dubb. Dubb’s card and festival carrier reward are saved. The left exit remembers the arrival branch, and both forward exits unlock after both tasks. Five art files, 13 dialogue recordings and two vocabulary recordings added.
- **Checks:** Honey orchard import/startup, both Orchard paths and green/sand/mixed/words passed. The repair run saved and restored both mistakes. Orchard tests entered from Oak, and the story regressions reached it from Lake. Meadow lake kind and repair paths passed, including reserve honey, saved wilt and a real hoofprint hold that did not advance the search. Final Godot import/startup and required green/sand/mixed/words checks passed. The fixed-step word check expired the bubble too early, so words was rerun successfully at normal timing. Rock cave import/startup and required green/sand/mixed/words checks passed. All three Cave routes passed after changing the web narration and choice signs to plain Cairo labels. This covers both honey custody cases and cleared the Rect2i error. Content check, Godot import/startup, both Oak paths and all four required paths passed. Both Oak paths tested real acorn holds, no duplicate rewards and both cards. The repair path also tested save/restore. The required paths had only permitted exit leaks.
- **Backup:** Oak forest and its audio are committed and pushed as 0691d21. Rock cave and its audio were pushed as 78ee4ad. Meadow lake was pushed as 8603395. Honey orchard and Hill slope were pushed as 4613a5c and 711099c.
- **Hill slope:** Section 16 is built with Tawoos, the shared display, repairable flattery, saved feathers and friend card. Four art files, seven dialogue recordings and three word recordings were added. Import, startup, both Hill paths and green/sand/mixed/words passed. From Honey orchard choose the hill, click Tawoos, choose shared work, then click the display. Hold the frame to hear its word without completing the display. The right exit uses provisional End until NarrowPass exists.
- **Waterfall Path:** Section 17 is built and linked from the orchard waterfall arrow. Four art files, eight Reem lines and three new vocabulary recordings are done. Qarqoor rolls the fruit, throwing it back wilts once, and asking calmly then rolling it back repairs the choice. The lantern-hanger flag and card persist. The right arrow uses provisional End until NarrowPass exists. Both the illustrated map and notebook include the room.
- **Waterfall checks:** Content, headless import and startup, both Waterfall choices and green, sand, mixed and words passed. The repair route checked save and restore, and both routes checked that holding the fruit teaches its name without completing the task.
- **Narrow Pass:** Section 19 joins HillSlope and WaterfallPath and remembers the arrival route. Reem can help Thaaloob and move the small stone, or leave him and later return to repair the choice. The rescue records Thaaloob's festival attendance, and he returns the HoneyJar only if he took it in Rock cave. Two art files, eight lines and one new word are marked done. The right exit uses provisional End until HilltopFestival is registered.
- **Narrow Pass checks:** Content, headless import and startup, both Narrow Pass routes and green, sand, mixed and words passed. The repair test checked save and continue, honey return and the one-time rescue reward.
- **Hilltop Festival:** Section 20 opens from Narrow Pass. Helped friends and earned gifts appear, Qarqoor raises the high lanterns if helped, and Dubb brings Grandpa. Click the big lantern for the ceremony and the right arrow for the heart-tree ending. Grandpa recognises repaired mistakes and suggests an unvisited branch. Returning to the title retains Continue. The six pack flags unlock and persist after the ceremony. The illustrated map and notebook include the festival.
- **Festival assets:** Three new art files, eleven dialogue files and two word recordings are installed and marked done. Listening comparison is open.
- **Festival checks:** Content, headless import and startup, festival, green, sand, mixed, words and valley_map passed. The festival test checked route-specific guests, both repair and unresolved-wilt narration, the final wilted tree, and Continue with all six unlocks. The green route tested starting a fresh journey after the ending.
- **Gull Island:** Section 21 implements GullShore, TideCave and GullLighthouse, reached via the Meadow Lake boat once pack 1 is unlocked. Reem can clean the shore, wait safely for low tide, match the octopus's shapes, share the shells and fit the lighthouse lens to bring the boat back. Nine images, 25 dialogue recordings and 13 word recordings are installed. The illustrated map and notebook include all three rooms and earned animal cards.
- **Gull Island checks:** Content, import, startup, gull, green, sand, mixed and words passed. The pack test used the actual Lake boat, both repairs, the wrong cave shape, saved low tide, the storm and the return trip.
- **Ramadan Lantern Night:** Section 22 builds RamadanLane, HedgehogCourt and IftarShelter from the farm lantern after pack 3 unlocks. The lantern reveals supplies and dates. Keeping the dates wilts once and sharing repairs it. The traveller joins once the iftar table is ready. Seven images, fourteen dialogue recordings and seven new word recordings are marked done. Both maps include the new rooms.
- **Ramadan checks:** Content, import, startup, ramadan, green, sand, mixed and words passed. The pack test covered the entrance, hidden supplies, saving and restoring the dates choice, repairing it, and serving the meal. The first run showed a text-layout error on two overhead lines. They now use a plain Cairo RTL caption and the second run was clear.
- **Old City Market:** Section 23 connects MarketGate, MarketStalls and ScaleCourtyard from Gate after pack 2 unlocks. Sell honey for five coins, count three for bread and repair the cat choice. Identical weights reveal Thaaloob's tilted scale, and the baker helps reset the counterweight. Seven images, eighteen dialogue files and eight word files are installed and marked done. Both maps include the rooms.
- **Old City Market checks:** Content, headless import and startup, market, green, sand, mixed and words passed. The first market run confirmed the puzzle logic and showed the known overhead text-layout error. The rerun with plain Cairo captions was clear.
- **Snow Trail:** Section 24 adds SnowEdge, SnowTracks and SledHill. The HillSlope snow arrow opens with pack 4. Help the goldfinch, compare three kinds of prints, ride a wooden board down the trail and bring the deer to shelter. Eight art files, seventeen dialogue recordings and eight words are installed. Both maps include the rooms.
- **Snow Trail checks:** Content, import, startup, snow, green, sand, mixed and words passed. The first snow test caught a landing slightly above the walking line. The sled now leaves Reem on the normal path and the rerun passed.
- **Ant Kingdom:** Section 25 adds GiantBloom, DewBank and AntCity via the giant flower at MeadowFork. Reem shrinks, helps the worker with a seed, aligns a leaf bridge, sorts seeds by size and shelters from rain. Nine art files, 21 dialogue recordings and nine word recordings are installed. Both maps include all three rooms.
- **Star Observatory:** Chapter 26 is built and pushed as c4aaa53. All nine art files, 18 dialogue recordings and eight vocabulary recordings are done. The festival mountain arrow opens Owl Perch. Listen to the bat, click the owl, then follow the four shapes from the astronomer and the three trail markers to guide the caravan. Both maps include the rooms.
- **Star Observatory checks:** Content, Godot import and startup, stars, green, sand, mixed and words passed. The stars test checked repair, wrong-shape handling, Continue and caravan arrival. An earlier overlapping test shared the save slot and failed at Continue. The isolated rerun passed. Listening comparison remains open.
- **Tree Day:** The garden, seven dialogue recordings and two word recordings are installed and marked done. After the festival, click the leaf in Yard, talk to Arnoob and click the seedling after offering water. Watering shows new leaves and awards the notebook card. Godot import and startup, the dedicated route and green, sand, mixed and words passed. Tree Day was committed as d888e57.
- **Mothers Day:** Mother Garden is built and pushed as ed2239b. The courtyard, seven dialogue recordings and two vocabulary recordings are installed and marked done. The dedicated route passed with the finished audio. Godot import, startup and the dedicated route passed. From Yard after the festival, click the pink flower, click the basket to choose, then click the blank card.
- **Next:** The roadmap is implemented. The final Cave, cave_sand, cave_empty, green, sand, mixed and words playtests all passed after the Cairo caption and choice-sign changes. Release checks still include hands-on Arabic layout, recording comparison and timings. Ankoob now uses a painted body and exactly eight Godot leg sprites. Content, Godot import and startup, all three Cave routes, and green, sand, mixed and words passed. The Cave routes verified exactly eight legs with four mirrored.
- **How to play Ant Kingdom:** After the festival, click the giant flower in the meadow. Help the worker and click the seed. At the dew drop, click the leaf to straighten it, then talk to the beetle. In the colony, talk to the queen, click the seeds from smallest to largest, then click the tunnel.
- **How to play Snow Trail:** After the festival, revisit Hill slope and take the snow arrow. Talk to the goldfinch and offer the bundle, then click the shelter. Talk to white-coated Arnoob and click the three split prints from left to right. At the next room click the wooden board, then click the deer when Reem reaches the bottom.
- **How to play Old City Market:** After the festival, visit Gate and take the market arrow. Click the honey stall, then go to the baker. Select three coins and click the green tick. Share bread with the cat, then visit the scale. Talk to Thaaloob, place both weights and click the tick. Show the baker, then place both weights and test again.
- **How to play Ramadan Lantern Night:** After the festival, revisit the farm yard and click the small lantern. Choose to help, then click the lantern in the lane and find both baskets and the jug. Continue to the hedgehog family, choose to share, and find three dates. Click the table in the shelter to serve the traveller.
- **How to play Gull Island:** Finish the festival, revisit Meadow Lake and click the wooden boat. If it offers reserve honey first, click it again to take the trip. Talk to the turtle, collect the three litter pieces, then click the tide rock to reveal the cave trail. In the cave, click the octopus, then diamond, circle and triangle. At the lighthouse, talk to the gull and click the lamp to fit the lens. Return via the cave and the shore boat.
- **How to play the festival:** Free Thaaloob in Narrow Pass and take the right arrow. Click the big lantern. Look for the friends you helped and the gifts they brought. Use the right arrow to see the final tree, then click the return button. Choose Continue to revisit the festival, or start another journey from the title.
- **How to play Narrow Pass:** Complete Hill slope or Waterfall Path and take the right arrow. Click Thaaloob and choose to help. Hold the small stone to learn its word, then click it to free him. If he took the HoneyJar in Rock cave, it returns to Reem's basket. Try leaving and coming back to see the repair.
- **How to play Waterfall:** At Honey orchard, help Dubb and find the lanterns. Click the waterfall arrow and then Qarqoor. Try throwing the fruit back, then talk to him again and choose to ask calmly. Hold the fruit for its word, then click it to play. The right arrow opens and Qarqoor's card appears in the notebook.
- **How to play Orchard:** Complete one of Oak, Cave or Lake and take the right arrow. Click Dubb, choose to speak softly, then click the jar to free him. Click Thaaloob, then inspect the two lanterns near the stream and report to Dubb. Try the wrong choices and repair them by the same steps. Both labelled routes unlock.
- **How to play Lake:** From Pine Fork choose الْبُحَيْرَةُ. Click Dafdoof. If Reem lacks honey, click the boat, then return to the frog. Try keeping the honey and then sharing to repair. Click Ghazlana and follow the three prints left to right. Hold a print to hear its word. The right exit unlocks once both friends are helped.
- **How to play Cave:** From Pine Fork choose الْكَهْفُ. Click the kitten and offer the lantern. Click Ankoob, choose to try and follow the four shapes from right to left in the example. Click Thaaloob after both gifts. Set down the basket to test his trick, then click the basket to repair.
- **How to play Oak:** Close and reopen Godot, press F5, start a new journey and reach Pine Fork via Stream or the meadow. Talk to Thaaloob and choose غَابَةُ الْبَلُّوطِ. Click Sinjoob, then the three acorns near the roots, then Sinjoob again. Try keeping all the acorns and then sharing to repair. Click Qunfood and try both choices. Press N to see earned cards. Hold an acorn before collecting to learn its name.

## Decisions to review

- **2026-11-14 / walk refinement:** Preserve the user-approved face exactly. Use eight distance-driven poses with 62.5% stance per leg; keep stance travel linear for planting and ease pose/swing changes with Tween sine interpolation. Walking speed is unchanged.
- **2026-11-14 / gait stance and knees:** Bring hidden hips and ankles into a side-view walking stance, retain exact original neutral pivots, cap stride at 90 native pixels and knee bend at 35 degrees. Hidden hip correction preserves contact without scaling trouser width. This supersedes the earlier 120px stride decision.
- **2026-11-14 / stable clothing:** Keep torso and scarf stable instead of spreading large shoulder rotations through them. A dedicated Hem bone adds delayed sway and 7% local vertical overlap (about 10 native pixels at the edge) only while walking. Separate hidden trouser caps and a measured curved hem avoid the previous repeated outline strips. This supersedes the prior scarf/torso shared-motion choice for walking.
- **2026-11-14 / evidence:** Use the actual packed scene in an isolated preview for all eight frozen poses and compare approved face crops pixel-for-pixel. No AI repainting or full windowed route tests.

- **2026-11-14 / source match:** Re-align by extracting original sprite pixels rather than independently stretching the differently proportioned generated parts. Keep all originals and previous generated files. Six source layers support separate overlapping native upper/lower/hand/foot meshes.
- **2026-11-14 / joints:** Use continuous native skin weights at overlapping joints and shared scarf/sleeve borders; rigid source crops alone produced jagged intersections when bent. Original-pixel under-hem caps are hidden in the neutral pose.
- **2026-11-14 / face:** Determine eye and mouth bounds from the original dark-feature components, not the earlier atlas guesses. Preserve the original eyebrows, blush and profile; blank only the old features and anchor every replacement to their measured source centre.
- **2026-11-14 / stride:** Cap legacy 160px stride settings to 120px in the rig so the original short legs can reach planted targets without sliding. The Inspector range/default now reflect 60–120px. Source size and neutral pose stay unchanged.
- **2026-11-14 / review:** Freeze the actual rig at neutral, eye/mouth states and four walk phases for sharp deterministic Godot screenshots. Compare neutral source pixels numerically as well as visually; a maximum 4/255 GPU colour-rounding difference remains, with no visible silhouette mismatch.


- **2026-11-14 / mirror UI:** Full text appears immediately instead of a typewriter reveal; this prevents partial Arabic shaping or voice-time truncation. Every dialogue channel shares one presentation component, with adaptive height rather than any maximum-line clipping. Text settings use 44–56px for subtitles, preserving the larger preferences.
- **2026-11-14 / cursor:** Use the native arrow for every game state, including inventory selection. Hide both software-cursor sources rather than replacing just the wait frame. Item selection state and click actions are unchanged.
- **2026-11-14 / mirror:** x=570 gives the current cutout one clear step left of the 800px-centred fallen frame. Keep fall_target as the artwork centre and shift only the sorting origin to the floor edge.
- **2026-11-14 / verification:** The supplied prompt describes a screenshot but no image attachment was available to save; reproduce the described scene and preserve after screenshots. The known windowed mouse-helper failure is documented, and only the scene/screenshot checks are counted as passed.


- **2026-11-14 / Reem:** The current request supersedes the earlier no-bob preference for Reem: bob is small (4 native pixels, about 1.4 on screen), exposed in the Inspector. Other characters keep their existing behaviour.
- **2026-11-14 / art:** Generate one shared transparent atlas with both references attached, then extract named parts, rather than independently generating inconsistent limbs. The generated painted finish and visible sleeve/knee joint outlines need user visual approval; no pixel-identical match is claimed.
- **2026-11-14 / gait:** Distance, rather than an independent clock, drives the walk phase so stance feet cancel character travel. Tween sine easing handles swing, start/stop, breathing, expressions, blink and wave. The original sprite stays hidden solely to preserve all existing size/facing integration.
- **2026-11-14 / expressions:** Existing tone containing sad/worried/sorry maps to sad; surpris/amazed maps to surprised; other tones map to happy. Arabic greeting detection triggers the wave. Existing line data is unchanged.
- **2026-11-14 / depth:** Use three soft horizontal depth masks (sky/landscape/near ground), maximum 3 pixels, from existing background textures. This avoids changing original art or click locations; it is a restrained depth approximation, not newly painted semantic scenery layers.
- **2026-11-14 / testing:** Test saves use an isolated APPDATA under .godot/reem-test-profile. Two native Yard clicks could not be verified after desktop app approval timed out. The focused manual mode waits for the well reward and Grandpa line; a timeout is reported honestly, not counted as success.


Choices made without asking (newest first).

- **Notebook map:** Chose the shared full-screen map and removed the notebook-only renderer and travel handler. The map introduction still plays as audio, with the name panel hidden until a marker is tapped.

- **Stream bridge:** Used the existing three duckling sprites with staggered paths, hops, tilt and perspective scale. The sound cues are short synthesized effects. The build spot is to the left of the bridge so Reem does not hide the crossing. The original dialogue stays in place as requested, including its reference to a log.

- **Meadow:** Kept the earlier destination composition as the reference file for the final wildflowers edit. A small set of interactive flowers bends while the painted meadow flowers stay decorative. Reem scales down as she walks uphill to the distant tree.

- **Gate exits:** Moved the Market arrow as well because its original hotspot overlapped the corrected Stream route after unlock. Kept the help button in place and made its background opaque.

- **Leaf and rock:** Preserved the generated PNGs and used sprite regions to remove transparent margins in-game. The leaf source is 2172 × 724 and displays near 520 × 120. The rock displays near 180 × 120. Both keep their previous movement and click areas.

- **Observatory stars moved, not the buttons:** the circle star sits 33 px higher and the crescent star 77 px lower, so the top buttons can stay where fix #2 put them. Every other room was checked by `--path=hud_layout` and has nothing under the buttons.
- **No hover text at all:** Popochiu's hover text (English) is now switched off inside the component itself, not only cleared by the GUI.
- **Leaf bridge placeholder:** drawn as a simple long leaf (SVG, 520x120) until Codex paints `dew_leaf_bridge`; the old 80x80 `leaf.svg` is left in place, unused.
- **Top buttons moved down:** the map, «دفتري» and «الإعدادات» buttons now sit at y 132–134, just below the inventory bar's 120 px strip, instead of inside it (docs/BUGS.md #2). Moving the bar instead would have meant editing Popochiu's inventory template.
- **Festival sizes:** only Thaaloob (back to 454 px, his size everywhere else) and Grandpa (300 px riding Dubb, 400 px without) were enlarged. The other guests keep their smaller festival sizes so all ten still fit along the path.
- **Narrow Pass tail:** the user chose a rock drawn over the tail. I made the existing clickable stone that rock (rather than adding a second rock), so there is still one thing to click; the tail's word area moved up to the visible white tip.
- **Dialogue outline:** the text above speakers has a cream outline (12 px) for all characters, not only where it was hard to read.

- **Cast audit:** Drafted child-friendly adult voice briefs and sample lines for the post-MVP speaking roles. Kept candidate voices pending until a saved character mapping is verified.

- **Map introduction audit:** A new ID keeps the original line and take available. The new introduction uses saved Jad with v3 and a warm tag. Listening comparison remains open.

- **Hints audit:** Wrote three fresh, progressively more explicit steps for each affected puzzle. The content checker now rejects repeated IDs in any hint set.

- **Theme audit:** Copied Popochiu's existing radio-button sheet into game resources so all four states retain their original appearance.

- **Ankoob:** The first body draft had background haze and the first leg request failed. Both retries passed. The Cave uses four legs on each side and a brief stepping wiggle on interaction. The notebook shows a cropped body portrait.

- **Cave captions:** The two web lines use plain Cairo bottom captions. This removed the repeated errors after connecting the web. The remaining error on the offer cleared when the choice signs switched to plain Cairo labels. All three Cave reruns passed without the rectangle error. The exact Arabic text and audio were preserved.

- **Mothers Day:** The courtyard card begins blank. A drawn flower appears on it after Reem chooses to share, repairs the wilt and earns the notebook keepsake. The event opens from Yard after the festival. Reem reads the note herself.

- **Tree Day:** The event opens from Yard after the festival. The existing Arnoob sprite and Reem narration cover the situation. A small drawn leaf overlay shows the effect of watering and serves as the notebook card. The new scene reuses familiar object words and adds the seedling and event name.

- **Parent Corner:** Open from Settings (F10). A randomized two-digit sum gates entry. The panel shows prompts for completed choices in the current journey. Godot startup and the dedicated parent route passed, covering wrong answers, the lesson list and clearing access.

- **Heart tree:** The canopy shows up to twelve extra flowers after the first three good deeds, both in play and on the ending screen. It uses the original tree pictures and keeps the wilted branches visible. Headless startup, festival, green, sand, mixed and words passed.

- **Star Observatory art and words:** The Dome background passed on the retry after a connection failure. Reem will narrate the new characters using her saved voice. The chart uses four distinct shapes, and the caravan follows three markers. Incorrect selections keep prior progress. The caravan uses the existing gazelle sprite. Existing words cover the path, trees, rocks, stars, shelter and familiar furnishings. New words include the telescope, owl and bat.

- **Ant Kingdom:** Reem's smaller scale makes the surroundings feel oversized. The worker and queen use dorsal sprites so all six legs are visible. Their first bases had occluded limbs. The empty meadow background was regenerated after the first take included a painted seed and ant. The rain stays outside the walking route and has no timer. Duration and listening comparison remain open.

- **Snow Trail:** Arnoob has a separate white-fur sprite derived from his original. Tracks differ by shape and spacing. A wrong print does not change progress. The sled uses a short automatic ride along the illustration, with controls restored at the bottom. Native props show tracks, the board and the bundle. Duration and listening comparison remain open.

- **Old City Market:** The honey stall can use its own jar when Reem arrives without one. An incorrect payment resets the coin selection and keeps all five coins. The pack uses reusable drawn coins, a moving scale beam and a removable merchant apron on Thaaloob. The cat choice and dishonest deal have separate repairs. Listening comparison and pack duration remain open.

- **Ramadan Lantern Night:** The lantern toggles the hidden supplies without hiding the path. The moment before Maghrib is in the story and has no timer. Reem narrates the new characters using her saved voice. The family uses Qunfood's sprite with smaller companions. The village guide helps prepare for iftar and the scene includes no call or quoted religious text. Play duration and listening comparison remain open.
- **Arabic caption rendering:** The bottom narration box now uses a plain Label. The two affected Ramadan recordings keep their original wording, speaker and sound in that box. The dedicated headless test no longer shows the Rect2i error. The older Rock cave problem can be investigated with the same approach during polish.

- **Gull Island:** Tide advances by a click on the tide rock, with no timer. The cave shows colours and distinct shapes. The coastal storm only delays the shore boat until the lighthouse is repaired. Native vector props cover litter and the cave shapes. The turtle reference was regenerated for clearer flipper anatomy. Each room has its own Popochiu folder and shares the pack script. Pack duration and listening comparison are open.

- **Hilltop Festival:** Dubb is Grandpa's carrier because helping him is on the mandatory orchard route. The screen darkens the painted small lanterns until the ceremony, then adds a gentle glow. Small gift icons use native vector drawings. The old end screen keeps its heart-tree display and returns to a title with the completed save available. The replay hint chooses an unseen branch friend. Older saves use known repaired-flower and mirror flags when a repair count is absent.

- **Narrow Pass:** The loose stone rolls safely aside. The rescue reuses Thaaloob's existing sprite and moves him away from the rock when he is free. Reem can return via the route she arrived on, even after a save. Forgiveness uses story dialogue without a religious quotation.

- **Valley map:** Kept the existing notebook map available. The new map groups the farm and meadow rooms around their painted landmarks. Ramadan and snow share the base valley, with locks near the farm and festival. The painting simplifies several trail joins, including the three-way reunion at the orchard. The data keeps those connections and follows the roadmap pack IDs. The first cloud generation included the room reference, so the second standalone cloud replaced that take. Headless checks verify behavior. The paper rustle and RTL layout still need a listening and visual review in the game.

- **Waterfall draft:** Fruit rolls on the ground and never hits either character. Reem narrates Qarqoor pending a verified saved voice.

- **Hill slope:** Reem narrates Tawoos. The display reuses recovered lantern art with a native ribbon and a new feather. Flattery is repaired by showing the shared display.

- **Honey orchard (Codex, 2026-11-07):** Orchard honey at the rim is available on every route, so the jar puzzle works without a HoneyJar inventory item. The arrival branch is saved for return travel. The wet lanterns stay visible for vocabulary. Dubb uses Reem narration. Hill and waterfall arrows are neutral and separately labelled.


- **Meadow lake (Codex, 2026-11-07):** The boat provides one reserve spoonful if Reem has no jar. Reem retains HoneyJar after sharing a spoonful. Reem narrates all three lake characters because no approved saved voices exist for them. Ghazlana's mother uses a larger flipped and shaded stand-in from Ghazlana's sprite. Hoofprints, warm cup and song symbol use Godot shapes. Wrong print order causes no wilt. Lake is now the standard provisional route for regression runs.


- **Rock cave (Codex, 2026-11-07):** Example sequence reads right to left and uses distinct shapes alongside colours. A wrong anchor resets the attempt without changing the tree. A child without HoneyJar can still experience and repair the basket choice. Ankoob's two sprite attempts failed visible leg count, so the row is problem and a temporary eight-legged SVG under game is used for room and card. The second cave background passed after excluding furniture. Existing MVP regression paths now finish through the provisional lake branch.


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
