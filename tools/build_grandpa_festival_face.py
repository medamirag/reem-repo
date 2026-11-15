"""Draws the blink and talking-mouth patches for Grandpa's festival picture.

Run from the project folder:  python tools/build_grandpa_festival_face.py [review.png]

Same method as tools/build_grandpa_face.py (whose drawing helpers are reused): the original
picture (assets/art/characters/grandpa/grandpa_festival_seated.png) is only read, every patch is
a small transparent PNG in game/characters/jad/festival_rig/ in the picture's own pixel
coordinates, and the boxes are written to face_layout.json.
"""
import json
import sys
from pathlib import Path
from PIL import Image

import build_grandpa_face as kit

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets/art/characters/grandpa/grandpa_festival_seated.png"
OUT = ROOT / "game/characters/jad/festival_rig"
kit.OUT = OUT

EYES_BOX = (456, 205, 650, 320)
MOUTH_BOX = (436, 340, 612, 452)
# Centre of the smile line drawn in the picture.
SMILE = [(452, 361), (460, 364.5), (470, 368), (480, 371.5), (490, 375), (500, 378), (510, 380.5),
         (520, 382.5), (530, 383.5), (540, 383.5), (550, 382.5), (560, 381), (570, 378), (580, 374),
         (588, 370), (595, 366)]


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    src = Image.open(SOURCE).convert("RGBA")
    line = kit.sample(src, 520, 383, 1)
    skin = kit.sample(src, 550, 245, 3)
    inside = (122, 38, 30)
    tongue = (236, 128, 118)

    # Eyes closed: every eye pixel becomes skin, then one curved lash line per eye.
    eyes = kit.Layer(EYES_BOX)
    not_skin = kit.far_from(skin, 30)
    eyes.pixels(src, kit.oval((606, 270), 33, 41), not_skin, skin, grow=3.0, feather=2.5)
    eyes.pixels(src, kit.oval((495, 253), 26, 39), not_skin, skin, grow=3.0, feather=2.5)
    eyes.stroke(kit.quad((580, 279), (606, 292), (632, 277)), 7.5, line)
    eyes.stroke(kit.quad((475, 265), (495, 277), (516, 263)), 7.0, line)
    eyes.save("eyes_closed.png")

    # Talking mouths: the jaw drops under the smile line, which stays.
    top = [(x, kit.interp(SMILE, x) + 0.5) for x in range(462, 589, 2)]
    for name, depth in (("mouth_half.png", 404.0), ("mouth_open.png", 428.0)):
        mouth = kit.Layer(MOUTH_BOX)
        bottom = kit.quad((588, top[-1][1]), (526, depth), (462, top[0][1]))
        shape = top + bottom
        mouth.fill(shape, inside)
        clip = mouth.mask_polygon(shape)
        mouth.ellipse((526, depth + 2), 31, 15 if depth > 410 else 9, tongue, clip=clip)
        mouth.stroke(bottom, 6.6, line)
        mouth.stroke(top, 7.4, line)
        mouth.save(name)

    layout = {
        "source": "assets/art/characters/grandpa/grandpa_festival_seated.png",
        "canvas": list(src.size),
        "eyes_box": list(EYES_BOX),
        "mouth_box": list(MOUTH_BOX),
        "note": "Boxes are [left, top, right, bottom] in the picture's pixels."
                " Made by tools/build_grandpa_festival_face.py.",
    }
    (OUT / "face_layout.json").write_text(json.dumps(layout, indent=2) + "\n", encoding="utf-8")


def review(path):
    """Original and every patch over the picture, 3x, for checking by eye."""
    src = Image.open(SOURCE).convert("RGBA")
    box = (400, 170, 720, 480)
    sets = [[], ["eyes_closed"], ["mouth_half"], ["mouth_open"]]
    boxes = {"eyes": EYES_BOX, "mouth": MOUTH_BOX}
    z = 2
    w, h = (box[2] - box[0]) * z, (box[3] - box[1]) * z
    sheet = Image.new("RGB", (w * 2, h * 2), (255, 244, 222))
    for i, names in enumerate(sets):
        frame = Image.new("RGBA", src.size, (255, 244, 222, 255))
        frame.alpha_composite(src)
        for n in names:
            b = boxes[n.split("_")[0]]
            frame.alpha_composite(Image.open(OUT / (n + ".png")), (b[0], b[1]))
        tile = frame.crop(box).resize((w, h), Image.LANCZOS)
        sheet.paste(tile.convert("RGB"), ((i % 2) * w, (i // 2) * h))
    sheet.save(path)


if __name__ == "__main__":
    build()
    if len(sys.argv) > 1:
        review(sys.argv[1])
    print("Festival Grandpa face patches written to", OUT)
