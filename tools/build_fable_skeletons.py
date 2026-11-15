"""Build static Skeleton2D scenes only. No script, animation, Tween or room wiring."""
import json
from pathlib import Path
from build_fable_assets import FULL
ROOT=Path(__file__).resolve().parents[1]
for name,cfg in FULL.items():
 folder=ROOT/'game/rig_parts'/name;layout=json.loads((folder/'layout.json').read_text());root=cfg['root'];head=cfg['head'];bone_for={};pos={'Skeleton2D/Body':root};nodes=[]
 def bone(label,parent,point):
  parent_point=pos[parent];delta=[point[i]-parent_point[i] for i in (0,1)];path=parent+'/'+label;pos[path]=point
  nodes.extend([f'[node name="{label}" type="Bone2D" parent="{parent}"]',f'position = Vector2({delta[0]}, {delta[1]})',f'rest = Transform2D(1, 0, 0, 1, {delta[0]}, {delta[1]})','auto_calculate_length_and_angle = false','length = 45.0'])
  return path
 bone_for['head_blank']=bone('Head','Skeleton2D/Body',head)
 for side in ['near','far']:
  for segments,labels in [(['upper_arm','lower_arm','hand'],['Shoulder','Elbow','Wrist']),(['upper_leg','lower_leg','foot'],['Hip','Knee','Ankle'])]:
   parent='Skeleton2D/Body'
   for segment,label in zip(segments,labels):
    key=segment+'_'+side;parent=bone(label+'_'+side,parent,cfg['joints'][key]);bone_for[key]=parent
 for part in ['tail','ear_near','ear_far','cane']:
  if part in cfg['joints']:bone_for[part]=bone(part.title().replace('_',''),'Skeleton2D/Body/Head' if part.startswith('ear_') else 'Skeleton2D/Body',cfg['joints'][part])
 parts=[p.stem for p in folder.glob('*.png') if p.stem not in ['neutral_assembly']]
 lines=[f'[gd_scene load_steps={len(parts)+1} format=3]']
 for i,part in enumerate(parts):lines.append(f'[ext_resource type="Texture2D" path="res://game/rig_parts/{name}/{part}.png" id="p{i}"]')
 lines+=['[node name="'+name.title()+'StaticRig" type="Node2D"]','texture_filter = 2','metadata/preparation_only = true','[node name="Skeleton2D" type="Skeleton2D" parent="."]','[node name="Body" type="Bone2D" parent="Skeleton2D"]','rest = Transform2D(1, 0, 0, 1, 0, 0)','auto_calculate_length_and_angle = false','length = 45.0']+nodes
 for i,part in enumerate(parts):
  facial=part.startswith('mouth_') or part.startswith('eyes_');parent='Skeleton2D/Body/Head' if facial else bone_for.get(part,'Skeleton2D/Body');pivot=pos[parent]
  if part=='seat_and_stool':parent='Skeleton2D';pivot=root
  z=100 if facial else layout['draw_order'].index(part)+1 if part in layout['draw_order'] else 50
  lines += [f'[node name="{part}" type="Sprite2D" parent="{parent}"]',f'texture = ExtResource("p{i}")',f'offset = Vector2({layout["canvas"][0]/2-pivot[0]}, {layout["canvas"][1]/2-pivot[1]})',f'z_index = {z}']
  if part in layout.get('neutral_hidden',[]) or (facial and part not in ['mouth_smile','eyes_open']):lines+=['visible = false']
 (folder/'static_rig.tscn').write_text('\n\n'.join(lines)+'\n');layout['bone_paths']=bone_for;layout['scene']=f'game/rig_parts/{name}/static_rig.tscn';(folder/'layout.json').write_text(json.dumps(layout,indent=2)+'\n')
 print('[STATIC BONES]',name,len(pos))
