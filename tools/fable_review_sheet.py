"""Arranges the pictures saved by tools/fable_review.gd into review sheets.

  python tools/fable_review_sheet.py grandpa

Writes, in docs/rigs/<name>_review/:
  poses_game_100pct.png  the eight poses at real game size (not resized)
  poses_400pct.png       the same eight poses rendered 4x larger by Godot
  face_closeup.png       the face of each pose, cut from the 4x render (not resized)
  walk_game_100pct.png / walk_400pct.png  (Thaaloob) the eight walk frames
  fixed_expressions_400pct.png  (Grandpa) greeting, sad and surprised, upper body
"""
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
PAPER = (255, 244, 222)
INK = (70, 45, 30)
# Face box in picture pixels, and the scale the character has in the game.
FACES = {"grandpa": ((95, 0, 420, 320), 0.438, 24), "fox": ((420, 0, 900, 540), 0.3617, 24)}


def font(size):
    try:
        return ImageFont.truetype("arial.ttf", size)
    except OSError:
        return ImageFont.load_default()


def sheet(frames, labels, columns, path, label_size):
    w = max(f.size[0] for f in frames)
    h = max(f.size[1] for f in frames)
    top = label_size + 14
    rows = (len(frames) + columns - 1) // columns
    out = Image.new("RGB", (w * columns, (h + top) * rows), PAPER)
    draw = ImageDraw.Draw(out)
    for i, (frame, label) in enumerate(zip(frames, labels)):
        x, y = (i % columns) * w, (i // columns) * (h + top)
        draw.text((x + 12, y + 8), label, fill=INK, font=font(label_size))
        out.paste(frame, (x, y + top), frame)
    out.save(path)
    print("saved", path)


def main(name):
    folder = ROOT / "docs/rigs" / (name + "_review")
    box, scale, pad = FACES[name]
    k = scale * 4
    crop = tuple(int(v * k + pad * 4) for v in box)
    opened = lambda paths: [Image.open(p).convert("RGBA") for p in paths]
    titles = lambda paths: [p.stem[:-4].lstrip("wf").replace("_", ". ", 1).replace("_", " ").capitalize() for p in paths]
    if name == "fox":
        # Walk frames and face poses are saved with the prefixes w and f.
        small, big = sorted(folder.glob("w[0-9]_*_100.png")), sorted(folder.glob("w[0-9]_*_400.png"))
        faces = sorted(folder.glob("f[0-9]_*_400.png"))
        sheet(opened(small), [l + " - 100%" for l in titles(small)], 4, folder / "walk_game_100pct.png", 15)
        sheet(opened(big), [l + " - 400%" for l in titles(big)], 4, folder / "walk_400pct.png", 40)
        sheet([i.crop(crop) for i in opened(faces)], [l + " - face 400%" for l in titles(faces)], 3,
              folder / "face_closeup.png", 26)
        sheet(opened(sorted(folder.glob("f[0-9]_*_100.png"))), [l + " - 100%" for l in titles(faces)], 6,
              folder / "poses_game_100pct.png", 15)
        return
    small = sorted(folder.glob("[0-9]_*_100.png"))
    big = sorted(folder.glob("[0-9]_*_400.png"))
    labels = titles(small)
    sheet(opened(small), [l + " - 100%" for l in labels], 4, folder / "poses_game_100pct.png", 15)
    sheet(opened(big), [l + " - 400%" for l in labels], 4, folder / "poses_400pct.png", 40)
    sheet([i.crop(crop) for i in opened(big)], [l + " - face 400%" for l in labels], 4,
          folder / "face_closeup.png", 26)
    if name == "grandpa":
        # The three expressions the user asked to see: upper body, cut from the 4x render.
        wanted = [p for p in big if any(k in p.stem for k in ("sad", "surprised", "hand_on_heart"))]
        upper = tuple(int(v * k + pad * 4) for v in (40, 0, 520, 620))
        sheet([Image.open(p).convert("RGBA").crop(upper) for p in wanted],
              [p.stem[2:-4].replace("_", " ").capitalize() + " - 400%" for p in wanted], 3,
              folder / "fixed_expressions_400pct.png", 30)


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "grandpa")
