"""Check source cutouts and compare the actual rendered neutral pose with the original."""
from pathlib import Path
from PIL import Image,ImageChops
ROOT=Path(__file__).resolve().parents[1]
im=Image.open(ROOT/'assets/art/characters/reem/reem_base.png').convert('RGBA')
alpha=Image.new('L',im.size)
for path in sorted((ROOT/'game/characters/reem/aligned').glob('*.png')):
 layer=Image.open(path).convert('RGBA');assert layer.size==im.size
 alpha=ImageChops.lighter(alpha,layer.getchannel('A'))
assert ImageChops.difference(alpha,im.getchannel('A')).getbbox() is None,'Source cutouts lose or add source alpha'
print('[ALIGN PIXELS] ok: source cutouts preserve original alpha at every pixel')
render=ROOT/'docs/reem_alignment/neutral_rgba.png'
if render.exists():
 actual=Image.open(render).convert('RGBA');assert actual.size==im.size
 lost=outside=different=0;maximum=0
 def pixels(image):return getattr(image,'get_flattened_data',image.getdata)()
 for original,pixel in zip(pixels(im),pixels(actual)):
  if original[3]>200 and pixel[3]<128:lost+=1
  if original[3]<16 and pixel[3]>128:outside+=1
  if original[3]>250:
   delta=max(abs(original[k]-pixel[k]) for k in range(3));maximum=max(maximum,delta)
   if delta>12:different+=1
 print(f'[ALIGN PIXELS] neutral lost={lost}, outside={outside}, colour difference >12={different}, max={maximum}')
 assert lost==0 and outside==0,'Rendered neutral has gaps or exceeds original silhouette'
 assert different<250,'Neutral colours no longer match original artwork'
 print('[ALIGN PIXELS] ok: rendered neutral matches original silhouette and colours')
