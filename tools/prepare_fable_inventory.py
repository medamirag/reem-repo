"""Inventory Fable cutout deliverables without changing runtime characters."""
from pathlib import Path
import json
from PIL import Image,ImageDraw,ImageFont
ROOT=Path(__file__).resolve().parents[1]
HUMANS={'grandpa','astronomer','market_baker','musaharati','iftar_traveller'}
BIPEDS={'fox','arnoob','sinjoob','dubb','qunfood','qarqoor','dafdoof'}
BIRDS={'duck','goldfinch','gull_bird','observatory_owl','tawoos'}
INSECTS={'ant_beetle','ant_queen','ant_worker','bees','ankoob'}
COMMON=['head_blank','eyes_open','eyes_closed','mouth_closed','mouth_open','mouth_smile','mouth_sad','mouth_surprised','torso']
def inventory():
 result=[]
 for d in sorted((ROOT/'assets/art/characters').iterdir()):
  if not d.is_dir() or d.name=='reem':continue
  key=d.name;sheet=next(d.glob('*_sheet.png'),None);sprite=next(d.glob('*_base.png'),None)
  if key=='grandpa':sprite=ROOT/'assets/cut/grandpa_bench/grandpa_seated.png'
  if key=='bees':sprite=ROOT/'assets/cut/bees_sheet/shahd_body.png'
  if key=='duck':sprite=ROOT/'assets/cut/stream/duck.png'
  if key=='ankoob':sprite=next((ROOT/'assets/cut').rglob('ankoob_body.png'),None)
  sprite=sprite or sheet
  if not sprite or not sprite.exists():continue
  kind='human' if key in HUMANS|BIPEDS else 'bird' if key in BIRDS else 'insect' if key in INSECTS else 'four-legged'
  parts=COMMON.copy()
  if key=='wooden_boat':kind='prop';parts=['hull','oar_left','oar_right']
  elif key=='gull_octopus':kind='cephalopod';parts += [f'tentacle_{i:02}_{segment}' for i in range(1,9) for segment in ['upper','lower','tip']]
  elif key in HUMANS|BIPEDS:
   parts += [f'{segment}_{side}' for side in ['near','far'] for segment in ['upper_arm','lower_arm','hand','upper_leg','lower_leg','foot']]
  elif key in BIRDS or key=='observatory_bat':
   parts += [f'{segment}_{side}' for side in ['near','far'] for segment in ['wing','upper_leg','lower_leg','foot']]
  else:
   count=8 if key=='ankoob' else 6 if key in INSECTS else 4
   parts += [f'leg_{i:02}_{segment}' for i in range(1,count+1) for segment in ['upper','lower','paw']]
  if key not in HUMANS|{'wooden_boat','ant_worker','ant_queen','ant_beetle','bees','ankoob','gull_octopus'}:parts+=['tail']
  if key in INSECTS-{'ankoob'}:parts+=['antenna_near','antenna_far']
  if key=='bees':parts+=['wing_near','wing_far']
  if key in BIPEDS|{'market_cat','qatqoota','ghazlana','snow_deer','observatory_bat'}:parts+=['ear_near','ear_far']
  if key=='grandpa':parts+=['cane','bench','footstool']
  size=Image.open(sprite).size
  result.append(dict(name=key,aliases={'grandpa':['Grandpa','Jad','Sulaiman'],'fox':['Thaaloob'],'bees':['Shahd']}.get(key,[]),body_type=kind,biped_animal=key in BIPEDS,reference_sheet=str(sheet.relative_to(ROOT)).replace('\\','/') if sheet else None,current_sprite=str(sprite.relative_to(ROOT)).replace('\\','/'),canvas=list(size),parts=[dict(name=p,path=f'game/rig_parts/{key}/{p}.png',status='problem: not generated; do not rig placeholders') for p in parts],review=f'docs/rigs/{key}_parts.png'))
 return result
if __name__=='__main__':
 out=ROOT/'docs/rigs';out.mkdir(exist_ok=True);data=inventory()
 import copy
 for i in range(1,4):
  c=copy.deepcopy(next(c for c in data if c['name']=='duck'));c['name']=f'duckling{i}';c['aliases']=[];c['current_sprite']=f'assets/cut/stream/duckling{i}.png';c['canvas']=list(Image.open(ROOT/c['current_sprite']).size);c['review']=f'docs/rigs/duckling{i}_parts.png'
  for part in c['parts']:part['path']=f"game/rig_parts/duckling{i}/{part['name']}.png"
  data.append(c)
 previous_path=out/'character_manifest.json'
 previous=json.loads(previous_path.read_text()) if previous_path.exists() else []
 statuses={(c['name'],p['name']):p['status'] for c in previous for p in c['parts']}
 for c in data:
  for p in c['parts']:p['status']=statuses.get((c['name'],p['name']),p['status'])
 (out/'character_manifest.json').write_text(json.dumps(data,indent=2)+'\n')
 q=ROOT/'content/art_queue.md';s=q.read_text();s+=('' if '### Fable character-part preparation' in s else '\n### Fable character-part preparation (2026-11-15; INCOMPLETE)\n\n| ID | Save as | Attach | Background | Size | Prompt | Extra check | Status |\n| --- | --- | --- | --- | --- | --- | --- | --- |\n')
 font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',18)
 for c in data:
  for p in c['parts']:
   prompt=f"Separate {p['name']} for {c['name']}; exact existing neutral view, colours and scale; complete rounded outlined overlaps; transparent; no redesign; smooth filtered edges. Blank head excludes eyes/mouth; all facial variants share anchors."
   row=f"| fable_{c['name']}_{p['name']} | `{p['path']}` | `{c['reference_sheet']}` and `{c['current_sprite']}` | transparent | {c['canvas'][0]}x{c['canvas'][1]} | {prompt} | Register over original; generous joint overlap; continuous original-weight black outlines; check 100% and 400% | {p['status']} |\n"
   row_id=f"| fable_{c['name']}_{p['name']} |"
   existing=next((line for line in s.splitlines() if line.startswith(row_id)),None)
   if existing:s=s.replace(existing,row.rstrip('\n'))
   else:s+=row
  rows=(len(c['parts'])+5)//6;im=Image.new('RGB',(1440,410+rows*95),'#fff4de');draw=ImageDraw.Draw(im)
  draw.text((20,12),c['name']+' — INCOMPLETE: part files not generated',font=font,fill='#a00000')
  src=Image.open(ROOT/c['current_sprite']).convert('RGBA');src.thumbnail((390,310));im.paste(src,(20,60),src)
  draw.text((440,60),'Original sprite (preview only).',font=font,fill='black');draw.text((440,100),'Empty cells are missing deliverables, NOT approved parts.',font=font,fill='#a00000')
  draw.text((440,140),'Body: '+c['body_type']+' / source canvas '+str(c['canvas']),font=font,fill='black')
  for i,p in enumerate(c['parts']):
   x=i%6*240;y=400+i//6*95;draw.rectangle((x+4,y+4,x+234,y+90),outline='#bf9b7a');draw.text((x+10,y+15),p['name'],font=font,fill='black');draw.text((x+10,y+47),'MISSING',font=font,fill='#a00000')
  if not any((ROOT/p['path']).exists() for p in c['parts']):im.save(ROOT/c['review'])
 q.write_text(s)
 print(len(data),'character designs;',sum(len(c['parts']) for c in data),'unbuilt parts documented')
