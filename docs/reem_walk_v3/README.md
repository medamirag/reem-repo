# Reem walk: four-point arm/shoulder correction

`eight_poses.png` contains eight untouched actual Godot renders. `shoulders_closeups.png` and `legs_closeups.png` enlarge all eight poses. The previous stride/shading review remains in `docs/reem_walk_v2/`.

| Requested correction | Checked result |
| --- | --- |
| 1. Mirrored arms | Both shoulders swing +/-20 degrees in physical space, with one shared elbow curve. Upper-arm and forearm directions exchange exactly across 1/5, 2/6, 3/7 and 4/8. At Passing (3/7), both upper arms are near vertical and close to the body. Arms oppose their own leg's cycle. |
| 2. Stable torso | Original torso texture/view, constant .008-radian forward lean and unit scale in every pose. No arm-bone weights turn the tunic. Body-side shoulder fill stays body-bound; only the sleeve-side gusset follows the arm. |
| 3. Shoulder opening | Rounded shirt backing beneath scarf/strap and a trimmed skinned far-sleeve gusset fill the missing shoulder area. Enlarged views inspected. These fade out at idle, preserving the exact original neutral silhouette/colour. |
| 4. Passing lift | Swing lift is now 60px instead of 40px, with over 50px measured toe clearance, slight toe-down angle and the foot beside the standing leg. The 40-degree knee bend, stride, 14% darker far leg and exact leg exchange are preserved. |

Source-size walk captures retain 96px padding on each side. Neutral and facial captures use the original 1254px coordinates. Approved neutral, talking and blinking face crops remain pixel-identical. Temporary reference overlay is removed before the final captures and does not ship.

Rebuild: Python/Pillow `tools/build_reem_cutout.py`; import with Godot 4.7.2. Capture using Godot `--path . --script tools/reem_alignment_review.gd` with a real renderer (headless runs assertions only). Arrange captures using `tools/reem_walk_contact_sheet.py`; audit original/neutral/face pixels using `tools/check_reem_cutout.py`. Focused headless integration: `-- --playtest --path=reem_animation`. No full windowed story routes were run.
