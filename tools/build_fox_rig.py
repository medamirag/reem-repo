"""Cuts Thaaloob's approved picture into the layers of his walking rig.

Run from the project folder:  python tools/build_fox_rig.py [review.png]

The original (assets/art/characters/fox/fox_base.png) is only read. Everything is written to
game/characters/thaaloob/rig/: one PNG per layer (cropped; its place is in layout.json), the face
patches, and layout.json (layers, bones, joints). The rig script (fox_rig.gd) turns each layer into
a flexible sheet that follows the bones, so shoulders, hips, knees and elbows bend without seams.

Layers, back to front: tail, far arm, far leg (with a copy of the hips), far foot, head,
body (chest, hips and near leg), near foot, near arm, scarf.
Hidden parts are completed in the picture's own flat colours: the tail under the near hand, the
back under the near arm, the top of the far arm, the bottoms of the legs inside the paws.
"""
import json
import sys
from pathlib import Path
from PIL import Image, ImageChops, ImageDraw, ImageFilter

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build_grandpa_face as kit  # shared drawing helpers (Layer, quad, smooth, sample ...)

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets/art/characters/fox/fox_base.png"
OUT = ROOT / "game/characters/thaaloob/rig"
SIZE = (1254, 1254)
FEET = (627, 1254)

# ---- Lines that separate the parts (picture pixels) ---------------------------------------------
# Back of the body, from under the scarf down the back, hip and the back of the near leg.
BODY_BACK = [(590, 520), (590, 556), (597, 600), (601, 640), (603, 700), (593, 750), (579, 790), (561, 830),
             (551, 850), (538, 925), (527, 985), (512, 1060), (492, 1130), (478, 1146), (400, 1150)]
BACK_UNDER_ARM = [(590, 556), (597, 600), (601, 640)]
# Middle of the gap between the two legs, from the crotch down.
LEG_GAP = [(647, 926), (641, 950), (620, 1000), (606, 1060), (602, 1120), (600, 1180), (600, 1254)]
FAR_LEG_AREA = [(647, 926), (740, 864), (900, 864), (900, 1254)] + LEG_GAP[::-1][:-1]
HIPS_AND_FAR_LEG = [(545, 790), (745, 790), (745, 864), (900, 864), (900, 1254)] + LEG_GAP[::-1] + [(552, 872), (545, 850)]
NEAR_ARM_AREA = [(570, 540), (640, 552), (632, 600), (603, 638), (585, 690), (560, 745), (538, 778), (482, 778),
                 (486, 745), (520, 650), (555, 575)]
FAR_ARM_AREA = [(740, 640), (790, 640), (905, 760), (905, 905), (765, 905), (749, 800), (740, 722)]
FAR_ARM_CAP = [(739, 716), (776, 678), (760, 646), (720, 672)]
HEAD_AREA = [(0, 0), (1254, 0), (1254, 470), (770, 470), (705, 512), (598, 512), (560, 470), (0, 470)]
TAIL_AREA = [(210, 560), (440, 560), (475, 640), (492, 700), (500, 760), (510, 825), (520, 858), (556, 850),
             (552, 935), (540, 990), (450, 1010), (210, 1010)]
TAIL_UNDER_HAND = [(469, 700), (464, 760), (478, 822), (505, 853), (556, 850), (552, 940), (440, 985), (380, 880),
                   (420, 740)]
TAIL_INNER_EDGE = [(468, 700), (464, 745), (470, 795), (486, 834), (508, 853), (548, 850)]
BOXES = {"hand_near": (412, 742, 548, 898), "hand_far": (772, 762, 892, 898),
         "foot_near": (408, 1138, 578, 1242), "foot_far": (622, 1138, 842, 1242)}
# Outline of the near paw (it lies over the tail, whose lines must not come along with it).
HAND_NEAR_SHAPE = [(476, 754), (500, 747), (529, 759), (536, 790), (540, 815), (536, 840), (522, 849), (510, 846),
                   (500, 864), (483, 879), (461, 883), (438, 875), (425, 851), (422, 822), (429, 793), (450, 770)]
LEG_END_NEAR = [(493, 1140), (556, 1140), (556, 1190), (493, 1190)]
LEG_END_FAR = [(655, 1140), (702, 1140), (702, 1188), (655, 1188)]

# ---- Bones (picture pixels). Children hang from their parent. -----------------------------------
BONES = [
    ["Body", "", (645, 900)],
    ["Head", "Body", (655, 492)], ["EarNear", "Head", (575, 268)], ["EarFar", "Head", (688, 170)],
    ["ScarfEnd", "Body", (746, 562)],
    ["Tail", "Body", (540, 888)], ["TailTip", "Tail", (372, 905)],
    ["Shoulder_near", "Body", (600, 578)], ["Elbow_near", "Shoulder_near", (551, 676)], ["Wrist_near", "Elbow_near", (503, 764)],
    ["Shoulder_far", "Body", (748, 690)], ["Elbow_far", "Shoulder_far", (776, 742)], ["Wrist_far", "Elbow_far", (806, 792)],
    ["Hip_near", "Body", (598, 899)], ["Knee_near", "Hip_near", (548, 1035)], ["Ankle_near", "Knee_near", (522, 1150)],
    ["Hip_far", "Body", (692, 897)], ["Knee_far", "Hip_far", (682, 1035)], ["Ankle_far", "Knee_far", (674, 1150)],
]
# A chain says how a layer's corners are shared between bones: before the first joint they follow
# `base`; past each joint (along `toward`, softly over `soft` pixels) they follow that joint's bone.
def chain(base, joints, area=None):
    return {"base": base, "joints": [{"bone": b, "at": list(a), "toward": list(t), "soft": s} for b, a, t, s in joints],
            "area": [list(p) for p in area] if area else None}

LAYERS = [
    ("tail", "Body", [chain("Body", [("Tail", (540, 888), (372, 905), 36), ("TailTip", (372, 905), (300, 700), 60)])], False),
    ("arm_far", "Body", [chain("Body", [("Shoulder_far", (748, 690), (776, 742), 14), ("Elbow_far", (776, 742), (806, 792), 16),
                                         ("Wrist_far", (806, 792), (826, 830), 10)])], True),
    ("leg_far", "Body", [chain("Body", [("Hip_far", (692, 897), (682, 1035), 44), ("Knee_far", (682, 1035), (674, 1150), 30)])], True),
    ("foot_far", "Ankle_far", [], True),
    ("head", "Head", [chain("Head", [("EarNear", (575, 268), (585, 40), 52)], [(470, 0), (600, 0), (640, 110), (664, 185), (650, 300), (470, 330)]),
                      chain("Head", [("EarFar", (688, 170), (690, 70), 18)], [(655, 55), (722, 55), (726, 172), (660, 188)])], False),
    ("body", "Body", [chain("Body", [("Hip_near", (598, 899), (548, 1035), 44), ("Knee_near", (548, 1035), (522, 1150), 30)])], False),
    ("foot_near", "Ankle_near", [], False),
    ("arm_near", "Body", [chain("Body", [("Shoulder_near", (600, 578), (551, 676), 26), ("Elbow_near", (551, 676), (503, 764), 22),
                                          ("Wrist_near", (503, 764), (480, 815), 12)])], False),
    ("scarf", "Body", [chain("Body", [("ScarfEnd", (746, 562), (752, 660), 18)], [(700, 548), (800, 548), (800, 712), (700, 712)])], False),
]
# Paws: heel and toe on the ground, measured from the ankle. The near paw points backwards in the
# picture (feet turned out); the rig mirrors it while walking, so its toe is given already mirrored.
SOLES = {"near": {"heel": (-46, 78), "toe": (104, 76)}, "far": {"heel": (-34, 76), "toe": (152, 72)}}

EYE_BOX = (636, 186, 790, 400)
MOUTH_BOX = (680, 380, 880, 500)
# Centre of the smile line, from its corner to the nose.
SMILE = [(702, 400), (712, 412), (722, 421), (735, 430), (750, 436), (770, 440), (790, 440), (810, 435),
         (830, 424), (845, 410), (855, 396)]


def mask_of(points, blur=0.0):
    big = Image.new("L", (SIZE[0] * 2, SIZE[1] * 2), 0)
    ImageDraw.Draw(big).polygon([(x * 2, y * 2) for x, y in points], fill=255)
    small = big.resize(SIZE, Image.LANCZOS)
    return small.filter(ImageFilter.GaussianBlur(blur)) if blur else small


def left_of(line):
    """Everything on the left of a top-to-bottom line (plus the far left and bottom)."""
    return mask_of([(0, line[0][1])] + line + [(line[-1][0], SIZE[1]), (0, SIZE[1])])


def grow(mask, pixels):
    return mask.filter(ImageFilter.MaxFilter(int(pixels) * 2 + 1))


def both(a, b):
    return ImageChops.multiply(a, b)


def either(a, b):
    return ImageChops.lighter(a, b)


def without(a, b):
    return ImageChops.multiply(a, ImageChops.invert(b))


def boxed(mask, box):
    out = Image.new("L", SIZE, 0)
    out.paste(mask.crop(box), box[:2])
    return out


def stroke(image, points, width, colour):
    big = Image.new("L", (SIZE[0] * 2, SIZE[1] * 2), 0)
    draw = ImageDraw.Draw(big)
    r = width
    pts = [(x * 2, y * 2) for x, y in points]
    for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
        steps = max(1, int(max(abs(x1 - x0), abs(y1 - y0))))
        for i in range(steps + 1):
            x, y = x0 + (x1 - x0) * i / steps, y0 + (y1 - y0) * i / steps
            draw.ellipse([x - r, y - r, x + r, y + r], fill=255)
    image.paste(Image.new("RGBA", SIZE, colour + (255,)), (0, 0), big.resize(SIZE, Image.LANCZOS))


def extend_down(image, x0, x1, y_from, y_to):
    """Repeats one row of pixels downwards: a leg (cloth and outlines) continues inside its paw."""
    row = image.crop((x0, y_from, x1, y_from + 1))
    for y in range(y_from + 1, y_to):
        image.paste(row, (x0, y))


def paint(image, mask, colour):
    image.paste(Image.new("RGBA", SIZE, colour + (255,)), (0, 0), mask)


def cut(src, mask):
    out = src.copy()
    out.putalpha(both(src.getchannel("A"), mask))
    return out


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    src = Image.open(SOURCE).convert("RGBA")
    data = list(src.get_flattened_data())
    def classify(test):
        m = Image.new("L", SIZE, 0)
        m.putdata([255 if p[3] > 128 and test(p) else 0 for p in data])
        return m
    purple = classify(lambda p: p[2] > p[1] + 45 and p[0] > p[1] + 25)
    brown = classify(lambda p: 150 < p[0] + p[1] + p[2] and p[0] < 175 and p[0] > p[1] + 35 and p[1] < 95 and p[2] < 75)
    dark = classify(lambda p: p[0] + p[1] + p[2] < 150)
    orange = kit.sample(src, 640, 760, 3)
    line = kit.sample(src, 603, 700, 1)
    alpha = src.getchannel("A")

    scarf = boxed(both(grow(boxed(purple, (560, 455, 805, 720)), 7), either(purple, dark)), (553, 448, 812, 727))
    paws = {}
    for name, box in BOXES.items():
        core = boxed(brown, box)
        wide = (box[0] - 9, box[1] - 9, box[2] + 9, box[3] + 9)
        paws[name] = boxed(both(grow(core, 8), either(brown, dark)), wide)
    paws["hand_near"] = both(paws["hand_near"], mask_of(HAND_NEAR_SHAPE))
    # No pieces of the leg's outline on the paws (the leg itself continues down inside them).
    paws["foot_near"] = without(paws["foot_near"], mask_of([(466, 1100), (578, 1100), (578, 1153), (466, 1153)]))
    paws["foot_far"] = without(paws["foot_far"], mask_of([(634, 1100), (712, 1100), (712, 1153), (634, 1153)]))
    around = {name: grow(mask, 3) for name, mask in paws.items()}

    left = left_of(BODY_BACK)
    near_arm_area = mask_of(NEAR_ARM_AREA)
    far_arm_area = without(mask_of(FAR_ARM_AREA), scarf)
    images = {}

    # Scarf and paws: exactly their own pixels.
    images["scarf"] = cut(src, scarf)
    images["foot_near"] = cut(src, paws["foot_near"])
    images["foot_far"] = cut(src, paws["foot_far"])

    # Head: everything above the middle of the scarf (its neck hides under the scarf layer).
    images["head"] = cut(src, mask_of(HEAD_AREA))

    # Near arm: sleeve area (soft where it joins the shoulder) plus its paw.
    arm = without(mask_of(NEAR_ARM_AREA, 1.2), scarf)
    images["arm_near"] = cut(src, either(without(arm, paws["hand_near"]), paws["hand_near"]))

    # Far arm: its top is completed upwards, hidden behind the chest.
    far = Image.new("RGBA", SIZE, (0, 0, 0, 0))
    paint(far, mask_of(FAR_ARM_CAP, 1.0), orange)
    far.alpha_composite(cut(src, either(far_arm_area, paws["hand_far"])))
    images["arm_far"] = far

    # Body: chest, hips and near leg. The near arm, far arm, far leg, tail and paws are taken away.
    body_mask = without(mask_of([(470, 480), (800, 480), (800, 1254), (470, 1254)]), left)
    body_mask = without(body_mask, mask_of(HEAD_AREA))
    body_mask = without(body_mask, far_arm_area)
    body_mask = without(body_mask, around["hand_far"])
    body_mask = without(body_mask, mask_of(FAR_LEG_AREA, 3.0))
    under = cut(src, without(body_mask, mask_of([(400, 1146), (585, 1146), (585, 1254), (400, 1254)])))
    extend_down(under, 470, 582, 1144, 1186)               # leg continues inside the paw
    stroke(under, kit.smooth(BACK_UNDER_ARM, 2), 7.0, line)  # the back, where the arm covered it
    images["body"] = under

    # Far leg with a copy of the hips, so the hip bends as one skin. Hidden behind the body.
    back_mask = without(without(mask_of(HIPS_AND_FAR_LEG), around["foot_far"]), around["hand_far"])
    back_mask = without(back_mask, mask_of([(610, 1146), (860, 1146), (860, 1254), (610, 1254)]))
    back = cut(src, back_mask)
    extend_down(back, 634, 724, 1144, 1186)
    images["leg_far"] = back

    # Tail: completed where the near paw covered it.
    tail_left = left_of([(x - 6, y) for x, y in BODY_BACK])
    tail_mask = both(both(mask_of(TAIL_AREA), tail_left), ImageChops.invert(grow(near_arm_area, 9)))
    tail = cut(src, without(tail_mask, grow(paws["hand_near"], 2)))
    filled = Image.new("RGBA", SIZE, (0, 0, 0, 0))
    paint(filled, mask_of([(522, 858), (574, 854), (574, 922), (549, 924)], 1.0), orange)  # root, hidden behind the hip
    paint(filled, both(mask_of(TAIL_UNDER_HAND, 0.8), grow(paws["hand_near"], 4)), orange)
    filled.alpha_composite(tail)
    stroke(filled, kit.smooth(TAIL_INNER_EDGE, 3), 7.0, line)
    images["tail"] = filled

    layers = []
    for name, base, chains, far_side in LAYERS:
        image = images[name]
        box = image.getchannel("A").point(lambda v: 255 if v > 20 else 0).getbbox()
        box = (max(0, box[0] - 2), max(0, box[1] - 2), min(SIZE[0], box[2] + 2), min(SIZE[1], box[3] + 2))
        image.crop(box).save(OUT / (name + ".png"))
        layers.append({"name": name, "file": name + ".png", "at": [box[0], box[1]], "base": base, "chains": chains,
                       "far_side": far_side})

    build_face(src, line)

    layout = {
        "source": "assets/art/characters/fox/fox_base.png", "canvas": list(SIZE), "feet": list(FEET),
        "bones": [{"name": n, "parent": p, "at": list(a)} for n, p, a in BONES],
        "layers": layers, "soles": {k: {a: list(b) for a, b in v.items()} for k, v in SOLES.items()},
        "eye_box": list(EYE_BOX), "mouth_box": list(MOUTH_BOX),
        "note": "All positions are in the picture's pixels. Made by tools/build_fox_rig.py; edit the tables in that"
                " script and run it again rather than editing this file.",
    }
    (OUT / "layout.json").write_text(json.dumps(layout, indent=1) + "\n", encoding="utf-8")
    return images


def build_face(src, line):
    kit.OUT = OUT
    orange = kit.sample(src, 660, 330, 2)
    cream = kit.sample(src, 760, 400, 3)
    inside = (122, 38, 30)
    tongue = (236, 128, 118)
    is_dark = lambda rgb: sum(rgb) < 200
    not_orange = kit.far_from(orange, 40)

    # ---- The eye: one layer per state (closed / sad / surprised) ----------------------------
    eye_area = kit.oval((722, 315), 44, 62)
    cheek_line = [(676, 351), (690, 357), (706, 364), (725, 373), (746, 381)]

    def blank_eye(layer, keep_brow=True):
        """Paints the eye away: fur colour above the cheek line, cream below it."""
        clip = layer.mask_polygon([(600, 180), (764, 180), (764, 420), (600, 420)])
        eye = layer.pixel_mask(src, eye_area + [], lambda rgb: not_orange(rgb) and kit.far_from(cream, 30)(rgb), 2.4)
        lash = layer.pixel_mask(src, [(655, 290), (700, 290), (700, 310), (655, 310)], is_dark, 2.0)
        whole = Image.composite(Image.new("L", layer.size, 255), eye, lash)
        whole = Image.composite(whole, Image.new("L", layer.size, 0), clip)
        layer._paste(whole, orange, 0.5, None)
        below = layer.mask_polygon(cheek_line + [(760, 381), (760, 420), (660, 420), (660, 351)])
        layer._paste(Image.composite(whole, Image.new("L", layer.size, 0), below), cream, 0.5, None)
        return clip

    closed = kit.Layer(EYE_BOX)
    blank_eye(closed)
    closed.stroke(kit.quad((683, 322), (718, 344), (754, 326)), 7.0, line)
    closed.save("eyes_closed.png")

    brow_area = [(655, 222), (742, 222), (742, 250), (700, 256), (672, 270), (655, 270)]

    def lift_brow(layer):
        brow = layer.cut(src, layer.pixel_mask(src, brow_area, is_dark, 1.6))
        layer.pixels(src, brow_area, is_dark, orange, grow=2.2)
        return brow

    sad = kit.Layer(EYE_BOX)
    brow = lift_brow(sad)
    sad.place(brow, (700, 240), angle=20, move=(0.0, 3.0))
    # The eyelid comes down a little more and slopes outwards.
    lid = kit.quad((668, 318), (712, 322), (757, 312))
    eye = sad.pixel_mask(src, eye_area, lambda rgb: not_orange(rgb), 1.8)
    over = sad.mask_polygon(lid + [(757, 246), (668, 246)])
    clip = sad.mask_polygon([(600, 200), (757, 200), (757, 420), (600, 420)])
    covered = Image.composite(Image.composite(eye, Image.new("L", sad.size, 0), over), Image.new("L", sad.size, 0), clip)
    sad._paste(covered, orange, 0.4, None)
    sad.stroke(lid, 7.0, line, clip=clip)
    sad.save("face_sad.png")

    wide = kit.Layer(EYE_BOX)
    brow = lift_brow(wide)
    wide.place(brow, (700, 240), angle=6, move=(2.0, -12.0))
    # The eyelid opens fully: the lid (found by filling from a point on it, up to the black
    # lines around it) becomes white, the lid line goes, and the pupil continues upwards.
    b = EYE_BOX
    small = Image.new("L", (b[2] - b[0], b[3] - b[1]), 0)
    small.putdata([0 if is_dark(px[:3]) else 255 for px in src.crop(b).get_flattened_data()])
    ImageDraw.floodfill(small, (722 - b[0], 280 - b[1]), 128)
    lid = small.point(lambda v: 255 if v == 128 else 0).resize(wide.size, Image.BICUBIC).point(lambda v: 255 if v > 96 else 0)
    lid = lid.filter(ImageFilter.MaxFilter(int(1.5 * kit.S) * 2 + 1))
    nothing = Image.new("L", wide.size, 0)
    wide._paste(lid, (255, 255, 255), 0.3, None)
    lid_line = wide.pixel_mask(src, [(693, 290), (730, 290), (730, 308), (693, 308)], lambda rgb: sum(rgb) < 520, 2.4)
    wide._paste(lid_line, (255, 255, 255), 0.3, wide.mask_polygon(kit.oval((722, 318), 30.5, 50)))
    lash = wide.pixel_mask(src, [(655, 290), (684, 290), (684, 310), (655, 310)], is_dark, 2.0)
    wide._paste(lash, orange, 0.4, None)
    reach = lid.filter(ImageFilter.MaxFilter(int(3 * kit.S) * 2 + 1))
    pupil_clip = Image.composite(reach, nothing, wide.mask_polygon([(712, 240), (764, 240), (764, 312), (712, 312)]))
    wide.ellipse((745.5, 322), 19.0, 52, line, clip=pupil_clip)
    wide.save("face_surprised.png")

    # ---- Mouths: the lower jaw drops under the muzzle; the smile line stays ------------------
    top = [(x, kit.interp(SMILE, x) + 1.0) for x in range(716, 843, 3)]
    for name, depth in (("mouth_half.png", 458.0), ("mouth_open.png", 474.0)):
        mouth = kit.Layer(MOUTH_BOX)
        inner = kit.quad(top[-1], (784, depth), top[0])
        jaw = kit.quad((top[-1][0] + 3, top[-1][1] + 3), (784, depth + 13), (top[0][0] - 5, top[0][1] + 7))
        mouth.fill(top + jaw, cream)
        shape = top + inner
        mouth.fill(shape, inside)
        mouth.ellipse((786, depth), 24, 9 if depth > 465 else 5.5, tongue, clip=mouth.mask_polygon(shape))
        mouth.stroke(jaw, 6.5, line)
        mouth.stroke(inner, 4.5, line)
        mouth.stroke(top, 5.5, line)
        mouth.save(name)

    # Sad: the corner of the mouth turns down instead of up.
    mouth = kit.Layer(MOUTH_BOX)
    mouth.pixels(src, [(694, 388), (732, 388), (760, 426), (776, 434), (776, 447), (750, 443), (722, 430), (694, 408)],
                 is_dark, cream, grow=2.0)
    mouth.stroke(kit.smooth([(790, 440.5), (768, 436), (746, 433), (726, 437), (712, 446), (705, 457)], 3), 5.6, line)
    mouth.save("mouth_sad.png")


def review(images, path):
    """Every layer on blue (to check the cuts), the layers put back together, and the original."""
    names = [l[0] for l in LAYERS]
    together = Image.new("RGBA", SIZE, (0, 0, 0, 0))
    for n in names:
        together.alpha_composite(images[n])
    tiles = [("original", Image.open(SOURCE).convert("RGBA")), ("layers together", together)] + [(n, images[n]) for n in names]
    sheet = Image.new("RGB", (4 * 940, 3 * 940), (120, 160, 220))
    for i, (name, image) in enumerate(tiles):
        tile = Image.new("RGBA", SIZE, (120, 160, 220, 255))
        tile.alpha_composite(image)
        box = image.getbbox() if i > 1 else (0, 0) + SIZE
        cx, cy = (box[0] + box[2]) // 2, (box[1] + box[3]) // 2
        half = max(box[2] - box[0], box[3] - box[1], 300) // 2 + 20
        crop = tile.crop((cx - half, cy - half, cx + half, cy + half)).resize((940, 940), Image.LANCZOS)
        sheet.paste(crop.convert("RGB"), ((i % 4) * 940, (i // 4) * 940))
        ImageDraw.Draw(sheet).text(((i % 4) * 940 + 8, (i // 4) * 940 + 6), name, fill=(255, 255, 0))
    sheet.save(path)


if __name__ == "__main__":
    made = build()
    if len(sys.argv) > 1:
        review(made, sys.argv[1])
    print("Thaaloob rig layers written to", OUT)
