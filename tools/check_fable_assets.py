"""Verify reduced tiers, actual PNG deliverables and source-preserving rest pose."""
import json
from pathlib import Path
from PIL import Image,ImageChops
ROOT=Path(__file__).resolve().parents[1]
data=json.loads((ROOT/'docs/rigs/character_manifest.json').read_text());active=0
for c in data:
 if c['tier']=='code_only':
  assert not c['parts'];assert not list((ROOT/'game/rig_parts'/c['name']).glob('*.png'));continue
 source=Image.open(ROOT/c['current_sprite']).convert('RGBA');assert list(source.size)==c['canvas']
 for p in c['parts']:
  im=Image.open(ROOT/p['path']).convert('RGBA');assert im.size==source.size;assert im.getbbox(),(c['name'],p['name']);assert p['status']=='done';active+=1
 if c['tier']=='light':assert {p['name'] for p in c['parts']} <= {'eyes_closed','mouth_open','mouth_closed','tail','ears'}
 if c['tier']=='full':
  assert (ROOT/f"game/rig_parts/{c['name']}/static_rig.tscn").exists()
  assembly=Image.open(ROOT/f"game/rig_parts/{c['name']}/neutral_assembly.png").convert('RGBA')
  maximum=0
  for colour in ['white','black']:
   before=Image.new('RGBA',source.size,colour);before.alpha_composite(source);after=Image.new('RGBA',source.size,colour);after.alpha_composite(assembly)
   diff=ImageChops.difference(before.convert('RGB'),after.convert('RGB'));maximum=max(maximum,max(ch.getextrema()[1] for ch in diff.split()))
  assert maximum<=4,(c['name'],'rest image changed',maximum)
  print('[FABLE ART]',c['name'],'full visible rest max difference',maximum)
q=(ROOT/'content/art_queue.md').read_text();cancelled=sum('cancelled: scope reduced' in l for l in q.splitlines())
planned={f"fable_{c['name']}_{p['name']}" for c in data for p in c['parts']}
for line in q.splitlines():
 if line.startswith('| fable_'):
  cells=[v.strip() for v in line.strip('|').split('|')];assert cells[-1]==('done' if cells[0] in planned else 'cancelled: scope reduced'),cells[0]
assert active==107 and cancelled==645,(active,cancelled)
print('[FABLE ART] DONE',active,'PNG deliverables;',cancelled,'cancelled rows retained')
