"""Extract untouched source pixels into layers and build smooth, overlapping native skin meshes."""
import json,math
from pathlib import Path
from PIL import Image,ImageDraw,ImageFilter,ImageChops
ROOT=Path(__file__).resolve().parents[1];D=json.loads((ROOT/'game/characters/reem/cutout_layout.json').read_text())
DEST=ROOT/'game/characters/reem/aligned';DEST.mkdir(exist_ok=True)
FRONT=[(430,636),(475,625),(500,616),(525,604),(550,590),(575,576),(600,568),(625,558),(650,549),(675,538),(700,525),(725,511),(750,498),(775,494),(800,488),(825,480),(850,480)]
BACK=[(480,697),(500,697),(525,694),(550,691),(575,696),(600,700),(625,703),(650,710),(675,715),(700,722),(725,731),(750,741),(775,749),(800,757),(825,770),(850,800)]
def interp(curve,y):
 if y<=curve[0][0]:return curve[0][1]
 for (a,x),(b,z) in zip(curve,curve[1:]):
  if y<=b:return x+(z-x)*(y-a)/(b-a)
 return curve[-1][1]
def smooth(a,b,t):
 t=max(0,min(1,(t-a)/(b-a)));return t*t*(3-2*t)
names=['head','torso','arm_front','arm_back','leg_front','leg_back']
im=Image.open(ROOT/'assets/art/characters/reem/reem_base.png').convert('RGBA')
# Remove thin alpha fringe at the collar/shoulders only; approved face pixels stay exact.
a=im.getchannel('A');core=a.point(lambda v:255 if v>=96 else 0)
opened=core.filter(ImageFilter.MinFilter(5)).filter(ImageFilter.MaxFilter(5)).filter(ImageFilter.MaxFilter(3))
clean=ImageChops.multiply(a,opened)
a.paste(clean.crop((390,420,850,590)),(390,420));im.putalpha(a)
im.save(ROOT/'game/characters/reem/reem_clean_source.png')
src=im.load();head=Image.new('L',im.size);ImageDraw.Draw(head).polygon([tuple(p) for p in D['parts']['head']],fill=255)
head=head.filter(ImageFilter.MaxFilter(9));hm=head.load()
warm=Image.new('L',im.size);wp=warm.load()
for y in range(410,590):
 for x in range(390,850):
  r,g,b,a=src[x,y]
  if r>145 and g>130 and b>90 and r>g*1.01 and r>b*1.06 and a>64:wp[x,y]=255
support=warm.filter(ImageFilter.MaxFilter(13)).load()
for y in range(410,590):
 for x in range(390,850):
  if not support[x,y]:hm[x,y]=0
hem_edge={}
for x in range(im.width):
 teal=[y for y in range(900,1025) if src[x,y][1]>65 and src[x,y][2]>65 and src[x,y][1]>src[x,y][0]*1.2 and src[x,y][2]>src[x,y][0]*1.2 and src[x,y][3]>200]
 hem_edge[x]=max(teal)+7 if teal else 980
masks={n:Image.new('L',im.size) for n in names};m={n:a.load() for n,a in masks.items()}
for y in range(im.height):
 for x in range(im.width):
  r,g,b,a=src[x,y]
  if not a:continue
  if hm[x,y] and not(y>420 and g>65 and b>65 and g>r*1.2 and b>r*1.2):name='head'
  elif y>=hem_edge[x]:name='leg_front' if x<(635 if y>1130 else 615) else 'leg_back'
  elif 430<=y<=850 and x<interp(FRONT,y):name='arm_front'
  elif 480<=y<=850 and x>interp(BACK,y):name='arm_back'
  else:name='torso'
  m[name][x,y]=255
for name,mask in masks.items():
 # One-pixel leg overlap seals the shared joint borders; keep body masks clean.
 mask=mask.filter(ImageFilter.MaxFilter(3)) if name.startswith("leg_") else mask
 if name=='torso':
  mp=mask.load()
  for x in range(im.width):
   for y in range(hem_edge[x]+1,im.height):mp[x,y]=0
 image=Image.new('RGBA',im.size);image.paste(im,(0,0),mask);image.save(DEST/(name+'.png'))
lines=['[gd_scene load_steps=18 format=3]','[ext_resource type="Script" path="res://game/characters/reem/reem_walk_rig.gd" id="rig"]','[ext_resource type="Texture2D" path="res://assets/art/characters/reem/reem_base.png" id="source"]','[ext_resource type="Shader" path="res://game/characters/reem/reem_face.gdshader" id="face"]']
lines.append('[ext_resource type="Shader" path="res://game/characters/reem/reem_trousers.gdshader" id="trousers"]')
lines.append('[ext_resource type="Shader" path="res://game/characters/reem/reem_shoulder.gdshader" id="shoulder"]')
for name in names:lines.append(f'[ext_resource type="Texture2D" path="res://game/characters/reem/aligned/{name}.png" id="{name}_tex"]')
lines+=['[sub_resource type="ShaderMaterial" id="TrouserTop"]','shader = ExtResource("trousers")','[sub_resource type="ShaderMaterial" id="TrouserCap"]','shader = ExtResource("trousers")','shader_parameter/cap_mode = true']
lines+=['[sub_resource type="ShaderMaterial" id="ShoulderFill"]','shader = ExtResource("shoulder")']
lines+=['[sub_resource type="ShaderMaterial" id="FaceSkin"]','shader = ExtResource("face")']
for name,key in [('OpenEye','eye_rect'),('NeutralMouth','mouth_rect')]:lines.extend([f'[sub_resource type="AtlasTexture" id="{name}"]','atlas = ExtResource("source")','region = Rect2(%s)'%', '.join(map(str,D[key]))])
lines+=['[node name="ReemCutout" type="Node2D"]','script = ExtResource("rig")','[node name="Skeleton2D" type="Skeleton2D" parent="."]']
BODY='Body'
def limb_weights(kind,side,y):
 a=D['arms' if kind=='arm' else 'legs'][side];j=['shoulder','elbow','wrist'] if kind=='arm' else ['hip','knee','ankle'];path=BODY;paths=[]
 for name in j:path+='/'+name.capitalize()+'_'+side;paths.append(path)
 first=smooth(a[j[1]][1]-18,a[j[1]][1]+18,y);second=smooth(a[j[2]][1]-18,a[j[2]][1]+18,y)
 start=smooth(a[j[0]][1]-10,a[j[0]][1]+45,y) if kind=='arm' else 1
 return {BODY:1-start,paths[0]:start*(1-first),paths[1]:start*first*(1-second),paths[2]:start*first*second}
def weights(family,x,y):
 if family.startswith('arm_') or family.startswith('leg_'):return limb_weights(*family.split('_'),y)
 if family=='head':return {'Body/Head':1}
 hem=smooth(790,980,y)
 return {BODY:1-hem,'Body/Hem':hem}

def mesh(name,family,box):
 x0,y0,x1,y1=box;xs=sorted(set([x0,x1]+list(range(math.ceil(x0/10)*10,x1,10))));ys=sorted(set([y0,y1]+list(range(math.ceil(y0/10)*10,y1,10))))
 points=[(x,y) for y in ys for x in xs];skin={}
 for i,(x,y) in enumerate(points):
  for path,value in weights(family,x,y).items():
   if path not in skin:skin[path]=[0.0]*len(points)
   skin[path][i]=round(value,7)
 cells=[];cols=len(xs)
 for row in range(len(ys)-1):
  for col in range(cols-1):
   a=row*cols+col;cells.extend([(a,a+1,a+cols+1),(a,a+cols+1,a+cols)])
 uv=[]
 for x,y in points:
  if name.endswith('Cap'):
   centre=550 if family.endswith('front') else 695
   uv.append((round(centre+(x-centre),5),1030))
  else:uv.append((x,y))
 lines.extend([f'[node name="{name}" type="Polygon2D" parent="Skeleton2D"]',f'texture = ExtResource("{family}_tex")','skeleton = NodePath("..")','polygon = PackedVector2Array('+', '.join(str(p[i]-D['feet_origin'][i]) for p in points for i in (0,1))+')','uv = PackedVector2Array('+', '.join(str(v) for p in uv for v in p)+')','polygons = ['+', '.join('PackedInt32Array('+', '.join(map(str,c))+')' for c in cells)+']','metadata/skin = {'+', '.join('"'+path+'": PackedFloat32Array('+', '.join(map(str,w))+')' for path,w in skin.items())+'}', 'metadata/virtual_cap = '+('true' if name.endswith('Cap') else 'false')])

for side in ['back','front']:
 if side=='back':
  for name,y0,y1 in [('Upper',480,620),('Lower',590,740),('Hand',700,850)]:mesh('ArmBack'+name,'arm_back',(640,y0,850,y1))
 mesh('Leg'+side.capitalize()+'Cap','leg_'+side,((450 if side=='front' else 615),900,(615 if side=='front' else 810),1030))
 lines.append('material = SubResource("TrouserCap")')
 for name,y0,y1 in [('Upper',945,1090),('Lower',1030,1180),('Foot',1130,1240)]:
  mesh('Leg'+side.capitalize()+name,'leg_'+side,((450 if side=='front' else 615),y0,((635 if name=='Foot' else 615) if side=='front' else 810),y1))
  lines.append('material = SubResource("TrouserTop")')
# Body-only rounded shoulder extension joins the scarf to the stable chest.
# Idle blending restores the exact original standing silhouette.
def bezier(a,b,c,d,steps=12):
 return [tuple(round((1-t)**3*a[k]+3*(1-t)**2*t*b[k]+3*(1-t)*t*t*c[k]+t**3*d[k],4) for k in (0,1)) for t in [i/steps for i in range(steps+1)]]
def edge_strip(points,width=5):
 outer=[];inner=[]
 for i,p in enumerate(points):
  before=points[max(0,i-1)];after=points[min(len(points)-1,i+1)]
  dx=after[0]-before[0];dy=after[1]-before[1];length=math.hypot(dx,dy)
  nx=-dy/length*width/2;ny=dx/length*width/2
  outer.append((p[0]+nx,p[1]+ny));inner.append((p[0]-nx,p[1]-ny))
 return outer+inner[::-1]
left=bezier((535,440),(500,440),(478,485),(485,515))+bezier((485,515),(488,545),(520,590),(550,650))[1:]
right=bezier((672,450),(700,460),(700,540),(700,580))+bezier((700,580),(700,610),(706,635),(706,650))[1:]
backing=left[:1]+right+left[:0:-1]
border=edge_strip(left)
colour=src[610,600]
# A skinned gusset bridges torso to the far sleeve. Arm-side vertices stay inside
# that sleeve; when it swings back the gusset folds behind the unchanged chest.
ys=[480,510,540,570,600,630,660];right_edge=[700,705,717,729,744,758,775]
points=[(round(680+(right-680)*column/5,5),y) for y,right in zip(ys,right_edge) for column in range(6)]
gusset_skin={}
for index,(x,y) in enumerate(points):
 row=index//6;edge=right_edge[row];blend=smooth(680,edge,x)
 values={BODY:1-blend}
 for path,value in limb_weights('arm','back',y).items():values[path]=values.get(path,0)+value*blend
 for path,value in values.items():
  if path not in gusset_skin:gusset_skin[path]=[0.0]*len(points)
  gusset_skin[path][index]=round(value,7)
cells=[]
for row in range(len(ys)-1):
 for col in range(5):
  a=row*6+col;cells.extend([(a,a+1,a+7),(a,a+7,a+6)])
lines.extend(['[node name="FarShoulderGusset" type="Polygon2D" parent="Skeleton2D"]',
 'polygon = PackedVector2Array('+', '.join(str(p[i]-D['feet_origin'][i]) for p in points for i in (0,1))+')',
 'polygons = ['+', '.join('PackedInt32Array('+', '.join(map(str,c))+')' for c in cells)+']',
 'material = SubResource("ShoulderFill")', 'skeleton = NodePath("..")',
 'color = Color('+', '.join(str(round(v/255,7)) for v in colour[:3])+', 1)',
 'modulate = Color(1, 1, 1, 0)', 'metadata/underlap = true',
 'metadata/skin = {'+', '.join('"'+path+'": PackedFloat32Array('+', '.join(map(str,values))+')' for path,values in gusset_skin.items())+'}'])
for name,points,tint in [('ShoulderContour',border,(.035,.025,.015)),('ShoulderBacking',backing,tuple(round(v/255,7) for v in colour[:3]))]:
 lines.extend([f'[node name="{name}" type="Polygon2D" parent="Skeleton2D"]',
  'polygon = PackedVector2Array('+', '.join(str(p[i]-D['feet_origin'][i]) for p in points for i in (0,1))+')',
  'uv = PackedVector2Array('+', '.join(str(v) for p in points for v in p)+')',
  'texture = ExtResource("source")','material = SubResource("ShoulderFill")',
  'color = Color('+', '.join(map(str,tint))+', 1)', 'modulate = Color(1, 1, 1, 0)',
  'skeleton = NodePath("..")',
  'metadata/skin = {"Body": PackedFloat32Array('+', '.join(['1']*len(points))+')}',
  'metadata/underlap = true'])
mesh('Tunic','torso',(400,400,850,1010))
mesh('HeadSurface','head',(390,0,850,580))
lines.append('material = SubResource("FaceSkin")')
def bone(name,parent,point,origin):
 v=[point[i]-origin[i] for i in (0,1)];lines.extend([f'[node name="{name}" type="Bone2D" parent="{parent}"]',f'position = Vector2({v[0]}, {v[1]})',f'rest = Transform2D(1, 0, 0, 1, {v[0]}, {v[1]})','auto_calculate_length_and_angle = false','length = 80.0']);return parent+'/'+name
bone('Body','Skeleton2D',D['feet_origin'],D['feet_origin'])
bone('Hem','Skeleton2D/Body',[620,850],D['feet_origin'])
for kind,table,joints in [('arm','arms',['shoulder','elbow','wrist']),('leg','legs',['hip','knee','ankle'])]:
 for side in ['back','front']:
  a=D[table][side];parent='Skeleton2D/Body';origin=D['feet_origin']
  for j in joints:parent=bone(j.capitalize()+'_'+side,parent,a[j],origin);origin=a[j]
head=bone('Head','Skeleton2D/Body',D['head_pivot'],D['feet_origin'])
for name,key in [('Eyes','eye_anchor'),('MouthAnchor','mouth_anchor')]:
 v=[D[key][i]-D['head_pivot'][i] for i in (0,1)];lines.extend([f'[node name="{name}" type="Node2D" parent="{head}"]',f'position = Vector2({v[0]}, {v[1]})'])
 if name=='Eyes':
  lines.extend([f'[node name="Open" type="Sprite2D" parent="{head}/Eyes"]','texture = SubResource("OpenEye")',f'[node name="Closed" type="Node2D" parent="{head}/Eyes"]','visible = false'])
  for label,points,width in [('Lid',[[-31,-1],[-23,7],[-10,12],[3,13],[17,8],[29,-1]],5),('LashLeft',[[-24,7],[-34,4]],4),('LashMiddle',[[-16,10],[-24,15]],4),('LashRight',[[18,8],[26,11]],4)]:lines.extend([f'[node name="{label}" type="Line2D" parent="{head}/Eyes/Closed"]','points = PackedVector2Array('+', '.join(str(v) for p in points for v in p)+')',f'width = {width}.0','default_color = Color(0.06, 0.035, 0.015, 1)','begin_cap_mode = 2','end_cap_mode = 2','antialiased = true'])
 else:lines.extend([f'[node name="Mouth" type="Sprite2D" parent="{head}/MouthAnchor"]','texture = SubResource("NeutralMouth")'])
for name,y0,y1 in [('Upper',430,620),('Lower',590,740),('Hand',700,850)]:mesh('ArmFront'+name,'arm_front',(390,y0,650,y1))
(ROOT/'game/characters/reem/reem_cutout.tscn').write_text('\n\n'.join(lines)+'\n',encoding='utf-8')
print('[CUTOUT] Built source-pixel masks and overlapping, smoothly weighted joint meshes')
