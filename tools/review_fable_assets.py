from pathlib import Path
import json
from PIL import Image,ImageDraw,ImageFont
m=[c for c in json.loads(Path('docs/rigs/character_manifest.json').read_text()) if c['tier']!='code_only'];font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',16)
for batch in range((len(m)+5)//6):
 out=Image.new('RGB',(1120,1440),'#fff4de');d=ImageDraw.Draw(out)
 for row,c in enumerate(m[batch*6:batch*6+6]):
  meta=json.loads((Path('game/rig_parts')/c['name']/'layout.json').read_text());src=Image.open(c['current_sprite']).convert('RGBA');boxes=meta['eyes']+[meta['mouth']];x0=min(b[0] for b in boxes);y0=min(b[1] for b in boxes);x1=max(b[2] for b in boxes);y1=max(b[3] for b in boxes);pad=max(x1-x0,y1-y0)*.4;box=(max(0,int(x0-pad)),max(0,int(y0-pad)),min(src.width,int(x1+pad)),min(src.height,int(y1+pad)))
  for col,state in enumerate(['original','eyes_closed','mouth_open','mouth_closed']):
   im=src.copy()
   if state in meta.get('erase_runs',{}):
    mask=Image.new('L',src.size);md=ImageDraw.Draw(mask)
    for yy,x0,x1 in meta['erase_runs'][state]:md.line((x0,yy,x1-1,yy),fill=255)
    from PIL import ImageChops;im.putalpha(ImageChops.subtract(im.getchannel('A'),mask))
   if state!='original':im.alpha_composite(Image.open(Path('game/rig_parts')/c['name']/(state+'.png')).convert('RGBA'))
   im=im.crop(box);im.thumbnail((270,210));out.paste(im,(col*280+5,row*240+26),im);d.text((col*280+5,row*240+4),c['name']+' '+state,font=font,fill='black')
 out.save(f'docs/rigs/face_overlays_review_{batch+1}.png')

# Full-rig comparisons, plus honest game-size and source-pixel 400% crops.
full=[c for c in m if c['tier']=='full']
comparison=Image.new('RGB',(1500,1000),'#fff4de');cd=ImageDraw.Draw(comparison)
zoom=Image.new('RGB',(1920,1000),'#fff4de');zd=ImageDraw.Draw(zoom)
game=Image.new('RGB',(1000,600),'#fff4de');gd=ImageDraw.Draw(game)
for row,c in enumerate(full):
 meta=json.loads((Path('game/rig_parts')/c['name']/'layout.json').read_text());src=Image.open(c['current_sprite']).convert('RGBA');rest=Image.open(Path('game/rig_parts')/c['name']/'neutral_assembly.png').convert('RGBA')
 for col,(label,im) in enumerate([('original',src),('source-cut assembly',rest),('blank head',Image.open(Path('game/rig_parts')/c['name']/'head_blank.png').convert('RGBA'))]):
  if col==2:im=im.crop(im.getbbox())
  im=im.copy();im.thumbnail((480,450));comparison.paste(im,(col*500+10,row*500+35),im);cd.text((col*500+10,row*500+5),c['name']+' '+label,font=font,fill='black')
 scale=.438 if c['name']=='grandpa' else .3617
 thumb=rest.resize((round(rest.width*scale),round(rest.height*scale)),Image.Resampling.LANCZOS);x=row*500;game.paste(thumb,(x+20,40),thumb);gd.text((x+20,5),c['name']+' at current game scale',font=font,fill='black')
 for col,state in enumerate(['original','eyes_closed','mouth_open','mouth_closed']):
  im=src.copy()
  if state!='original':im.alpha_composite(Image.open(Path('game/rig_parts')/c['name']/(state+'.png')).convert('RGBA'))
  boxes=meta['eyes']+[meta['mouth']];x0=min(b[0] for b in boxes)-15;y0=min(b[1] for b in boxes)-15;x1=max(b[2] for b in boxes)+15;y1=max(b[3] for b in boxes)+15
  crop=im.crop((x0,y0,x1,y1)).resize(((x1-x0)*4,(y1-y0)*4),Image.Resampling.BICUBIC)
  # Crop inspection windows without shrinking the 4x pixels.
  crop=crop.crop((0,0,min(475,crop.width),min(455,crop.height)));zoom.paste(crop,(col*480,row*500+35),crop);zd.text((col*480+5,row*500+5),c['name']+' '+state+' 400%',font=font,fill='black')
comparison.save('docs/rigs/full_rigs_comparison.png');game.save('docs/rigs/full_rigs_game_size.png');zoom.save('docs/rigs/full_faces_400pct.png')
