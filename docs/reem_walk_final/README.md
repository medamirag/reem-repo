# Final Reem walk cleanup — 2026-11-15

`walk_game_100pct.png` contains actual Godot renders at the character picture scale of 0.362. Each game pixel is one image pixel; the frames are arranged without resizing. `torso_game_400pct.png` contains shoulder/back/front crops rendered separately at scale 1.448, exactly four times game scale. Both use Reem's explicit linear texture filtering. Neither screenshot has been retouched or enlarged with nearest-neighbour sampling.

The rounded back overlap closes the scarf/arm junction. The near sleeve retains its original texture and joint weights, with a smooth continuous outlined outer edge replacing the old alpha-mask step. The scarf is drawn over the upper sleeve. The front overlap covers the far sleeve's residual neck marks and parallel edge. All gait parameters and facial anchors remain unchanged.

These sheets supersede the earlier native-source 400% sheet, which deliberately used nearest-neighbour diagnostic enlargement and looked pixelated. After this cleanup, the walk is final: change it only for defects visible at game size, per the user's instruction.
