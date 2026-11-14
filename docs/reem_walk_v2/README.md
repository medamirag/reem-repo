# Reem stronger walk: seven-point review

`eight_poses.png` is eight untouched Godot renders, arranged in contact/down/passing/up order, twice. `legs_closeups.png` enlarges the tunic edge, knees and shoes. Captures are frozen poses of the real packed scene, not painted corrections. The previous sheet remains in `docs/reem_walk/`.

| User point | Implemented and checked |
| --- | --- |
| 1. Contact stride | 25-degree thighs, 232.5px heel-to-toe contact gap (1.5 nominal 155px feet), front toes up and back heel raised. Planted-contact assertions pass. |
| 2. Alternate legs | Pairs 1/5, 2/6, 3/7 and 4/8 exchange joint/foot positions exactly. Far leg is 14% darker; near leg draws in front. |
| 3. Passing | Moving knee is 40 degrees; lifted shoe clears the floor by more than 30px. No leg-bone scaling. |
| 4. Arms | Near shoulder swings +/-20 degrees about its original source rest, far +/-14 in opposition. Small elbow bend increases to about 22 degrees on the forward near arm, freeing the hand from the bag. Both contact hand-clearance checks pass. |
| 5. Bob | Down +31.35px, Up -31.35px: 2.6% of visible character height. Head, torso and arms inherit the same movement. |
| 6. Marks and seams | Scarf no longer owns long sleeve-edge strips; near shoe edge belongs to its own foot; original-colour caps cover the upper trouser joints. Enlarged captures inspected for collar lines, floor dashes, top gaps and knee inflation. |
| 7. Original angle | Compared with the original base and reference sheet: same right-facing profile/slight three-quarter body view. Source pixels/neutral registration preserved, with only deliberate collar/shoulder alpha-fringe cleanup. Approved neutral, talking and blinking face crops remain identical. |

The source-size walk captures have 96px padding on each side to prevent clipping the Up pose. Neutral/face captures are cropped back to original source coordinates. The 50% original overlay is temporary and removed before final captures; it does not ship.

Rebuild with Python/Pillow: `tools/build_reem_cutout.py`. Import with Godot 4.7.2, then run Godot `--path . --script tools/reem_alignment_review.gd` with a real renderer. It closes automatically; headless runs assertions without overwriting the PNGs. Run `tools/reem_walk_contact_sheet.py` to arrange the captures and `tools/check_reem_cutout.py` to audit source layers, cleaned neutral and the unchanged approved face. `-- --playtest --path=reem_animation` is the focused headless integration path. No full windowed story tests were run.
