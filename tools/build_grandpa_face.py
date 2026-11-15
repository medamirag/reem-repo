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

    def pixels(self, src, region, test, colour, grow=1.6, feather=0.5, clip=None):
        """Paints `colour` over every picture pixel inside `region` for which test(rgb) is true."""
        b = self.box
        small = Image.new("L", (b[2] - b[0], b[3] - b[1]), 0)
        inside = Image.new("L", small.size, 0)
        ImageDraw.Draw(inside).polygon([(x - b[0], y - b[1]) for x, y in region], fill=255)
        for j in range(small.size[1]):
            for i in range(small.size[0]):
                if inside.getpixel((i, j)) and test(src.getpixel((i + b[0], j + b[1]))[:3]):
                    small.putpixel((i, j), 255)
        mask = small.resize(self.size, Image.BICUBIC).point(lambda v: 255 if v > 96 else 0)
        mask = mask.filter(ImageFilter.MaxFilter(int(grow * S) * 2 + 1))
        self._paste(mask, colour, feather, clip)

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
    eyes.pixels(src, oval((288, 147), 25, 29), far_from(skin_near, 26), skin_near)
    # The far eye touches the outline of the face: keep that outline (x >= 362).
    clip = eyes.mask_polygon([(320, 100), (361.8, 100), (361.8, 180), (320, 180)])
    eyes.pixels(src, oval((348, 138), 21, 27), far_from(skin_far, 26), skin_far, clip=clip)
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

    # --- Sad and surprised: the smile line is replaced by a flatter one --------------------
    for name, middle_y, with_o in (("mouth_sad.png", 210.5, False), ("mouth_surprised.png", 212.5, True)):
        mouth = Layer(MOUTH_BOX)
        ends = ((300.8, 219.6), (373.5, 218.5)) if not with_o else ((301.5, 217), (373, 215.5))
        new_line = quad(ends[0], (338, middle_y), ends[1])
        # Old corners (the little up-turned ends of the smile) become moustache again.
        dark = lambda rgb: sum(rgb) < 520 and rgb[0] - rgb[2] < 60
        mouth.pixels(src, [(301.5, 198), (318, 198), (318, 219), (303, 219), (300.5, 212), (296, 210), (296, 204)], dark, white_left, grow=1.3)
        mouth.pixels(src, [(366, 203.5), (381, 203), (382.3, 211), (377.5, 219), (364, 221.5)], dark, white_left, grow=1.3)
        # The lip's old left corner (outline and a little skin above the new line) too.
        mouth.fill([(295, 204.5), (306, 204.5), (307.5, 215.5), (304, 217.6), (299, 217.8), (295.3, 214)], white_left, feather=0.4)
        # Everything between the new line and the old smile becomes lip.
        under = new_line + [(374.5, 224), (372, 227), (360, 229), (350, 230.5), (340, 230.5), (330, 229.5),
                            (320, 227), (312, 224.5), (303, 223.5)]
        mouth.fill(under, lip, feather=0.7)
        mouth.stroke(new_line, 4.8, line)
        if with_o:
            mouth.ellipse((338.5, 233), 9.5, 11.5, line)
            mouth.ellipse((338.5, 233), 6.0, 8.0, inside)
        mouth.save(name)

    layout = {
        "source": "assets/cut/grandpa_bench/grandpa_seated.png",
        "canvas": list(src.size),
        "eyes_box": list(EYES_BOX),
        "mouth_box": list(MOUTH_BOX),
        "note": "Boxes are [left, top, right, bottom] in the picture's pixels. Made by tools/build_grandpa_face.py.",
    }
    (OUT / "face_layout.json").write_text(json.dumps(layout, indent=2) + "\n", encoding="utf-8")


def review(path):
    """Original and every patch over the picture, 6x, for checking by eye."""
    src = Image.open(SOURCE).convert("RGBA")
    box = (215, 80, 415, 290)
    sets = [[], ["eyes_closed"], ["mouth_half"], ["mouth_open"], ["mouth_sad"], ["mouth_surprised"]]
    boxes = {"eyes": EYES_BOX, "mouth": MOUTH_BOX}
    z = 4
    w, h = (box[2] - box[0]) * z, (box[3] - box[1]) * z
    sheet = Image.new("RGB", (w * 3, h * 2), (255, 244, 222))
    for i, names in enumerate(sets):
        frame = Image.new("RGBA", src.size, (255, 244, 222, 255))
        frame.alpha_composite(src)
        for n in names:
            b = boxes[n.split("_")[0]]
            frame.alpha_composite(Image.open(OUT / (n + ".png")), (b[0], b[1]))
        sheet.paste(frame.crop(box).resize((w, h), Image.LANCZOS).convert("RGB"), ((i % 3) * w, (i // 3) * h))
    sheet.save(path)


if __name__ == "__main__":
    import sys
    build()
    if len(sys.argv) > 1:
        review(sys.argv[1])
    print("Grandpa face patches written to", OUT)
