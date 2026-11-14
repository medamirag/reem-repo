"""Arrange the eight unpainted Godot captures into a labelled review image."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
ROOT = Path(__file__).resolve().parents[1]
folder = ROOT / 'docs/reem_torso_outline'
sheet = Image.new('RGB', (1600, 1040), '#fff4de')
draw = ImageDraw.Draw(sheet)
font = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 22)
for index in range(8):
    frame = Image.open(folder / f'walk_{index + 1}_rgba.png').convert('RGBA')
    frame = frame.crop((350, 50, 1040, 1370))
    frame.thumbnail((390, 455), Image.Resampling.LANCZOS)
    x = index % 4 * 400 + (400 - frame.width) // 2
    y = index // 4 * 520 + 12
    sheet.paste(frame, (x, y), frame)
    label = ['Contact', 'Down', 'Passing', 'Up'][index % 4]
    draw.text((index % 4 * 400 + 25, index // 4 * 520 + 482), f'{index + 1}. {label}', font=font, fill='#4c2e1d')
sheet.save(folder / 'eight_poses.png')
print('[WALK] Saved docs/reem_torso_outline/eight_poses.png from actual Godot renders')

legs = Image.new('RGB', (2600, 708), '#fff4de')
for index in range(8):
    frame = Image.open(folder / f'walk_{index + 1}_rgba.png').convert('RGBA')
    frame = frame.crop((396, 996, 1046, 1350))
    legs.paste(frame, (index % 4 * 650, index // 4 * 354), frame)
legs.save(folder / 'legs_closeups.png')

shoulders = Image.new('RGB', (1300, 620), '#fff4de')
for index in range(8):
    frame = Image.open(folder / f'walk_{index + 1}_rgba.png').convert('RGBA')
    frame = frame.crop((540, 475, 865, 785))
    shoulders.paste(frame, (index % 4 * 325, index // 4 * 310), frame)
shoulders.save(folder / 'shoulders_closeups.png')

# True 400% source-pixel inspection: nearest-neighbour enlargement cannot hide
# alpha fragments, outline gaps or steps through smoothing.
zoom = Image.new('RGB', (5120, 2800), '#fff4de')
zd = ImageDraw.Draw(zoom)
zfont = ImageFont.truetype('C:/Windows/Fonts/arial.ttf', 30)
bob = [0, 31.35, -15.675, -31.35, 0, 31.35, -15.675, -31.35]
for index in range(8):
    image = Image.open(folder / f'walk_{index + 1}_rgba.png').convert('RGBA')
    y = 390 + 96 + round(bob[index])
    crop = image.crop((460 + 96, y, 780 + 96, y + 340))
    crop = crop.resize((1280,1360), Image.Resampling.NEAREST)
    x = index % 4 * 1280
    top = index // 4 * 1400
    zoom.paste(crop, (x,top + 40), crop)
    zd.text((x+15,top+3), f'{index+1}. '+['Contact','Down','Passing','Up'][index%4]+' - 400%',font=zfont,fill='#4c2e1d')
zoom.save(folder / 'torso_all_8_400pct.png')
