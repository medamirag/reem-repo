"""Arrange the eight unpainted Godot captures into a labelled review image."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
ROOT = Path(__file__).resolve().parents[1]
folder = ROOT / 'docs/reem_walk'
sheet = Image.new('RGB', (1600, 1040), '#fff4de')
draw = ImageDraw.Draw(sheet)
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 22)
for index in range(8):
    frame = Image.open(folder / f'walk_{index + 1}_rgba.png').convert('RGBA')
    frame = frame.crop((350, 0, 890, 1254))
    frame.thumbnail((390, 455), Image.Resampling.LANCZOS)
    x = index % 4 * 400 + (400 - frame.width) // 2
    y = index // 4 * 520 + 12
    sheet.paste(frame, (x, y), frame)
    label = ['Contact', 'Down', 'Passing', 'Up'][index % 4]
    draw.text((index % 4 * 400 + 25, index // 4 * 520 + 482), f'{index + 1}. {label}', font=font, fill='#4c2e1d')
sheet.save(folder / 'eight_poses.png')
print('[WALK] Saved docs/reem_walk/eight_poses.png from actual Godot renders')

legs = Image.new('RGB', (1440, 680), '#fff4de')
for index in range(8):
    frame = Image.open(folder / f'walk_{index + 1}_rgba.png').convert('RGBA')
    frame = frame.crop((440, 920, 800, 1260))
    legs.paste(frame, (index % 4 * 360, index // 4 * 340), frame)
legs.save(folder / 'legs_closeups.png')
