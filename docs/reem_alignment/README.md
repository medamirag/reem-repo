# Reem alignment review

This supersedes the earlier generated-parts preview in docs/reem_animation.

- [Neutral pose beside the original](neutral_side_by_side.png)
- [Talking and blinking face close-ups](face_closeups.png)
- [Four walk phases](walk_four_frames.png)
- [Temporary 50% original overlay](overlay_50.png) — removed before final captures.
- Individual phases: [1](walk_1.png), [2](walk_2.png), [3](walk_3.png), [4](walk_4.png).

These are actual Godot renders of the same cutout scene used in the game. Contact sheets crop/arrange those renders without repainting them. The neutral pose and face states are frozen for comparison; normal breathing, random blink and voice mouth timing remain active in the game.

The neutral comparison uses the original sprite's pixels at the same scale and origin. Pixel validation found **zero missing/protruding visible pixels**, zero solid-source colour differences above 12/255, and a maximum channel difference of 4/255 from rendering. The source-extracted layers preserve the original alpha at every pixel.

The editable rig is `game/characters/reem/reem_cutout.tscn`. Pivots and face anchors are in `cutout_layout.json`. Separate upper/lower/hand/foot mesh sections overlap, using shared skin weights across joints. Near-side limbs render in front. Source eye anchor: (718.5,238.5); mouth anchor: (754,324). No reference overlay is included in the shipping scene.

Rebuild with `tools/build_reem_cutout.py` (Pillow), then import in Godot. Run `tools/check_reem_cutout.py` for source/neutral pixel checks. The isolated capture/check fixture runs with Godot's `--script tools/reem_alignment_review.gd`; it creates the overlay only temporarily and asserts its removal.

All alignment checks and the focused headless Reem integration path passed, including blinking, voice start/end, expressions, room changes, inventory and Continue. No full story routes were run and no other character was changed.
