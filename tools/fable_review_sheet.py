"""Arranges the pictures saved by tools/fable_review.gd into review sheets.

  python tools/fable_review_sheet.py grandpa

Writes, in docs/rigs/<name>_review/:
  poses_game_100pct.png  the eight poses at real game size (not resized)
  poses_400pct.png       the same eight poses rendered 4x larger by Godot
  face_closeup.png       the face of each pose, cut from the 4x render (not resized)
"""
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parents[1]
PAPER = (255, 244, 222)
INK = (70, 45, 30)
# Face box in picture pixels, and the scale the character has in the game.
FACES = {"grandpa": ((95, 0, 420, 320), 0.438, 24), "fox": ((500, 20, 880, 520), 0.3617, 24)}


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
    small = sorted(folder.glob("[0-9]_*_100.png"))
    big = sorted(folder.glob("[0-9]_*_400.png"))
    labels = [p.stem[:-4].replace("_", ". ", 1).replace("_", " ").capitalize() for p in small]
    sheet([Image.open(p).convert("RGBA") for p in small], [l + " - 100%" for l in labels], 4,
          folder / "poses_game_100pct.png", 15)
    sheet([Image.open(p).convert("RGBA") for p in big], [l + " - 400%" for l in labels], 4,
          folder / "poses_400pct.png", 40)
    box, scale, pad = FACES[name]
    k = scale * 4
    crop = tuple(int(v * k + pad * 4) for v in box)
    sheet([Image.open(p).convert("RGBA").crop(crop) for p in big], [l + " - face 400%" for l in labels], 4,
          folder / "face_closeup.png", 26)


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "grandpa")
