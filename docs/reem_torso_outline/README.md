# Reem torso and shoulder correction

Actual Godot renders, not retouched screenshots. `torso_all_8_400pct.png` shows every walk pose at exactly 4x source-pixel size (nearest-neighbour). The back, shoulder and front beside the strap are included. `eight_poses.png` shows the complete character.

Replaced clipped torso patches with one closed rounded tunic and continuous 7px black outline. The upper shoulder overlap is repainted in the existing teal to remove baked grey fringe. Original bag/strap pixels are extracted separately. Native curves retain lower fabric shading and hem movement. Source originals remain untouched.

Reviewed all eight poses at 400% for outline continuity, scarf overlap and stray shoulder lines. Approved motion code is unchanged. Face comparisons are exact for neutral, talking and blinking; original lower legs/feet also pass the pixel comparison. Pose checks cover the approved arm/leg symmetry, stride, fixed torso angle, bob and planted heel/toe contacts.
