"""Compose untouched Godot renders at game scale and 4x game scale."""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
ROOT=Path(__file__).resolve().parents[1]
folder=ROOT/'docs/reem_walk_final'
font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',22)
labels=['Contact','Down','Passing','Up']
sheet=Image.new('RGB',(1200,1128),'#fff4de');draw=ImageDraw.Draw(sheet)
zoom=Image.new('RGB',(2080,1220),'#fff4de');zd=ImageDraw.Draw(zoom)
bob=[0,31.35,-15.675,-31.35]*2
for i in range(8):
    game=Image.open(folder/f'walk_{i+1}_game.png').convert('RGBA').crop((120,0,420,524))
    x=i%4*300;y=i//4*564
    sheet.paste(game,(x,y+34),game);draw.text((x+12,y+5),f'{i+1}. {labels[i%4]} - 100%',font=font,fill='#4c2e1d')
    actual_zoom=Image.open(folder/f'walk_{i+1}_zoom.png').convert('RGBA')
    left=round((450+96)*1.448);top=round((380+96+bob[i])*1.448)
    crop=actual_zoom.crop((left,top,left+520,top+570))
    x=i%4*520;y=i//4*610
    zoom.paste(crop,(x,y+36),crop);zd.text((x+12,y+5),f'{i+1}. {labels[i%4]} - 400%',font=font,fill='#4c2e1d')
sheet.save(folder/'walk_game_100pct.png');zoom.save(folder/'torso_game_400pct.png')
print('[REVIEW] saved actual game-size and 4x filtered Godot renders')
