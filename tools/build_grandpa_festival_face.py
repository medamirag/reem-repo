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

# Greeting arm (hand on heart): his right forearm, drawn raised, with the picture's own hand.
ARM_BOX = (270, 640, 720, 1010)
ELBOW = (330, 905)
# Degrees clockwise that lay the raised forearm back towards his lap (where it fades out).
ARM_REST_ANGLE = 34.0
# The loose sleeve: under side (it hangs a little), cuff, upper side. All three are outlined.
SLEEVE_UNDER = [(336, 992), (382, 995), (428, 978), (468, 938), (502, 884), (531, 826), (556, 782)]
SLEEVE_CUFF = [(556, 782), (538, 746), (508, 720)]
SLEEVE_UPPER = [(508, 720), (462, 752), (414, 790)]
# Inside his upper sleeve there is no line: the same cloth, blended softly.
SLEEVE_BACK = [(380, 812), (336, 842), (320, 900), (324, 966)]
# His upper hand in the picture (wrist on the left), reused turned on his chest.
HAND_AREA = [(374, 952), (379, 926), (392, 906), (418, 893), (455, 888), (500, 887), (536, 895), (556, 918),
             (567, 956), (561, 988), (544, 1002), (518, 1009), (494, 1016), (468, 1012), (444, 994),
             (420, 990), (398, 990), (383, 978)]
HAND_BOX = (360, 876, 580, 1026)
HAND_WRIST = (392, 950)
HAND_TO = (540, 748)
HAND_TURN = 42.0
HAND_SCALE = 0.92


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

    build_heart_arm(src, line)

    layout = {
        "source": "assets/art/characters/grandpa/grandpa_festival_seated.png",
        "canvas": list(src.size),
        "eyes_box": list(EYES_BOX),
        "mouth_box": list(MOUTH_BOX),
        "arm_box": list(ARM_BOX),
        "elbow": list(ELBOW),
        "arm_rest_angle": ARM_REST_ANGLE,
        "note": "Boxes are [left, top, right, bottom] in the picture's pixels. arm_fore.png is drawn raised"
                " (hand on heart); turning it arm_rest_angle degrees clockwise around `elbow` lays it back"
                " towards his lap. Made by tools/build_grandpa_festival_face.py.",
    }
    (OUT / "face_layout.json").write_text(json.dumps(layout, indent=2) + "\n", encoding="utf-8")


def build_heart_arm(src, line):
    """The greeting: his right forearm lifts and the hand rests on his heart.

    arm_fore.png is the forearm in its raised pose; the rig turns it around the elbow. Nothing of
    the picture is hidden: his other hand stays in his lap, partly behind the hanging sleeve.
    """
    dark, light = kit.sample(src, 335, 890, 4), kit.sample(src, 380, 700, 3)
    sleeve = tuple((dark[k] + 2 * light[k]) // 3 for k in range(3))
    fold = kit.sample(src, 352, 780, 2)
    arm = kit.Layer(ARM_BOX)

    hand_layer = kit.Layer(HAND_BOX)
    hand = hand_layer.cut(src, hand_layer.mask_polygon(HAND_AREA), feather=0.3)
    # Same maths as Layer.place, between two layers of different boxes.
    import math
    px, py = hand_layer.pt(HAND_WRIST)
    tx, ty = arm.pt(HAND_TO)
    a = math.radians(HAND_TURN)
    c, s = math.cos(a) / HAND_SCALE, math.sin(a) / HAND_SCALE
    matrix = (c, -s, px - c * tx + s * ty, s, c, py - s * tx - c * ty)
    arm.image.alpha_composite(hand.convert("RGBa").transform(arm.size, Image.AFFINE, matrix, Image.BICUBIC).convert("RGBA"))

    under = kit.smooth(SLEEVE_UNDER)
    cuff = kit.smooth(SLEEVE_CUFF, 2)
    upper = kit.smooth(SLEEVE_UPPER)
    shape = under + cuff + upper + SLEEVE_BACK
    back = arm.mask_polygon([(270, 770), (416, 770), (404, 860), (352, 1005), (270, 1005)])
    arm.fill(shape, sleeve, feather=6.0, clip=back)
    arm.fill(under + cuff + upper + [(400, 818), (348, 850), (331, 900), (334, 968)], sleeve)
    inside = arm.mask_polygon(shape)
    arm.stroke(kit.smooth([(392, 930), (432, 898), (470, 846)]), 6.0, fold, clip=inside)
    arm.stroke(kit.smooth([(440, 800), (478, 790), (512, 766)]), 5.0, fold, clip=inside)
    arm.stroke(under + cuff + upper, 7.0, line)
    arm.save("arm_fore.png")


def review(path):
    """Original and every patch over the picture, 3x, for checking by eye."""
    src = Image.open(SOURCE).convert("RGBA")
    box = (400, 170, 720, 480)
    if "arm" in path:
        frame = Image.new("RGBA", src.size, (255, 244, 222, 255))
        frame.alpha_composite(src)
        frame.alpha_composite(Image.open(OUT / "arm_fore.png"), ARM_BOX[:2])
        frame.crop((200, 150, 950, 1100)).convert("RGB").save(path)
        return
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
