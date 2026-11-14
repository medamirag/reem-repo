"""Check source cutouts and compare the actual rendered neutral pose with the original."""
from pathlib import Path
import sys
from PIL import Image,ImageChops
ROOT=Path(__file__).resolve().parents[1]
original=Image.open(ROOT/'assets/art/characters/reem/reem_base.png').convert('RGBA')
im=Image.open(ROOT/'game/characters/reem/reem_clean_source.png').convert('RGBA')
assert ImageChops.difference(original.convert('RGB'),im.convert('RGB')).getbbox() is None
delta=ImageChops.difference(original.getchannel('A'),im.getchannel('A'))
box=delta.getbbox()
assert box is None or (box[1]>=420 and box[3]<=590), 'Cleanup changed pixels outside the collar/shoulder area'
alpha=Image.new('L',im.size)
for path in sorted((ROOT/'game/characters/reem/aligned').glob('*.png')):
 layer=Image.open(path).convert('RGBA');assert layer.size==im.size
 alpha=ImageChops.lighter(alpha,layer.getchannel('A'))
assert ImageChops.difference(alpha,im.getchannel('A')).getbbox() is None,'Source cutouts lose or add source alpha'
print('[ALIGN PIXELS] ok: source cutouts preserve original alpha at every pixel')
render=ROOT/(sys.argv[1] if len(sys.argv)>1 else 'docs/reem_walk_v2/neutral_rgba.png')
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

# Preserve the face the user approved, including the exact talking/blinking previews.
if render.exists() and render.parent.name in ['reem_walk','reem_walk_v2']:
 for name in ['neutral_rgba','face_talking','face_blinking']:
  before=Image.open(ROOT/'docs/reem_alignment'/f'{name}.png').convert('RGBA')
  after=Image.open(render.parent/f'{name}.png').convert('RGBA')
  region=(650,120,800,350)
  assert ImageChops.difference(before.crop(region),after.crop(region)).getbbox() is None, f'Approved face changed: {name}'
 print('[FACE] ok: approved neutral, talking and blinking face pixels unchanged')
