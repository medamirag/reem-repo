"""Draws the blink and talking-mouth patches of the LIGHT characters (Shahd and the valley animals).

Run from the project folder:  python tools/build_light_faces.py [review_folder]

Same method as tools/build_grandpa_face.py (its drawing helpers are reused): each original picture
is only read; every patch is a small transparent PNG in game/light_rigs/<name>/ in the picture's
own pixel coordinates, and the boxes are written to game/light_rigs/<name>/layout.json.

Where the eyes and the mouth are comes from the measured boxes in game/rig_parts/<name>/layout.json
(Codex's preparation). TUNING below corrects single characters by hand.

- eyes_closed.png: the eye is painted over with the colour around it, then one curved lash line.
- mouth_half.png / mouth_open.png: only for characters drawn with a closed smile. The smile line
  stays; the jaw drops under it. Characters drawn with an open mouth or a beak have no mouth patch
  (they bounce while talking instead).
"""
import json
import sys
from pathlib import Path
from PIL import Image, ImageDraw

import build_grandpa_face as kit

ROOT = Path(__file__).resolve().parents[1]
PARTS = ROOT / "game/rig_parts"
OUT = ROOT / "game/light_rigs"

# name -> game speaker (AGENTS.md voice table), has a drawn closed smile?
CHARACTERS = {
    "bees": ("Shahd", False),  # no drawn mouth: she keeps her TalkingMouth node
    "duck": ("Duck", False),
    "duckling1": ("", False),
    "duckling2": ("", False),
    "duckling3": ("", False),
    "arnoob": ("Arnoob", False),
    "sinjoob": ("Sinjoob", True),
    "qunfood": ("Qunfood", True),
    "qatqoota": ("Qatqoota", True),
    "ankoob": ("Ankoob", False),
    "dafdoof": ("Dafdoof", False),
    "ghazlana": ("Ghazlana", True),
    "dubb": ("Dubb", True),
    "tawoos": ("Tawoos", False),
    "qarqoor": ("Qarqoor", True),
}

# Hand corrections. Keys:
#   eyes: list of (cx, cy, rx, ry) replacing the measured eye boxes
#   skin: list of (x, y) points where the colour around each eye is sampled
#   lash: list of (droop, width) per eye; droop is a fraction of the eye height
#   lash_span: fraction of the eye width covered by the lash line
#   smile: (x0, x1) part of the smile line that opens; depth: (half, open) in pixels
#   mouth_skin: (x, y) unused; inside: colour of the open mouth
#   cover: extra (cx, cy, rx, ry, (sample x, y)) ovals painted before the lash (stray lashes)
#   restore: list of (three points, width): outline strokes redrawn after the eye is painted over
TUNING = {
    "bees": {"eyes": [(412, 238, 52, 70), (497, 237, 27, 62)], "skin": [(440, 330), (440, 330)],
             "cover": [(378, 214, 24, 26, (440, 330))],
             "lash": [(0.17, 8.0), (0.17, 8.0)]},
    "dafdoof": {"eyes": [(591, 216, 74, 98)], "skin": [(700, 335)], "feather": 1.0, "lash": [(0.16, 8.0)]},
    "qarqoor": {"eyes": [(333, 338, 40, 65), (464, 352, 76, 86)], "skin": [(374, 290), (374, 290)],
                "mouth_box": (296, 452, 452, 532), "smile": (322, 428), "depth": (20, 36)},
    "tawoos": {"eyes": [(812, 265, 50, 47)], "skin": [(760, 230)], "cover": [(782, 242, 14, 12, (760, 230))]},
    "qatqoota": {"smile": (972, 1032), "depth": (9, 17)},
    "ghazlana": {"depth": (12, 22)},
    "qunfood": {"depth_scale": 0.62},
    "sinjoob": {"depth_scale": 0.8},
}


def darkest(src, share=0.03):
    """The picture's outline colour: the middle of its darkest opaque pixels."""
    small = src.resize((src.width // 4, src.height // 4), Image.BOX)
    px = [small.getpixel((x, y)) for x in range(small.width) for y in range(small.height)]
    px = [p[:3] for p in px if p[3] > 250]
    px.sort(key=sum)
    px = px[int(len(px) * 0.005):max(2, int(len(px) * share))]
    return px[len(px) // 2]


def around(src, centre, rx, ry):
    """Median colour of the ring just outside an oval (the fur or skin around an eye)."""
    px = []
    for point in kit.oval(centre, rx * 1.28, ry * 1.28, 40) + kit.oval(centre, rx * 1.45, ry * 1.45, 40):
        x, y = int(point[0]), int(point[1])
        if 0 <= x < src.width and 0 <= y < src.height:
            p = src.getpixel((x, y))
            if p[3] > 250:
                px.append(p[:3])
    px.sort(key=sum)
    # The lighter half: the ring also crosses outlines and brows.
    return px[int(len(px) * 0.7)] if px else (255, 255, 255)


def alpha_clip(layer, src):
    """4x mask of the picture's own opaque area inside the layer (patches never leave the body)."""
    b = layer.box
    return src.crop(b).getchannel("A").resize(layer.size, Image.BICUBIC).point(lambda v: 255 if v > 200 else 0)


def smile_line(src, box, line, span):
    """Centre of the drawn smile line: for every column, the middle of its dark pixels."""
    points = []
    for x in range(box[0], box[2]):
        ys = [y for y in range(box[1], box[3])
              if src.getpixel((x, y))[3] > 200 and sum(abs(src.getpixel((x, y))[k] - line[k]) for k in range(3)) < 110]
        if ys:
            # Keep the lowest run of dark pixels in the column (the smile, not a nose above it).
            run = [ys[-1]]
            for y in reversed(ys[:-1]):
                if run[-1] - y > 2:
                    break
                run.append(y)
            points.append((x, sum(run) / len(run)))
    if span:
        points = [p for p in points if span[0] <= p[0] <= span[1]]
    # Smooth a little.
    out = []
    for i in range(len(points)):
        near = points[max(0, i - 3):i + 4]
        out.append((points[i][0], sum(p[1] for p in near) / len(near)))
    return out


def build(name):
    layout = json.loads((PARTS / name / "layout.json").read_text(encoding="utf-8"))
    tune = TUNING.get(name, {})
    src = Image.open(ROOT / layout["source"]).convert("RGBA")
    out = OUT / name
    out.mkdir(parents=True, exist_ok=True)
    kit.OUT = out
    line = tuple(tune.get("line", darkest(src)))

    eyes = tune.get("eyes")
    if eyes is None:
        eyes = [((b[0] + b[2]) / 2, (b[1] + b[3]) / 2, (b[2] - b[0]) / 2 * 1.1, (b[3] - b[1]) / 2 * 1.1)
                for b in layout["eyes"]]
    pad = 14
    eyes_box = (int(min(e[0] - e[2] for e in eyes)) - pad, int(min(e[1] - e[3] for e in eyes)) - pad,
                int(max(e[0] + e[2] for e in eyes)) + pad, int(max(e[1] + e[3] for e in eyes)) + pad)
    eyes_box = (max(0, eyes_box[0]), max(0, eyes_box[1]), min(src.width, eyes_box[2]), min(src.height, eyes_box[3]))
    layer = kit.Layer(eyes_box)
    clip = alpha_clip(layer, src)
    for index, (cx, cy, rx, ry) in enumerate(eyes):
        skin = kit.sample(src, *tune["skin"][index], 3) if "skin" in tune else around(src, (cx, cy), rx, ry)
        layer.fill(kit.oval((cx, cy), rx, ry), skin, feather=tune.get("feather", 2.0), clip=clip)
        if index == 0:
            for ox, oy, orx, ory, at in tune.get("cover", []):
                layer.fill(kit.oval((ox, oy), orx, ory), kit.sample(src, at[0], at[1], 3), feather=2.0, clip=clip)
            for points, stroke_width in tune.get("restore", []):
                layer.stroke(kit.quad(*points), stroke_width, line, clip=clip)
        droop, width = tune.get("lash", [(0.2, max(4.0, min(9.0, ry * 0.16)))] * len(eyes))[index]
        span = tune.get("lash_span", 0.8)
        y0 = cy + ry * tune.get("lash_y", 0.12)
        lash = kit.quad((cx - rx * span, y0), (cx, y0 + ry * 2 * droop), (cx + rx * span, y0))
        layer.stroke(lash, width, line, clip=clip)
    layer.save("eyes_closed.png")

    result = {
        "source": layout["source"],
        "canvas": list(src.size),
        "speaker": CHARACTERS[name][0],
        "eyes_box": list(eyes_box),
        "note": "Boxes are [left, top, right, bottom] in the picture's pixels. Made by tools/build_light_faces.py.",
    }

    if CHARACTERS[name][1]:
        b = tune.get("mouth_box", layout["mouth"])
        points = smile_line(src, b, line, tune.get("smile"))
        x0, x1 = points[0][0], points[-1][0]
        width = x1 - x0
        k = tune.get("depth_scale", 1.0)
        depths = tune.get("depth", (width * 0.2 * k, width * 0.38 * k))
        mouth_box = (int(x0) - pad, int(min(p[1] for p in points)) - pad,
                     int(x1) + pad, int(max(p[1] for p in points) + depths[1]) + pad)
        top = [(x, y + 0.5) for x, y in points]
        mid = tune.get("jaw_x", (x0 + x1) / 2)
        mid_y = kit.interp(points, mid)
        for file, depth in (("mouth_half.png", depths[0]), ("mouth_open.png", depths[1])):
            mouth = kit.Layer(mouth_box)
            body = alpha_clip(mouth, src)
            bottom = kit.quad(top[-1], (mid, mid_y + depth), top[0])
            shape = top + bottom
            mouth.fill(shape, tuple(tune.get("inside", (122, 38, 30))), clip=body)
            inside = mouth.mask_polygon(shape)
            mouth.ellipse((mid, mid_y + depth + width * 0.04), width * 0.27, depth * 0.42, (236, 128, 118),
                          clip=Image.composite(inside, Image.new("L", mouth.size, 0), body))
            stroke = tune.get("mouth_line", max(4.0, min(8.0, width * 0.06)))
            mouth.stroke(bottom, stroke * 0.9, line, clip=body)
            mouth.stroke(top, stroke, line, clip=body)
            mouth.save(file)
        result["mouth_box"] = list(mouth_box)

    for key in ("extra_anchor", "extra_mask"):
        if key in layout:
            result[key] = layout[key]
    (out / "layout.json").write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    return src, result


def review(name, src, result, folder):
    """Original, blink, half and open mouth around the face, for checking by eye."""
    boxes = [result["eyes_box"]] + ([result["mouth_box"]] if "mouth_box" in result else [])
    left, top = min(b[0] for b in boxes), min(b[1] for b in boxes)
    right, bottom = max(b[2] for b in boxes), max(b[3] for b in boxes)
    margin = int(max(right - left, bottom - top) * 0.45)
    crop = (max(0, left - margin), max(0, top - margin), min(src.width, right + margin), min(src.height, bottom + margin))
    sets = [[], ["eyes_closed"]] + ([["mouth_half"], ["eyes_closed", "mouth_open"]] if "mouth_box" in result else [])
    side = 330
    sheet = Image.new("RGB", (side * 4, side), (255, 244, 222))
    for i, names in enumerate(sets):
        frame = Image.new("RGBA", src.size, (255, 244, 222, 255))
        frame.alpha_composite(src)
        for n in names:
            b = result["eyes_box" if n.startswith("eyes") else "mouth_box"]
            frame.alpha_composite(Image.open(OUT / name / (n + ".png")), (b[0], b[1]))
        tile = frame.crop(crop)
        tile.thumbnail((side - 6, side - 6), Image.LANCZOS)
        sheet.paste(tile.convert("RGB"), (i * side + 3, 3))
    ImageDraw.Draw(sheet).text((6, 4), name, fill=(60, 40, 20))
    sheet.save(Path(folder) / (name + ".png"))


if __name__ == "__main__":
    only = [a for a in sys.argv[2:]]
    for character in CHARACTERS:
        if only and character not in only:
            continue
        picture, made = build(character)
        if len(sys.argv) > 1:
            Path(sys.argv[1]).mkdir(parents=True, exist_ok=True)
            review(character, picture, made, sys.argv[1])
    print("Light face patches written to", OUT)
