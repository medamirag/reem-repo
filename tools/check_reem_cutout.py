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
render=ROOT/(sys.argv[1] if len(sys.argv)>1 else 'docs/reem_walk_final/neutral_rgba.png')
if render.exists():
 actual=Image.open(render).convert('RGBA');assert actual.size==im.size
 lost=outside=different=0;maximum=0
 def pixels(image):return getattr(image,'get_flattened_data',image.getdata)()
 # Redrawing the torso deliberately changes its silhouette/colour. Preserve
 # exact face and lower-leg/foot checks rather than asserting the old cut edges.
 pairs=list(zip(pixels(im),pixels(actual)))
 if render.parent.name in ['reem_torso_outline','reem_walk_final']:pairs=pairs[1015*im.width:]
 for original,pixel in pairs:
  if original[3]>200 and pixel[3]<128:lost+=1
  if original[3]<16 and pixel[3]>128:outside+=1
  if original[3]>250:
   delta=max(abs(original[k]-pixel[k]) for k in range(3));maximum=max(maximum,delta)
   if delta>12:different+=1
 print(f'[ALIGN PIXELS] neutral lost={lost}, outside={outside}, colour difference >12={different}, max={maximum}')
 assert lost==0 and outside==0,'Rendered neutral has gaps or exceeds original silhouette'
 assert different<250,'Neutral colours no longer match original artwork'
 print('[ALIGN PIXELS] ok: unchanged lower legs/feet match original' if render.parent.name in ['reem_torso_outline','reem_walk_final'] else '[ALIGN PIXELS] ok: rendered neutral matches original silhouette and colours')

# Preserve the face the user approved, including the exact talking/blinking previews.
if render.exists() and render.parent.name in ['reem_walk','reem_walk_v2','reem_walk_v3','reem_torso_outline','reem_walk_final']:
 for name in ['neutral_rgba','face_talking','face_blinking']:
  before=Image.open(ROOT/'docs/reem_alignment'/f'{name}.png').convert('RGBA')
  after=Image.open(render.parent/f'{name}.png').convert('RGBA')
  region=(650,120,800,350)
  assert ImageChops.difference(before.crop(region),after.crop(region)).getbbox() is None, f'Approved face changed: {name}'
 print('[FACE] ok: approved neutral, talking and blinking face pixels unchanged')

for name in ['arm_front','arm_back','bag_and_strap']:
 path=ROOT/'game/characters/reem/refined'/f'{name}.png'
 if path.exists():
  refined=Image.open(path).convert('RGBA')
  assert refined.size==im.size
  for index,(source,pixel) in enumerate(zip(im.get_flattened_data(),refined.get_flattened_data())):
   x,y=index%im.width,index//im.width
   if name.startswith('arm_') and 460<=x<590 and 430<=y<=600:continue
   if pixel[3]:assert source[:3]==pixel[:3], f'Source RGB changed in {name}'
print('[REFINED] ok: accessories, hands and sleeves outside repainted shoulder preserve original colours')
