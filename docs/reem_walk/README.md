# Reem eight-pose walk review

`eight_poses.png` arranges eight untouched Godot renders at phases 0, 1/8, ... 7/8. Each row shows contact, down, passing and up; the opposite leg leads in the second row. The face is the approved original. `legs_closeups.png` enlarges the eight rendered knee/foot regions. These are frozen animation states, not a story playthrough or painted mock-up.

The neutral, talking and blinking source-size captures allow comparison with the previous `docs/reem_alignment/` evidence. The temporary 50% overlay is fixture-only and is removed before final captures. No overlay ships in the rig.

Rebuild layers/scene with `tools/build_reem_cutout.py` using Python with Pillow. Import the project with Godot 4.7.2. Run Godot with `--path . --script tools/reem_alignment_review.gd` and a real renderer for captures (headless runs assertions only). The isolated preview closes automatically. Run `tools/reem_walk_contact_sheet.py` to arrange the captures and `tools/check_reem_cutout.py docs/reem_walk/neutral_rgba.png` to check original neutral pixels. The contact-sheet script uses Windows Arial only for English review captions; game Arabic/fonts are unchanged.

Pose checks cover all mouth/eye anchors, neutral registration, overlay removal, opposing arms, forward knees with a 35-degree limit, shoe angles, draw order, and flat/heel/toe planting during matching actor travel. The focused headless game path is `-- --playtest --path=reem_animation`. No full route or native click tests were run for this walk-only change.
