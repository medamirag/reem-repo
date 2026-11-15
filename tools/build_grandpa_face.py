"""Draws Grandpa's blink and mouth patches for the seated rig.

Run from the project folder:  python tools/build_grandpa_face.py

The original picture (assets/cut/grandpa_bench/grandpa_seated.png) is only read. Every patch is a
small transparent PNG in game/characters/jad/rig/, in the picture's own pixel coordinates (the box
of each patch is written to face_layout.json). Shapes are drawn 4x larger and scaled down, so the
edges are smooth. Colours are sampled from the picture.
"""
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets/cut/grandpa_bench/grandpa_seated.png"
OUT = ROOT / "game/characters/jad/rig"
S = 4  # supersampling

EYES_BOX = (256, 108, 376, 172)
MOUTH_BOX = (286, 194, 394, 262)
UPPER_BOX = (238, 62, 378, 180)

# Greeting arm (hand on heart). Angles in degrees, 0 = pointing right, negative = upwards.
ARM_BOX = (130, 330, 390, 610)
ELBOW = (212, 500)
ARM_RAISED_ANGLE = -50.0
ARM_REST_ANGLE = 79.0
# Forearm outline around the elbow: u along the arm, v across it (positive = lower side).
# The back of the elbow is left open: there the sleeve joins the upper arm (same cloth).
SLEEVE_OUTLINE = [(4, -40), (40, -40), (72, -37), (80, -20), (83, 2), (80, 26), (73, 41), (40, 45), (0, 46),
                  (-22, 41), (-33, 27), (-40, 16)]
SLEEVE_BACK = [(-36, 0), (-20, -30)]
# Where the forearm is in the picture (repainted as waistcoat while the arm is raised).
FOREARM_AREA = [(243, 460), (300, 494), (299, 508), (290, 530), (279, 553), (266, 571), (254, 582),
                (248, 590), (192, 558), (188, 541), (215, 528), (236, 500), (241, 468)]
ELBOW_CURVE = [(241, 466), (239, 486), (232, 506), (218, 524), (200, 536), (190, 541)]
# The hand on his knee, reused (mirrored, so the thumb is on top) for the raised hand.
HAND_SOURCE_BOX = (388, 488, 520, 590)
HAND_AREA = [(392, 499), (516, 499), (516, 586), (392, 586)]
HAND_WRIST = (452, 512)
HAND_WRIST_LOCAL = (68, 1)
HAND_TURN = 133.0
HAND_SCALE = 0.8

# Centre of the smile line drawn in the picture (the lower edge of the moustache).
SMILE = [(300, 209), (305, 212), (312, 215.5), (320, 218.5), (330, 221), (340, 222.3),
         (350, 222.2), (360, 220.5), (368, 217.5), (374, 213), (378, 208)]


def sample(src, x, y, r=2):
    px = [src.getpixel((i, j))[:3] for i in range(x - r, x + r + 1) for j in range(y - r, y + r + 1)]
    return tuple(sum(c[k] for c in px) // len(px) for k in range(3))


def quad(p0, p1, p2, n=40):
    """Points of a curve that starts at p0, ends at p2 and passes through p1 in the middle."""
    cx = 2 * p1[0] - (p0[0] + p2[0]) / 2
    cy = 2 * p1[1] - (p0[1] + p2[1]) / 2
    pts = []
    for i in range(n + 1):
        t = i / n
        pts.append(((1 - t) ** 2 * p0[0] + 2 * t * (1 - t) * cx + t * t * p2[0],
                    (1 - t) ** 2 * p0[1] + 2 * t * (1 - t) * cy + t * t * p2[1]))
    return pts


def interp(points, x):
    for (x0, y0), (x1, y1) in zip(points, points[1:]):
        if x0 <= x <= x1:
            return y0 + (y1 - y0) * (x - x0) / (x1 - x0)
    return points[0][1] if x < points[0][0] else points[-1][1]


class Layer:
    def __init__(self, box):
        self.box = box
        self.size = ((box[2] - box[0]) * S, (box[3] - box[1]) * S)
        self.image = Image.new("RGBA", self.size, (0, 0, 0, 0))

    def pt(self, p):
        return ((p[0] - self.box[0]) * S, (p[1] - self.box[1]) * S)

    def pts(self, points):
        return [self.pt(p) for p in points]

    def fill(self, points, colour, feather=0.0, clip=None):
        mask = Image.new("L", self.size, 0)
        ImageDraw.Draw(mask).polygon(self.pts(points), fill=255)
        self._paste(mask, colour, feather, clip)

    def ellipse(self, centre, rx, ry, colour, feather=0.0, clip=None):
        mask = Image.new("L", self.size, 0)
        c = self.pt(centre)
        ImageDraw.Draw(mask).ellipse([c[0] - rx * S, c[1] - ry * S, c[0] + rx * S, c[1] + ry * S], fill=255)
        self._paste(mask, colour, feather, clip)

    def stroke(self, points, width, colour, clip=None):
        """A round brush moved along the points (even thickness whatever the spacing)."""
        mask = Image.new("L", self.size, 0)
        draw = ImageDraw.Draw(mask)
        p = self.pts(points)
        r = width * S / 2
        for (x0, y0), (x1, y1) in zip(p, p[1:]):
            steps = max(1, int(max(abs(x1 - x0), abs(y1 - y0))))
            for i in range(steps + 1):
                x = x0 + (x1 - x0) * i / steps
                y = y0 + (y1 - y0) * i / steps
                draw.ellipse([x - r, y - r, x + r, y + r], fill=255)
        self._paste(mask, colour, 0.0, clip)

    def mask_polygon(self, points):
        mask = Image.new("L", self.size, 0)
        ImageDraw.Draw(mask).polygon(self.pts(points), fill=255)
        return mask

    def _paste(self, mask, colour, feather, clip):
        if feather > 0:
            mask = mask.filter(ImageFilter.GaussianBlur(feather * S))
        if clip is not None:
            mask = Image.composite(mask, Image.new("L", self.size, 0), clip)
        tint = Image.new("RGBA", self.size, colour + (255,))
        tint.putalpha(mask)
        self.image.alpha_composite(tint)

    def pixel_mask(self, src, region, test, grow=1.6):
        """4x mask of every picture pixel inside `region` for which test(rgb) is true."""
        b = self.box
        small = Image.new("L", (b[2] - b[0], b[3] - b[1]), 0)
        inside = Image.new("L", small.size, 0)
        ImageDraw.Draw(inside).polygon([(x - b[0], y - b[1]) for x, y in region], fill=255)
        for j in range(small.size[1]):
            for i in range(small.size[0]):
                if inside.getpixel((i, j)) and test(src.getpixel((i + b[0], j + b[1]))[:3]):
                    small.putpixel((i, j), 255)
        mask = small.resize(self.size, Image.BICUBIC).point(lambda v: 255 if v > 96 else 0)
        if grow > 0:
            mask = mask.filter(ImageFilter.MaxFilter(int(grow * S) * 2 + 1))
        return mask

    def pixels(self, src, region, test, colour, grow=1.6, feather=0.5, clip=None):
        """Paints `colour` over every picture pixel inside `region` for which test(rgb) is true."""
        self._paste(self.pixel_mask(src, region, test, grow), colour, feather, clip)

    def cut(self, src, mask, feather=0.4):
        """The picture's own pixels under `mask`, as a 4x sprite that can be moved and pasted."""
        b = self.box
        sprite = src.crop(b).resize(self.size, Image.BICUBIC)
        sprite.putalpha(mask.filter(ImageFilter.GaussianBlur(feather * S)))
        return sprite

    def place(self, sprite, pivot, angle=0.0, scale=1.0, move=(0.0, 0.0), clip=None, to=None):
        """Pastes a cut sprite turned by `angle` degrees (counter-clockwise on screen) and scaled
        around `pivot`, then moved by `move`; or with its pivot placed at `to`."""
        import math
        px, py = self.pt(pivot)
        tx, ty = self.pt(to) if to is not None else (px + move[0] * S, py + move[1] * S)
        a = math.radians(angle)
        c, s = math.cos(a) / scale, math.sin(a) / scale
        # Output pixel -> sprite pixel (inverse of: rotate/scale about pivot, then put pivot at t).
        matrix = (c, -s, px - c * tx + s * ty, s, c, py - s * tx - c * ty)
        moved = sprite.convert("RGBa").transform(self.size, Image.AFFINE, matrix, Image.BICUBIC).convert("RGBA")
        if clip is not None:
            alpha = Image.composite(moved.getchannel("A"), Image.new("L", self.size, 0), clip)
            moved.putalpha(alpha)
        self.image.alpha_composite(moved)

    def save(self, name):
        size = (self.box[2] - self.box[0], self.box[3] - self.box[1])
        small = self.image.convert("RGBa").resize(size, Image.LANCZOS).convert("RGBA")
        small.save(OUT / name)


def far_from(colour, limit):
    return lambda rgb: sum(abs(rgb[k] - colour[k]) for k in range(3)) > limit


def oval(centre, rx, ry, n=48):
    import math
    return [(centre[0] + rx * math.cos(i * math.tau / n), centre[1] + ry * math.sin(i * math.tau / n)) for i in range(n)]


def build():
    OUT.mkdir(parents=True, exist_ok=True)
    src = Image.open(SOURCE).convert("RGBA")
    line = sample(src, 345, 222, 1)
    skin_near = sample(src, 318, 140, 3)
    skin_far = sample(src, 328, 132, 2)
    lip = sample(src, 338, 229, 2)
    white_left = sample(src, 318, 208, 1)
    white_right = sample(src, 384, 214, 1)
    inside = (122, 38, 30)
    tongue = (236, 128, 118)

    # --- Eyes closed -----------------------------------------------------------------------
    eyes = Layer(EYES_BOX)
    # Every eye pixel (white, pupil, outline, lashes) is covered with the skin colour next to it.
    eyes.pixels(src, oval((288, 147), 25, 29), far_from(skin_near, 26), skin_near, grow=2.6)
    # The far eye touches the outline of the face: keep that outline (x >= 362).
    clip = eyes.mask_polygon([(320, 100), (361.8, 100), (361.8, 180), (320, 180)])
    eyes.pixels(src, oval((348, 138), 21, 27), far_from(skin_far, 26), skin_far, grow=2.6, clip=clip)
    eyes.stroke(quad((271, 148.5), (289, 158), (307, 147.5)), 5.4, line)
    eyes.stroke(quad((338.5, 140), (350, 147.5), (360.5, 140.5)), 5.0, line)
    eyes.save("eyes_closed.png")

    # --- Talking mouths: the jaw drops under the moustache, the smile line stays -----------
    top = [(x, interp(SMILE, x) + 0.5) for x in range(306, 373, 2)]
    for name, depth in (("mouth_half.png", 235.0), ("mouth_open.png", 250.5)):
        mouth = Layer(MOUTH_BOX)
        bottom = quad((372, top[-1][1]), (339, depth), (306, top[0][1]))
        shape = top + bottom
        mouth.fill(shape, inside)
        clip = mouth.mask_polygon(shape)
        mouth.ellipse((339, depth + 1), 17, 8.5 if depth > 240 else 5, tongue, clip=clip)
        mouth.stroke(bottom, 4.4, line)
        mouth.stroke(top, 5.0, line)
        mouth.save(name)

    # --- Sad and surprised mouths: the smile line is replaced by a new line ------------------
    dark = lambda rgb: sum(rgb) < 520 and rgb[0] - rgb[2] < 60
    xs = list(range(301, 377, 2))
    for name, new_line, round_mouth in (
            ("mouth_sad.png", quad((299.5, 224.5), (338, 208.0), (376.5, 223.5)), False),
            ("mouth_surprised.png", quad((301.5, 216.5), (338, 212.0), (373.5, 215.5)), True)):
        mouth = Layer(MOUTH_BOX)
        # The band that holds the old smile and the new line; above the new line it becomes
        # moustache, below it lip. So the corners of a frown really go down into the beard.
        band_top = [(x, min(interp(SMILE, x) - 4.4, interp(new_line, x))) for x in xs]
        band_bottom = [(x, max(interp(SMILE, x) + 5.6, interp(new_line, x))) for x in xs]
        band = mouth.mask_polygon(band_top + band_bottom[::-1])
        above = mouth.mask_polygon(new_line + [(396, 190), (284, 190)])
        below = above.point(lambda v: 255 - v)
        mouth._paste(band, white_left, 0.5, above)
        mouth._paste(band, lip, 0.5, below)
        # Old corners (the little up-turned ends of the smile) become moustache again.
        mouth.pixels(src, [(301.5, 198), (318, 198), (318, 219), (303, 219), (300.5, 212), (296, 210), (296, 204)], dark, white_left, grow=1.3, clip=above)
        mouth.pixels(src, [(366, 203.5), (381, 203), (382.3, 211), (377.5, 219), (364, 221.5)], dark, white_left, grow=1.3, clip=above)
        low = 222.5 if not round_mouth else 216.5
        mouth.fill([(295, 204.5), (306, 204.5), (307.5, 214), (304, low - 1.5), (299, low - 1), (295.3, 214)], white_left, feather=0.4)
        mouth.stroke(new_line, 5.2, line)
        if round_mouth:
            # A clear round "oh": its top tucks under the moustache line.
            shape = oval((338.5, 236.0), 17.0, 18.0)
            mouth.fill(shape, line)
            inner = oval((338.5, 236.0), 12.6, 13.6)
            mouth.fill(inner, inside)
            mouth.ellipse((338.5, 249.5), 10.5, 5.5, tongue, clip=mouth.mask_polygon(inner))
            mouth.stroke(new_line, 5.2, line)
        mouth.save(name)

    # --- Upper face for sad and surprised: eyebrows, eyelids, wider eyes --------------------
    not_skin_near = far_from(skin_near, 26)
    not_skin_far = far_from(skin_far, 26)
    keep_contour = lambda layer: layer.mask_polygon([(300, 60), (361.6, 60), (361.6, 180), (300, 180)])
    near_brow_area = [(245.5, 88), (262, 78), (309, 78), (309, 105), (282, 113), (264, 131), (245.5, 131)]
    far_brow_area = [(327, 78.5), (362, 78.5), (362, 113), (345, 109), (327, 105)]
    near_eye_area = oval((288, 147), 25, 29)
    far_eye_area = oval((348, 138), 21, 27)

    def upper_face():
        face = Layer(UPPER_BOX)
        clip = keep_contour(face)
        parts = {
            "near_brow": face.cut(src, face.pixel_mask(src, near_brow_area, not_skin_near, 1.0)),
            "far_brow": face.cut(src, face.pixel_mask(src, far_brow_area, not_skin_far, 1.0)),
            "near_eye": face.cut(src, face.pixel_mask(src, near_eye_area, not_skin_near, 1.0)),
            "far_eye": face.cut(src, face.pixel_mask(src, far_eye_area, not_skin_far, 1.0)),
        }
        # The eyebrows are lifted off the face (skin painted where they were), then put back moved.
        face.pixels(src, near_brow_area, not_skin_near, skin_near)
        face.pixels(src, far_brow_area, not_skin_far, skin_far, clip=clip)
        return face, parts, clip

    # Sad: inner ends of the eyebrows up, outer ends down; eyelids a little lowered.
    face, parts, clip = upper_face()
    face.place(parts["near_brow"], (276, 103), angle=17, move=(1.0, -1.5))
    face.place(parts["far_brow"], (363.5, 104), angle=-15, clip=clip)
    for area, test, skin, lid, width, eye_clip in (
            (near_eye_area, not_skin_near, skin_near, quad((266.0, 140.5), (286, 131.5), (310, 134.5)), 5.2, None),
            (far_eye_area, not_skin_far, skin_far, quad((334.5, 132.5), (347, 125.0), (363, 127.0)), 4.8, clip)):
        eye = face.pixel_mask(src, area, test, 1.6)
        over_lid = face.mask_polygon(lid + [(lid[-1][0], 100), (lid[0][0], 100)])
        covered = Image.composite(eye, Image.new("L", face.size, 0), over_lid)
        if eye_clip is not None:
            covered = Image.composite(covered, Image.new("L", face.size, 0), eye_clip)
        face._paste(covered, skin, 0.4, None)
        on_eye = eye if eye_clip is None else Image.composite(eye, Image.new("L", face.size, 0), eye_clip)
        face.stroke(lid, width, line, clip=on_eye)
    face.save("face_sad.png")

    # Surprised: eyebrows high, eyes a little wider.
    face, parts, clip = upper_face()
    face.place(parts["near_brow"], (276, 103), angle=-3, move=(0.0, -9.0))
    face.place(parts["far_brow"], (363.5, 104), angle=-11, move=(0.0, -2.0), clip=clip)
    face.place(parts["near_eye"], (288, 148), scale=1.14)
    wide_clip = face.mask_polygon([(300, 60), (361.6, 60), (361.6, 151), (357, 163), (300, 180)])
    face.place(parts["far_eye"], (361.6, 138), scale=1.12, clip=wide_clip)
    face.save("face_surprised.png")

    build_heart_arm(src, line)

    layout = {
        "source": "assets/cut/grandpa_bench/grandpa_seated.png",
        "canvas": list(src.size),
        "eyes_box": list(EYES_BOX),
        "upper_box": list(UPPER_BOX),
        "mouth_box": list(MOUTH_BOX),
        "arm_box": list(ARM_BOX),
        "elbow": list(ELBOW),
        "arm_rest_angle": ARM_REST_ANGLE,
        "note": "Boxes are [left, top, right, bottom] in the picture's pixels. arm_fore.png is drawn raised"
                " (hand on heart); turning it arm_rest_angle degrees clockwise around `elbow` lays it where"
                " the forearm is in the picture. Made by tools/build_grandpa_face.py.",
    }
    (OUT / "face_layout.json").write_text(json.dumps(layout, indent=2) + "\n", encoding="utf-8")


def smooth(points, rounds=3):
    """Rounds the corners of an open line (corner cutting); the two ends stay where they are."""
    for _ in range(rounds):
        out = [points[0]]
        for (x0, y0), (x1, y1) in zip(points, points[1:]):
            out.append((x0 * 0.75 + x1 * 0.25, y0 * 0.75 + y1 * 0.25))
            out.append((x0 * 0.25 + x1 * 0.75, y0 * 0.25 + y1 * 0.75))
        out.append(points[-1])
        points = out
    return points


def build_heart_arm(src, line):
    """The greeting: his right forearm lifts and the hand rests on his heart.

    arm_cover.png hides the forearm drawn in the picture (waistcoat painted where it was).
    arm_fore.png is the forearm in its raised pose; the rig turns it around the elbow.
    """
    import math
    from PIL import ImageOps
    sleeve = sample(src, 205, 490, 3)
    fold = sample(src, 322, 517, 1)
    green = sample(src, 272, 430, 3)
    hand_skin = sample(src, 440, 525, 2)

    cover = Layer(ARM_BOX)
    cover.fill(FOREARM_AREA, green, feather=0.6)
    cover.stroke(smooth(ELBOW_CURVE, 2), 6.0, line)
    cover.save("arm_cover.png")

    arm = Layer(ARM_BOX)
    theta = math.radians(ARM_RAISED_ANGLE)
    ux, uy = math.cos(theta), math.sin(theta)

    def at(point):
        u, v = point
        return (ELBOW[0] + u * ux - v * uy, ELBOW[1] + u * uy + v * ux)

    # The hand: the picture's own hand, mirrored and turned so that it lies flat on his chest.
    hand_layer = Layer(HAND_SOURCE_BOX)
    is_hand = lambda rgb: rgb[0] > 215 and rgb[1] < 192 and rgb[0] - rgb[2] > 125
    hand_mask = hand_layer.pixel_mask(src, HAND_AREA, is_hand, 4.0)
    hand = ImageOps.mirror(hand_layer.cut(src, hand_mask, feather=0.3))
    px, py = hand_layer.pt(HAND_WRIST)
    px = hand.size[0] - px
    tx, ty = arm.pt(at(HAND_WRIST_LOCAL))
    a = math.radians(HAND_TURN)
    c, s = math.cos(a) / HAND_SCALE, math.sin(a) / HAND_SCALE
    matrix = (c, -s, px - c * tx + s * ty, s, c, py - s * tx - c * ty)
    arm.image.alpha_composite(hand.convert("RGBa").transform(arm.size, Image.AFFINE, matrix, Image.BICUBIC).convert("RGBA"))

    outline = smooth([at(p) for p in SLEEVE_OUTLINE])
    shape = outline + [at(p) for p in SLEEVE_BACK]
    # Where the sleeve joins the upper arm there is no line: blend the cloth softly there.
    back = arm.mask_polygon([at((-52, -52)), at((2, -33)), at((-6, 0)), at((-24, 30)), at((-52, 22))])
    arm.fill(shape, sleeve, feather=1.6, clip=back)
    arm.fill(shape, sleeve)
    inside_sleeve = arm.mask_polygon(shape)
    arm.stroke(smooth([at((14, 30)), at((40, 24)), at((62, 27))]), 5.0, fold, clip=inside_sleeve)
    arm.stroke(outline, 6.0, line)
    arm.save("arm_fore.png")


def review(path):
    """Original and every patch over the picture, 4x, for checking by eye."""
    src = Image.open(SOURCE).convert("RGBA")
    box = (215, 60, 415, 290)
    sets = [[], ["eyes_closed"], ["mouth_half"], ["mouth_open"], ["face_sad", "mouth_sad"],
            ["face_surprised", "mouth_surprised"], ["face_sad", "eyes_closed", "mouth_sad"], ["arm"]]
    boxes = {"eyes": EYES_BOX, "mouth": MOUTH_BOX, "face": UPPER_BOX}
    z = 4
    w, h = (box[2] - box[0]) * z, (box[3] - box[1]) * z
    sheet = Image.new("RGB", (w * 4, h * 2), (255, 244, 222))
    for i, names in enumerate(sets):
        frame = Image.new("RGBA", src.size, (255, 244, 222, 255))
        frame.alpha_composite(src)
        crop = box
        for n in names:
            if n == "arm":
                frame.alpha_composite(Image.open(OUT / "arm_cover.png"), ARM_BOX[:2])
                frame.alpha_composite(Image.open(OUT / "arm_fore.png"), ARM_BOX[:2])
                crop = (110, 250, 410, 595)
                continue
            b = boxes[n.split("_")[0]]
            frame.alpha_composite(Image.open(OUT / (n + ".png")), (b[0], b[1]))
        tile = frame.crop(crop)
        k = min(w / tile.size[0], h / tile.size[1])
        tile = tile.resize((int(tile.size[0] * k), int(tile.size[1] * k)), Image.LANCZOS)
        sheet.paste(tile.convert("RGB"), ((i % 4) * w, (i // 4) * h))
    sheet.save(path)


if __name__ == "__main__":
    import sys
    build()
    if len(sys.argv) > 1:
        review(sys.argv[1])
    print("Grandpa face patches written to", OUT)
