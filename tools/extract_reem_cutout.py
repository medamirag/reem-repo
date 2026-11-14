"""Extract generated atlas cells; ignore near-invisible alpha when finding part bounds."""
from pathlib import Path
from PIL import Image
ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / 'game/characters/reem/cutout'
NAMES = ['head','eyes_open','eyes_closed','mouth_closed','mouth_open','mouth_smile','mouth_sad','mouth_surprised','torso','arm_upper_back','arm_lower_back','hand_back','arm_upper_front','arm_lower_front','hand_front','leg_upper_back','leg_lower_back','foot_back','leg_upper_front','leg_lower_front','foot_front']
SIZES = [(383,510),(80,130),(80,130)] + [(42,28)]*5 + [(327,555),(95,165),(85,155),(75,115),(95,165),(85,155),(75,115),(110,140),(100,140),(150,75),(110,140),(100,140),(150,75)]
image = Image.open(DEST / 'atlas.png').convert('RGBA')
for index, (name, size) in enumerate(zip(NAMES,SIZES)):
    x,y = (index%5)*256,(index//5)*256
    start_y = y + (24 if index == 5 else 28 if index == 13 else 0)
    part = image.crop((x,start_y,x+256,y+(278 if index in (0,8) else 256)))
    bounds = part.getchannel('A').point(lambda a: 255 if a >= 80 else 0).getbbox()
    assert bounds, name
    part = part.crop(bounds)
    if name.startswith('mouth_'):
        part.thumbnail(size,Image.Resampling.LANCZOS)
        canvas = Image.new('RGBA',size)
        canvas.paste(part,((size[0]-part.width)//2,(size[1]-part.height)//2))
        part=canvas
    else:
        part=part.resize(size,Image.Resampling.LANCZOS)
    assert part.getchannel('A').getextrema()[0] == 0, name
    part.save(DEST / (name+'.png'))
    print('[CUTOUT] ok',name,size)
